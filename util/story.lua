Gamestate = require 'libraries.gamestate'
story = {}
story = Gamestate.new()


local positions = {
    {50, 50},
    {50, 100},
    {50, 150},
    {50, 200},
    {50, 250},
    {50, 300},
    {50, 350}
}

-- Current iteration of SCP: Fallen story
local text = {
    "April 2, 2238",
    "REPORT FROM SCP LAB 676:",
    "Request for a Mobile Task Force Epsilon-11 'Nine-Tailed Fox' immediately",
    "Our lab has been compromised and containment protocol 792 has failed. As far as we are currently aware the casualty rates are high.",
    "I'm [REDACTED] and I will be waiting on you in the bottom left corner of the main lobby to explain more of the situation. As it is currently, it is too dangerous for a scientist to",
    "gather the required equipment to engage in containment protocol 6. I'm quite well educated in the security protocols so you can come to me and I may give information as you need. Any delay in your arrival and we could have a much more serious containment breach",
    "HIT ENTER TO ARRIVE AT THE FACILITY"
    --Whenever you add a new line add a new 0 value to charIndex, a new false value to linePrinted, and a new position vector
}

local charIndex = {0, 0, 0, 0, 0, 0, 0}
local lineIndex = 1
local linePrinted = {false, false, false, false, false, false, false}
local timeElapsed = 0
local delay = 0.02
local gameState = "intro"


function story.load()

end

function story:update(dt)
    if gameState == "intro" then
        timeElapsed = timeElapsed + dt
        if timeElapsed > delay then
            timeElapsed = timeElapsed - delay
            charIndex[lineIndex] = charIndex[lineIndex] + 1
            if charIndex[lineIndex] > #text[lineIndex] then
                linePrinted[lineIndex] = true
            end
        end
        if linePrinted[lineIndex] then
            charIndex[lineIndex] = 0
            lineIndex = lineIndex + 1
            if lineIndex > #text then
                gameState = "wait_for_input"
            end
        end
    elseif gameState == "wait_for_input" then
        if love.keyboard.isDown('return') then
            gameState = "next_screen"
        end
    end
    if love.keyboard.isDown('return') then
        Gamestate.switch(runGame)
    end
end

function story:draw()
    for i = 1, #text do
        if i < lineIndex then
            love.graphics.print(text[i], positions[i][1], positions[i][2])
        elseif i == lineIndex then
            if linePrinted[i] then
                love.graphics.print(text[i], positions[i][1], positions[i][2])
            else
                love.graphics.print(string.sub(text[i], 1, charIndex[i]), positions[i][1], positions[i][2])
            end
        else
            break
        end
    end

end