require "hump.class"
local Slab = require 'Slab'
require "hexagon"

local ITEM_SIZE = 20
Inventory = Class {
    init = function(self, name)
        self.name = name
        self.items = {}
        self.grid_width = 8
        self.grid_height = 8
        for r = 1, self.grid_height do
            self.items[r] = {}
            for c = 1, self.grid_width do
                self.items[r][c] = nil
            end
        end
        self.height = self.grid_height * ITEM_SIZE
        self.width = self.grid_width * ITEM_SIZE
    end
}

function Inventory:add(entity)
    for r = 1, self.grid_height do
        for c = 1, self.grid_width do
            if self.items[r][c] == nil then
                self.items[r][c] = entity
                return
            end
        end
    end
end

function Inventory:get_width()
    return self.width
end

function Inventory:get_height()
    return self.height
end

function Inventory:click(x, y)
    local r = math.floor(y / ITEM_SIZE) + 1
    local c = math.floor(x / ITEM_SIZE) + 1
    if self.items[r] and self.items[r][c] then
        self:on_item_click(r, c)
    end
end

function Inventory:on_item_click(r, c)
    print(self.items[r][c].name)
end

function Inventory:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
    for r = 1, self.grid_height do
        for c = 1, self.grid_width do
            if self.items[r][c] then
                love.graphics.print(self.items[r][c].name, (c - 1) * ITEM_SIZE, (r - 1) * ITEM_SIZE)
            else
                love.graphics.rectangle("line", (c - 1) * ITEM_SIZE, (r - 1) * ITEM_SIZE, ITEM_SIZE, ITEM_SIZE)
            end
        end
    end
end

ShopInventory = Class {
    __includes = Inventory
}

function ShopInventory:on_item_click(r, c)
    local item = self.items[r][c]
    if item and GAME.player.money >= 50 then
        GAME.player.inventory:add(item)
        GAME.player.money = GAME.player.money - 50
        self.items[r][c] = nil
    end
end

PlayerInventory = Class {
    __includes = Inventory
}
function PlayerInventory:on_item_click(r, c)
    local item = self.items[r][c]
    if item then
        local tile = GAME.map.tiles[Hexagons.get_hex_coords(GAME.player.location):key()]
        if not tile.entity then
            tile.entity = item
            self.items[r][c] = nil
        end
    end
end
