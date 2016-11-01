local curpat = "off"
local curargs = 0
local oldpat = "off"
local oldargs = 0

local function selectPattern(name, ...)
    if not name then
        ledbar.setFunction()
        return
    end
    name =  tostring(name)
    local pa = patterns[name]
    if pa then
        curpat = name
        curargs = ...
        print("Switching to pattern "..name)
        ledbar.setFunction(pa, ...)
        ledbar.start()
    end
end

local function mqttChangePattern(data)
    local jd = cjson.decode(data)
    if jd.pattern then
        selectPattern(jd.pattern, jd.arg, jd.arg1)
    end
end

local function mqttReactToPresence(data)
    local jd = cjson.decode(data)
    if jd.Present then
        selectPattern("plasma")
    else
        selectPattern("off")
    end
end

local function mqttReactToButton(data)
	oldpat = curpat
	oldargs = curargs
    selectPattern("uspol")
    tmr.alarm(0, 15000, tmr.ALARM_SINGLE, function() selectPattern(oldpat, oldargs) end)
end

local mqtt_topic_prefix = "action/PipeLEDs/"

r3mqtt.setHandler(mqtt_topic_prefix .. "pattern", mqttChangePattern)
r3mqtt.setHandler(mqtt_topic_prefix .. "restart", function() node.restart() end)
r3mqtt.setHandler("realraum/metaevt/presence", mqttReactToPresence)
r3mqtt.setHandler("realraum/pillar/boredoombuttonpressed", mqttReactToButton)
r3mqtt.connect()
setglobal("patt", selectPattern)

ledbar.init()


--selectPattern "strobo"
