shaders = {}

-- NOTE: These shaders are written using GLSL for Love2D

--windowWidth, windowHeight = love.window.getMode()


function shaders:window()
    if game.width == nil then
        windowWidth = 1920
        windowHeight = 1080
    else
        windowWidth = game.width
        windowHeight = game.height
    end
end

scale = 100

shaders.flashlight = false
-- Hole-punch light source
shaders.simpleLight = love.graphics.newShader[[

    extern number playerX = 0;
    extern number playerY = 0;
    extern number mouseX = 0;
    extern number mouseY = 0;
    extern number falloff = .5;
    extern bool flashlight = true;
    number radius = 200;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        number distance = pow(pow(screen_coords.x - playerX, 2) + pow(screen_coords.y - playerY, 2), 0.5);
        number alpha = (distance / radius);
        number lightAlpha = (distance / 600);
        vec2 lightDirection = normalize(vec2(mouseX - playerX, mouseY - playerY));
        number dotProduct = dot(normalize(screen_coords - vec2(playerX, playerY)), lightDirection);
        

        if (flashlight == true && distance < radius && dotProduct > .95) {
            return vec4(0,0,0,lightAlpha);
        }
        if (distance < radius) {
            return vec4(0,0,0,alpha);
        }
        if (flashlight == false){
            //if (dotProduct > 0.9) {
                //return vec4(0, 0, 0, alpha);
            //}
            //else {
                return vec4(0, 0, 0, 1);
            //} 
        }
        else if (flashlight == true) {
            if (dotProduct > 0.95) {
                return vec4(0, 0, 0, lightAlpha);
            }
            else {
                return vec4(0, 0, 0, alpha);
            } 
        }
    }

]]

-- Faded light source
shaders.trueLight = love.graphics.newShader[[
    extern number originX = 0;
    extern number originY = 0;
    extern number  mouseX = 0;
    extern number mouseY = 0;
    extern bool flashlight = false;
    number radius = 300;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        number distance = pow(pow(screen_coords.x - originX, 2) + pow(screen_coords.y - originY, 2), 0.5);
        number mousedistance = pow(pow(screen_coords.x - mouseX, 2) + pow(screen_coords.y - mouseY, 2), 0.5);
        number alpha = distance / radius;
        if (flashlight == false) {
        if(distance < radius) {
            return vec4(0, 0, 0, alpha);   
        }
            else {
                return vec4(0, 0, 0, alpha);
            } 
        }
        else if (flashlight == true) {
            number mousealpha = mousedistance/radius;
            if (mousedistance<radius) {
                return vec4(0, 0, 0, mousealpha);
            }
            if (distance < (radius) / 4) {
                number smallalpha = distance / (radius/4);
                return vec4(0, 0, 0, smallalpha);
                }

        else {
            return vec4(0, 0, 0, 1);
}
        }
    }
]]

-- White damage flash
shaders.whiteout = love.graphics.newShader[[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        vec4 pixel = Texel(texture, texture_coords);
        if (pixel.a == 1) {
            return vec4(1, 1, 1, 1);
        } else {
            return vec4(0, 0, 0, 0);
        }
    }
]]

function shaders:update(dt)
    shaders:window()

    if (shaders.flashlight == false) then

        local px = 400
        local py = 250
        flashlight.charge = flashlight.charge + flashlight.recharge
        -- if room == "levelTwo" then
        --     flashlight.charge = flashlight.charge+(flashlight.recharge*5)
        -- end
        -- if room == "maze" then
        --     flashlight.charge = flashlight.charge+(flashlight.recharge*2)
        -- end
        if flashlight.charge > flashlight.max then
            flashlight.charge = flashlight.max
        end
        -- Get width/height of background
        local mapW = testingMap.width * testingMap.tilewidth
        local mapH = testingMap.height * testingMap.tileheight

        local lightX = (windowWidth/2)
        local lightY = (windowHeight/2)

        shaders.simpleLight:send("playerX", lightX)
        shaders.simpleLight:send("playerY", lightY)
        shaders.trueLight:send("originX", lightX)
        shaders.trueLight:send("originY", lightY)
        shaders.simpleLight:send("flashlight", shaders.flashlight)
        shaders.trueLight:send("flashlight", shaders.flashlight)



    else

        if (shaders.flashlight == true) then

        local px = love.mouse.getX()
        local py = love.mouse.getY()
        flashlight.charge = flashlight.charge-flashlight.decay
        -- if love.keyboard.isDown('m') then
        --     flashlight.charge = flashlight.charge-(flashlight.decay*30)
        -- end
        if flashlight.charge < 0 then
            shaders.flashlight = false
            flashlight.charge = 0
        end
        -- Get width/height of background
        local mapW = testingMap.width * testingMap.tilewidth
        local mapH = testingMap.height * testingMap.tileheight

        local lightX = (windowWidth/2)
        local lightY = (windowHeight/2)

        shaders.trueLight:send("originX", lightX)
        shaders.trueLight:send("originY", lightY)
        shaders.trueLight:send("mouseX", px)
        shaders.trueLight:send("mouseY", py)
        shaders.trueLight:send("flashlight", shaders.flashlight)
        shaders.simpleLight:send("playerX", lightX)
        shaders.simpleLight:send("playerY", lightY)
        shaders.simpleLight:send("mouseX", px)
        shaders.simpleLight:send("mouseY", py)
        shaders.simpleLight:send("flashlight", shaders.flashlight)
        end
    end

end