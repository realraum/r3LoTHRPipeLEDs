-- debug stuff
local function pp(t)
   local tt={}
   local i=0
   for k,v in pairs(t) do
      i=i+1 tt[i]=tostring(k) .. " = " .. tostring(v)
   end
   table.sort(tt)
   print(table.concat(tt,"\n"))
end

local function ls()
    pp(file.list())
end

local function rgb(r,g,b)
    ledbar.stop()
    ledbar.wsbuf:fill(g,r,b)
    ws2812.write(ledbar.wsbuf)
end

local function slurp(fn)
    local s
    if file.open(fn) then
        s = file.read()
        file.close()
    end
    return s
end

local function cat(fn)
    print(slurp(fn) or "! File not found")
end


setglobal("pp", pp) -- pretty print table
setglobal("rm", file.remove)
setglobal("cc", file.compile)
setglobal("ls", ls)
setglobal("rgb", rgb)
setglobal("slurp", slurp)
setglobal("cat", cat)

