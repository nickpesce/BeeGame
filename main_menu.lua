local Slab = require 'Slab'
Gamestate = require 'hump.gamestate'

main_menu = {}

function main_menu:update(dt)
    Slab.Update(dt)

    Slab.BeginWindow('MainMenu', {
        Title = "Bee Game"
    })
    if Slab.Button("Play") then
        Gamestate.switch(game)
    end
    Slab.EndWindow()
end

function main_menu:keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function main_menu:draw()
    Slab.Draw()
end
