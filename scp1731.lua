Gamestate = require 'libraries.gamestate'
anim8 = require 'libraries/anim8'

local enemies = {}
-- makes stretch not blurry
love.graphics.setDefaultFilter("nearest", "nearest")
--scp1731.spawn(-2687,6930)
scp1731 = {}
    scp1731.x = -2687
    scp1731.y = 6930
    scp1731.width = 5
    scp1731.height = 5
    scp1731.speed = 150
    scp1731.friction = 7.5
    -- scp1731.spriteSheet = love.graphics.newImage('sprites/scp1731.png')
    -- scp1731.grid = anim8.newGrid(4, 28, scp1731.spriteSheet:getWidth(), scp1731.spriteSheet:getHeight())
    scp1731.spriteSheet = love.graphics.newImage('sprites/scp173.png')
    scp1731.grid = anim8.newGrid(31, 56, scp1731.spriteSheet:getWidth(), scp1731.spriteSheet:getHeight())

    scp1731.found = false
    scp1731.frozen = false
    


scp1731.animations = {}


scp1731.animations.up = anim8.newAnimation(scp1731.grid(1,4), 0.1)
scp1731.animations.down = anim8.newAnimation(scp1731.grid(1,3), 0.1)
scp1731.animations.left = anim8.newAnimation(scp1731.grid(1,2), 0.1)
scp1731.animations.right = anim8.newAnimation(scp1731.grid(1,1), 0.1)
scp1731.anim = scp1731.animations.down



function scp1731.spawn(x,y)
    table.insert(scp1731, {x = x, y=y, xvel=0,yvel=0, health = 2, width = 2, height = 2})
end

function scp1731.load()
    scp1731.x = -3630
    scp1731.y = 4739
    scp1731.collider = world:newBSGRectangleCollider(scp1731.x, scp1731.y, 45, 45, 14)
    scp1731.collider:setFixedRotation(true)
    scp1731.colX = 0
    scp1731.colY = 0
    scp1731.timer = 0
    scp1731.colxvel = 0
    scp1731.colyvel = 0
    scp1731.lastx = 0
    scp1731.lasty = 0
    scp1731.frozenx = 0
    scp1731.frozeny = 0

end

function scp1731.draw()
        love.graphics.setColor(255,255,255)
        --love.graphics.rectangle('fill',scp1731.colX,scp1731.colY,scp1731.width,scp1731.height)
        scp1731.anim:draw(scp1731.spriteSheet, scp1731.x,scp1731.y, nil, 3, 1, 4, 4)
end




function scp1731.colAI(dt)

    --scp1731.timer = scp1731.timer +1
    scp1731.distance = ((player.x - scp1731.collider:getX())^2 + (player.y - scp1731.collider:getY())^2)^(1/2)
    scp1731.xdist = ((player.x - scp1731.collider:getX())^2)^(1/2)
    scp1731.ydist = ((player.y - scp1731.collider:getY())^2)^(1/2)
    scp1731.xvect = (player.x - scp1731.collider:getX()) / scp1731.xdist
    scp1731.yvect = (player.y - scp1731.collider:getY()) / scp1731.ydist

--snap out of player view
    if scp1731.distance > 700 then
        --scp1731.collider:setPosition(50+((player.x + scp1731.colX)/2), -(50+(-player.y + -scp1731.colY)/2))
    end

--snap back to player
if scp1731.distance > 1000 then
    scp1731.found = false
if scp1731.distance > 2000 then
    local angle = love.math.random(0, 3) * math.pi / 2 -- choose angle in increments of 90 degrees
    local distance = love.math.random(700, 1000) -- choose distance between 1000 and 1500
  
    local colliderX = player.x + distance * math.cos(angle)
    local colliderY = player.y + distance * math.sin(angle)
  
    scp1731.collider:setPosition(colliderX, colliderY)
--print("SCP JUMPED")
end
else
    scp1731.found = true
end

local mouseX, mouseY = love.mouse.getPosition()
local centerX, centerY = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2
local deltaX, deltaY = mouseX - centerX, mouseY - centerY
local mouseAngle =  math.atan2(deltaY, deltaX) * 180 / math.pi


local dx = scp1731.x - player.x
local dy = scp1731.y - player.y
local angle = math.atan2(dy, dx) * 180 / math.pi

