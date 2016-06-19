local dispatch = _G.__index
setmetatable(_G, {
    __index = function(t, k)
        local v = dispatch and dispatch(t, k)
        if v == nil then
            print("Warning: Attempt to access _G[" .. tostring(k) .. "]")
        end
        return v
    end,
    __newindex = function(t, k, v)
        error("Error: Attempt to _G[" .. tostring(k) .. "] = " .. tostring(v))
    end,
})

local function errorLog(s)
    -- TODO print callstack and shit
    print(s)
    
    setglobal("LAST_ERROR", s)
end
setglobal("errorLog", errorLog)
