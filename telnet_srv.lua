--
-- setup a telnet server that hooks the sockets input
--

telnetServer = false

function setupTelnetServer()
    inUse = false
    function listenFun(sock)
        if inUse then
            sock:send("Already in use.\n")
            sock:close()
            return
        end
        inUse = true

        function s_output(str)
            if(sock ~=nil) then
                sock:send(str)
            end
        end

        node.output(s_output, 0)

        sock:on("receive",function(sock, input)
                node.input(input)
            end)

        sock:on("disconnection",function(sock)
                node.output(nil)
                inUse = false
            end)

        stopstartup() --on login inhibit startup

        sock:send("Welcome to NodeMCU world.\n> ")
    end

    telnetServer = net.createServer(net.TCP, 180)
    telnetServer:listen(23, listenFun)
end

function stopTelnetServer()
  telnetServer:close()
  telnetServer = false
end
