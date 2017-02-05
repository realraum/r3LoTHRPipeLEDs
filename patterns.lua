local patterns = {}

local function loadPattern(pn)
    local f, err = loadfile("patt_" .. pn .. ".lua")
    if f then
        local p = f()
        patterns[pn] = p
        return p
    end
    errorLog(err)
end

-- auto-load additional patterns from external files
setmetatable(patterns, {
    __index = function(patterns, k)
        return loadPattern(k)
    end,
    --__mode = "kv",
})

local random = math.random

---- STROBO ----
do
    local on = false
    patterns.strobo = function(wsbuf)
        if on then
            wsbuf:fill(0, 0, 0)
        else
            wsbuf:fill(255, 255, 255)
        end
        on = not on
        return 1
    end
end

patterns.rstrobo = function(wsbuf)
    local r, g, b = random(0, 255),  random(0, 255),  random(0, 255)
    wsbuf:fill(g, r, b)
    return 50
end

patterns.allcolors = function(wsbuf)
    local set = wsbuf.set
    for i = 1, wsbuf:size() do
        local r, g, b = random(0, 255),  random(0, 255),  random(0, 255)
        set(wsbuf, i, g, r, b)
    end
end


return patterns
