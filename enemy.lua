Gamestate = require 'libraries.gamestate'
anim8 = require 'libraries/anim8'

-- makes stretch not blurry
love.graphics.setDefaultFilter("nearest", "nearest")

enemy = {}
    enemy.width = 5
    enemy.height = 5
    enemy.speed = 200
    enemy.friction = 7.5
    enemy.spriteSheet = love.graphics.newImage('sprites/eyeballW.png')
    enemy.grid = anim8.newGrid(32, 32, enemy.spriteSheet:getWidth(), enemy.spriteSheet:getHeight())


enemy.animations = {}
    enemy.animations.right = anim8.newAnimation(enemy.grid('1-4', 2), 0.25)
    enemy.animations.left = anim8.newAnimation(enemy.grid('1-4', 7), 0.25)
    enemy.animations.idleR = anim8.newAnimation(enemy.grid('1-4', 1), 0.25)
    enemy.animations.idleL = anim8.newAnimation(enemy.grid('1-4', 6), 0.25)
    enemy.anim = enemy.animations.right

function enemy.spawn(x,y)
    table.insert(enemy, {x = x, y=y, xvel=0,yvel=0, health = 2, width = 2, height = 2})
end

function enemy.load()
    enemy.collider = world:newBSGRectangleCollider(400, 200, 45, 45, 14)
    enemy.collider:setFixedRotation(true)
    enemy.colX = 0
    enemy.colY = 0
    enemy.timer = 0
    enemy.colxvel = 0
    enemy.colyvel = 0
    enemy.x = 0
    enemy.y = 0
    enemy.lastx = 0
    enemy.lasty = 0

end

function enemy.draw()
        love.graphics.setColor(255,255,255)
        --love.graphics.rectangle('fill',enemy.colX,enemy.colY,enemy.width,enemy.height)
        enemy.anim:draw(enemy.spriteSheet, enemy.x,enemy.y, nil, 3, nil, 4, 4)
end




function enemy.colAI(dt)

    --enemy.timer = enemy.timer +1
    enemy.distance = ((player.x - enemy.collider:getX())^2 + (player.y - enemy.collider:getY())^2)^(1/2)
    enemy.xdist = ((player.x - enemy.collider:getX())^2)^(1/2)
    enemy.ydist = ((player.y - enemy.collider:getY())^2)^(1/2)
    enemy.xvect = (player.x - enemy.collider:getX()) / enemy.xdist
    enemy.yvect = (player.y - enemy.collider:getY()) / enemy.ydist

--snap out of player view
    if enemy.distance > 700 then
        enemy.collider:setPosition(50+((player.x + enemy.colX)/2), -(50+(-player.y + -enemy.colY)/2))
    end

--snap back to player
    if enemy.distance > 1000 then
        enemy.collider:setPosition((player.x), ((player.y)))
    end

--check distance to player
        if enemy.distance > 150 and enemy.distance < 700 then
        --check enemy right
            if player.x > enemy.collider:getX() then
                enemy.colxvel = enemy.speed
                --enemy.anim = enemy.animations.right
            end
        --check enemy left
            if player.x < enemy.collider:getX() then
                enemy.colxvel = -enemy.speed
                --enemy.anim = enemy.animations.left
            end
        --check enemy below
            if player.y > enemy.collider:getY() + 20 then
                enemy.colyvel = enemy.speed
                --enemy.anim = enemy.animations.left
            end
        --check enemy above
            if player.y < enemy.collider:getY() -20 then
                enemy.colyvel = -enemy.speed
                --enemy.anim = enemy.animations.right
            end
            if enemy.colxvel < 0 and enemy.xdist > 5 then
                enemy.anim = enemy.animations.left
        end
        if enemy.colxvel > 0 and enemy.xdist > 5 then
            enemy.anim = enemy.animations.right  
    end

        else
            if (player.timer%5 == 0) then
            enemy.colxvel = math.random(-100,100)
            enemy.colyvel = math.random(-100,100)
            Sounds.collision:play()

            if (math.random(0,100) == 19) then
                if enemy.anim == enemy.animations.idleR then
                enemy.anim = enemy.animations.idleL
                else
                    enemy.anim = enemy.animations.idleR
                end
            end
            enemy.collision()
            end
        end

        enemy.colX = enemy.colX + enemy.colxvel *dt
        enemy.colY = enemy.colY + enemy.colyvel *dt
        enemy.colxvel = enemy.colxvel * (1-math.min(dt*enemy.friction,1))
        enemy.colyvel = enemy.colyvel * (1-math.min(dt*enemy.friction,1))

        enemy.collider:setLinearVelocity(enemy.colxvel*(enemy.distance/150), enemy.colyvel*(enemy.distance/150))

end

function enemy.collision()
    if enemy.xdist < 68 then
        if enemy.ydist < 35 then
        enemy.colxvel = player.xvel
        Sounds.collision:play()
        end
    end
    if enemy.ydist < 90 then
        if enemy.xdist < 35 then
        enemy.colyvel = player.yvel
        Sounds.collision:play()
        end
    end
end

function enemy.pathing()

end

function enemy.colliderMatching(dt)
    enemy.x = enemy.collider:getX() -43
    enemy.y = enemy.collider:getY() -15
end

 function DRAW_ENEMY()
     enemy.draw()
end

function UPDATE_ENEMY(dt)
    enemy.colAI(dt)
    enemy.colliderMatching(dt)
end