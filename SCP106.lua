Gamestate = require 'libraries.gamestate'
anim8 = require 'libraries/anim8'

-- makes stretch not blurry
love.graphics.setDefaultFilter("nearest", "nearest")

SCP106 = {}
    SCP106.width = 5
    SCP106.height = 5
    SCP106.speed = 80
    SCP106.friction = 7.5
    SCP106.spriteSheet = love.graphics.newImage('sprites/eyeballW.png')
    SCP106.grid = anim8.newGrid(32, 32, SCP106.spriteSheet:getWidth(), SCP106.spriteSheet:getHeight())


SCP106.animations = {}
    SCP106.animations.right = anim8.newAnimation(SCP106.grid('1-4', 2), 0.25)
    SCP106.animations.left = anim8.newAnimation(SCP106.grid('1-4', 7), 0.25)
    SCP106.animations.idleR = anim8.newAnimation(SCP106.grid('1-4', 1), 0.25)
    SCP106.animations.idleL = anim8.newAnimation(SCP106.grid('1-4', 6), 0.25)
    SCP106.anim = SCP106.animations.right

function SCP106.spawn(x,y)
    table.insert(SCP106, {x = x, y=y, xvel=0,yvel=0, health = 2, width = 2, height = 2})
end

function SCP106.load()
    SCP106.collider = world:newBSGRectangleCollider(700, 700, 45, 45, 14)
    SCP106.collider:setFixedRotation(true)
    SCP106.colX = 0
    SCP106.colY = 0
    SCP106.timer = 0
    SCP106.colxvel = 0
    SCP106.colyvel = 0
    SCP106.x = 0
    SCP106.y = 0
    SCP106.lastx = 0
    SCP106.lasty = 0
    SCP106.initSimpleModel()
    SCP106.prev_distance = 0
end

function SCP106.draw()
        love.graphics.setColor(255,255,255)
        --love.graphics.rectangle('fill',SCP106.colX,SCP106.colY,SCP106.width,SCP106.height)
        SCP106.anim:draw(SCP106.spriteSheet, SCP106.x,SCP106.y, nil, 3, nil, 4, 4)
end

function SCP106.extractFeatures()
    local max_x_diff = 1000  -- Set the maximum difference based on the game world
    local max_y_diff = 1000  -- Set the maximum difference based on the game world

    local x_diff = (player.x - SCP106.collider:getX()) / max_x_diff
    local y_diff = (player.y - SCP106.collider:getY()) / max_y_diff
    local dist = math.sqrt(x_diff^2 + y_diff^2)

    return {x_diff, y_diff, dist}
end


function SCP106.initSimpleModel()
    SCP106.weights = {0, 0, 0}
    SCP106.learning_rate = 0.1
end

function SCP106.updateSimpleModel(action, features, reward)
    for i = 1, #features do
        SCP106.weights[i] = SCP106.weights[i] + SCP106.learning_rate * (reward - action) * features[i]
    end
end




function SCP106.colAI(dt)
    local features = SCP106.extractFeatures()

    -- Calculate the reward based on the current distance
    local distance = math.sqrt(features[1]^2 + features[2]^2)
    local reward = SCP106.prev_distance - distance
    SCP106.prev_distance = distance

    -- Calculate SCP106.xdist and SCP106.ydist
    SCP106.xdist = math.abs(features[1])
    SCP106.ydist = math.abs(features[2])

    -- Predict the action using the linear model
    local predicted_action = 0
    for i = 1, #features do
        predicted_action = predicted_action + SCP106.weights[i] * features[i]
    end

    -- Perform the action based on the predicted value
    if predicted_action < 0 then
        SCP106.colxvel = -SCP106.speed
        SCP106.anim = SCP106.animations.left
    else
        SCP106.colxvel = SCP106.speed
        SCP106.anim = SCP106.animations.right
    end

    -- Update the model with the new data
    SCP106.updateSimpleModel(predicted_action, features, reward)

    -- Rest of the colAI function remains the same
    --SCP106.timer = SCP106.timer +1
    SCP106.distance = ((player.x - SCP106.collider:getX())^2 + (player.y - SCP106.collider:getY())^2)^(1/2)
    SCP106.xdist = ((player.x - SCP106.collider:getX())^2)^(1/2)
    SCP106.ydist = ((player.y - SCP106.collider:getY())^2)^(1/2)
    SCP106.xvect = (player.x - SCP106.collider:getX()) / SCP106.xdist
    SCP106.yvect = (player.y - SCP106.collider:getY()) / SCP106.ydist

--snap out of player view
    -- if SCP106.distance > 700 then
    --     SCP106.collider:setPosition(50+((player.x + SCP106.colX)/2), -(50+(-player.y + -SCP106.colY)/2))
    -- end

--snap back to player
    -- if SCP106.distance > 1000 then
    --     SCP106.collider:setPosition((player.x), ((player.y)))
    -- end

--check distance to player
        if SCP106.distance > 1 and SCP106.distance < 700 then
        --check SCP106 right
            if player.x > SCP106.collider:getX() then
                SCP106.colxvel = SCP106.speed
                --SCP106.anim = SCP106.animations.right
            end
        --check SCP106 left
            if player.x < SCP106.collider:getX() then
                SCP106.colxvel = -SCP106.speed
                --SCP106.anim = SCP106.animations.left
            end
        --check SCP106 below
            if player.y > SCP106.collider:getY() + 20 then
                SCP106.colyvel = SCP106.speed
                --SCP106.anim = SCP106.animations.left
            end
        --check SCP106 above
            if player.y < SCP106.collider:getY() -20 then
                SCP106.colyvel = -SCP106.speed
                --SCP106.anim = SCP106.animations.right
            end
            if SCP106.colxvel < 0 and SCP106.xdist > 5 then
                SCP106.anim = SCP106.animations.left
        end
        if SCP106.colxvel > 0 and SCP106.xdist > 5 then
            SCP106.anim = SCP106.animations.right  
    end

        else
            if (player.timer%5 == 0) then
            SCP106.colxvel = math.random(-100,100)
            SCP106.colyvel = math.random(-100,100)

            if (math.random(0,100) == 19) then
                if SCP106.anim == SCP106.animations.idleR then
                SCP106.anim = SCP106.animations.idleL
                else
                    SCP106.anim = SCP106.animations.idleR
                end
            end
            end
        end

        SCP106.colX = SCP106.colX + SCP106.colxvel *dt
        SCP106.colY = SCP106.colY + SCP106.colyvel *dt
        SCP106.colxvel = SCP106.colxvel * (1-math.min(dt*SCP106.friction,1))
        SCP106.colyvel = SCP106.colyvel * (1-math.min(dt*SCP106.friction,1))

        SCP106.collider:setLinearVelocity(SCP106.colxvel, SCP106.colyvel)

end

function SCP106.collision()
    if SCP106.xdist < 90 then
        if SCP106.ydist < 55 then
        --SCP106.colxvel = player.xvel
        Sounds.collision:play()
        player.health = player.health - .1
        end
    end
    if SCP106.ydist < 120 then
        if SCP106.xdist < 70 then
        --SCP106.colyvel = player.yvel
        Sounds.collision:play()
        player.health = player.health - .1
        end
    end
end

function SCP106.pathing()

end

function SCP106.colliderMatching(dt)
    SCP106.x = SCP106.collider:getX() -43
    SCP106.y = SCP106.collider:getY() -15
end

 function DRAW_SCP106()
     SCP106.draw()
end

function UPDATE_SCP106(dt)
    SCP106.colAI(dt)
    SCP106.collision()
    SCP106.colliderMatching(dt)
end