gengar = {}
    gengar.spritesheet = love.graphics.newImage("sprites/gengar.png")
    gengar.x = 100
    gengar.y = 100
    gengar.h = gengar.spritesheet:getHeight()
    gengar.w= gengar.spritesheet:getWidth()
    gengar.room = "runGame"


function gengar:draw()
    if checkInventory(inventory, "gengar") == false then
    if gengar.room == room then
    love.graphics.draw(gengar.spritesheet,gengar.x,gengar.y)
    end
end

end

function gengar.load()
    gengar.x = data.gengarpos.x
    gengar.y = data.gengarpos.y
    gengar.room = data.gengarpos.room
end
