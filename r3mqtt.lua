
local mc
local msgH = {}

local function onConnect(client)
    for t, _ in pairs(msgH) do
        client:subscribe(t,0,nil)
    end
end
local function onMessage(client, topic, data)
    local f = msgH[topic]
    if f then
        f(data)
    end
end

local function onMqttError(client, reason)
    tmr.create():alarm(10 * 1000, tmr.ALARM_SINGLE, connect)
end

local function close()
    if mc then
        mc:close()
        mc = nil
    end
end

local function connect()
    close()
    mc = mqtt.Client("PipeLEDs",30,nil,nil,1)
    mc:on("connect", onConnect)
    mc:on("message", onMessage)
    mc:on("connfail", onMqttError)
    mc:connect("mqtt.realraum.at",1883,false,true,onMqttError)
end

local function online()
    return not not mc
end

local function setHandler(t, f)
    msgH[t] = f
    if mc then
        mc:subscribe(t ,0,nil)
    end
end

return {
   close      = close,
   connect    = connect,
   setHandler = setHandler,
   online     = online
}
