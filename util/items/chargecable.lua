chargecable = {}
    chargecable.spritesheet = love.graphics.newImage("sprites/chargingcable.png")
    chargecable.x = 60
    chargecable.y = 750
    chargecable.h = chargecable.spritesheet:getHeight()
    chargecable.w = chargecable.spritesheet:getWidth()
    chargecable.scale = 3
    chargecable.room = "levelTwo"

function chargecable:draw()
    if checkInventory(inventory, "chargecable") == false then
    if chargecable.room == room then
        love.graphics.draw(chargecable.spritesheet,chargecable.x,chargecable.y,0,chargecable.scale,chargecable.scale)
    end
end

end

function chargecable.load()
    chargecable.x = data.chargecable.x
    chargecable.y = data.chargecable.y
    chargecable.room = data.chargecable.room
end