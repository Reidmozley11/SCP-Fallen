
player = {}
inventory = {}
chest = {}
local testing = require("testing.testing")
local tests = require('testing.tests')
Moan = require 'libraries/Moan/Moan'
anim8 = require 'libraries/anim8'
local mapmap = love.graphics.newImage("maps/Maze.jpg")
transitionModule = require('util/transition')

player.paused = 0
player.spriteSheet = love.graphics.newImage('sprites/guard_yellow_spritesheet.png')
player.grid = anim8.newGrid( 16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
player.x = 0
player.y = 0
player.xvel = 0
player.yvel = 0
player.friction = 5
player.speed = 250
player.stamina = 2000
player.max_health = 100
player.health = 100
player.keytimer = 0
player.hinttimer = 500
player.width, player.height = player.spriteSheet:getDimensions()
player.flashlightCounter = 0

--this is for the green health sprite
heartbeat = {}
    heartbeat.spritesheet = love.graphics.newImage('sprites/greenheath2.png')
    heartbeat.grid = anim8.newGrid (64, 32, heartbeat.spritesheet:getWidth(), heartbeat.spritesheet:getHeight())
    heartbeat.animations = anim8.newAnimation( heartbeat.grid('1-107', 1),0.025)
    heartbeat.anim = heartbeat.animations


yellowheartbeat = {}
    yellowheartbeat.spritesheet = love.graphics.newImage('sprites/yellowhealth.png')
    yellowheartbeat.grid = anim8.newGrid (64, 32, yellowheartbeat.spritesheet:getWidth(), yellowheartbeat.spritesheet:getHeight())
    yellowheartbeat.animations = anim8.newAnimation( yellowheartbeat.grid('1-84', 1),0.020)
    yellowheartbeat.anim = yellowheartbeat.animations
    
--this is for the red health sprite
redheartbeat = {}
    redheartbeat.spritesheet = love.graphics.newImage('sprites/redhealth.png')
    redheartbeat.grid = anim8.newGrid (64, 32, redheartbeat.spritesheet:getWidth(), redheartbeat.spritesheet:getHeight())
    redheartbeat.animations = anim8.newAnimation( redheartbeat.grid('1-109', 1),0.015)
    redheartbeat.anim = redheartbeat.animations

player.animations = {}
    player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.25 )
    player.animations.left = anim8.newAnimation( player.grid('1-4', 3), 0.25 )
    player.animations.right = anim8.newAnimation( player.grid('1-4', 4), 0.25 )
    player.animations.up = anim8.newAnimation( player.grid('1-4', 2), 0.25 )
    player.anim = player.animations.left

function player.load(x,y)
if x == nil then
    x = 450
    y = 300
end
        player.collider = world:newBSGRectangleCollider(x, y, 55, 80, 14)
        player.collider:setCollisionClass('Solid')
        player.collider:setFixedRotation(true)
        player.timer = 0
end

function player:update(dt)
   -- print(player.health)
    if (player.health > (player.max_health -3)) then
        heartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health -3) and player.health > (player.max_health / 3)) then
        yellowheartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 3)) then
        redheartbeat.anim:update(dt)
    end

    if player.keytimer < 500 then
        player.keytimer = player.keytimer +1
    end
    if player.keytimer >= 500 then
        player.keytimer = 0
    end
    if player.hinttimer < 500 then
        player.hinttimer = player.hinttimer + 1
       -- print(player.hinttimer)
    end
    player.timer = player.timer + dt
        -- player.pause(dt)
        player.control(dt)
        player.physics(dt)
        player.colliderMatching(dt)
        transition.Transitioner(self)
        if (player.keytimer%1000 == 0) then
            --os.execute("clear")
            --testing.run()
        end
        if player.health < player.max_health then
            player.health = player.health + .01
        end
        Moan.update(dt)
end

function player.colliderMatching(dt)
        player.x = player.collider:getX() - 10
        player.y = player.collider:getY() -13
end

