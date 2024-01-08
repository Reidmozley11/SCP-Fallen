Gamestate = require 'libraries.gamestate'
anim8 = require 'libraries/anim8'

local enemies = {}
-- makes stretch not blurry
love.graphics.setDefaultFilter("nearest", "nearest")
--scp173.spawn(-2687,6930)
scp173 = {}
    scp173.x = -2687
    scp173.y = 6930
    scp173.width = 5
    scp173.height = 5
    scp173.speed = 150
    scp173.friction = 7.5
    -- scp173.spriteSheet = love.graphics.newImage('sprites/scp173.png')
    -- scp173.grid = anim8.newGrid(4, 28, scp173.spriteSheet:getWidth(), scp173.spriteSheet:getHeight())
    scp173.spriteSheet = love.graphics.newImage('sprites/scp173.png')
    scp173.grid = anim8.newGrid(31, 56, scp173.spriteSheet:getWidth(), scp173.spriteSheet:getHeight())

    scp173.found = false
    scp173.frozen = false
    


scp173.animations = {}


scp173.animations.up = anim8.newAnimation(scp173.grid(1,4), 0.1)
scp173.animations.down = anim8.newAnimation(scp173.grid(1,3), 0.1)
scp173.animations.left = anim8.newAnimation(scp173.grid(1,2), 0.1)
scp173.animations.right = anim8.newAnimation(scp173.grid(1,1), 0.1)
scp173.anim = scp173.animations.down



function scp173.spawn(x,y)
    table.insert(scp173, {x = x, y=y, xvel=0,yvel=0, health = 2, width = 2, height = 2})
end

function scp173.load()
    scp173.x = -2687
    scp173.y = 7800
    scp173.collider = world:newBSGRectangleCollider(scp173.x, scp173.y, 45, 45, 14)
    scp173.collider:setFixedRotation(true)
    scp173.colX = 0
    scp173.colY = 0
    scp173.timer = 0
    scp173.colxvel = 0
    scp173.colyvel = 0
    scp173.lastx = 0
    scp173.lasty = 0
    scp173.frozenx = 0
    scp173.frozeny = 0
    scp173.frozen = 0

end

function scp173.draw()
        love.graphics.setColor(255,255,255)
        --love.graphics.rectangle('fill',scp173.colX,scp173.colY,scp173.width,scp173.height)
        scp173.anim:draw(scp173.spriteSheet, scp173.x,scp173.y, nil, 3, 1, 4, 4)
end




function scp173.colAI(dt)

    --scp173.timer = scp173.timer +1
    scp173.distance = ((player.x - scp173.collider:getX())^2 + (player.y - scp173.collider:getY())^2)^(1/2)
    scp173.xdist = ((player.x - scp173.collider:getX())^2)^(1/2)
    scp173.ydist = ((player.y - scp173.collider:getY())^2)^(1/2)
    scp173.xvect = (player.x - scp173.collider:getX()) / scp173.xdist
    scp173.yvect = (player.y - scp173.collider:getY()) / scp173.ydist

--snap out of player view
    if scp173.distance > 700 then
        --scp173.collider:setPosition(50+((player.x + scp173.colX)/2), -(50+(-player.y + -scp173.colY)/2))
    end

--snap back to player
--print(scp173.distance)
    if scp173.distance > 1000 then
        scp173.found = false
    if scp173.distance > 2000 then
        local angle = love.math.random(0, 3) * math.pi / 2 -- choose angle in increments of 90 degrees
        local distance = love.math.random(700, 1000) -- choose distance between 1000 and 1500
      
        local colliderX = player.x + distance * math.cos(angle)
        local colliderY = player.y + distance * math.sin(angle)
      
        scp173.collider:setPosition(colliderX, colliderY)
--print("SCP JUMPED")
    end
    else
        scp173.found = true
    end
    
    local mouseX, mouseY = love.mouse.getPosition()
    local centerX, centerY = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2
    local deltaX, deltaY = mouseX - centerX, mouseY - centerY
    local mouseAngle =  math.atan2(deltaY, deltaX) * 180 / math.pi
    

local dx = scp173.x - player.x
local dy = scp173.y - player.y
local angle = math.atan2(dy, dx) * 180 / math.pi

local function isWithinAngleThreshold(angle1, angle2, threshold)
local diff = math.abs(angle1 - angle2) % 360
diff = diff > 180 and 360 - diff or diff
return diff <= threshold
end

