flashlight = {}
    flashlight.spritesheet = love.graphics.newImage("sprites/flashlight.png")
    flashlight.x = 650
    flashlight.y = 350
    flashlight.h = flashlight.spritesheet:getHeight()
    flashlight.w = flashlight.spritesheet:getWidth()
    flashlight.scale = 0.1
    flashlight.room = "runGame"
    flashlight.charge = 2000
    flashlight.max = 2000
    flashlight.decay = 1
    flashlight.recharge = 1.5

function flashlight:draw()
    if checkInventory(inventory, "flashlight") == false then
        
    if flashlight.room == room then
        love.graphics.draw(flashlight.spritesheet,flashlight.x,flashlight.y,0,flashlight.scale,flashlight.scale)
    end
end

end

function flashlight.load()
    flashlight.x = data.flashlightpos.x
    flashlight.y = data.flashlightpos.y
    flashlight.room = data.flashlightpos.room
end