function player.control(dt)
        local isMoving = false 
        player.xvel = 0
        player.yvel = 0
        player.speed = 250

        if player.stamina < 2000 then
        player.stamina = player.stamina +2
        end

        if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
            if player.stamina > 0 then
                player.speed = 500
                player.anim:update(.005)
            end
            if player.stamina > -9 then
                player.stamina = player.stamina -5
            end          
        end
        -- Player Movement
        
        




       if love.keyboard.isDown("d") then
           player.xvel = player.speed
           player.anim = player.animations.right
           isMoving = true
       end
       if love.keyboard.isDown("a") then
           player.xvel = player.speed * -1
           player.anim = player.animations.left
           isMoving = true
       end
       if love.keyboard.isDown("s") then
           player.yvel = player.speed
           player.anim = player.animations['down']
           isMoving = true
       end
       if love.keyboard.isDown("w") then
           player.yvel = player.speed * -1
           player.anim = player.animations.up
           isMoving = true
       end


       if shaders.flashlight == true then
       local width, height = love.window.getMode()
       local mousex, mousey = love.mouse.getPosition()
       if mousex < width/2.5 then 
           player.anim = player.animations.left
       end
       if mousex > (width -(.4*width)) then
           player.anim = player.animations.right
       end
       if mousey < height/2.5 then
           player.anim = player.animations.up
       end
       if mousey > (height -(.4*height)) then
           player.anim = player.animations.down
       end
    end

       -- Sets the players hitbox to move with where our 
       -- player is currently moving
       player.collider:setLinearVelocity(player.xvel, player.yvel)


       -- switches game back into the main menu
    --    if love.keyboard.isDown("escape") then
    --     --need to set the size of screen to match the main screen or shrink the screen size
    --         love.window.setMode(800, 600)
    --         Gamestate.push(menu)
    --    end


       if love.keyboard.isDown("escape") then
            love.timer.sleep(.3)
            --Sounds.music:pause()
            Gamestate.push(pause)
       end

--and checkInventory(inventory, "flashlight") == true

    if love.keyboard.isDown("f") and checkInventory(inventory, "flashlight")  then
        levelOne.flashtime = levelOne.flashtime + 1
    if (player.keytimer > 150) then
        if (shaders.flashlight == false) then
            shaders.flashlight = true
            player.keytimer = 0
        else
            shaders.flashlight = false
            player.keytimer = 0
        end
    end
end

if love.keyboard.isDown("l") and player.keytimer > 150 then
    testing.run()
    player.keytimer = 0
end


function distanceBetweenSprites(x1, y1, w1, h1, x2, y2, w2, h2)
    if x1 == nil or y1 == nil or w1 == nil or h1 == nil or x2 == nil or y2 == nil or w2 == nil or h2 == nil then
      return 10000
    end
    local center1_x = x1 + w1/2
    local center1_y = y1 + h1/2
    local center2_x = x2 + w2/2
    local center2_y = y2 + h2/2
  
    local x_distance = center1_x - center2_x
    local y_distance = center1_y - center2_y
    local distance = math.sqrt(x_distance^2 + y_distance^2)
    return distance
  end
  
