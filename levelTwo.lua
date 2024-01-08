-- Gamestate library

Gamestate = require 'libraries.gamestate'
levelTwo = Gamestate.new()
levelTwo = {}
walls = {}
require('util.wavegen.waver')
require('util.wavegen.waver2')
require('util.wavegen.waver3')
require('util.wavegen.waver4')
require('util.computer5')
require("util.items.gengar")
require("util.items.flashlight")
require("util.items.chargecable")
require("util.items.rock")
require("util.items.book")
require("SCP106")

-- Loads level two in and intializes all of it
function levelTwo:enter()
    room = "levelTwo"
    -- Hitbox library
    wf = require 'libraries/windfield'
    -- Tiled implementation library
    sti = require 'libraries/sti'
    -- Animations library
    anim8 = require 'libraries/anim8'
    -- Camera library
    cam = require 'libraries/camera'

    -- Makes the character stretch not blurry
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    camera = cam()

    -- loads in the map
    testingMap = sti('maps/level2.lua')

    -- draws the window size
    world = wf.newWorld(0, 0)
    love.window.setTitle("SCP: FALLEN")
    love.window.setMode(1920, 1080, {resizable=true, vsync=0, minwidth=400, minheight=300})

    world:addCollisionClass('Solid')
    
    -- Collision Class for transitions
    world:addCollisionClass('Ghost', {ignores = {'Solid'}})

    -- Collision Class for puzzleLock
    world:addCollisionClass('Ignore', {ignores = {'Solid'}})

    SCP106.spawn(700,700)
    SCP106.load()

        if testingMap.layers["Walls"] then
            for i, box in pairs(testingMap.layers["Walls"].objects) do
                local wall = world:newRectangleCollider(box.x, box.y, box.width, box.height)
                wall:setType('static')
                table.insert(walls, wall)
            end
        end

    transitions = {}
        if testingMap.layers["Transitions"] then
            for i, obj in pairs(testingMap.layers["Transitions"].objects) do
                local transition = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                transition:setType('static')
                transition:setCollisionClass('Ghost')
                table.insert(transitions,transition)
            end
        end

    puzzleBarrier = {}
        if testingMap.layers["Puzzlelock"] then
            for i, bar in pairs(testingMap.layers["Puzzlelock"].objects) do
                local barr = world:newRectangleCollider(bar.x, bar.y, bar.width, bar.height)
                barr:setType('static')
                
                table.insert(puzzleBarrier, barr)
            end
        end

        if saveLoad == true then
            print(saveLoad)
            if firstLoad == false then
                player.load(transition.coordx,transition.coordy)
            else
                flashlight.load()
                gengar.load()
                rock.loadSave()
                rock.load(rock.x,rock.y)
                battery1.load()
                battery2.load()
                battery3.load()
                waver.load()
                waver2.load()
                waver3.load()
                waver4.load()
                book.load()
                --print(data.waver.wave2)
            end
        else
        print(saveLoad)
        player.load(transition.coordx,transition.coordy)
        rock.load(rock.x,rock.y)
        end
end

-- Updates level two and its respective
-- features.
-- @param dt <- Updates every frame on delta-time
function levelTwo:update(dt)
    UPDATE_SCP106(dt)
    player:update(dt)
    player.anim:update(dt)
    game.height = love.graphics.getHeight()
    game.width = love.graphics.getWidth()

    -- Animates the different health bar values
    if (player.health > (player.max_health / 2)) then
        heartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 2) and player.health > (player.max_health / 4)) then
        yellowheartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 4)) then
        redheartbeat.anim:update(dt)
    end

    -- These four if statements check if the player
    -- is close to a computer and plays
    -- its respective waver.
    if distanceBetweenSprites(player.x, player.y, 55, 80, 64, 164, 93.33, 48.00) < 150 then
        if love.keyboard.isDown("e") then
            Gamestate.push(waver)
        end
    end

    if distanceBetweenSprites(player.x, player.y, 55, 80, 1527.6566, 176.625, 93.33, 48.00) < 150 then
        if love.keyboard.isDown("e") then
            Gamestate.push(waver2)
        end
    end

    if distanceBetweenSprites(player.x, player.y, 55, 80, 1263, 1425, 93.33, 48.00) < 150 then
        if love.keyboard.isDown("e") then
            Gamestate.push(waver3)
        end
    end

    if distanceBetweenSprites(player.x, player.y, 55, 80, 98, 1449, 93.33, 48.00) < 150 then
        if love.keyboard.isDown("e") then
            Gamestate.push(waver4)
        end
    end

    if distanceBetweenSprites(player.x, player.y, 55, 80, 326, 1449, 93.33, 48) < 150 then
        if love.keyboard.isDown("e") then
            Gamestate.push(computer5)
        end
    end

   -- Moves the camera according to the players movements
   camera:lookAt(player.x, player.y)

   rock.update(dt)
   world:update(dt)

   -- Opens the puzzle barrier for the player 
   -- if the computers have been correctly 
   -- set to the right waveforms.
   if computer1 == 2 and computer2 == 3 and computer3 == 4 and computer4 == 1 then
        for i, barrier in ipairs(puzzleBarrier) do
            barrier:setCollisionClass('Ignore')
        end
        if game.sounds == 1 then
            Sounds.win:play()
            game.sounds = 2
        end
    else 
        for i, barrier in ipairs(puzzleBarrier) do
            barrier:setCollisionClass('Solid')
        end
    end
    shaders:update(dt)
end

function levelTwo:draw()
    -- Tells the game where to start looking through the camera POV
    camera:attach()

        -- Draws the visual layers of the map
        testingMap:drawLayer(testingMap.layers["lava"])
        testingMap:drawLayer(testingMap.layers["floor"])
        testingMap:drawLayer(testingMap.layers["items"])
        testingMap:drawLayer(testingMap.layers["walls"])

        -- Draws the puzzle lock layer when the 
        -- the computers are on the wrong wave forms.
        if computer1 == 2 and computer2 == 3 and computer3 == 4 and computer4 == 1 then
            love.graphics.setColor(0, 0, 255)
            testingMap:drawLayer(testingMap.layers["puzzlelock"])
        else
            testingMap:drawLayer(testingMap.layers["puzzlelock"])
        end

        DRAW_SCP106()
        gengar.draw("levelTwo")
        flashlight.draw("levelTwo")
        rock.draw("levelTwo")
        chargecable.draw("levelTwo")
        book:draw("levelTwo")
        ball.draw("levelTwo")

        -- Animates the player
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 8, 8)

        love.graphics.setShader(shaders.simpleLight)
        love.graphics.rectangle("fill", player.x -5000, player.y -5000, 10000, 10000)
        love.graphics.setShader()

        -- Draws the world hitboxes if not a comment
        -- This feature draws the hitboxes of the game
        if devMODE == true then
            world:draw()
            drawPlayerVelocityLine()
        end


        love.graphics.setColor(255,255,255,255)
    camera:detach()
    -- love.graphics.print(player.x, 100, 100)
    -- love.graphics.print(player.y, 100, 120)
    love.graphics.reset()

    DRAW_HUD()
end