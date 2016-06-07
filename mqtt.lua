function mqttChangePattern(client, topic, data)
	print(data)
	jd = cjson.decode(data)
	if jd["pattern"] ~= nil and jd["arg"] ~= nil then
		fn = "pattern_" .. jd["pattern"] .. ".lc"
		if file.exists(fn) then
			print("Switching to pattern ".. fn)
			arg=jd["arg"]
			tmr.unregister(1) -- all pattern timers need to be 1
			dofile(fn)
		end
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