local function isWithinAngleThreshold(angle1, angle2, threshold)
local diff = math.abs(angle1 - angle2) % 360
diff = diff > 180 and 360 - diff or diff
return diff <= threshold
end
--check distance to player
        if scp1731.distance > 1 and scp1731.found == true then
            scp1731.frozenx = 0
            scp1731.frozeny = 0
            scp1731.colxvel = 0
            scp1731.colyvel = 0
        --check scp1731 right
        --print("angle looking scp1731")
        --print(isWithinAngleThreshold(mouseAngle, angle, 25))
        --if ~isWithinAngleThreshold(mouseAngle, angle, 25) then
            if (player.x > scp1731.collider:getX() and player.anim ~= player.animations.left and not isWithinAngleThreshold(mouseAngle, angle, 25) or (player.x > scp1731.collider:getX() and scp1731.distance > 563)) or (player.x > scp1731.collider:getX() and shaders.flashlight == false) then
                --print(shaders.flashlight)
                if scp1731.colxvel == 0 then
                    scp1731.colxvel = scp1731.speed
                    scp1731.frozen = scp1731.frozenx +1
                    scp173.anim = scp173.animations.right
                end
            end
        --check scp1731 left
            if (player.x < scp1731.collider:getX() and player.anim ~= player.animations.right and not isWithinAngleThreshold(mouseAngle, angle, 25) or (player.x < scp1731.collider:getX() and scp1731.distance > 563)) or (player.x < scp1731.collider:getX() and shaders.flashlight == false) then
                --print(shaders.flashlight)
                if scp1731.colxvel == 0 then
                    scp1731.colxvel = -scp1731.speed
                    scp1731.frozen = scp1731.frozenx +1
                end
                --scp1731.colxvel = -scp1731.speed
                scp1731.anim = scp1731.animations.left

            end
        --check scp1731 below
            if (player.y > scp1731.collider:getY() + 20 and player.anim ~= player.animations.up and not isWithinAngleThreshold(mouseAngle, angle, 25) or (player.y > scp1731.collider:getY() + 20 and scp1731.distance > 563)) or (player.y > scp1731.collider:getY() + 20 and shaders.flashlight == false) then
                if scp1731.colyvel == 0 then
                scp1731.colyvel = scp1731.speed
                scp1731.frozen = scp1731.frozeny +1
                end
                --scp1731.anim = scp1731.animations.left

            end
        
        --check scp1731 above
            if (player.y < scp1731.collider:getY() -20 and player.anim ~= player.animations.down and not isWithinAngleThreshold(mouseAngle, angle, 25) or (player.y < scp1731.collider:getY() -20 and scp1731.distance > 563)) or (player.y < scp1731.collider:getY() -20 and shaders.flashlight == false) then
                if scp1731.colyvel == 0 then
                scp1731.colyvel = -scp1731.speed
                scp1731.frozen = scp1731.frozeny +1
                end
                --scp1731.anim = scp1731.animations.right

            end
        end
    
    --end
           
        if scp1731.xdist > scp1731.ydist then
            if scp1731.colxvel > 0 then
                scp1731.anim = scp1731.animations.right
            if scp1731.colxvel < 0 then
                scp1731.anim = scp1731.animations.left
            end
        end
    end
    if scp1731.ydist > scp1731.xdist then
        if scp1731.colyvel > 0 then
            scp1731.anim = scp1731.animations.down
        end
        if scp1731.colyvel < 0 then
            scp1731.anim = scp1731.animations.up
        end
    end






        scp1731.colX = scp1731.colX + scp1731.colxvel *dt
        scp1731.colY = scp1731.colY + scp1731.colyvel *dt
        scp1731.colxvel = scp1731.colxvel * (1-math.min(dt*scp1731.friction,1))
        scp1731.colyvel = scp1731.colyvel * (1-math.min(dt*scp1731.friction,1))

        scp1731.collider:setLinearVelocity(scp1731.colxvel, scp1731.colyvel)
        if isWithinAngleThreshold(mouseAngle, angle, 25) and scp173.distance < 600 and shaders.flashlight == true then
            scp1731.collider:setLinearVelocity(0, 0)
        end
end

function scp1731.collision()

    if scp1731.xdist < 90 then
        if scp1731.ydist < 55 then
        --scp1731.colxvel = player.xvel
        Sounds.collision:play()
        player.health = player.health - .1
        end
    end
    if scp1731.ydist < 120 then
        if scp1731.xdist < 70 then
        --scp1731.colyvel = player.yvel
        Sounds.collision:play()
        player.health = player.health - .1
        end
    end
end

function scp1731.pathing()

end

function scp1731.colliderMatching(dt)
    scp1731.x = scp1731.collider:getX() -43
    scp1731.y = scp1731.collider:getY() -15
end

 function DRAW_scp1731()
     scp1731.draw()
end

function UPDATE_scp1731(dt)
    scp1731.colAI(dt)
    scp1731.collision()
    scp1731.colliderMatching(dt)
end