-- Player picks things up!
if love.keyboard.isDown("e")  then 
    if distanceBetweenSprites(player.x, player.y, 55, 80, gengar.x+30, gengar.y+50, gengar.w, gengar.h) < 100 then
        if checkInventory(inventory,"gengar") == false and inventory[2] == nil and room == gengar.room then
       --print("added Genga to inventory")
        gengar.x = 0
        gengar.y = 0
        table.insert(inventory,"gengar")
       --print(distanceBetweenSprites(player.x, player.y, 65, 100, gengar.x+30, gengar.y+50, gengar.w, gengar.h)) 
        end
    end
    if distanceBetweenSprites(player.x, player.y, 55, 80, flashlight.x+20, flashlight.y, flashlight.w*flashlight.scale,flashlight.h*flashlight.scale ) <85 and checkInventory(inventory,"flashlight") == false and inventory[2] == nil and room == flashlight.room then
        --print("added flashlight to inventory")
        flashlight.x = 0
        flashlight.y = 0
        table.insert(inventory,"flashlight")
        game.interact = game.interact + 1
        player.flashlightCounter = player.flashlightCounter +1
       -- print(player.flashlightCounter)
       
    end
    if distanceBetweenSprites(player.x, player.y, 55, 80, rock.x, rock.y, rock.w, rock.h ) <100 and checkInventory(inventory,"rock") == false  and player.keytimer > 150 and inventory[2] == nil  and rock.collider ~= nil then
        --print("added rock to inventory")
        rock.x = 0
        rock.y = 0
        table.insert(inventory,"rock")
        rock.collider:destroy()
        rock.collider = nil
        player.keytimer = 0
    end
    if distanceBetweenSprites(player.x, player.y, 55, 80, battery1.x, battery1.y, battery1.w, battery1.h) < 80 and checkInventory(inventory,"battery1") == false and inventory[2] == nil and room == battery1.room then
        battery1.x = 0
        battery1.y = 0
        table.insert(inventory,"battery1")
    end
    if distanceBetweenSprites(player.x, player.y, 55, 80, battery2.x, battery2.y, battery2.w, battery2.h) < 80 and checkInventory(inventory,"battery2") == false and inventory[2] == nil and room == battery2.room then
        battery2.x = 0
        battery2.y = 0
        table.insert(inventory,"battery2")
    end
    if distanceBetweenSprites(player.x, player.y, 55, 80, battery3.x, battery3.y, battery3.w, battery3.h) < 80 and checkInventory(inventory,"battery3") == false and inventory[2] == nil and room == battery3.room then
        battery3.x = 0
        battery3.y = 0
        table.insert(inventory,"battery3")
    end
    if distanceBetweenSprites(player.x, player.y, 55, 80, book.x, book.y, book.w*book.scale, book.h*book.scale) < 80 and checkInventory(inventory,"book") == false and inventory[2] == nil and room == book.room then
        book.x = 0
        book.y = 0
        table.insert(inventory,"book")
    end
    if distanceBetweenSprites(player.x, player.y, 55, 80, chargecable.x, chargecable.y, chargecable.w*chargecable.scale, chargecable.h*chargecable.scale) < 80 and checkInventory(inventory,"chargecable") == false and inventory[2] == nil and room == chargecable.room then
        chargecable.x = 0
        chargecable.y = 0
        table.insert(inventory,"chargecable")
    end
    if distanceBetweenSprites(player.x, player.y, 55, 80, ball.x, ball.y, ball.w*ball.scale, ball.h*ball.scale) < 150 and checkInventory(inventory,"ball") == false and inventory[2] == nil and room == ball.room then
        ball.x = 0 
        ball.y = 0 
        table.insert(inventory,"ball")
    end
end

local gamecount = 0
if room == "runGame" and player.x > 634 and player.x < 788 then
    if player.y > 111 and player.y < 189 then
        if checkInventory(inventory, "book") == true and love.keyboard.isDown('e') then
            DropItem(findItem("book"))
            table.insert(chest,"book")
            book.x = 5000
            book.y = 5000
        end
        if checkInventory(inventory, "chargecable") == true and love.keyboard.isDown('e') then
            DropItem(findItem("chargecable"))
            table.insert(chest,"chargecable")
            chargecable.x = 5000
            chargecable.y = 5000
        end
        if checkInventory(inventory, "ball") == true and love.keyboard.isDown('e') then
        DropItem(findItem("ball"))
        table.insert(chest,"ball")
        ball.x = 5000
        ball.y = 5000
        end
    end
end

-- SHOW DIRECTION TO TARGET
function player.playerHint(targetX,targetY)
    if targetX == nil or targetY == nil or player.x == nil or player.y == nil then
        do return end
    end
