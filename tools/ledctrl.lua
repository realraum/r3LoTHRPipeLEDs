-- Run with Lua 5.1; slight fixup for 5.2+
-- Usage: lua uploader.lua <host[:port]> [list of files...]

local MAX_LINE_LEN = 230 -- make lines shorter than this to stay under the serial buffer limit
local SLEEP_TIME = 0.1
local SOCKET_TIMEOUT = 0.2

require "socket"

local floor = math.floor

local checksyntax = loadstring or load


local saferep = {
    ["\026"] = "\\026",
    ["\n"] = "n", -- HACK: format %q already transforms a newline to "\" followed by an actual newline, so if we match that newline, just replace that with an "n", so it ends up as "\n".
    ["\0"] = "\\000",
}
-- returns string that is REALLY safe to load back into Lua, even for binary data
function string.safefmt(s)
    return (("%q"):format(s):gsub(".", saferep)) -- drop all except first return value
end


local function sleep(t)
    socket.sleep(t or SLEEP_TIME)
end

local function filename(s)
    return s:match("/(.+)$") or s
end

-- returns a part of the code long enough to fit into MAX_LINE_LEN bytes when properly escaped
local function makeline(code, start)
    local size = MAX_LINE_LEN - 10 -- start somewhere, account for escape bloat
    while true do
        local s = code:sub(start, start + size)
        local slen = #s -- remember how much code we took out of the buffer
        s = s:safefmt()
        if #s < MAX_LINE_LEN then -- escaped code fits?
            return s, slen
        end
        size = floor(size * 0.9 - 1) -- shrink section, try again
        assert(size > 0)
    end
end

-- returns table of escaped lines
local function mangle(code)
    local t = {}
    local start = 1
    local i = 1
    while true do
        local s, len = makeline(code, start)
        if len == 0 then
            break
        end
        start = start + len
        t[i] = s
        i = i + 1
    end
    
    -- make sure that mangled code will unescape properly and produce the exact same code
    local evalcode = "return " .. table.concat(t, "..")
    local recode = assert(loadstring(evalcode))()
    assert(recode == code, recode)
    
    return t
end

