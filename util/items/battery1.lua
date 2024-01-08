battery1 = {}
    battery1.spritesheet = love.graphics.newImage("sprites/battery.png")
    local b1posx= {}
        b1posx[1] = 1400
        b1posx[2] = 2000
        b1posx[3] = 600
        b1posx[4] = 160
        b1posx[5] = 527
        b1posx[6] = 1692
        b1posx[7] = 2958
        b1posx[8] = 2477
    local b1posy = {}
        b1posy[1] = 2600
        b1posy[2] = 3000
        b1posy[3] = 2222
        b1posy[4] = 2022
        b1posy[5] = 1420
        b1posy[6] = 1366
        b1posy[7] = 1189
        b1posy[8] = 2295
    local r = love.math.random(1,8)
    battery1.x = b1posx[r]
    battery1.y = b1posy[r]
    battery1.h = battery1.spritesheet:getHeight()
    battery1.w = battery1.spritesheet:getWidth() 
    battery1.room = "levelOne"

function battery1:draw()
    if checkInventory(inventory, "battery1") == false and checkInventory(chest, "battery1") == false and battery1.room == room then
        love.graphics.draw(battery1.spritesheet,battery1.x,battery1.y)
    end
end

function battery1.load()
    battery1.x = data.battery1.x
    battery1.y = data.battery1.y
    battery1.room = data.battery1.room
end