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

import "safe"
-- From here, unsafe access to globals will fail

xxpcall(import, errorLog, "loader") -- load the rest, safely
