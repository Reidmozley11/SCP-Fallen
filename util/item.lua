local Item = {}
-- If yall are curious this is really cool.
-- it insures that the field of the metatable will look up keys that 
-- are not found in the original table. This may be useful may not be. Imma include it because it seems like good practice
Item.__index = Item

function Item:new(name, img, value)
    local item = {}
    setmetatable(item, Item)
    item.name = name
    item.sprite = img
    item.value = value
    return item
end

function Item:use()
    -- any function we may need for an item can go here
end

-- Create items here
-- for example

local manequin = Item:new("Manequin", "sprites/manequin.sprite", 1)