crates = {}


function spawnCrate(x, y)
    local crate = {}
    crate.x = x
    crate.y = y
    crate.spritesheet = love.graphics.newImage("sprites/crates.png")
    crate.h = crate.spritesheet:getHeight() 
    crate.w = crate.spritesheet:getWidth()
    crate.collider = world:newRectangleCollider(x, y, crate.w*5 , crate.h*5)
    crate.collider:setFixedRotation(true)
    crate.room = "levelOne"
    crate.scale = 5
   
    function crate.update(dt)
      if crate.room == room and crate.collider ~= nil then
        -- Update crate position based on collider position
        crate.x = crate.collider:getX() - 40
        crate.y = crate.collider:getY() - 45
        
        -- Draw crate sprite
        
        
        -- Update crate collider properties
        local x, y = crate.collider:getLinearVelocity()
        local w = crate.collider:getAngularVelocity()
        if (math.random(0, range) == 1) then
          if x > 1 and y > 1 and w > 1 then
            x = x * 0.33
            y = y * 0.33
            w = w * 0.33
          else
            x = 0
            y = 0
            w = 0
          end
          range = range / 1.5
          if range < 10 then
            range = 100
          end
        end
        crate.collider:setAngularVelocity(w)
        crate.collider:setLinearVelocity(x, y)
        --love.graphics.draw(crate.spritesheet, crate.x, crate.y, crate.collider:getAngle(), 1, 1, crate.w / 2, crate.h /2)
        
      end
      --crates:draw()
      --love.graphics.draw(crate.spritesheet, crate.x, crate.y, crate.collider:getAngle(), 1, 1, crate.w / 2, crate.h /2)
    end
    
    table.insert(crates, crate)
    return crate
  end
  

function crates:update(dt)
    for _,c in ipairs(crates) do
        c.update(dt)
    end
end

function crates:draw()
    for _,c in ipairs(crates) do
        love.graphics.draw(c.spritesheet, c.x, c.y,0,c.scale,c.scale)
        --print(c.x)
    end
end

function crates.delete()
    for _,c in ipairs(crates) do
        c.x = 5000
    end
end

function crates.clearCrates()
    for k in pairs(crates) do
      
    end
  end
  
