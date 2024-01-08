transition = {}
Gamestate = require 'libraries.gamestate'
transition.coordx = nil
transition.coordy = nil
function sleep (a)
    local sec = tonumber(os.clock() + a);
    while (os.clock() < sec) do
    end
end

function transition:Transitioner()
    if player.collider:enter('Ghost') then
        --LevelOne to Main lobby
        if player.x > 1300 and player.x < 1550 and Gamestate.current() == runLevelOne and (checkInventory(chest,"battery1") and checkInventory(chest,"battery2") and checkInventory(chest,"battery3") and checkInventory(inventory, "flashlight") and checkInventory(inventory, "ball")) then
            return OneToGame()
        end
print(player.x)
print(player.y)
        --transition:update()
print(Gamestate.current() == runGame)

        -- Main lobby to LevelOne
        if Gamestate.current() == runGame and player.y < 300  and checkInventory(inventory,"flashlight") and checkInventory(chest,"battery1") == false then
            return GameToOne()
            
        --Main lobby to LevelTwo
        else if Gamestate.current() == runGame and player.y > 350 and checkInventory(chest,"battery1") then
            return GameToTwo()
        end
        end

        if Gamestate.current() == runLevelTwo and player.y > 1400 then

            --TwoToThree()
            return TwoToMaze()
            --end
        else if Gamestate.current() == runLevelTwo then
            return TwoToGame()
        end
        end

        if Gamestate.current() == runLevelThree and player.y <300 then
            --ThreeToTwo()
            return ThreeToMaze()
        end
        if Gamestate.current() == runMaze and player.x < 0 then
            return MazeToTwo()
        else if Gamestate.current() == runMaze and player.x > 0 then
             MazeToThree()
        end
        end
        end

    end


function OneToGame()
    rock.delete()
    room = "runGame"
    transition.coordx = 405
    transition.coordy = 142
    --crates.clearCrates()
    --crates.delete()
    return Gamestate.switch(runGame)
end

function GameToOne()
    rock.delete()
    transition.coordx = 1430
    transition.coordy = 3000
    room = "levelOne"
    return Gamestate.switch(runLevelOne)
end

function GameToTwo()
    rock.delete()
    room = "levelTwo"
    transition.coordx = 831
    transition.coordy = 130
    return Gamestate.switch(runLevelTwo)
end

function TwoToThree()
    rock.delete()
    room = "levelThree"
    transition.coordx = 862
    transition.coordy = 144
    return Gamestate.switch(runLevelThree)
end

function TwoToGame()
    transition.coordx = 468
    transition.coordy = 780
    room = "runGame"
    Gamestate.switch(runGame)
end

function ThreeToTwo()
        rock.delete()
        room = "levelTwo"
        transition.coordx = 831
        transition.coordy = 1420
        return Gamestate.switch(runLevelTwo)
end

function TwoToMaze()
    rock.delete()
    room = "maze"
    transition.coordx = -2675.8
    transition.coordy = 6901.2
    return Gamestate.switch(runMaze)
end

function MazeToTwo()
    rock.delete()
    room = "levelTwo"
    transition.coordx = 831
    transition.coordy = 1420
    return Gamestate.switch(runLevelTwo)
end

function MazeToThree()
    rock.delete()
    room = "levelThree"
    transition.coordx = 862
    transition.coordy = 144
    return Gamestate.switch(runLevelThree)
end

function ThreeToMaze()
    rock.delete()
    room = "maze"
    transition.coordx = 5483
    transition.coordy = 1750.9
    return Gamestate.switch(runMaze)
end


function transition:update(dt)
    for i = 1, 5 do
        camera:zoom(1.05)
    end
end

return transition