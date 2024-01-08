
local testing = require("testing.testing")
local assert = testing.assert
local register = testing.register

function Square(n)
    return n*n
end
function Test_sounds_not_nil()
    assert.not_nil(Sounds)
end
function Test_table_not_nil()
    assert.not_nil(table)
end
function Test_music_not_nil()
    assert.not_nil(Music)
end
function Test_walls_not_nil()
    assert.not_nil(walls)
end
function Test_flashlight()
    assert.not_nil(flashlight.x)
end
function Test_gengar()
    assert.not_nil(gengar.x)
end
function Test_ball()
    assert.not_nil(ball.x)
end
function Test_manaquine()
    assert.not_nil(book.x)
end
function Test_chest()
    assert.not_nil(chest)
end
function Test_charger()
    assert.not_nil(chargecable.x)
end
function Test_devMode()
    assert.truthy(devMODE == true)
end
function Test_scp173()
    assert.not_nil(scp173.x)
end
function Test_SCP076()
    assert.not_nil(SCP076.x)
end
function Test_SCP106()
    assert.not_nil(SCP106.x)
end
function Test_inventory()
    assert.not_nil(inventory)
end
function Test_inventory_slot1()
    assert.not_nil(inventory[1])
end
function Test_inventory_slot2()
    assert.not_nil(inventory[2])
end
function Test_saveFile()
    assert.not_nil(love.filesystem.getInfo("save"))
end
function Test_flashlight_on()
    assert.truthy(shaders.flashlight == true)
end
function Test_flashlight_off()
    assert.truthy(shaders.flashlight == false)
end
function Test_lvlOne_done()
    assert.truthy(checkInventory(chest, "ball") == true)
end
function Test_lvlTwo_done()
    assert.truthy(checkInventory(chest, "chargecable") == true)
end
function Test_lvlThree_done()
    assert.truthy(checkInventory(chest, "book") == true)
end
function Test_playerHas_map()
    assert.truthy((scientist.maze ~= 0) == true)
end
function Test_playerHas_taskList()
    assert.truthy((game.talk ~= 0) == true)
end
testing.register("square 3", function()
    assert.equal(9, Square(3))
end)

-- function Test_speed_on_shift()
--     -- assume the player object exists and has a property "speed"
--     local isSprinting = isSprinting

--     -- assume the shift key press is detected and stored in a variable "shift_pressed"
--     if (love.keyboard.isDown('lshift') and love.keyboard.isDown("d") or love.keyboard.isDown("w") or love.keyboard.isDown("a") or love.keyboard.isDown("d")) or (love.keyboard.isDown('rshift') and love.keyboard.isDown("d") or love.keyboard.isDown("w") or love.keyboard.isDown("a") or love.keyboard.isDown("d")) then
--         assert.truthy(isSprinting)
--     else
--         assert.not_truthy(isSprinting)
--     end
-- end

function Test_idle()
    local xvel = player.xvel
    local yvel = player.yvel
    assert.truthy(xvel == 0)
    assert.truthy(yvel == 0 )
end
local function test_player_health_heartbeat_anim_draw()
    -- assume the player object exists and has a property "health"
    local health = player.health
    if health < 0 or health >105 then
        if health <=0 then
        error("player health is less than 0")
        else
        error("player health is greater than 100")
        end
      end
    if health > player.max_health / 2 then
        assert.not_nil(heartbeat.anim)
        assert.not_nil(heartbeat.spritesheet)
        heartbeat.anim:draw(heartbeat.spritesheet, 30, 30, nil, 3, nil, 9, 9)
    else if health <= player.max_health / 2 then
        assert.not_nil(heartbeat.anim)
        assert.not_nil(heartbeat.spritesheet)
        heartbeat.anim:draw(heartbeat.spritesheet, 30, 30, nil, 3, nil, 9, 9)
    else if (health <= player.max_health / 4) and (health > 0) then
        assert.not_nil(heartbeat.anim)
        assert.not_nil(heartbeat.spritesheet)
        heartbeat.anim:draw(heartbeat.spritesheet, 30, 30, nil, 3, nil, 9, 9)
    end
    end
    end
end



testing.register("square 5", function()
    assert.equal(25, Square(5)) -- Oops!
end)
testing.register("test_sounds_not_nil", Test_sounds_not_nil)
testing.register("test_music_not_nil", Test_music_not_nil)
testing.register("test_table_not_nil", Test_table_not_nil)
testing.register("test_walls_not_nil", Test_walls_not_nil)
testing.register("test_Idle", Test_idle)
testing.register("test_player_health_heartbeat_anim_draw", test_player_health_heartbeat_anim_draw)
testing.register("Test_flashlight", Test_flashlight)
testing.register("Test_gengar", Test_gengar)
testing.register("Test_ball", Test_ball)
testing.register("Test_chest",Test_chest)
testing.register("Test_charger",Test_charger)
testing.register("Test_manaquine",Test_manaquine)
testing.register("Test_devMode",Test_devMode)
testing.register("Test_scp173",Test_scp173)
testing.register("Test_SCP076",Test_SCP076)
testing.register("Test_SCP106",Test_SCP106)
testing.register("Test_inventory",Test_inventory)
testing.register("Test_inventory_slot1",Test_inventory_slot1)
testing.register("Test_inventory_slot2",Test_inventory_slot2)
testing.register("Test_saveFile",Test_saveFile)
testing.register("Test_flashlight_on",Test_flashlight_on)
testing.register("Test_flashlight_off",Test_flashlight_off)
testing.register("Test_lvlOne_done",Test_lvlOne_done)
testing.register("Test_lvlTwo_done",Test_lvlTwo_done)
testing.register("Test_lvlThree_done",Test_lvlThree_done)
testing.register("Test_playerHas_map",Test_playerHas_map)
testing.register("Test_playerHas_taskList",Test_playerHas_taskList)
--testing.register("",)
-- testing.register("test_speed_on_shift", Test_speed_on_shift)