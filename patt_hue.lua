local function run(wsbuf, hue, bright_percent)
    if bright_percent > 100 then bright_percent = 100 end
    if bright_percent < 0 then bright_percent = 0 end
    wsbuf:fill(hue2rgb(hue % 256, bright_percent))
    return 1000
end

return run
