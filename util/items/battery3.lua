battery3 = {}
    battery3.spritesheet = love.graphics.newImage("sprites/battery.png")
    local bposx = {}
        bposx[1] = 2340
        bposx[2] = 1902
        bposx[3] = 695
        bposx[4] = 480
        bposx[5] = 453
        bposx[6] = 120
        bposx[7] = 199
        bposx[8] = 776
        bposx[9] = 919
    local bposy = {}
        bposy[1] = 1125
        bposy[2] = 127
        bposy[3] = 469
        bposy[4] = 830
        bposy[5] = 1117
        bposy[6] = 1137
        bposy[7] = 2838
        bposy[8] = 2619
        bposy[9] = 2990
    local r = love.math.random(1, 9)
    battery3.x = bposx[r]
    battery3.y = bposy[r]
    battery3.h = battery3.spritesheet:getHeight()
    battery3.w = battery3.spritesheet:getWidth() 
    battery3.room = "levelOne"

    function battery3:draw()
        if checkInventory(inventory, "battery3") == false and checkInventory(chest, "battery3") == false  and battery3.room == room then
            love.graphics.draw(battery3.spritesheet,battery3.x,battery3.y)
        end
    end

    function battery3.load()
        battery3.x = data.battery3.x
        battery3.y = data.battery3.y
        battery3.room = data.battery3.room
    end