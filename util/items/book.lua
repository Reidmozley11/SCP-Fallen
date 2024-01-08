book = {}
    book.spritesheet = love.graphics.newImage("sprites/mannequin1.png")
    book.x = 1390
    book.y = 300
    book.h = book.spritesheet:getHeight()
    book.w = book.spritesheet:getWidth()
    book.scale = 3
    book.room = "levelThree"

function book:draw()
    if checkInventory(inventory, "book") == false and checkInventory(chest, "book") == false then
    if book.room == room then
        love.graphics.draw(book.spritesheet,book.x,book.y,0,book.scale,book.scale)
        --print("drawing")
    end
end
 
end

function book.load()
    book.x = data.book.x
    book.y = data.book.y
    book.room = data.book.room
end