local arrowX = player.x
local arrowY = player.y
local dx = targetX - player.x
local dy = targetY - player.y
-- local angle = 0
-- if dx == 0 then
--     if dy < 0 then
--         angle = math.pi * 3 / 2
--     else
--         angle = math.pi / 2
--     end
-- elseif dy == 0 then
--     if dx < 0 then
--         angle = math.pi
--     end
-- else
--     angle = math.atan(dy/dx)
--     if dx < 0 and dy < 0 then
--         angle = angle - math.pi
--     elseif dx < 0 and dy > 0 then
--         angle = angle + math.pi
--     end
-- end

    local arrowAngle = math.atan2(dy, dx)
    local arrowAngle = math.deg(arrowAngle) - 90


    local arrowImage = love.graphics.newImage("sprites/arrow.png")
    local arrowScale = .5
    local arrowX = player.x
    local arrowY = player.y
    --print(arrowAngle)
    love.graphics.draw(arrowImage, arrowX, arrowY, math.rad(arrowAngle), arrowScale, arrowScale)
end





--print(player.keytimer)
local mouseX, mouseY = love.mouse:getPosition()
    if mouseX >= 200 and mouseX <= 264 and mouseY >= 15 and mouseY <= 79 and love.mouse.isDown(1) and player.keytimer > 150 then

    DropItem(1)
    elseif mouseX >= 280 and mouseX <= 344 and mouseY >= 15 and mouseY <= 79 and love.mouse.isDown(1) and player.keytimer > 150 then
    DropItem(2)
    --end
end

function DropItem(param)
    local item = inventory[param]
    table.remove(inventory, param)
    local x,y
    if player.anim == player.animations.right then
        x = player.collider:getX() + 20
        y = player.collider:getY()
    end
    if player.anim == player.animations.left then 
         x = player.collider:getX() -55
         y = player.collider:getY()
    end
    if player.anim == player.animations.up then 
         x = player.collider:getX()
         y = player.collider:getY() -25
    end
    if player.anim == player.animations.down then
         x = player.collider:getX()
         y = player.collider:getY() +25
    end
    if item == "rock" then
        rock.room = room
        rock.load(x,y)
        --rock.collider:setPosition(x,y)
    end
    if item == "flashlight" then
        flashlight.x = x
        flashlight.y = y
        flashlight.room = room
        shaders.flashlight = false
    end
    if item == "gengar" then
        gengar.x = x
        gengar.y = y
        gengar.room = room
    end
        if item == "battery1" then
        battery1.x = x
        battery1.y = y
        battery1.room = room
    end
    if item == "battery2" then
        battery2.x = x
        battery2.y = y
        battery2.room = room
    end
    if item == "battery3" then
        battery3.x = x
        battery3.y = y
        battery3.room = room
    end
    if item == "book" then
        book.x = x
        book.y = y
        book.room = room
    end
    if item == "chargecable" then
        chargecable.x = x
        chargecable.y = y
        chargecable.room = room
    end
    if item == "ball" then
        ball.x = x
        ball.y = y
        ball.room = room
    end
    player.keytimer = 0

end

       -- Freezes the frame on the idle sprite in that direction
       if (isMoving == false) then
            player.anim:gotoFrame(3)
       end

       if love.keyboard.isDown("l") then
        player.health = player.health - .1
       end

       if love.keyboard.isDown("k") then
        player.health = player.health + .1
       end
       
       if player.health <= 0 then
        Gamestate.switch(lose)
        player.health = 100
       end
end

function player.physics(dt)
	player.x = player.x + player.xvel * dt
	player.y = player.y + player.yvel * dt
	player.xvel = player.xvel * (1 - math.min(dt*player.friction, 1))
	player.yvel = player.yvel * (1 - math.min(dt*player.friction, 1))
end

