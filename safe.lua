local dispatch = assert(_G.__index, "Not running on NodeMCU Lua?")
setmetatable(_G, {
    __index = function(t, k)
        local v = dispatch(t, k)
        if v == nil then
            print("Warning: Attempt to access _G[" .. tostring(k) .. "]")
        end
        return v
    end,
    __newindex = function(t, k, v)
        error("Error: Attempt to _G[" .. tostring(k) .. "] = " .. tostring(v))
    end,
})

setglobal("__index",  nil) -- kill original hidden dispatch function


local function errorLog(s)
    -- TODO print callstack and shit
    print(s)
    
    setglobal("LAST_ERROR", s)
end
setglobal("errorLog", errorLog)
