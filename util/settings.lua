Gamestate = require 'libraries.gamestate'
settings = {}
settings = Gamestate.new()

-- Builds all of the buttons for the settings
-- screen
BUTTON_HEIGHT = 64
devMODE = false

local font = love.graphics.newFont(32)
local button6 = {text = "Return to Pause Menu", fn = function()Gamestate.pop() sleep(.3)end, width = 300}
local button3 = {text = "Increase Volume", fn = function() settings.increasevolumes(Music.music) end, width = 150, x = 450 , y = 200}
local button2 = {text = "Decrease Volume", fn = function() settings.decreasevolumes(Music.music) end, width = 150, x = 900, y = 200}
local button5 = {text = "Increase Sound Effect Volumes", fn = function() settings.increasevolumes(Sounds.boop) settings.increasevolumes(Sounds.collision) settings.decreasevolumes(Sounds.win) end, width = 150, x = 450, y = 400}
local button4 = {text = "Decrease Sound Effect Volumes", fn = function() settings.decreasevolumes(Sounds.boop) settings.decreasevolumes(Sounds.collision) settings.decreasevolumes(Sounds.win) end, width = 150, x = 900, y = 400}
local button1 = {text = "Mute Sounds", fn = function() settings.mute() end, width = 300, x = 900, y = 100}
local button7 = {text = "Controls", fn = function()  Gamestate.push(controls) sleep(.3) end, width = 300, x = 900, y = 100}
local button8 = {text = "Dev Mode", fn = function() settings.dev() end, width = 100, x = 800, y = 75}

local allButtons = {button1,button2,button3,button4,button5,button6,button7,button8}

-- Builds a new button for the settings
-- screen.
-- @param text <- Takes in a string to write the buttons text
-- @param fn <- Takes in a function that the button will run
local function newButton(text,fn)
    return{
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end

-- Begins the settings screen
-- @param from <- Takes last screen that was present
function settings:enter(from)
    self:buttonpositions()
    self.from = from
end

-- Assigns the buttons to their correct positions
function settings:buttonpositions()
    local window_width = love.graphics.getWidth()
    local button_width = 300
    local window_height = love.graphics.getHeight()
    local button_height = 64
    button1.x = (window_width-300)/ 2
    button1.y = window_height/6
    button2.x = (window_width - 150) / 3
    button2.y = window_height/6 + window_height/6
    button3.x = (window_width-150)/3 + (window_width-150)/3
    button3.y = window_height/6 + window_height/6
    button4.x = (window_width - 150) / 3
    button4.y = 3*(window_height/6)
    button5.x = (window_width-150)/3 + (window_width-150)/3
    button6.x = (window_width - 300) / 2
    button6.y = 4*(window_height/6) +100
    button5.y = 3*(window_height/6)
    button7.x = (window_width - 300) / 2
    button7.y = 4*(window_height/6)
    button8.x = (window_width-150)/3 + (window_width-150)/3
    button8.y = 4*(window_height/6)
end

-- Resizes  the buttons
function love.resize()
    settings:buttonpositions()
end

Mastervolume = .5
font = love.graphics.newFont(32)

MVolume = .2
CVolume = .2
mute = false

-- Draws the settings screen on top
-- of whatever screen was being accessed
function settings:draw()
    self:buttonpositions()
    love.graphics.printf(("Music: " .. math.floor(Music.music:getVolume()*100) .. "%"),100,200,200)
    love.graphics.printf("Sound Effects: " .. math.floor(Sounds.collision:getVolume()*100) .. "%",100,400,400)
    local mousex, mousey = love.mouse.getPosition()
    for i, button in ipairs(allButtons) do
        local color = {.8,.4,.5,1}
        local highlight = mousex > button.x and mousex < button.x + button.width and mousey > button.y and mousey < button.y + BUTTON_HEIGHT
        if highlight then
            color = {.8,.8,.9,1}
            if love.mouse.isDown(1) then
                button.fn()
            end
        end
        love.graphics.setColor(unpack(color))
        if button == button8 then
            if devMODE == true then
                love.graphics.setColor(0,255,0)
            end
        end
        love.graphics.rectangle("fill", button.x, button.y, button.width, BUTTON_HEIGHT)
        love.graphics.setColor(0,0,0,1)
        love.graphics.printf(button.text, button.x, button.y + (BUTTON_HEIGHT/2)-(font:getHeight()/2), button.width, "center")
        
    end

    --resets the color so that it doesnt have a black screen (very important please dont delete)
    love.graphics.reset()
    if love.keyboard.isDown('m') then
        Gamestate.pop()
    end
    if love.keyboard.isDown('y') then
        Gamestate.switch(menu)
    end
end

function settings.dev()
    love.timer.sleep(.15)
    if devMODE == false then
        devMODE = true
    elseif devMODE == true then
        devMODE = false
    end
end

-- Mutes the volume of the game completely
function settings.mute()
    love.timer.sleep(.15)
    if mute == false then
        mute = true
    elseif mute == true then
        mute = false
    end

    if mute == false then
            Music.music:setVolume(TemMu)
            Sounds.collision:setVolume(TemCol)
            Sounds.boop:setVolume(TemCol)
            Sounds.win:setVolume(TemCol)
    end

    if mute == true then
        TemMu = Music.music:getVolume()
        TemCol = Sounds.collision:getVolume()
        Music.music:setVolume(0)
        Sounds.collision:setVolume(0)
        Sounds.boop:setVolume(0)
        Sounds.win:setVolume(0)
        

    end

end

-- Increases the volume of the game
-- @param param <- Passes a music table into the funtion
function settings.increasevolumes(param)
    love.timer.sleep(.15)
    local vom
        vom = param:getVolume()
        vom = vom + .1
        param:setVolume(vom)
        if vom > 1 then
            vom = 1
        end
    param:setVolume(vom)
end

-- Decreases the volume of the game
-- @param parameter <- Passes a music table into the funtion
function settings.decreasevolumes(parameter)
    local vom
    love.timer.sleep(.15)
        vom = parameter:getVolume()
        vom = vom - .1
        parameter:setVolume(vom)
        if vom <= 0 then
            vom = 0
        end
    parameter:setVolume(vom)
end

function settings.load()

end

-- Updates the settings screen 
-- checking to see if the player presses escape to
-- close out the settings screen
function settings:update()
    if love.keyboard.isScancodeDown('escape') then
        love.timer.sleep(.15)
        return Gamestate.pop()
    end
end