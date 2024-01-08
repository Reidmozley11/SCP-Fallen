-- Gamestate library
Gamestate = require 'libraries.gamestate'
require("scp173")
require("scp1731")
maze = {}
walls = {}
room = "maze"
function maze:enter()
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
    testingMap = sti('maps/Maze2.0.lua')

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

        --player.load()
        --scp173.spawn(7100,-2600)

        scp173.spawn(-2672,7650)
        scp173.spawn(-2672,7715)
        scp173.load()
        scp1731.load()
        --enemy.load()
        --SCP.load()
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

function maze:update(dt)
    UPDATE_scp173(dt)
    UPDATE_scp1731(dt)
    player:update(dt)
    player.anim:update(dt)

    game.height = love.graphics.getHeight()
    game.width = love.graphics.getWidth()
    --enemy.anim:update(dt)
    --UPDATE_ENEMY(dt)
    --UPDATE_SCP(dt)

   -- Moves the camera according to the players movements
   camera:lookAt(player.x, player.y)

   world:update(dt)
   shaders:update(dt)
   

end

function maze:draw()
    -- Tells the game where to start looking through the camera POV
    camera:attach()
        testingMap:drawLayer(testingMap.layers["Tile Layer 1"])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 8, 8)
       --enemy.draw()
       gengar.draw("maze")
       flashlight.draw("maze")
       rock.draw("maze")
       chargecable.draw("maze")
       book:draw("maze")
       ball.draw("maze")

       DRAW_scp173()
       DRAW_scp1731()
        love.graphics.setShader(shaders.simpleLight)
        love.graphics.rectangle("fill", player.x -5000, player.y -5000, 10000, 10000)
        love.graphics.setShader()

        -- This feature draws the hitboxes of the game
        if devMODE == true then
            world:draw()
            drawPlayerVelocityLine()
        end

        love.graphics.setColor(255,255,255,255)
        --love.graphics.rectangle('fill', 400,200,size,size,14)
        --DRAW_SCP()
        if love.keyboard.isDown("j") then
            --table.insert(inventory,"Itemsssssss")
            print(player.x)
            print(player.y)
            scp173.x = player.x
            scp173.y = player.y
        end
    camera:detach()
    love.graphics.reset()
    DRAW_HUD()

end
