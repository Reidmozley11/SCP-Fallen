anim8 = require 'libraries/anim8'
Gamestate = require 'libraries.gamestate'
Moan = require 'libraries/Moan/Moan'
scientist = {}


scientist.x = 500
scientist.y = 450
scientist.speed = 200
scientist.xvel = 0
scientist.yvel = 0
scientist.timer = 0
scientist.spriteSheet = love.graphics.newImage('sprites/guard_white_spritesheet.png')
scientist.grid = anim8.newGrid(16, 16, scientist.spriteSheet:getWidth(), scientist.spriteSheet:getHeight())
scientist.w = scientist.spriteSheet:getWidth()
scientist.h = scientist.spriteSheet:getHeight()
scientist.icon = love.graphics.newImage('sprites/scientist.png')
scientist.maze = 0
scientist.animations = {}
    scientist.animations.down = anim8.newAnimation( scientist.grid('1-4', 1), 0.25 )
    scientist.animations.up = anim8.newAnimation( scientist.grid('1-4', 2), 0.25 )
    scientist.animations.left = anim8.newAnimation( scientist.grid('1-4', 3), 0.25 )
    scientist.animations.right = anim8.newAnimation( scientist.grid('1-4', 4), 0.25 )    
    scientist.anim = anim8.newAnimation( scientist.grid(1, 4), 1)

local function getPos()
    return scientist.x, scientist.y
end

local function getWidth()
    return scientist.w
end

local function getHeight()
    return scientist.h
end

function scientist.draw()
        love.graphics.setColor(255,255,255)
        love.graphics.rectangle('fill',scientist.x,scientist.y,scientist.spriteSheet:getWidth(),scientist.dspriteSheet:getHeight())
        scientist.anim:draw(scientist.spriteSheet, scientist.x, scientist.y, nil, 6, nil, 8, 8)
end

function scientist.colliderMatching(dt)
    scientist.x = scientist.collider:getX() - 10
    scientist.y = scientist.collider:getY() - 13
end

function scientist.spawn(x,y)
    scientist.x = x
    scientist.y = y
    scientist.collider = world:newBSGRectangleCollider(scientist.x, scientist.y, 55, 80, 14)
    scientist.collider:setType('kinematic')
    scientist.collider:setFixedRotation(true)

    table.insert(scientist, {scientist.x == x, scientist.y == y, 0, 0, 1, scientist.w, scientist.h})
end

function scientist.moveleft(x)
    scientist.xvel = scientist.speed
    local update_position = function (dt)
        elapsed_time = 0
        elapsed_time = elapsed_time + dt
        if elapsed_time >= x then
            scientist.xvel = 0
            scientist.collider:setLinearVelocity(0, 0)
            game.update:removeFunction(update_position)
        else
            scientist.collider:setLinearVelocity(scientist.xvel, scientist.yvel)
        end
    end
end

function scientist.move(dt, direction)
    if direction == "left" then
        scientist.xvel = -scientist.speed * dt
        scientist.anim = scientist.animations.left
    elseif direction == "right" then
        scientist.xvel = scientist.speed * dt
        scientist.anim = scientist.animations.right
    elseif direction == "up" then
        scientist.yvel = -scientist.speed * dt
        scientist.anim = scientist.animations.up
    elseif direction == "down" then
        scientist.yvel = scientist.speed * dt
        scientist.anim = scientist.animations.down
    end
    scientist.x = scientist.x + scientist.xvel
    scientist.y = scientist.y + scientist.yvel
    scientist.collider:setLinearVelocity(scientist.xvel, scientist.yvel)
end

function scientist.stop()
    scientist.yvel = 0
    scientist.xvel = 0
    scientist.collider:setLinearVelocity(0,0)
    scientist.anim:gotoFrame(3)
end

function scientist:update(dt)
    scientist.physics(dt)
    scientist.colliderMatching(dt)
    scientist.response(dt)
    Moan.update(dt)
end

