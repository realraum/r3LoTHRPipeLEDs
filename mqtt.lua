function mqttChangePattern(client, topic, data)
	jd = cjson.decode(data)
	fn = "pattern_" .. jd["pattern"] .. ".lc"
	if file.exists(fn) then
		arg=jd["arg"]
		runfile=fn
		abort = true
		changefile = true
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
