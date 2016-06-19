
local PIXELS     = 30*5
local BYTES_PER_LED = 3

--global LED buffer for all animations and PIXELS
local wsbuf = ws2812.newBuffer(PIXELS, BYTES_PER_LED)

local POST = node.task.post
local PRIO = node.task.LOW_PRIORITY

local animFunc, animParams, animNumParams


function off()
    wsbuf:fill(0, 0, 0)
    wsbuf:write()
    tmr.wdclr()
end

function stop()
    tmr.unregister(2)
end

local timerTick

function animate()
    if animFunc then
        local delay = animFunc(wsbuf, unpack(animParams, 1, animNumParamsn))
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

function init()
    ws2812.init()
end

function start()
    tmr.register(2, 10, tmr.ALARM_SEMI, timerTick)
    return tmr.start(2)
end

function setFunction(f, ...)
    animFunc = f
    animParams = { ... }
    animNumParams = select("#", ...)
end


return {
   off         = off,
   start       = start,
   stop        = stop,
   init        = init,
   setFunction = setFunction
}
