require("game")
require('tutorial')
require('levelOne')
require('maze')
require('levelTwo')
require('levelThree')
require('pause')

require('util.settings')
require('util.lose')
require('util.win')
require('save_file_menu')
require('util.save')
require('util.greenmon')
require('util.bluemon')
require('util.controls')
require('util.story')

local tests = require('testing.tests')

-- Tiled implementation library
local testing = require("testing.testing")

sti = require 'libraries/sti'

-- Gamestate library
Gamestate = require 'libraries.gamestate'

-- Tables containing each levels functions
menu = {}
runGame = {}
runTutorial = {}
runLevelOne = {}
runLevelTwo = {}
runLevelThree = {}
runMaze = {}

--runLevelTwo = {}

chestinventory = {}
craftbtr = {}

-- Sets the title of the window to the name 
-- of the game
love.window.setTitle("SCP: FALLEN")

local buttons = {}
local test = {}

BUTTON_HEIGHT = 64
local font = nil
background = love.graphics.newImage("maps/mainmenu.png")

-- Creates a new instance of a button
-- @param text <- Takes in a string to be displayed onto the button
-- @param fn <- Takes in a function for the button to execute
local function newButton(text,fn)
    return{
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end

-- Enters and initializes the gamestate for the main menu
function menu:enter()
    img = love.graphics.newImage("maps/mainmenu.png")
    img:setWrap("repeat", "repeat")
    quad = love.graphics.newQuad( 0,0, 800,600, 800,720)
    Sounds.spook = love.audio.newSource("sounds/spook.wav", "static")
    Sounds.spook:setVolume(.5)
    Sounds.spook:play()
end

-- Draws the main menu and creates the buttons
function menu:draw()
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    love.graphics.draw(background, 0, 0, 0, screenWidth / background:getWidth(), screenHeight / background:getHeight())
        local ww = love.graphics.getWidth()
        local wh = love.graphics.getHeight()
        local buttonwidth = ww * (1/3)
        local margin = 16
        local cursor_y = 0
        local total = (BUTTON_HEIGHT+margin) * #buttons
        for i, buttons in ipairs(buttons) do
            buttons.last = buttons.now
            love.graphics.setColor(0.4,.4,.5,1)
            local x = (ww*.5)-(buttonwidth*.5)
            local y = (wh * .5)-(total * .5)+cursor_y
            local color = {.4,.4,.5,1}
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
    -- resets the color so that it doesnt have a black screen (very important please dont delete)
    love.graphics.reset()
end

-- Code for executing the tutorial
function runTutorial:enter()
    tutorial.enter(self)
end

-- Runs the update function of the maze gamestate
-- @param dt <- Iterates every frame using delta-time
-- function runMaze:update(dt)
--     tutorial.update(self, dt)
-- end

-- Runs the draw function of the maze gamestate
-- function runMaze:draw()
--     tutorial.draw(self)
-- end

-- Code for executing the main lobby of the game
function runGame:enter()
    game.enter(self)
end

-- Runs the update function of the main lobby gamestate
-- @param dt <- Iterates every frame using delta-time
function runGame:update(dt)
    if player.paused == 0 then
        game.update(self, dt)
    else
        player.pause(dt)
    end

end

-- Runs the draw function of the main lobby
function runGame:draw()
    game.draw(self)
end

-- Code for executing the first stage of the game
function runLevelOne:enter()
    levelOne.enter(self)
end

-- Runs the update function of level one's gamestate
-- @param dt <- Iterates every frame using delta-time
function runLevelOne:update(dt)
    levelOne.update(self, dt)
end

-- Runs level one's draw function
function runLevelOne:draw()
    levelOne.draw(self)
end

-- Runs level two
function runLevelTwo:enter()
    levelTwo.enter(self)
end

-- Runs the update function of level two's gamestate
-- @param dt <- Iterates every frame using delta-time
function runLevelTwo:update(dt)
    levelTwo.update(self, dt)
end

-- Runs level two's draw function
function runLevelTwo:draw()
    levelTwo.draw(self)
end

-- Runs level three
function runLevelThree:enter()
    levelThree.enter(self)
end

-- Runs the update function of level three's gamestate
-- @param dt <- Iterates every frame using delta-time
function runLevelThree:update(dt)
    levelThree.update(self, dt)
end

-- Runs the level three draw function
function runLevelThree:draw()
    levelThree.draw(self)
end

-- Code for executing the maze section
function runMaze:enter()
    maze.enter(self)
end

-- Runs the update function of level Maze's gamestate
-- @param dt <- Iterates every frame using delta-time
function runMaze:update(dt)
    maze.update(self, dt)
end

-- Runs the maze draw function
function runMaze:draw()
    maze.draw(self)
end

-- Loads in the sounds and prepares the game
-- for game state switches and builds the buttons
-- with their respective funtions and text.
function love.load()
    Sounds = {}
    Music = {}
    Music.music = love.audio.newSource("sounds/scary.mp3","stream")
    Music.music:setLooping(true)
    Sounds.collision = love.audio.newSource("sounds/collision.wav", "stream")
    Sounds.boop = love.audio.newSource("sounds/boop.wav", "static")
    Sounds.win = love.audio.newSource("sounds/success.mp3","static")
    Sounds.boop:setVolume(.2)
    Sounds.win:setVolume(.2)
    Sounds.collision:setVolume(.2)
    Music.music:setVolume(.2)
    Gamestate.registerEvents()
    font = love.graphics.newFont(32)
    Gamestate.switch(menu)
    love.graphics.setBackgroundColor(0,255,255,1)
    table.insert(buttons,newButton("Start Game",function() Gamestate.switch(story) Music.music:play() love.window.setMode(1920, 1080, {resizable=true, vsync=true, minwidth=400, minheight=300})end))
    table.insert(buttons,newButton("Load Save",function() Gamestate.push(save) sleep(.3) end))
    table.insert(buttons,newButton("Exit",function()love.event.quit(0)end))
    testing.run()
end




