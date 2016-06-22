local max = math.max
local min = math.min

local function clamp(x, mi, ma)
    return min(ma, max(mi, x))
end


-- same as xpcall(f, errf), but additional args can follow: xxpcall(f, errf, ...)
local xxpcall
do
    -- code is slightly convoluted to prevent additional per-call memory allocation
    local ARGS = {}
    local CALLFUNC
    local NUMARGS
    local unpack = unpack
    local select = select
    local function _fillArgs(f, ...)
        CALLFUNC = f
        NUMARGS = select("#", ...)
        for i = 1, NUMARGS do
            ARGS[i] = select(i, ...)
        end
    end
    local function _callHelper()
        return CALLFUNC(unpack(ARGS, 1, NUMARGS)) -- this safely handles returned NILs or NILs in ARGS
    end
    xxpcall = function(f, errf, ...)
        _fillArgs(f, ...)
        return xpcall(_callHelper, errf)
    end
end

local BRIGHT = 10 -- in %
local function hue2rgb(index)
  if index < 85 then
    return index * 3 * BRIGHT / 100, (255 - index * 3) * BRIGHT / 100, 0
  elseif index < 170 then
    index = index - 85
    return (255 - index * 3) * BRIGHT / 100, 0, index * 3 * BRIGHT / 100
  else
    index = index - 170
    return 0, index * 3 * BRIGHT / 100, (255 - index * 3) * BRIGHT / 100
  end
end


setglobal("xxpcall", xxpcall)
setglobal("hue2rgb", hue2rgb)
setglobal("clamp", clamp)
