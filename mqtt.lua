
-- Callback function to handle MQTT msg /action/PipeLEDs/pattern
function mqttChangePattern(client, topic, data)
	print(data)
	jd = cjson.decode(data)
	if jd["pattern"] ~= nil and jd["arg"] ~= nil then
		ws2812Select(jd["pattern"], jd["arg"])
	end
end

-- Connect to r3 MQTT Broker
-- NOTE: on disconnect the whole ESP8266 wil be reset
function connectMQTT()
	mc = mqtt.Client("PipeLEDs",30,nil,nil,true)
	-- on connect subscribe to action/PipeLEDs/pattern
	mc:on("connect", function(client) client:subscribe("action/PipeLEDs/pattern",0,nil) end)
	-- on offline, print a message and restart
	mc:on("offline", function(client) 
		print("mqtt offline")
		node.restart()
	end)
	mc:on("message", mqttChangePattern)
	mc:connect("mqtt.realraum.at",1883,false,true)
end