function player.draw()
    -- Health Bar
    -- Green above 50%
    if (player.health > (player.max_health -3)) then
        heartbeat.anim:draw(heartbeat.spritesheet,30, 30, nil,3, nil,  9,9) 
    -- Yellow between 50% and 25%
    elseif ( player.health <= (player.max_health -3) and player.health > (player.max_health / 3)) then
        yellowheartbeat.anim:draw(yellowheartbeat.spritesheet,30, 30, nil,3, nil,  9,9)
    -- Red under 25%
    elseif (player.health <= (player.max_health / 3)) then
        redheartbeat.anim:draw(redheartbeat.spritesheet,30, 30, nil,3, nil,  9,9) 
    end

    -- Blue coloring for stamina bar
    love.graphics.setColor(0,0,255)
    -- Stamina Bar
    love.graphics.rectangle("fill", 5, 90, math.floor(190 * (player.stamina/2000)), 25)
    love.graphics.reset()
    -- Text that sits on stamina bar
    love.graphics.print("Sprint", 5, 90, nil, 1)

    if checkInventory(inventory,"flashlight") then
        love.graphics.setColor(0,255,255)
        --print(flashlight.charge)
        love.graphics.rectangle("fill", 5, 120, math.floor(190 * (flashlight.charge/flashlight.max)), 25)
        love.graphics.setColor(0,0,0)
        love.graphics.print("Flashlight Charge", 5, 120, nil, 1)
        love.graphics.reset()
    end
    -- Inventory Boxes
    local position = findItem("flashlight")
    local position2 = findItem("gengar")
    local position3 = findItem("rock")
    local position4 = findItem("battery1")
    local position5 = findItem("battery2")
    local position6 = findItem("battery3")
    local position7 = findItem("book")
    local position8 = findItem("chargecable")
    local position9 = findItem("ball")
        love.graphics.rectangle("line", 200, 15, 64, 64)
        love.graphics.rectangle("line", 280, 15, 64, 64)
    if position3 == 1 then
        love.graphics.draw(rock.spritesheet,207.5,19,0,1.5,1.5)
    end
    if position3 == 2 then
        love.graphics.draw(rock.spritesheet,287,18,0,1.5,1.5)
    end
    if position == 1 then
        love.graphics.draw(flashlight.spritesheet,209,20,0,flashlight.scale,flashlight.scale)
    end
    if position == 2 then
        love.graphics.draw(flashlight.spritesheet,287,21,0,flashlight.scale,flashlight.scale)
    end
    if position2 == 1 then
        love.graphics.draw(gengar.spritesheet,207.5,19,0,.5,.5)
    end
    if position2 == 2 then
        love.graphics.draw(gengar.spritesheet,287,18,0,.5,.5)
    end
    if position4 == 1 then
        love.graphics.draw(battery1.spritesheet,277,0,1.5,1.5)
    end
    if position4 == 2 then
            love.graphics.draw(battery1.spritesheet,367,0,1.5,1.5)
    end
    if position5 == 1 then
        love.graphics.draw(battery1.spritesheet,277,0,1.5,1.5)
    end
    if position5 == 2 then
            love.graphics.draw(battery1.spritesheet,367,0,1.5,1.5)
    end
    if position6 == 1 then
        love.graphics.draw(battery1.spritesheet,277,0,1.5,1.5)
    end
    if position6 == 2 then
            love.graphics.draw(battery1.spritesheet,367,0,1.5,1.5)
    end
    if position7 == 1 then
        love.graphics.draw(book.spritesheet,217,20,0,1.2,1.2)
    end
    if position7 == 2 then
            love.graphics.draw(book.spritesheet,299,20,0,1.2,1.2)
    end
    if position8 == 1 then
        love.graphics.draw(chargecable.spritesheet,195,15,0,2,2)
    end
    if position8 == 2 then
            love.graphics.draw(chargecable.spritesheet,277,15,0,2,2)
    end
    if position9 == 1 then
        love.graphics.draw(ball.spritesheet, 209, 25, 0, ball.scale, ball.scale)
    end
    if position9 == 2 then
        love.graphics.draw(ball.spritesheet, 292, 25, 0, ball.scale, ball.scale)
    end

    if love.keyboard.isDown("e")  then 
        if nearItem() ~= false then 
            if inventory[2] ~= nil and checkInventory(inventory, nearItem()) == false then
                --Gamestate.push(full)
                love.graphics.print("Inventory Full!", game.width/2-28,game.height/2-50)
            end
        end 
    end

    if love.keyboard.isDown("i") and game.talk ~= 0 then
        if checkInventory(chest, "battery1") == false or checkInventory(chest, "battery2") == false or checkInventory(chest, "battery3") == false then
            checklist = love.graphics.newImage("sprites/checklist.png")
        elseif (checkInventory(inventory, "book") == true or checkInventory(chest, "book") or (book.x ~= 1390 and book.y ~= 300)) and (checkInventory(inventory, "ball") == true or checkInventory(chest, "ball") or (ball.x ~= 3000 and ball.y ~= 230)) and (checkInventory(inventory, "chargecable") == true or checkInventory(chest, "chargecable") or (chargecable.x ~= 60 and chargecable.y ~= 750 )) then
            checklist = love.graphics.newImage("sprites/checklist3.png")
        elseif (checkInventory(inventory, "ball") == true or checkInventory(chest, "ball") or (ball.x ~= 3000 and ball.y ~= 230)) and checkInventory(inventory, "chargecable") == true or checkInventory(chest, "chargecable") or (chargecable.x ~= 60 and chargecable.y ~= 750 )then
            checklist = love.graphics.newImage("sprites/checklist2.png")
        elseif checkInventory(inventory, "ball") == true or checkInventory(chest, "ball") or (ball.x ~= 3000 and ball.y ~= 230) then
            checklist = love.graphics.newImage("sprites/checklist1.png")
        end
        love.graphics.draw(checklist, game.width/2, game.height/3 -game.height/3 + 10)
    end
    
    if love.keyboard.isDown("m") and scientist.maze ~= 0 then
        love.graphics.draw(mapmap, game.width/2, game.height/3, 0, 0.4,0.4)
    end
