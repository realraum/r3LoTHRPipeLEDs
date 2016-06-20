local function setglobal(k,v) rawset(_G, k, v) end
local function import(m, ...)
    local t = assert(loadfile(m .. ".lua"))(...)
    if t then
        setglobal(m, t)
    end
end
setglobal("setglobal", setglobal)
setglobal("import", import)

import "startup"
import "telnet"
telnet.open()

-- a global under the same name will be registered by safe.lua
local function errorLog(s)
    print(s)
    setglobal("LAST_ERROR", s)
    return s
end

-- load the rest, safely
xpcall(function() import "loader" end, errorLog)
