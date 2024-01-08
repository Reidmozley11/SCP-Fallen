-- Gamestate library
Gamestate = require 'libraries.gamestate'
tutorial = {}

function tutorial:enter()
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
    testingMap = sti('maps/tutroom.lua')

    -- draws the window size
    world = wf.newWorld(0, 0)
    love.window.setTitle("SCP: FALLEN")
    love.window.setMode(1920, 1080, {resizable=true, vsync=0, minwidth=400, minheight=300})

    --  Walls table: 
    --          intializes the hitboxes for the map 
    --          whether that be the walls, the green stuff, etc...
    world:addCollisionClass('Solid')
    world:addCollisionClass('Ghost', {ignores = {'Solid'}})

    walls = {}

        if testingMap.layers["Walls"] then
            for i, box in pairs(testingMap.layers["Walls"].objects) do
                local wall = world:newRectangleCollider(box.x, box.y, box.width, box.height)
                wall:setType('static')
                table.insert(walls, wall)
            end
        end

    transitions = {}
        if testingMap.layers["transition"] then
            for i, obj in pairs(testingMap.layers["transition"].objects) do
                local transition = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                transition:setType('static')
                transition:setCollisionClass('Ghost')
                table.insert(transitions,transition)
            end
        end

        player.load()
end

function tutorial:update(dt)
    player:update(dt)
    player.anim:update(dt)

    if (player.health > (player.max_health / 2)) then
        heartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 2) and player.health > (player.max_health / 4)) then
        yellowheartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 4)) then
        redheartbeat.anim:update(dt)
    end

    UPDATE_ENEMY(dt)

   -- Moves the camera according to the players movements
   camera:lookAt(player.x, player.y)

   world:update(dt)
   shaders:update(dt)

end

function tutorial:draw()
    -- Tells the game where to start looking through the camera POV
    camera:attach()
        testingMap:drawLayer(testingMap.layers["Tile Layer 1"])
        testingMap:drawLayer(testingMap.layers["walls"])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 8, 8)
        love.graphics.setShader(shaders.trueLight)
        love.graphics.rectangle("fill", player.x -5000, player.y -5000, 10000, 10000)
        love.graphics.setShader()
        world:draw()
    camera:detach()
    love.graphics.reset()
    DRAW_HUD()
end