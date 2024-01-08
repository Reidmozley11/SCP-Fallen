Gamestate = require 'libraries.gamestate'
controls = {}
controls = Gamestate.new()
con = love.graphics.newImage("screens/controls.png")
function controls:enter(from)
      self.from = from
      love.graphics.clear()
      love.graphics.reset()
  end

function controls:update(dt)
    --controls.update(dt)
end

function controls:draw()
    self.from:draw()
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    
    love.graphics.draw(con, 0, 0, 0, screenWidth / con:getWidth(), screenHeight / con:getHeight())
    if love.keyboard.isDown('escape') then
        love.timer.sleep(.15)
        Gamestate.pop()
    end
end

function controls.load()
    con = love.graphics.newImage("screens/controls.jpg")
end
