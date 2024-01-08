battery2 = {}
    battery2.spritesheet = love.graphics.newImage("sprites/battery.png")
    local b2posx = {}
        b2posx[1] = 1988
        b2posx[2] = 172
        b2posx[3] = 1082
        b2posx[4] = 2100
        b2posx[5] = 2533
        b2posx[6] = 1451
        b2posx[7] = 818
        b2posx[8] = 1856
        b2posx[9] = 2486
    local b2posy = {}
        b2posy[1] = 545
        b2posy[2] = 288
        b2posy[3] = 1420
        b2posy[4] = 813
        b2posy[5] = 3000
        b2posy[6] = 240
        b2posy[7] = 2000
        b2posy[8] = 1980
        b2posy[9] = 1668
    local r = love.math.random(1,9)
    battery2.x = b2posx[r]
    battery2.y = b2posy[r]
    battery2.h = battery2.spritesheet:getHeight()
    battery2.w = battery2.spritesheet:getWidth() 
    battery2.room = "levelOne"

    function battery2:draw()
        if checkInventory(inventory, "battery2") == false and checkInventory(chest, "battery2") == false  and battery2.room == room then
            love.graphics.draw(battery2.spritesheet,battery2.x,battery2.y)
        end
    end

    function battery2.load()
        battery2.x = data.battery2.x
        battery2.y = data.battery2.y
        battery2.room = data.battery2.room
    end