function scientist.physics(dt)
    scientist.x = scientist.x + scientist.xvel * dt
    scientist.y = scientist.y + scientist.yvel * dt
    scientist.xvel = scientist.xvel * (1 - math.min(dt * 5, 1))
    scientist.yvel = scientist.yvel * (1 - math.min(dt * 5, 1))
end

-- chat
function scientist.response(dt)
    if love.keyboard.isDown("e") and distanceBetweenSprites(player.x, player.y, 55, 80, scientist.x, scientist.y, scientist.w,scientist.h) < 80 then
        game.talk = game.talk + 1
       if checkInventory(chest, "battery1") == false or checkInventory(chest, "battery2") == false or checkInventory(chest, "battery3") == false then
            Moan.speak("Scientist", { "Hello, to escape the facility you will need to collect 3 seperate items located in 3 different rooms. To see more messages click 'space'" , "Each room will have a seperate puzzle. But be careful there are escaped SCPs that if you get too close they will kill you","Once you collect each item you need to drop it off in the container in this room, simply click 'e' when next to the container to drop it.", "A hint for the first puzzle in the room above is to check under the boxes you are looking for three batteries to unlock the ball. Make sure you have the flashlight otherwise you can't enter that room", "I've given you a task list of what you need to do to escape, press 'i' to view it."}, {image = scientist.icon})
        else if (checkInventory(inventory, "book") == true or checkInventory(chest, "book") or (book.x ~= 1390 and book.y ~= 300)) and (checkInventory(inventory, "ball") == true or checkInventory(chest, "ball") or (ball.x ~= 3000 and ball.y ~= 230)) and (checkInventory(inventory, "chargecable") == true or checkInventory(chest, "chargecable") or (chargecable.x ~= 60 and chargecable.y ~= 750 )) then
            Moan.speak("Scientist", { "You've found the last piece! Go drop it off and get out of here" }, {image = scientist.icon })
        else if (checkInventory(inventory, "ball") == true or checkInventory(chest, "ball") or (ball.x ~= 3000 and ball.y ~= 230)) and checkInventory(inventory, "chargecable") == true or checkInventory(chest, "chargecable") or (chargecable.x ~= 60 and chargecable.y ~= 750 )then
            Moan.speak("Scientist", { "You solved the second puzzle, now only one to go. You'll have to go through a maze to get to the next puzzle (make sure you have your flashlight to keep you safe). For this next puzzle you need to find the green and blue screens, those screens will provide a riddle to solve.", "Additionally I have given you the map for the maze that you will encounter! Unfortunately due to the breach the software crashed and has ruined the file so it may be difficult to read, use your M key to access this map. You will enter the maze from the circle on the map. The exit should be somewhere within the square drawn on it." }, {image = scientist.icon })
            scientist.maze = scientist.maze + 1
            --end
         else if checkInventory(inventory, "ball") == true or checkInventory(chest, "ball") or (ball.x ~= 3000 and ball.y ~= 230) then
            Moan.speak("Scientist", { "Congradulations, you completed the first puzzle now as for the second puzzle my hint to you is to check all the computer screens and eventually you'll find instructions to help" }, {image = scientist.icon })
    end
end
end
        -- if checkInventory(inventory, "flashlight") == true then
        --     Moan.speak("Scientist", { "You got the flashlight" }, {image = scientist.icon })
        -- end
--        Moan.speak("Scientist", {"Should I stop talking?"}, {x=10, y=10, image=scientist.icon,
--                  onstart=function() camera:move(100, 20) end,
--                   options={
--                    {"Yes",  function() scientist.goodbye() end},
--                    {"No", function() end},
--                     }}
--                   )
end
end
    -- if player leaves radius the chat disapears
    if distanceBetweenSprites(player.x, player.y, 55, 80, scientist.x, scientist.y, scientist.w, scientist.h) > 150 then
        Moan.clearMessages()
    end
end

function scientist.goodbye() 
        Moan.speak("\n", { "\n"})
end

function love.keypressed(key)
    Moan.keypressed(key)
end