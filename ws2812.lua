BRIGHT     = 10 -- in %
-- LED_PIN    = 4       -- GPIO2
PIXELS     = 30*5
TIME_ALARM = 400     -- [ms] define as global var

--global LED buffer for all animations and PIXELS
wsbuf = ws2812.newBuffer(PIXELS, 3)

--basic slow hue function with fixed brightness
--returns RGB array
function colourWheel(index)
  if index < 85 then
    return {index * 3 * BRIGHT / 100, (255 - index * 3) * BRIGHT / 100, 0}
  elseif index < 170 then
    index = index - 85
    return {(255 - index * 3) * BRIGHT / 100, 0, index * 3 * BRIGHT / 100}
  else
    index = index - 170
    return 0, index * 3 * BRIGHT / 100, (255 - index * 3) * BRIGHT / 100
  end
end

--global vars for pattern_rainbow
rainbow_speed = 2

--"rainbow"-pattern
--show a PIXELS long rainbow that reapeats with frequency rainbow_speed
--i.e. higher rainbow_speed, the less pixels a individual rainbow will be long
--
--since running pattern_rainbow() takes so long, we need to call tmr.wdclr() in between, otherwise the watchdog will reset us
--TODO: make pattern_rainbow() run faster
--TODO: use bit. module and replace % 256 with & 0xFF


if wsbuf.shift then
	function pattern_rainbow_fast()
	  wsbuf:shift(1,ws2812.SHIFT_CIRCULAR)
	  tmr.wdclr()
	  wsbuf:write()
	end
	function pattern_rainbow()
	  for pixel = 1, PIXELS do
	    tmr.wdclr()
	    wsbuf:set(pixel, colourWheel((pixel * rainbow_speed + rainbow_index) % 256))
	  end
	  tmr.wdclr()
	  wsbuf:write()
	  CurrentLedFunction = pattern_rainbow_fast
	end
else
	rainbow_index = 1
	function pattern_rainbow()
	  for pixel = 1, PIXELS do
	    tmr.wdclr()
	    wsbuf:set(pixel, colourWheel((pixel * rainbow_speed + rainbow_index) % 256))
	  end
	  rainbow_index = (rainbow_index + 1) % 256
	  tmr.wdclr()
	  wsbuf:write()
	end
end

--"off"-pattern.
-- fades out current content of wsbuf
function pattern_off()
  wsbuf:fade(2,ws2812.FADE_OUT)
  wsbuf:write()
  tmr.wdclr()
end

--"moving spots"-patterns
--show white pixelspots moving from left to right with trail
--number of pixelspots can be varied with spots_count
spots_index = 0
spots_count = 1
spots_distance = PIXELS/spots_count
function pattern_moving_spots()
  wsbuf:fade(2,ws2812.FADE_OUT)
  for spot = 0, spots_count do
  	tmr.wdclr()
  	wsbuf:set(1 + spots_index + (spot*spots_distance),255,255,255)
  end
  spots_index = (spots_index + 1) % spots_distance
  wsbuf:write()
end

--TODO: define additional animation patterns here
--animation patterns could also be single shot and return to the previous pattern when finished, just need to remember last state

--define availabe animation functions and map a string identifier to them
LedPatterns = {off = pattern_off, rainbow = pattern_rainbow, spots = pattern_moving_spots}
-- map string identifier for animations to repeat-interval in ms
-- repeat intervall [ms] must be at least as long as the function needs to run plus time needed to 
-- handle all other tasks (like task queuing and mqtt)
-- e.g. for each run of pattern_rainbow we need about 400ms, sadly.
LedPatternsInterval = {rainbow = 200, off = 600, spots = 200}
CurrentLedFunction = LedPatterns["rainbow"]
TIME_ALARM=LedPatternsInterval["rainbow"]

-- called regularly to animate LEDstrip by calling CurrentLedFunction
function ws2812Animate ()
  node.task.post(node.task.LOW_PRIORITY, CurrentLedFunction)
end

-- start timer and init ws2812 pins
-- TODO: restore state saved in filesystem in case of reboot on mqtt disconnect
function ws2812Start ()
  ws2812.init()
  tmr.alarm(2, TIME_ALARM, 1, ws2812Animate)
end

-- stop timer
function ws2812Stop ()
  tmr.unregister(2)
end

-- Select/Set Animation Function and optional argument
-- called by mqttChangePattern()
-- TODO: save last choosen pattern into a file
function ws2812Select (patt, arg)
  if LedPatterns[patt] ~= nil then
    print("Switching to pattern "..patt)
    CurrentLedFunction = LedPatterns[patt]
    -- change animation speed in necessary
    if LedPatternsInterval[patt] ~= TIME_ALARM then
        ws2812Stop()
        ws2812Start()
    end
    -- handle args
    if type(arg) == "number" and patt == "rainbow" then
      rainbow_speed = arg
    end
    if type(arg) == "number" and patt == "spots" then
    	spots_count = arg
		spots_distance = PIXELS/spots_count
	end
  end
end

