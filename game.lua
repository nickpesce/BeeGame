require "map"
require "entity"
Camera = require "hump.camera"
require "tile"
require "player"
require "dialog"
require "hud"
local Slab = require 'Slab'

GAME = {}

function GAME:enter()
    self.dialogs = {}
    self.camera = Camera(0, 0)
    self.map = Map(4)
    self.player = Player()
    local content = {}
    content[ScreenCoords(0, 0)] = self.player.inventory
    self.inventory_window = Dialog('Inventory', content)
    self.hud = Hud()
end

function GAME:update(dt)
    Slab.Update(dt)
    self.player:update(dt)
    self.map:update(dt)
    self.hud:update()
    for _, dialog in pairs(self.dialogs) do
        dialog:update(dt)
    end
end

function GAME:keypressed(key)
    if key == "escape" then
        for _, dialog in pairs(self.dialogs) do
            dialog:close()
        end
    elseif key == "e" then
        self.inventory_window:toggle()
    elseif key == "space" then
        local tile = self.map.tiles[Hexagons.get_hex_coords(self.player.location):key()]
        if tile and tile.entity then
            tile.entity:interact(self.player)
        end
    end
end

function GAME:draw()
    self.camera:attach()

    self.map:draw()
    self.player:draw()

    self.camera:detach()

    self.hud:update()
    for _, dialog in pairs(self.dialogs) do
        dialog:draw()
    end
    Slab.Draw()
end

function GAME:wheelmoved(dx, dy)
    if dy > 0 then
        self.camera:zoom(1.1)
    elseif dy < 0 then
        self.camera:zoom(0.9)
    end
end

function GAME:mousemoved(x, y, dx, dy)
    if love.mouse.isDown(1) then
        self.camera:move(-dx/self.camera.scale, -dy/self.camera.scale)
    end
end
