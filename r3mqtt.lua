
local mc
local msgH = {}
local mqtt_topic_prefix = "action/PipeLEDs/"

local function onConnect(client)
    for t, _ in pairs(msgH) do
        client:subscribe(mqtt_topic_prefix .. t,0,nil)
    end
end
local function onOffline(client)
    mc = nil
    print("mqtt offline")
end
local function onMessage(client, topic, data)
	msgH[topic](data)
end

local function close()
    if mc then
        mc:close()
        mc = nil
    end
end

local function connect()
    close()
    mc = mqtt.Client("PipeLEDs",30,nil,nil,true)
    mc:on("connect", onConnect)
    mc:on("offline", onOffline)
    mc:on("message", onMessage)
    mc:connect("mqtt.realraum.at",1883,false,true)
end

local function online()
    return not not mc
end

local function setHandler(t, f)
    msgH[t] = f
    if mc then
        mc:subscribe(mqtt_topic_prefix .. t,0,nil)
    end
end

return {
   close      = close,
   connect    = connect,
   setHandler = setHandler,
   online     = online
}
