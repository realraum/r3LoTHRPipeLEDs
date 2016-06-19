
local function selectPattern(name, ...)
    local pa = patterns[name]
    if pa then
        print("Switching to pattern "..patt)
        ledbar.setFunction(pa, ...)
    end
end

local function mqttChangePattern(topic, data)
    print(data)
    local jd = cjson.decode(data)
    if jd.pattern then
        selectPattern(jd.pattern jd.arg)
    end
end

r3mqtt.setHandler("patt", mqttChangePattern)

setglobal("patt", selectPattern)

selectPattern "strobo"
