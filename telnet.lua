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

local function listen(sock)
    if server then
        sock:send("Already in use.\n")
        sock:close()
        return
    end
    client = sock
    node.output(sendout, 0)
    sock:on("receive", function(sock, input) node.input(input) end)
    sock:on("disconnection",function(sock) node.output(nil) client = nil end)
    sock:send("NodeMCU\n")
end

local function open()
    server = net.createServer(net.TCP, 180)
    server:listen(23, listen)
end

local function close()
  server:close()
  server = nil
end

return { open = open, close = close }
