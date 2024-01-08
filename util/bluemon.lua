bluemon = {}
bluemon = Gamestate.new()
og = love.graphics.newImage("screens/secret.png")
secret = og
require('util.items.book')
bluemon.answer = true
answer = false
bluemon.done = false
bluemon.timer = 0
function bluemon:enter(from)
    self.from = from
    self.word = ""
end

function bluemon:update(dt)

end

function bluemon:draw()
    self.from:draw()
   -- love.graphics.reset()
   --print(bluemon.timer)
bluemon.timer = bluemon.timer +1
   local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    if secret ~= og or bluemon.done == true then
        if bluemon.timer > 500 then
            if answer == true then
                bluemon.done = true
                bluemon.timer = 300
                Gamestate.pop()
            end
            secret = og
    end
    end
   love.graphics.draw(secret, 0, 0, 0, screenWidth / secret:getWidth(), screenHeight / greenpuzzle:getHeight())
   if love.keyboard.isDown('escape') then
       love.timer.sleep(.15)
       Gamestate.pop()
   end
   if answer == false then
    love.graphics.printf("Enter the secret password:", 0, love.graphics.getHeight()/2 - 20, love.graphics.getWidth(), "center")
    love.graphics.printf(self.word, 0, love.graphics.getHeight()/2 + 10, love.graphics.getWidth(), "center")
   else 
   end
   if bluemon.done == true then
    secret = love.graphics.newImage("screens/correct.png")
    
    answer = true
   end
    
end

function bluemon:textinput(t)
    self.word = self.word .. t
end

function bluemon:keypressed(key)
    if key == "backspace" then
        self.word = self.word:sub(1, #self.word-1)
    elseif key == "return" then
        if self.word == "secure contain protect" then
            secret = love.graphics.newImage("screens/correct.png")
            book:draw()
            bluemon.timer = 0
            answer = true
            self.word = ""
           -- Gamestate.pop(bluemon)
            --need to unlock/draw item that is from solving puzzle
        else
            print(self.word)
            secret = love.graphics.newImage("screens/incorrect.png")
            bluemon.timer = 0
            self.word = ""
        end
    end
end


function bluemon.load()
    print(answer)
    if answer == true then
        secret = love.graphics.newImage("screens/correct.png")
        --self.word = "secure contain protect"
    else
    secret = og
    end
end

function bluemon.loadSave()
    bluemon.done = data.three
    print("bluemon loaded...")
    print(bluemon.done)
end
