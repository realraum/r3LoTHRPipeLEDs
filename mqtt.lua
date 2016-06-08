function mqttChangePattern(client, topic, data)
	print(data)
	jd = cjson.decode(data)
	if jd["pattern"] ~= nil and jd["arg"] ~= nil then
		ws2812Select(jd["pattern"], jd["arg"])
	end
end

function connectMQTT()
	mc = mqtt.Client("PipeLEDs",30,nil,nil,true)
	mc:on("connect", function(client) client:subscribe("action/PipeLEDs/pattern",0,nil) end)
	mc:on("offline", function(client) 
		print("mqtt offline")
		node.reset()
	end)
	mc:on("message", mqttChangePattern)
	mc:connect("mqtt.realraum.at",1883,false,true)
end
