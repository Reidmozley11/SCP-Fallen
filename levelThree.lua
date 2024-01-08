-- Gamestate library

Gamestate = require 'libraries.gamestate'
levelThree = {}
walls = {}
require('game')
require("util.items.gengar")
require("util.items.flashlight")
require("util.items.rock")
require('util.items.book')
require("util.bluemon")
require("SCP076")
require("player")

function levelThree:enter()
    room = "levelThree"
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
    testingMap = sti('maps/level3.lua')

    -- draws the window size
    world = wf.newWorld(0, 0)
    love.window.setTitle("SCP: FALLEN")
    love.window.setMode(1920, 1080, {resizable=true, vsync=0, minwidth=400, minheight=300})
    --wenemy.spawn(500,500)
    --  Walls table: 
    --          intializes the hitboxes for the map 
    --          whether that be the walls, the green stuff, etc...
    world:addCollisionClass('Solid')
    world:addCollisionClass('Ghost', {ignores = {'Solid'}})
    world:addCollisionClass('Ignore', {ignores = {'Solid'}})



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
                bluemon.loadSave()
                book.load()
            end
            --player.load(data.position.x,data.position.y)
        else
        print(saveLoad)
        player.load(transition.coordx,transition.coordy)
        end
        rock.load(rock.x,rock.y)
        --SCP076.spawn(1390,600)
        --enemy.load()
        --SCP.load()

end

function levelThree:update(dt)

    player:update(dt)
    player.anim:update(dt)
    --enemy.anim:update(dt)
    --UPDATE_ENEMY(dt)
    --UPDATE_SCP(dt)

if player.y > 270 and player.y < 295 then
    if player.x > 382 and player.x < 457 then
        if love.keyboard.isDown('e') then
            Gamestate.push(greenmon)
        end
    end
    if  player.x > 183 and player.x < 328 then
        if love.keyboard.isDown('e') then
            Gamestate.push(bluemon)
        end
    end

end

if bluemon.done == true then
    for i, barrier in ipairs(puzzleBarrier) do
        barrier:setCollisionClass('Ignore')
    end
    if game.sounds == 2 then
        Sounds.win:play()
        game.sounds = 3
        end
else
    for i, barrier in ipairs(puzzleBarrier) do
        barrier:setCollisionClass('Solid')
    end
end


   -- Moves the camera according to the players movements
   camera:lookAt(player.x, player.y)

   world:update(dt)
   shaders:update(dt)
   rock.update(dt)

end

function levelThree:draw()
    -- Tells the game where to start looking through the camera POV
    camera:attach()
        testingMap:drawLayer(testingMap.layers["floor"])
        testingMap:drawLayer(testingMap.layers["walls"])
        testingMap:drawLayer(testingMap.layers["walls2"])
        testingMap:drawLayer(testingMap.layers["puzzlelock"])
        testingMap:drawLayer(testingMap.layers["items"])

        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 8, 8)
       --enemy.draw()

       
        -- This feature draws the hitboxes of the game
        if devMODE == true then
            world:draw()
            drawPlayerVelocityLine()
        end
        gengar.draw("levelThree")
        flashlight.draw("levelThree")
        rock.draw("levelThree")
        chargecable.draw("levelThree")
        book:draw("levelThree")
        ball.draw("levelThree")


        
        if bluemon.done == false then
            testingMap:drawLayer(testingMap.layers["puzzlelock"])
        end
        if Gamestate.current() == pause then 
            DRAW_SCP(SCP076, player.x, player.y, 0)
            else
            DRAW_SCP(SCP076, player.x, player.y, love.timer.getDelta())
            end
        love.graphics.setColor(255,255,255,255)
        --love.graphics.rectangle('fill', 400,200,size,size,14)
        --DRAW_SCP()
    --SCP076.Check()
        if bluemon.done == true then
            love.graphics.setColor(0, 0, 255)
            testingMap:drawLayer(testingMap.layers["puzzlelock"])
            love.graphics.reset()
        end

    love.graphics.setShader(shaders.simpleLight)
    love.graphics.rectangle("fill", player.x -5000, player.y -5000, 10000, 10000)
    love.graphics.setShader()
    camera:detach()
    love.graphics.reset()
    DRAW_HUD()
    -- love.graphics.print(player.x, 100, 10)
    -- love.graphics.print(player.y, 100, 30)
end
