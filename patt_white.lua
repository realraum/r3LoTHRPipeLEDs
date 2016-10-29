local function run(wsbuf, bright_percent)
    if bright_percent > 100 then bright_percent = 100 end
    if bright_percent < 0 then bright_percent = 0 end
    wsbuf:fill(255*bright_percent/100, 255*bright_percent/100, 255*bright_percent/100)
    return 1000
end

return run
