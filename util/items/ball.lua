ball = {}
    ball.spritesheet = love.graphics.newImage("sprites/ball.png")
    ball.x = 3000
    ball.y = 230
    ball.h = ball.spritesheet:getHeight()
    ball.w = ball.spritesheet:getWidth()
    ball.scale = 3
    ball.room = "levelOne"

    function ball:draw()
        if checkInventory(inventory, "ball") == false then
            if ball.room == room then
                love.graphics.draw(ball.spritesheet, ball.x, ball.y, 0, ball.scale,
                    ball.scale)
            end
        end
    end

    function ball.load()
        ball.x = data.ball.x
        ball.y = data.ball.y
        ball.room = data.ball.room
    end
