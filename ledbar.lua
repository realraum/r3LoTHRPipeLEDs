
local PIXELS     = 30*5
local BYTES_PER_LED = 3

--global LED buffer for all animations and PIXELS
local wsbuf = pixbuf.newBuffer(PIXELS, BYTES_PER_LED)

local POST = node.task.post
local PRIO = node.task.LOW_PRIORITY
local W = ws2812.write

local animFunc, animParams, animNumParams

local lbartmr = tmr.create()

local function off()
    wsbuf:fill(0, 0, 0)
    W(wsbuf)
    tmr.wdclr()
end


local function stop()
    lbartmr:unregister()
end

local timerTick

local function animate()
    if animFunc then
        local delay = animFunc(wsbuf, unpack(animParams, 1, animNumParams))
        W(wsbuf)
        if delay then
            lbartmr:interval(delay)
            lbartmr:start()
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
    lbartmr:register(100, tmr.ALARM_SEMI, timerTick)
    return lbartmr:start()
end

local function setFunction(f, ...)
    animFunc = f
    animParams = { ... }
    animNumParams = select("#", ...)
end

local function ison()
    return lbartmr:state()
end

local function info()
    local on, mode = lbartmr:state()
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
