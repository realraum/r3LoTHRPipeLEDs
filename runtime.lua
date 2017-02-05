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

---- Default Settings -----
local pattparams = {brightness=30, speed=150, hue=0, randomhue=0} -- speed: 0..255, hue: 0..255, brightness: 0..100
function pattparams:getHue()
    if self.randomhue == 0 then return self.hue else return math.random(0,255) end
end
---------------------------

local function mqttChangePattern(data)
    local jd = cjson.decode(data)
    if jd.hue then
        if type(jd.hue) == "number" then
            pattparams.hue = jd.hue % 256
            pattparams.randomhue = 0
        else
            pattparams.randomhue = 1
        end
    end
    if jd.brightness and type(jd.brightness) == "number" and jd.brightness >= 0 and jd.brightness <= 100 then
        pattparams.brightness = jd.brightness -- 0..100
    end
    if jd.speed and type(jd.speed) == "number" and jd.speed >= 0 and jd.speed <= 255 then
        pattparams.speed = jd.speed -- 0..255
    end
    if jd.pattern then
        selectPattern(jd.pattern, pattparams, jd.arg, jd.arg1)
    end
end

local function mqttReactToPresence(data)
    local jd = cjson.decode(data)
    if jd.Present then
        selectPattern("huefade",pattparams)
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
