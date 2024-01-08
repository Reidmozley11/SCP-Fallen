-- Gamestate library
Gamestate = require 'libraries.gamestate'
lose = {}
lose = Gamestate.new()

local buttons = {}
BUTTON_HEIGHT = 64
font = nil
losebackground = love.graphics.newImage("screens/lose.png")
local function newButton(text,fn)
    return{
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end

function lose:enter(from)
    
  --  img = love.graphics.newImage("screens/lose.png")
    --img:setWrap("repeat", "repeat")
    --quad = love.graphics.newQuad( 0,0, 800,600, 800,720)
    self.from = from
    
    --pause.load()
   -- love.graphics.clear()
    --love.graphics.reset()
   -- love.window.setMode(1024,1024)
    --todo
    --player.load()

end

--function pause:update(dt)
  --  pause.update(dt)
--end

table.insert(buttons,newButton("Return to Main Menu",function() love.event.quit( "restart" ) end))
table.insert(buttons,newButton("Exit",function()love.event.quit(0)end))

font = love.graphics.newFont(32)
function lose:draw()
    love.graphics.reset()
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.draw(losebackground, 0, 0, 0, screenWidth / losebackground:getWidth(), screenHeight / losebackground:getHeight())
    --love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / background:getWidth(), love.graphics.getHeight() / background:getHeight())
    --love.graphics.draw(img, quad, 0,0, 0, 1,1)
   --love.graphics.reset()
    --self.from:draw()
    --font = love.graphics.newFont(32)
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local buttonwidth = ww * (1/3)
    local margin = 16
    local cursor_y = 0
    local total = (BUTTON_HEIGHT+margin) * #buttons
    --love.graphics.printf('SETTINGS',0,wh/2,ww,'center')
    for i, buttons in ipairs(buttons) do
        buttons.last = buttons.now
        --love.graphics.setColor(255,255,255,1)
        local x = (ww*.5)-(buttonwidth*.5)
        local y = (wh * .5)-(total * .5)+cursor_y
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

   -- if love.keyboard.isDown('s') then
     --   Gamestate.pop()
       -- love.graphics.reset()
        --Gamestate.push(settings)
        --settings.load()
    if love.keyboard.isDown('escape') then
        love.timer.sleep(.15)
        Gamestate.pop()
    end
end

 function lose.load()

    losebackground = love.graphics.newImage("screens/lose.jpg")
--     --Gamestate.switch(pause)

end


function lose:update()
    if love.keyboard.isScancodeDown('p') then
        love.timer.sleep(.15)
        return Gamestate.pop()
    end
end

