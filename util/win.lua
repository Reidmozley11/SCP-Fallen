-- Gamestate library
Gamestate = require 'libraries.gamestate'
win = {}
win = Gamestate.new()

local buttons = {}
BUTTON_HEIGHT = 64
font = nil
winbackground = love.graphics.newImage("screens/win.png")

-- Builds a new button for the win screen.
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

-- Enters the win screen 
-- @param from <- Brings in the screen that was present
function win:enter(from)
    self.from = from
end

-- Creates two buttons for returning to the main menu or 
-- exiting the game.
table.insert(buttons,newButton("Return to Main Menu",function() love.event.quit( "restart" ) end))
table.insert(buttons,newButton("Exit",function()sleep(1) love.event.quit(0)end))

font = love.graphics.newFont(32)

-- Draws the win screen
function win:draw()
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.draw(winbackground, 0, 0, 0, screenWidth / winbackground:getWidth(), screenHeight / winbackground:getHeight())
    
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local buttonwidth = ww * (1/3)
    local margin = 16
    local cursor_y = 0
    local total = (BUTTON_HEIGHT+margin) * #buttons

    for i, buttons in ipairs(buttons) do
        buttons.last = buttons.now
        local x = (ww*.5) - (buttonwidth*.5)
        local y = (wh * .5) - (total * .5) + cursor_y
        local color = {.8,.4,.5,1}
        local mousex, mousey = love.mouse.getPosition()
        local highlight = mousex > x and mousex < x + buttonwidth and mousey > y and mousey < y + BUTTON_HEIGHT
        if highlight then
            color  = {.8,.8,.9,1}
        end
        buttons.now = love.mouse.isDown(1)
        if buttons.now and not buttons.last and highlight then
            buttons.fn()
        end

        love.graphics.setColor((color))
        love.graphics.rectangle("fill",(ww*.5)-(buttonwidth*.5),(wh * .5)-(total * .5)+cursor_y,buttonwidth,BUTTON_HEIGHT)
        love.graphics.setColor(0,0,0,1)
        local textwidth = font:getWidth(buttons.text)
        local textHeight = font:getHeight(buttons.text)
        love.graphics.print(buttons.text,font,(ww*.5)-textwidth*.5,y+textHeight*.5)
        cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
    end

    love.graphics.reset()

    if love.keyboard.isDown('escape') then
        love.timer.sleep(.15)
        Gamestate.pop()
    end
end

-- Loads the win screen image
function win.load()
    winbackground = love.graphics.newImage("screens/win.jpg")
end

