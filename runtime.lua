
local function selectPattern(name, ...)
    if not name then
        ledbar.setFunction()
        return
    end
    name =  tostring(name)
    local pa = patterns[name]
    if pa then
        print("Switching to pattern "..name)
        ledbar.setFunction(pa, ...)
        ledbar.start()
    end
end

local function mqttChangePattern(data)
    print(data)
    local jd = cjson.decode(data)
    if jd.pattern then
        selectPattern(jd.pattern, jd.arg)
    end
end

r3mqtt.setHandler("pattern", mqttChangePattern)

setglobal("patt", selectPattern)

ledbar.init()


--selectPattern "strobo"
