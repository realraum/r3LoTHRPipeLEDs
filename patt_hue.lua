local function run(wsbuf, p, legacy_hue, legacy_bright_percent)
	if type(legacy_bright_percent) == "number" and legacy_bright_percent >= 0 and legacy_bright_percent <= 100 then
		p.brightness = legacy_bright_percent
	end
    if legacy_hue and type(legacy_hue) == "number" then
    	p.hue = legacy_hue % 256
    	p.randomhue = 0
    end
    wsbuf:fill(hue2rgb(p:getHue(), p.brightness))
    return 50 + ((19860 * (255 - p.speed)) / 255)
end

return run
