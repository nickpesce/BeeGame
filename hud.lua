require "hump.class"
local Slab = require 'Slab'

Hud = Class {}

function Hud:update()
    Slab.BeginWindow('TopHud', {
        X = 0,
        Y = 0,
        W = love.graphics.getWidth(),
        H = 20,
        AutoSizeWindow = false,
        CanObstruct = false,
        AllowResize = false,
        NoSavedSettings = true
    })
    Slab.BeginLayout('TopHudLayout', {AlignX= 'right'})
    Slab.Text("$"..game.player.money)
    Slab.EndLayout()
    Slab.EndWindow()
end