-- fancy progress bar
local function progress(prefix, cur, all)
    local BAR = 40
    local perc = ""
    local p
    if type(cur) == "number" and type(all) == "number" then
        p = cur / all
        perc = ("%d%%"):format(p*100)
    end
    local s = prefix .. (" "):rep(20 - #prefix) .. "["
    if p then
        local n = floor(BAR*p)
        s = s .. ("="):rep(n) .. (" "):rep(BAR-n)
    else
        local ps = tostring(cur)
        s = s .. ps .. (" "):rep(BAR - #ps)
    end
    s = s .. "] " .. perc .. "\r"
    io.stdout:write(s)
end

-- additional verification for commands to be written into the remote REPL
local function checkupload(prefix, parts, suffix)
    local tt = {prefix}
    for i, part in ipairs(parts) do
        local s = "file.write"..part.."\r"
        table.insert(tt, s)
    end
    table.insert(tt, suffix)
    local code = table.concat(tt, "\n")
    assert(loadstring(code))
end

local function upload(sock, fn, parts)

    -- don't open a scope; keep things on the top level.
    -- (Opening a scope here will crash the NodeMCU when too much stuff is sent.)
    local prefix = 'file.open("' .. fn .. '", "w")\r'
    local suffix = 'file.flush() file.close()\r'
    
    -- make very sure that the uploaded code does not cause a syntax error in the REPL
    checkupload(prefix, parts, suffix)
    
    progress(fn, " OPEN")
    sock:send(prefix)
    sleep()

    local N = #parts
    for i, part in ipairs(parts) do
        progress(fn, i, N)
        sock:send("file.write"..part.."\r")
        sleep()
    end
    progress(fn, " CLOSE")
    sock:send(suffix)
    sleep()
    progress(fn, " DONE")
    print()
end

local function exec(sock, cmd)
    print("EXEC " .. cmd)
    sock:send(cmd.."\r")
    sleep()
end

local function echotest(sock)
    local _, err, partial
    _, err, partial = sock:receive("*a") -- clear input buffer
    sock:send("='echo'..'-'..(167*8+1)\r") -- REPL code
    sleep()
    _, err, partial = sock:receive("*a")
    if err == "closed" then
        print("Connection closed early. Telnet busy?")
        return
    end
    if partial:sub(1,10)  ~= "echo-1337\n" then
        print("Echo test failed, got: [" .. tostring(partial) .. "]")
        return
    end
    return true
end

-----------------------------------------------------------------------------------------------

local args = { ... }
local host = table.remove(args, 1)
if not host then
    print("Usage: uploader.lua <host[:port]> [files...]")
    return
end

local files = {}
local proc = {}

do
    local mode
    local restart, reload
    for i, x in ipairs(args) do
        if x:sub(1, 1) == "-" then
            if mode then
                print("Expected file name after switch -" .. mode)
                return
            end
            mode = x:sub(2)
            if mode == "R" then
                restart = true
                mode = nil
            elseif mode == "r" then
                reload = true
                mode = nil
            end
        else
            if not mode then
                table.insert(files, x)
                table.insert(proc, { action = "upload", assert(filename(x)) })
            elseif mode == "c" or mode == "C" then
                table.insert(files, x)
                table.insert(proc, { action = "upload", assert(filename(x)) })
                table.insert(proc, { action = "exec", 'node.compile"'..x..'"' })
                table.insert(proc, { action = "sleep", 1 }) -- give it some time to compile the file
                if mode == "C" then
                    table.insert(proc, { action = "exec", 'file.remove"'..x..'"' })
                end
            elseif mode == "d" then
                table.insert(proc, { action = "exec", 'file.remove"'..x..'"' })
            elseif mode == "e" then
                table.insert(proc, { action = "exec", x })
            elseif mode == "s" then
                table.insert(proc, { action = "sleep", assert(tonumber(x)) })
            elseif mode == "p" then
                table.insert(proc, { action = "exec", 'patt"'..x..'"'})
                table.insert(proc, { action = "sleep", 0.3 })
            elseif mode == "P" then
                local fn = "patt_" .. x .. ".lua"
                table.insert(files, fn)
                table.insert(proc, { action = "upload", assert(filename(fn)) })
                table.insert(proc, { action = "exec", 'patterns.'..x..'=nil; patt"'..x..'"'})
                table.insert(proc, { action = "sleep", 0.3 })
            else
                print("Unknown switch: -" .. mode)
                return
            end
            mode = nil
        end
    end
    if restart then
        table.insert(proc, { action = "exec", "node.restart()" })
    elseif reload then
        table.insert(proc, { action = "exec", "reload()" })
    end
end
--print("Queued " .. #proc .. " actions")

local allcode = {}

-- do the syntax checks first
local timeneeded = 0
for i, fn in ipairs(files) do
    local h = io.open(fn, "rb")
    if not h then
        print("Failed to open file: " .. fn)
        return
    end
    local code = h:read("*a")
    h:close()
    local ok, err = checksyntax(code)
    if not ok then
        print("Syntax error in " .. fn .. "!\n" .. err)
        return
    end
    local t = mangle(code)
    allcode[fn] = t
    timeneeded = timeneeded + ((2 + #t) * SLEEP_TIME) -- prefix and suffix too
end
if timeneeded > 0 then
    print("Will need about " .. timeneeded .. " seconds to upload " .. #files .. " files")
end

-- connect
local port
host, port = host:match("^([^:]+):?(%d-)$") -- FIXME: this fails for IPv6
if not host then
    print("Malformed host, use any of: hostname, IP, hostname:port, IP:port")
    return
end
port = tonumber(port) or 23
local sock = socket.connect(host, port)
if not sock then
    print("Failed to connect to [" .. host .. "] port " .. port)
    return
end

sock:settimeout(SOCKET_TIMEOUT)

print("Connected to to [" .. host .. "] port " .. port)
sleep() -- wait a bit before the echo test

if not echotest(sock) then
    return
end

-- in case a remote file is open due to a failed transfer or whatever, make sure it's closed.
sock:send("file.close()\r")
sleep()

-- upload all files
for i, cmd in ipairs(proc) do
    if cmd.action == "upload" then
        local fn = assert(filename(cmd[1]))
        upload(sock, fn, assert(allcode[fn]))
    elseif cmd.action == "exec" then
        exec(sock, assert(cmd[1]))
    elseif cmd.action == "sleep" then
        sleep(cmd[1])
    else
        error("WTF!")
    end
end

sock:close()
