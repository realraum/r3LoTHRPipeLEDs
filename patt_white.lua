local function run(wsbuf, p, legacy_bright_percent)
	if not (type(legacy_bright_percent) == "number" and legacy_bright_percent >0 and legacy_bright_percent <= 100) then
		legacy_bright_percent = p.brightness
	end
    wsbuf:fill(255*legacy_bright_percent/100, 255*legacy_bright_percent/100, 255*legacy_bright_percent/100)
    return 1000
end

return run
