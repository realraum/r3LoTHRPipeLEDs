
local mc
local msgH = {}

local function onConnect(client)
    client:subscribe("action/PipeLEDs/pattern",0,nil)
end
local function onOffline(client)
    mc = nil
    print("mqtt offline")
end
local function onMessage(client, topic, data)
    for _, f in pairs(msgH) do
        f(topic, data)
    end
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

local function setHandler(k, f)
    msgH[k] = f
end

return { close = close, connect = connect, setHandler = setHandler, online = online }
