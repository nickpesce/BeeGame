Gamestate = require "hump.gamestate"
require "main_menu"
require "game"
local Slab = require 'Slab'

function love.load(args)
    Slab.SetINIStatePath(nil)
    Slab.Initialize(args)
    Gamestate.registerEvents()
    Gamestate.switch(GAME)
end
