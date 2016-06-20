
local PIXELS     = 30*5
local BYTES_PER_LED = 3

--global LED buffer for all animations and PIXELS
local wsbuf = ws2812.newBuffer(PIXELS, BYTES_PER_LED)

local POST = node.task.post
local PRIO = node.task.LOW_PRIORITY

local animFunc, animParams, animNumParams


local function off()
    wsbuf:fill(0, 0, 0)
    wsbuf:write()
    tmr.wdclr()
end

local function stop()
    tmr.unregister(2)
end

local timerTick

local function animate()
    if animFunc then
        local delay = animFunc(wsbuf, unpack(animParams, 1, animNumParams))
        if delay then
            tmr.interval(2, delay)
            tmr.start(2)
            return
        end
    end
    stop()
end

timerTick = function()
    POST(PRIO, animate)
end

local function init()
    ws2812.init()
end

local function start()
    tmr.register(2, 100, tmr.ALARM_SEMI, timerTick)
    return tmr.start(2)
end

local function setFunction(f, ...)
    animFunc = f
    animParams = { ... }
    animNumParams = select("#", ...)
end

local function ison()
    return tmr.state(2)
end

local function info()
    local on, mode = tmr.state(2)
    local s = "tmrOn: " .. tostring(on) .. ", tmrMode: " .. tostring(mode) .. ", func: " .. tostring(animFunc)
    print(s)
    return s
end

return {
   off         = off,
   start       = start,
   stop        = stop,
   init        = init,
   setFunction = setFunction,
   ison        = ison,
   info        = info,
   wsbuf       = wsbuf,
}
