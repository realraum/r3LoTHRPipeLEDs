--
-- setup a telnet server that hooks the sockets input
--

local client
local server
local fifo
local drained

local function sendnext(sock)
    local s = table.remove(fifo, 1)
    if s then
        sock:send(s)
    else
        drained = true
    end
end

local function output(s)
    if client then
        table.insert(fifo, s)
        if drained then
            drained = false
            sendnext(client)
        end
    end
end

local function onReceive(sock, input)
    node.input(input)
end

local function onDisconnect(sock)
    node.output(nil)
    client = nil
    fifo = nil
    drained = nil
end


local function listen(sock)
    if client then
        sock:send("Already in use.\n")
        sock:close()
        return
    end
    client = sock
    fifo = {}
    drained = true
    node.output(output, 0)
    sock:on("receive", onReceive)
    sock:on("disconnection", onDisconnect)
    sock:on("sent", sendnext)
    sock:send("NodeMCU\n")
end

local function open(port)
    server = net.createServer(net.TCP, 180)
    server:listen(port or 23, listen)
end

local function close()
    if client then
        client:close()
        client = nil
    end
    if server then
        server:close()
        server = nil
    end
end

return { open = open, close = close }