end

function DRAW_HUD()
    player.draw()
end

function checkInventory(inventory, item)
    for _, value in pairs(inventory) do
        if value == item then
            return true
        end
    end
    return false
end

function findItem(item)
    for i, v in ipairs(inventory) do
      if v == item then
        return i
      end
    end
    return -1
  end

function nearItem()
    if distanceBetweenSprites(player.x, player.y, 55, 80, gengar.x+30, gengar.y+50, gengar.w, gengar.h) < 100 then
        return "gengar"
    elseif distanceBetweenSprites(player.x, player.y, 55, 80, flashlight.x+20, flashlight.y, flashlight.w*flashlight.scale,flashlight.h*flashlight.scale ) <85 then
        return "flashlight"
    elseif distanceBetweenSprites(player.x, player.y, 55, 80, rock.x, rock.y, rock.w, rock.h ) <100  then
        return "rock"
    elseif distanceBetweenSprites(player.x, player.y, 55, 80, battery1.x, battery1.y, battery1.w, battery1.h) < 80 then
        return "battery1"
    elseif distanceBetweenSprites(player.x, player.y, 55, 80, battery2.x, battery2.y, battery2.w, battery2.h) < 80 then
        return "battery2"
    elseif distanceBetweenSprites(player.x, player.y, 55, 80, battery3.x, battery3.y, battery3.w, battery3.h) < 80  then
        return "battery3"
    elseif distanceBetweenSprites(player.x, player.y, 55, 80, book.x, book.y, book.w*book.scale, book.h*book.scale) < 80 then
        return "book"
    elseif distanceBetweenSprites(player.x, player.y, 55, 80, chargecable.x, chargecable.y, chargecable.w*chargecable.scale, chargecable.h*chargecable.scale) < 80 then
        return "chargecable"
    elseif distanceBetweenSprites(player.x, player.y, 55, 80, ball.x, ball.y, ball.w*ball.scale, ball.h*ball.scale) < 150 then
        return "ball"
    else 
        return false
    end
end

function drawPlayerVelocityLine()
    local player_center_x = player.x + player.width / 2 - 25
    local player_center_y = player.y + player.height / 2 - 50
    local vel = true
    local x = player.xvel
    local y = player.yvel
    if x == 0 and y == 0 then
        vel = false
    end
    if x == 0 then
        x = .1
    end
    if y == 0 then
        y = .1
    end
    local velocity_angle = math.atan2(y,x)

    -- Length of the line you want to draw
    local line_length = 50

    local line_end_x = player_center_x + line_length * math.cos(velocity_angle)
    local line_end_y = player_center_y + line_length * math.sin(velocity_angle)

    if vel == true then
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(player_center_x, player_center_y, line_end_x, line_end_y)
    end
end


