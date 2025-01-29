local Slab = require 'Slab'
Gamestate = require 'hump.gamestate'

MAIN_MENU = {}

function MAIN_MENU:update(dt)
    Slab.Update(dt)

    Slab.BeginWindow('MainMenu', {
        Title = "Bee Game"
    })
    if Slab.Button("Play") then
        Gamestate.switch(GAME)
    end
    Slab.EndWindow()
end

function MAIN_MENU:keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function MAIN_MENU:draw()
    Slab.Draw()
end
