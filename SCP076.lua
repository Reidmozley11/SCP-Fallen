Gamestate = require 'libraries.gamestate'
anim8 = require 'libraries/anim8'
require("player")

-- makes stretch not blurry
love.graphics.setDefaultFilter("nearest", "nearest")

SCP076 = {}
    SCP076.spritesheet = love.graphics.newImage("sprites/scp076.png")
    SCP076.x = 1000
    SCP076.y = 800



function SCP076.spawn(x,y)
    table.insert(SCP076, {x = x, y=y})
end


function drawSCP076WithSize(SCP076, playerX, playerY, dt)
    local distance = math.sqrt((SCP076.x - playerX)^2 + (SCP076.y - playerY)^2)
    --print(distance)
    local dist = distance/1000000
    local maxScale = .065
    local scale = math.min(maxScale,dist)
    local growthFactor = math.exp(-distance/100)
    growthFactor = math.min(growthFactor,1/10)
    SCP076.scale = SCP076.scale or scale
    --print(SCP076.scale)
    SCP076.scale = SCP076.scale + growthFactor * dt
        
        -- Calculate the new width and height based on the original dimensions and the scaling factor
    local spriteWidth, spriteHeight = SCP076.spritesheet:getDimensions()
    local newWidth, newHeight = spriteWidth * SCP076.scale, spriteHeight * SCP076.scale
      
        -- Calculate the offset needed to maintain the center point of the PNG
    local xOffset = (newWidth - spriteWidth * SCP076.scale) / 2
    local yOffset = (newHeight - spriteHeight * SCP076.scale) / 2
    --SCP076.x = SCP076.x + xOffset
    --SCP076.y = SCP076.y + yOffset
        -- Draw the PNG using the origin parameter to maintain the center point
    love.graphics.draw(SCP076.spritesheet, SCP076.x, SCP076.y, 0, SCP076.scale, SCP076.scale, spriteWidth/2, spriteHeight/2)
    --print(SCP076.scale)
    end

 function DRAW_SCP(SCP076, playerX, playerY, dt)
    drawSCP076WithSize(SCP076, playerX, playerY, dt)
    Check()
end

function Check()

    local spriteWidth, spriteHeight = SCP076.spritesheet:getDimensions()
    local newWidth, newHeight = spriteWidth * SCP076.scale, spriteHeight * SCP076.scale
    local xOffset = (newWidth - spriteWidth * SCP076.scale) / 2
    local yOffset = (newHeight - spriteHeight * SCP076.scale) / 2
    local sprite1 = { x = player.x, y = player.y, width = 50, height = 80 }
    local sprite2 = { x = SCP076.x - newWidth/2, y = SCP076.y - newHeight/2, width = newWidth, height = newHeight }

    if (sprite1.x < sprite2.x + sprite2.width and
      sprite1.x + sprite1.width > sprite2.x and
      sprite1.y < sprite2.y + sprite2.height and
      sprite1.y + sprite1.height > sprite2.y) then
        player.health = player.health - .1
    return true
    else
        --print(player.x)
        --print(SCP076.x)
    end
end


function UPDATE_SCP(dt)
    --SCP.grow()
end