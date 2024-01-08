-- Gamestate library

Gamestate = require 'libraries.gamestate'
levelOne = {}
walls = {}
require('game')
require("util.transition")
require("util.items.gengar")
require("util.items.flashlight")
require("util.items.rock")
require("util.items.battery1")
require("util.items.battery2")
require("util.items.battery3")
require("util.items.crate")
require("util.items.book")
require("util.items.ball")
levelOne.flashtime = 0
function levelOne:enter()
    room = "levelOne"
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
    testingMap = sti('maps/level1.lua')

    --loads in the battery images for use
    battery = love.graphics.newImage("sprites/battery.png")

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
    world:addCollisionClass('Ignore', { ignores = { 'Solid' } })

    

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
    if testingMap.layers["PuzzleLock"] then
        for i, bar in pairs(testingMap.layers["PuzzleLock"].objects) do
            local barr = world:newRectangleCollider(bar.x, bar.y, bar.width, bar.height)
            barr:setType('static')

            table.insert(puzzleBarrier, barr)
        end
    end

        generator = world:newRectangleCollider(2480,135,70,20)
        generator:setType('static')
        generator:setCollisionClass('Solid')

        spawnCrate(1400,2600)
        spawnCrate(2000,3000)
        spawnCrate(600,2222)
        spawnCrate(160,2022)
        spawnCrate(527,1420)
        spawnCrate(1692,1366)
        spawnCrate(2958,1189)
        spawnCrate(2477,2295)

        spawnCrate(1988,545)
        spawnCrate(172,288)
        spawnCrate(1082,1420)
        spawnCrate(2100,813)
        spawnCrate(2533,3000)
        spawnCrate(1451,240)
        spawnCrate(818,2000)
        spawnCrate(1856,1980)
        spawnCrate(2486,1668)

        spawnCrate(2340,1125)
        spawnCrate(1902,127)
        spawnCrate(695,469)
        spawnCrate(480,830)
        spawnCrate(453,1117)
        spawnCrate(120,1137)
        spawnCrate(199,2838)
        spawnCrate(776,2619)
        spawnCrate(919,2990)


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
                book.load()
            end 
        else
        print(saveLoad)
        player.load(transition.coordx, transition.coordy)
        end
        rock.load(rock.x,rock.y)
        --enemy.load()
        --SCP.load()
        
        
end
local batcount = 0
function levelOne:update(dt)
    
    player:update(dt)
    player.anim:update(dt)

    game.height = love.graphics.getHeight()
    game.width = love.graphics.getWidth()
    
    if love.keyboard.isDown("e") and (checkInventory(inventory, "battery1") == true or checkInventory(inventory, "battery2") == true or checkInventory(inventory, "battery3") == true) then 
        if distanceBetweenSprites(player.x, player.y, 55, 80, 2480,135,70,20) < 150 then 
            -- need to remove from inventory then move on if battery count = 3 
            if checkInventory(inventory, "battery1") == true then
                Sounds.boop:play()
                --local slot = findItem("battery1")
                table.remove(inventory, findItem("battery1"))
                table.insert(chest,"battery1")
                batcount = batcount + 1
            end
            if checkInventory(inventory, "battery2") == true then
                Sounds.boop:play()
                --local slot = findItem("battery2")
                table.remove(inventory, findItem("battery2"))
                table.insert(chest,"battery2")
                batcount = batcount + 1
            end
            if checkInventory(inventory, "battery3") == true then
                Sounds.boop:play()
                --local slot = findItem("battery3")
                table.remove(inventory, findItem("battery3"))
                table.insert(chest,"battery3")
                batcount = batcount + 1
            end
        end
    end
    if batcount == 3 or (checkInventory(chest,"battery1") and checkInventory(chest,"battery2") and checkInventory(chest,"battery3")) then
        
        for i, barrier in ipairs(puzzleBarrier) do
            barrier:setCollisionClass('Ignore')
        end
        if (game.sounds == 0) then
            Sounds.win:play()
            game.sounds = 1
            end
    else
        for i, barrier in ipairs(puzzleBarrier) do
            barrier:setCollisionClass('Solid')
        end
    end
    --enemy.anim:update(dt)
    --UPDATE_ENEMY(dt)
    --UPDATE_SCP(dt)

   -- Moves the camera according to the players movements
   camera:lookAt(player.x, player.y)
   rock.update(dt)
   world:update(dt)
   shaders:update(dt)
   crates:update(dt)

end

function levelOne:draw()
    -- Tells the game where to start looking through the camera POV
    camera:attach()
        testingMap:drawLayer(testingMap.layers["floor"])
        testingMap:drawLayer(testingMap.layers["walls"])
        testingMap:drawLayer(testingMap.layers["stuff"])
        testingMap:drawLayer(testingMap.layers["items"])
        if batcount == 3 then
        testingMap:drawLayer(testingMap.layers["bluepuzzlelock"])
        end

       --enemy.draw()


        -- This feature draws the hitboxes of the game
        if devMODE == true then
            world:draw()
            drawPlayerVelocityLine()
        end

        battery1.draw("levelOne")
        battery2.draw("levelOne")
        battery3.draw("levelOne")
        crates:draw()
        gengar.draw("levelOne")
        flashlight.draw("levelOne")
        ball.draw("levelOne")
        rock.draw("levelOne")
        book:draw("levelOne")
        chargecable.draw("levelOne")

        -- Draws the balls into the generator box
        -- and turns the tv on when completed
local batsave = 0
        if (checkInventory(chest, "battery1") == true) then
            batsave = batsave +1
        end
        if (checkInventory(chest, 'battery2') == true) then
            batsave = batsave +1
        end
        if (checkInventory(chest, 'battery3') == true) then
            batsave = batsave +1
        end
        if batsave == 1 then
            love.graphics.draw(battery, 2450, 108)
        end
        if batsave == 2 then
            love.graphics.draw(battery, 2450, 108)
            love.graphics.draw(battery, 2465, 108)
        end
        if batsave == 3 then
            love.graphics.draw(battery, 2450, 108)
            love.graphics.draw(battery, 2465, 108)
            love.graphics.draw(battery, 2480, 108)
            love.graphics.print("{POWER ACTIVATED}", 2592.5, 140)
        end

        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 8, 8)
        love.graphics.setColor(255,255,255,255)
        --love.graphics.rectangle('fill', 400,200,size,size,14)
        --DRAW_SCP()
       -- scp106.UPDATE_ENEMY()
        love.graphics.setShader(shaders.simpleLight)
        love.graphics.rectangle("fill", player.x -5000, player.y -5000, 10000, 10000)
        love.graphics.setShader()


        --print(batcount)
        if love.keyboard.isDown("tab") and batcount ~= 3 then
        if not (checkInventory(inventory, "battery1") or (checkInventory(chest, "battery1"))) then
        player.playerHint(battery1.x,battery1.y)
        elseif not (checkInventory(inventory, "battery2") or (checkInventory(chest, "battery2"))) then
            player.playerHint(battery2.x,battery2.y)
        elseif not (checkInventory(inventory, "battery3") or (checkInventory(chest, "battery3"))) then
            player.playerHint(battery3.x,battery3.y)
        end
    end
    

    if checkInventory(inventory, "flashlight") and levelOne.flashtime == 0 then
        love.graphics.print("Press F to use flashlight",1400,2900)  
    end
    camera:detach()
    love.graphics.reset()
    DRAW_HUD()
    
end