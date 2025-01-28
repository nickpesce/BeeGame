require "hump.class"
local Slab = require 'Slab'
require "hexagon"

local item_size = 20
local header_height = 15
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
        self.height = self.grid_height * item_size + header_height
        self.width = self.grid_width * item_size
        self.location = ScreenCoords(love.graphics.getWidth() / 2 - self.width / 2,
            love.graphics.getHeight() / 2 - self.height / 2)
        self.is_open = false
        table.insert(game.dialogs, self)
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

function Inventory:toggle()
    if self.is_open then
        self:close()
    else
        self:open()
    end
end

function Inventory:open()
    self.is_open = true
end

function Inventory:close()
    self.is_open = false
end

function Inventory:draw()
    if not self.is_open then
        return
    end
    love.graphics.push()
    love.graphics.translate(self.location.x, self.location.y)

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, self.width, 10)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("X", 0, 0)
    for r = 1, self.grid_height do
        for c = 1, self.grid_width do
            if self.items[r][c] then
                love.graphics.print(self.items[r][c].name, (c - 1) * item_size, (r - 1) * item_size + header_height)
            else
                love.graphics.rectangle("line", (c - 1) * item_size, (r - 1) * item_size + header_height, item_size,
                    item_size)
            end
        end
    end

    love.graphics.pop()
end
