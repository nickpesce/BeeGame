require "map"
require "entity"
Camera = require "hump.camera"
require "tile"
require "player"
require "hud"
local Slab = require 'Slab'

game = {}

function game:enter()
    self.dialogs = {}
    self.camera = Camera(0, 0)
    self.map = Map(4)
    self.map.tiles[HexCoords(0, 0):key()].entity = BeeBox()
    self.map.tiles[HexCoords(4, 0):key()].entity = Shop()
    self.player = Player()
    self.hud = Hud()
end

function game:update(dt)
    Slab.Update(dt)
    self.player:update(dt)
    self.map:update(dt)
    self.hud:update()
end

function game:keypressed(key)
    if key == "escape" then
        Gamestate.switch(main_menu)
    elseif key == "e" then
        self.player.inventory:toggle()
    elseif key == "space" then
        local entity = self.map.tiles[Hexagons.get_hex_coords(self.player.location):key()].entity
        if entity then
            entity:interact(self.player)
        end
    end
end

function game:draw()
    self.camera:attach()

    self.map:draw()
    self.player:draw()

    self.camera:detach()

    self.hud:update()
    for _, dialog in ipairs(self.dialogs) do
        dialog:draw()
    end
    Slab.Draw()
end

function game:wheelmoved(dx, dy)
    if dy > 0 then
        self.camera:zoom(1.1)
    elseif dy < 0 then
        self.camera:zoom(0.9)
    end
end

function game:mousemoved(x, y, dx, dy)
    if love.mouse.isDown(1) then
        self.camera:move(-dx/self.camera.scale, -dy/self.camera.scale)
    end
end
