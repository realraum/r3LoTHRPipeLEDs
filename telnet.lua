--
-- setup a telnet server that hooks the sockets input
--

local client
local server

local function sendout(str)
    if client then
        client:send(str)
    end
end

local function onReceive(sock, input)
    node.input(input)
end

local function onDisconnect(sock)
    node.output(nil)
    client = nil
end

local function listen(sock)
    if client then
        sock:send("Already in use.\n")
        sock:close()
        return
    end
    client = sock
    node.output(sendout, 0)
    sock:on("receive", onReceive)
    sock:on("disconnection", onDisconnect)
    sock:send("NodeMCU\n")
end

local function open()
    server = net.createServer(net.TCP, 180)
    server:listen(23, listen)
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
