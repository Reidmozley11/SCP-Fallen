
-- Gamestate library
local json = require("libraries.dkjson")
Gamestate = require 'libraries.gamestate'
pause = {}
pause = Gamestate.new()
saveInventory = {}
chestInvetory = {}
local buttons = {}
mainmenufrompause = false
BUTTON_HEIGHT = 64
local font = nil
local function newButton(text,fn)
    return{
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end

function pause:enter(from)
    self.from = from
    --pause.load()
    love.graphics.clear()
    love.graphics.reset()
   -- love.window.setMode(1024,1024)
    --todo
    --player.load()

end
function write_to_json_file(filename, data)
    -- convert Lua table to JSON format
    local json_data = json.encode(data)
    local op = love.system.getOS()

    -- if op == "Windows" then
        
    --     filename = os.getenv("HOMEDRIVE") .. os.getenv("HOMEPATH") .. "\\Desktop\\Remedy\\" .. filename
    -- else
    --     filename = os.getenv("HOME") .. "/Desktop/Remedy/" .. filename
    -- end

    if op == "Windows" then
        filename = filepath .. "\\" .. filename
    else
    filename = filepath .. "/".. filename
    end
    --end
    --filename = os.getenv("HOME") .. "/Desktop/Remedy/" .. filename
    -- open file for writing
    local file = io.open(filename, "w")

    -- write JSON data to file
    file:write(json_data)

    -- close file
    file:close()
end
function pause:update(dt)
    pause.update(dt)
end

font = love.graphics.newFont(32)
table.insert(buttons,newButton("Return to Game",function()Gamestate.pop() end))
table.insert(buttons,newButton("Settings",function()Gamestate.push(settings) sleep(.3)end))

table.insert(buttons,newButton("Save and Return to Main Menu", function() saveInventory = inventory  chestInventory = chest mainmenufrompause = true Gamestate.push(save_file_menu) end))
table.insert(buttons,newButton("Save Game",function() saveInventory = inventory  chestInventory = chest Gamestate.push(save_file_menu)
        --playerData = {
        --position = {x = player.x,y = player.y},
        --inventory = saveInventory
        --}
       -- write_to_json_file("playerData.json", playerData)
        
    --end
    --if set == true then 
        -- file = io.open("saveData.json", "r")
        -- jsonDatas = file:read("*all")
        -- file:close()
    
        -- help = json.decode(jsonDatas)
        -- print(help.position.x)
        -- print(help.position.y)
        -- print(help.inventory[1])
    
    --end
end))

table.insert(buttons,newButton("Exit to Windows",function()love.event.quit(0)end))

function pause:draw()
    love.graphics.reset()
    self.from:draw()
    font = love.graphics.newFont(32)
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local buttonwidth = ww * (1/3)
    local margin = 16
    local cursor_y = 0
    local total = (BUTTON_HEIGHT+margin) * #buttons
    love.graphics.printf('SETTINGS',0,wh/2,ww,'center')
    for i, buttons in ipairs(buttons) do
        buttons.last = buttons.now
        --love.graphics.setColor(255,255,255,1)
        local x = (ww*.5)-(buttonwidth*.5)
        local y = (wh * .5)-(total * .5)+cursor_y
        local color = {.8,.4,.5,1}
        local mousex, mousey = love.mouse.getPosition()
        local highlight = mousex > x and mousex < x + buttonwidth and mousey > y and mousey < y + BUTTON_HEIGHT
        if highlight then
            color  = {.8,.8,.9,1}
        end
        buttons.now = love.mouse.isDown(1)
        if buttons.now and not buttons.last and highlight then
            buttons.fn()
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle("fill",(ww*.5)-(buttonwidth*.5),(wh * .5)-(total * .5)+cursor_y,buttonwidth,BUTTON_HEIGHT)
        love.graphics.setColor(0,0,0,1)
        local textwidth = font:getWidth(buttons.text)
        local textHeight = font:getHeight(buttons.text)
        love.graphics.print(buttons.text,font,(ww*.5)-textwidth*.5,y+textHeight*.5)
        cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
    end

    love.graphics.reset()

    if love.keyboard.isDown('s') then
        Gamestate.pop()
        love.graphics.reset()
        Gamestate.push(settings)
        settings.load()
    elseif love.keyboard.isDown('escape') then
        love.timer.sleep(.15)
        Gamestate.pop()
    end
end

 function pause.load()
--     --Gamestate.switch(pause)
 end

function pause:update(dt)
    if love.keyboard.isScancodeDown('p') then
        love.timer.sleep(.15)
        return Gamestate.pop()
    end
  end

  Gamestate.addStates{
    pause = pause,
    save_file_menu = save_file_menu,
}