--check distance to player
        if scp173.distance > 1 and scp173.found == true then
            scp173.frozenx = 0
            scp173.frozeny = 0
            scp173.colxvel = 0
            scp173.colyvel = 0
            scp173.facing = true
        --check scp173 right
            if (player.x > scp173.collider:getX() and player.anim ~= player.animations.left and not isWithinAngleThreshold(mouseAngle, angle, 25)or (player.x > scp173.collider:getX() and scp173.distance > 563)) or (player.x > scp173.collider:getX() and shaders.flashlight == false) then
                --print(shaders.flashlight)
                if scp173.colxvel == 0 then
                    scp173.colxvel = scp173.speed
                end
                scp173.anim = scp173.animations.right
            end
        --check scp173 left
            if (player.x < scp173.collider:getX() and player.anim ~= player.animations.right and not isWithinAngleThreshold(mouseAngle, angle, 25)or (player.x < scp173.collider:getX() and scp173.distance > 563)) or (player.x < scp173.collider:getX() and shaders.flashlight == false) then
                --print(shaders.flashlight)
                if scp173.colxvel == 0 then
                    scp173.colxvel = -scp173.speed
                    scp173.frozen = scp173.frozen +1
                end
                --scp173.colxvel = -scp173.speed
                scp173.anim = scp173.animations.left

            end
        --check scp173 below
            if (player.y > scp173.collider:getY() + 20 and player.anim ~= player.animations.up and not isWithinAngleThreshold(mouseAngle, angle, 25)or (player.y > scp173.collider:getY() + 20 and scp173.distance > 563)) or (player.y > scp173.collider:getY() + 20 and shaders.flashlight == false) then
                if scp173.colyvel == 0 then
                scp173.colyvel = scp173.speed
                scp173.frozen = scp173.frozen +1
                end
                --scp173.anim = scp173.animations.left

            end
        
        --check scp173 above
            if (player.y < scp173.collider:getY() -20 and player.anim ~= player.animations.down and not isWithinAngleThreshold(mouseAngle, angle, 25)or (player.y < scp173.collider:getY() -20 and scp173.distance > 563)) or (player.y < scp173.collider:getY() -20 and shaders.flashlight == false) then
                if scp173.colyvel == 0 then
                scp173.colyvel = -scp173.speed
                scp173.frozen = scp173.frozen +1
                end
                --scp173.anim = scp173.animations.right

            end
        end
    


        if scp173.xdist > scp173.ydist then
            if scp173.colxvel > 0 then
                scp173.anim = scp173.animations.right
            if scp173.colxvel < 0 then
                scp173.anim = scp173.animations.left
            end
        end
    end
    if scp173.ydist > scp173.xdist then
        if scp173.colyvel > 0 then
            scp173.anim = scp173.animations.down
        end
        if scp173.colyvel < 0 then
            scp173.anim = scp173.animations.up
        end
    end



-- if isWithinAngleThreshold(mouseAngle, angle, 25) and scp173.distance < 600 and shaders.flashlight == true then
--     scp1731.colyvel = 0
--     scp1731.colxvel = 0
-- end

      
--print(scp173.frozen)

        -- if scp173.frozenx == 0 then 
        --     scp173.colxvel = 0
        -- end
        -- if scp173.frozeny == 0 then
        -- scp173.colyvel = 0
        -- end

        scp173.colX = scp173.colX + scp173.colxvel *dt
        scp173.colY = scp173.colY + scp173.colyvel *dt
        scp173.colxvel = scp173.colxvel * (1-math.min(dt*scp173.friction,1))
        scp173.colyvel = scp173.colyvel * (1-math.min(dt*scp173.friction,1))

        scp173.collider:setLinearVelocity(scp173.colxvel, scp173.colyvel)
        if isWithinAngleThreshold(mouseAngle, angle, 25) and scp173.distance < 600 and shaders.flashlight == true then
            scp173.collider:setLinearVelocity(0, 0)
        end
end

function scp173.collision()

    if scp173.xdist < 90 then
        if scp173.ydist < 55 then
        --scp173.colxvel = player.xvel
        Sounds.collision:play()
        player.health = player.health - .1
        end
    end
    if scp173.ydist < 120 then
        if scp173.xdist < 70 then
        --scp173.colyvel = player.yvel
        Sounds.collision:play()
        player.health = player.health - .1
        end
    end
end

function scp173.pathing()

end

function scp173.colliderMatching(dt)
    scp173.x = scp173.collider:getX() -43
    scp173.y = scp173.collider:getY() -15
end

 function DRAW_scp173()
     scp173.draw()
end

function UPDATE_scp173(dt)
    scp173.colAI(dt)
    scp173.collision()
    scp173.colliderMatching(dt)
end