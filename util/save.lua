
-- Gamestate library
local json = require("libraries.dkjson")
Gamestate = require 'libraries.gamestate'
require("shaders")
save = {}
save = Gamestate.new()

local max = 5
count = 0
local buttons = {}
BUTTON_HEIGHT = 64
font = nil

shaders:window()
--losebackground = love.graphics.newImage("screens/lose.png")
local function newButton(text,fn)
    return{
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end

if love.keyboard.isDown("escape") then
    Gamestate.push(menu)
end

function save:enter(from)
    self.from = from
end



--function pause:update(dt)
  --  pause.update(dt)
--end

--local folder_path = "Desktop/Remedy" -- Replace this with the path to your folder
subDirectory = "save"
if not love.filesystem.getInfo(subDirectory) then
    print("RIGHTFUCKINGHERES")
    print("Creating directory: " .. subDirectory)
    love.filesystem.createDirectory(subDirectory)
end


filepath = love.filesystem.getRealDirectory('/')
filepath = love.filesystem.getRealDirectory('/')
saveDirectory = love.filesystem.getSaveDirectory().."/save"
print("Save directory:", saveDirectory)

-- local subDirectory = "save"

if not love.filesystem.getInfo(saveDirectory) then
    love.filesystem.createDirectory(saveDirectory)
end


local subDirectory = "save"
local info = saveDirectory

if info then
    print("Info for directory '" .. subDirectory .. "':")
    
else
    print("Directory '" .. subDirectory .. "' not found.")
end


print(filepath)
files = {}
firstLoad = true
local op = love.system.getOS()
if op == "Windows" then
    filepath = saveDirectory
    --filepath = filepath.gsub(filepath, "/SCP","/LOVE/Remedy")
    filepath = string.gsub(filepath, "/", "\\")
    for file in io.popen("dir /B " .. filepath .. "\\".."*.json"):lines() do 
        file_name = file
        file = filepath .. "\\"..file
        table.insert(files, file)
       
        table.sort(files, function(a, b)
            -- Read and parse the JSON file for each file
            local f1 = io.open(a, "r")
            local data_str1 = f1:read("*all")
            f1:close()
            local data1 = json.decode(data_str1)
        
            local f2 = io.open(b, "r")
            local data_str2 = f2:read("*all")
            f2:close()
            local data2 = json.decode(data_str2)
        
            if not data1.date or not data2.date then
                return false
            end
            
            return data1.date > data2.date
        end)
        
                
            end
        
            for i, file in ipairs(files) do
                if i > max then
                    break
                end
                --print(file_name)
        --file_name = file_name:gsub("[/%[%]%(%){}%+%-*%%^%$%?%.\\]%f[%a]json%f[%A]", "")
        --file = file:gsub("[/%[%]%(%){}%+%-*%%^%$%?%.\\]%f[%a]c:\\Users\\18035\\Desktop\\Remedy\\%f[%A]", "")
        --c:\Users\18035\Desktop\Remedy\please.json
        fafafafafafafafafafafa = file
        fafafafafafafafafafafa = fafafafafafafafafafafa:gsub(filepath, ""):gsub("%.json", ""):gsub("\\", "")
        

        --local file_name = file
        table.insert(buttons, newButton(fafafafafafafafafafafa, function() 
            --Read and parse the JSON file
            files = io.open(file, "r")
            data_str = files:read("*all")
            data = json.decode(data_str)
            files:close()
            -- Do something with the data, e.g. set player coordinates
           
            -- player.x = data.position.x
            -- player.y = data.position.y
            print(data.position.x)
            print(data.position.y)

            inventory = data.inventory
            chest = data.chestInventory
            saveLoad = true
            game.up = data.up
            game.down = data.down
            game.right = data.right
            game.left = data.left
            game.shift = data.shift
            game.escape = data.escape
            game.interact = data.interact
            player.stamina = data.stamina
            flashlight.charge = data.charge
            levelOne.flashtime = data.flashtime
            scientist.maze = data.maze
            game.sounds = data.sounds
            Music.music:setVolume(data.mvol)
            Sounds.boop:setVolume(data.svol)
            Sounds.win:setVolume(data.svol)
            Sounds.collision:setVolume(data.svol)
            if data.level == "runGame" then
                level = runGame
            elseif data.level == "levelOne" then
                shaders:window()
                level = runLevelOne
            elseif data.level == "levelTwo" then
                level = runLevelTwo
            elseif data.level == "levelThree" then
                level = runLevelThree
            elseif data.level == "maze" then
                level = runMaze
            end
            Gamestate.switch(level)
            player.load(data.position.x,data.position.y)
            firstLoad = false
        end))
    end


else


        
    
    -- local mod_time = love.filesystem.getLastModified("/Users/madison/Desktop/Remedy/2.json")
    -- print("Last modified time:", mod_time)

    files = {}
    local file_date = {}
    filepath = filepath .. "/save"
    for file in io.popen("ls " .. filepath .. "/" .. "*.json"):lines() do 
    table.insert(files, file)
        -- print(file)
        -- local f = io.open(file, "r")
        -- local data_str = f:read("*all")
        -- f:close()
        -- local data = json.decode(data_str)
        -- local cry = (data.date)
        -- --dateString = os.date("%Y-%m-%d %H:%M:%S", cry)
        -- print(cry)
        -- Sort the files table based on date
    table.sort(files, function(a, b)
    -- Read and parse the JSON file for each file
    local f1 = io.open(a, "r")
    local data_str1 = f1:read("*all")
    f1:close()
    local data1 = json.decode(data_str1)

    local f2 = io.open(b, "r")
    local data_str2 = f2:read("*all")
    f2:close()
    local data2 = json.decode(data_str2)

    if not data1.date or not data2.date then
        return false
    end

    return data1.date > data2.date
end)

        
    end

    for i, file in ipairs(files) do
        if i > max then
            break
        end
        local file_name = string.match(file,".+/([^/]+)$")
        local file_name = file_name:gsub(filepath, ""):gsub("%.json", ""):gsub("/", ""):gsub("\\","")
        --print(filename)
        table.insert(buttons, newButton(file_name, function() 
            -- Read and parse the JSON file
            f = io.open(file, "r")
            data_str = f:read("*all")
            data = json.decode(data_str)
            f:close()
            
            
            -- Do something with the data, e.g. set player coordinates
            saveLoad = true
            if data.level == "runGame" then
                level = runGame
            elseif data.level == "levelOne" then
                shaders:window()
                level = runLevelOne
            elseif data.level == "levelTwo" then
                level = runLevelTwo
            elseif data.level == "levelThree" then
                level = runLevelThree
            elseif data.level == "maze" then
                level = runMaze
            end
            Gamestate.switch(level)
            player.x = data.position.x
            player.y = data.position.y
            inventory = data.inventory
            chest = data.chestInventory
            player.load(data.position.x,data.position.y)
            firstLoad = false
            game.up = data.up
            game.down = data.down
            game.right = data.right
            game.left = data.left
            game.shift = data.shift
            game.escape = data.escape
            game.interact = data.interact
            player.stamina = data.stamina
            flashlight.charge = data.charge
            levelOne.flashtime = data.flashtime
            scientist.maze = data.maze
            game.sounds = data.sounds
            Music.music:setVolume(data.mvol)
            Sounds.boop:setVolume(data.svol)
            Sounds.win:setVolume(data.svol)
            Sounds.collision:setVolume(data.svol)
            --player.anim:draw(player.spriteSheet, data.position.x, data.position.y, nil, 5, nil, 6, 6)
        end))
    end
end

font = love.graphics.newFont(32)
function save:draw()
    love.graphics.reset()
   -- local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    --love.graphics.draw(losebackground, 0, 0, 0, screenWidth / losebackground:getWidth(), screenHeight / losebackground:getHeight())
    --love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / background:getWidth(), love.graphics.getHeight() / background:getHeight())
    --love.graphics.draw(img, quad, 0,0, 0, 1,1)
   --love.graphics.reset()
    --self.from:draw()
    --font = love.graphics.newFont(32)
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local buttonwidth = ww * (1/3)
    local margin = 16
    local cursor_y = 0
    local total = (BUTTON_HEIGHT+margin) * #buttons
    --love.graphics.printf('SETTINGS',0,wh/2,ww,'center')
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

        love.graphics.setColor((color))
        love.graphics.rectangle("fill",(ww*.5)-(buttonwidth*.5),(wh * .5)-(total * .5)+cursor_y,buttonwidth,BUTTON_HEIGHT)
        love.graphics.setColor(0,0,0,1)
        local textwidth = font:getWidth(buttons.text)
        local textHeight = font:getHeight(buttons.text)
        love.graphics.print(buttons.text,font,(ww*.5)-textwidth*.5,y+textHeight*.5)
        cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
    end

    love.graphics.reset()

    if love.keyboard.isDown('escape') then
        love.timer.sleep(.15)
        Gamestate.pop()
    end
end

 function save.load()

   -- losebackground = love.graphics.newImage("screens/lose.jpg")
--     --Gamestate.switch(pause)

end


function save:update()
    if love.keyboard.isScancodeDown('p') then
        love.timer.sleep(.15)
        return Gamestate.pop()
    end
end