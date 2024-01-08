local points = {} -- table to hold waveform data
local maxDataPoints = 200 -- maximum number of data points to store
local updateInterval = 0.1 -- time interval between new data points
local period = 1 -- time period of the waveform
local dutyCycle = 0.5 -- duty cycle of the waveform
local wave = 1

computer2 = wave
waver2 = {}
Gamestate = require 'libraries.gamestate'
waver2 = Gamestate.new()
waver2.wave2 = wave

-- Adds the points of interest to the line for 
-- the waver to a waveform.
function addDataPoint2()
    -- Code for creating a sine wave
    if wave == 1 then
        -- Calculate the time since the start of the program
        local time = love.timer.getTime()

        -- Calculate the value of the waveform at the current time
        local t = time % period
        local value = math.sin(t / period * 2 * math.pi)

        -- Add the data point to the data table
        table.insert(points, value)

        -- Remove the oldest data point if the maximum number of data points has been reached
        if #points > maxDataPoints then
            table.remove(points, 1)
        end
    end

    -- Code for creating a sawtooth wave
    if wave == 2 then
            -- Calculate the time since the start of the program
        local time = love.timer.getTime()

        -- Calculate the value of the waveform at the current time
        local t = time % period
        local value = t / period * 2 - 1

        -- Add the data point to the data table
        table.insert(points, value)

        -- Remove the oldest data point if the maximum number of data points has been reached
        if #points > maxDataPoints then
            table.remove(points, 1)
        end
    end

    -- Code for creating a square wave
    if wave == 3 then
            -- Calculate the time since the start of the program
        local time = love.timer.getTime()

        -- Calculate the value of the waveform at the current time
        local t = time % period
        local value = t < period * dutyCycle and 1 or -1

        -- Add the data point to the data table
        table.insert(points, value)

        -- Remove the oldest data point if the maximum number of data points has been reached
        if #points > maxDataPoints then
            table.remove(points, 1)
        end
    end

    -- Code for creating a triangle wave
    if wave == 4 then
        -- Calculate the time since the start of the program
        local time = love.timer.getTime()

        -- Calculate the value of the waveform at the current time
        local t = time % period
        local slope = 2 * (t / period - math.floor(0.5 + t / period))
        local value = math.abs(slope) * 2 - 1

        -- Add the data point to the data table
        table.insert(points, value)

        -- Remove the oldest data point if the maximum number of data points has been reached
        if #points > maxDataPoints then
            table.remove(points, 1)
        end
    end
end

-- Updates and checks if the player has 
-- switched to any different waveforms
-- or has attempted to exit the waver.
function waver2:update(dt)
    if love.keyboard.isDown('1') then
        wave = 1
    end
    if love.keyboard.isDown('2') then
        wave = 2
    end
    if love.keyboard.isDown('3') then
        wave = 3
    end
    if love.keyboard.isDown('4') then
        wave = 4
    end

    if love.keyboard.isDown("escape") then
        waver2.wave2 = wave
        sleep(.5)
        Gamestate.pop(waver2)
    end
    -- Add a new data point at the specified time interval
    updateInterval = updateInterval - dt
    if updateInterval <= 0 then
        addDataPoint2()
        updateInterval = period / maxDataPoints -- update the interval based on the waveform period and the number of data points
    end

    computer2 = wave
end

-- Draws the waver on the players screen
function waver2:draw()
    love.graphics.clear(0.1, 0.1, 0.1) -- clear the screen with a dark gray color
    love.graphics.setColor(0, 1, 0) -- set the drawing color to green
    love.graphics.setLineWidth(1) -- set the line width to 1 pixel
    love.graphics.setLineStyle("smooth") -- set the line style to a smooth line with rounded corners

    -- Draw the waveform data points as a line
    for i = 2, #points do
        love.graphics.line(
            (i - 2) * love.graphics.getWidth() / (maxDataPoints - 1),
            (points[i - 1] + 1) * love.graphics.getHeight() / 2,
            (i - 1) * love.graphics.getWidth() / (maxDataPoints - 1),
            (points[i] + 1) * love.graphics.getHeight() / 2
        )
    end

    love.graphics.print(wave, 100, 100)
    love.graphics.print("Wave Data Manipulation Station", 100, 10)
    love.graphics.print("Usage Guide:", 100, 30)
    love.graphics.print("Use Numbers 1-4 to change between different wave forms", 100, 50)
end

-- Loads the waver for save states
function waver2.load()
    wave = data.wave2
    computer2 = wave
end
