require "hump.class"
local Slab = require 'Slab'
require "hexagon"

Inventory = Class {
    init = function(self)
        self.items = {}
        self.grid_width = 8
        self.grid_height = 8
        for r = 1, self.grid_height do
            self.items[r] = {}
            for c = 1, self.grid_width do
                self.items[r][c] = nil
            end
        end
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

local ITEM_SIZE = 20
InventoryView = Class {
    init = function(self, inventory)
        self.inventory = inventory
        self.height = inventory.grid_height * ITEM_SIZE
        self.width = inventory.grid_width * ITEM_SIZE
    end }

function InventoryView:get_width()
    return self.width
end

function InventoryView:get_height()
    return self.height
end

function InventoryView:click(x, y)
    local r = math.floor(y / ITEM_SIZE) + 1
    local c = math.floor(x / ITEM_SIZE) + 1
    if self.inventory.items[r] and self.inventory.items[r][c] then
        self:on_item_click(r, c)
    end
end

function InventoryView:on_item_click(r, c)
    print(self.inventory.items[r][c].name)
end

function InventoryView:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    for r = 1, self.inventory.grid_height do
        for c = 1, self.inventory.grid_width do
            love.graphics.push()
            love.graphics.translate(ITEM_SIZE * (c - 1), ITEM_SIZE * (r - 1))
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", 0, 0, ITEM_SIZE, ITEM_SIZE)
            if self.inventory.items[r][c] then
                --love.graphics.print(self.items[r][c].name, (c - 1) * ITEM_SIZE, (r - 1) * ITEM_SIZE)
                love.graphics.push()
                love.graphics.translate(ITEM_SIZE / 2, ITEM_SIZE / 2)
                self.inventory.items[r][c]:draw()
                love.graphics.pop()
            end
            love.graphics.pop()
        end
    end
end

ShopInventoryView = Class {
    init = function(self, inventory)
        InventoryView.init(self, inventory)
    end,
    __includes = InventoryView
}

function ShopInventoryView:on_item_click(r, c)
    local item = self.inventory.items[r][c]
    if item and GAME.player.money >= 50 then
        GAME.player.inventory:add(item)
        GAME.player.money = GAME.player.money - 50
        self.inventory.items[r][c] = nil
    end
end

PlayerInventoryView = Class {
    init = function(self, inventory)
        InventoryView.init(self, inventory)
    end,
    __includes = InventoryView
}

function PlayerInventoryView:on_item_click(r, c)
    local item = self.inventory.items[r][c]
    if item then
        local tile = GAME.map.tiles[Hexagons.get_hex_coords(GAME.player.location):key()]
        if tile and not tile.entity then
            item:place(tile)
            self.inventory.items[r][c] = nil
        end
    end
end

InShopPlayerInventoryView = Class {
    init = function(self, inventory, shop_inventory)
        InventoryView.init(self, inventory)
        self.shop_inventory = shop_inventory
    end,
    __includes = InventoryView
}

function InShopPlayerInventoryView:on_item_click(r, c)
    local item = self.inventory.items[r][c]
    if item then
        self.shop_inventory:add(item)
        self.inventory.items[r][c] = nil
    end
end
