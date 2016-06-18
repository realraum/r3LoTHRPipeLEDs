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
})


---- STROBO ----
do
    local on = false
    patterns.strobo = function(wsbuf)
        if on then
            wsbuf:fill(0, 0, 0)
        else
            wsbuf:fill(255, 255, 255)
        end
        wsbuf:write()
        on = not on
        return 50
    end
end

