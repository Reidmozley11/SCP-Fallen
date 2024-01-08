Gamestate = require 'libraries.gamestate'
greenmon = {}
greenmon = Gamestate.new()
greenpuzzle = love.graphics.newImage("screens/pigpen.png")
function greenmon:enter(from)
      self.from = from
      love.graphics.clear()
      love.graphics.reset()
  end

function greenmon:update(dt)
    --greenmon.update(dt)
end

function greenmon:draw()
    self.from:draw()
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    
    love.graphics.draw(greenpuzzle, 0, 0, 0, screenWidth / greenpuzzle:getWidth(), screenHeight / greenpuzzle:getHeight())
    if love.keyboard.isDown('escape') then
        love.timer.sleep(.15)
        Gamestate.pop()
    end
end

function greenmon.load()
    greenpuzzle = love.graphics.newImage("screens/pigpen.jpg")
end

