local curhue=0

local function run(wsbuf, speed, bright_percent)
	if type(bright_percent) == "number" then
		if bright_percent > 100 then bright_percent = 100 end
		if bright_percent < 0 then bright_percent = 0 end
	else
		bright_percent = 100
	end
    if not speed or not type(speed) == "number" or speed < 1 or speed > 5000 then speed = 1 end
    wsbuf:fill(hue2rgb(curhue % 256, bright_percent))
    curhue = curhue + 1
    return 5000/speed
end

return run
