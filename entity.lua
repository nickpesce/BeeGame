require "inventory"
Entity = Class {
    init = function(self, type)
        self.type = type
    end
}

function Entity:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", 0, 0, 10)
end

local BeeBoxSize = 5
BeeBox = Class {
    init = function(self)
        self.bee_attributes = {}
        self.honey = 0
    end
}

function BeeBox:update(dt)
    self.honey = math.min(BeeBoxSize, self.honey + dt)
end

function BeeBox:is_full()
    return self.honey == BeeBoxSize
end

function BeeBox:draw()
    if self:is_full() then
        love.graphics.setColor(1, 1, 0)
        love.graphics.circle("fill", 0, 0, 10)
    else
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", 0, 0, 10)
        love.graphics.setColor(1, 1, 0)
        love.graphics.line(-5, 5, self.honey-5, 5)
    end
end

function BeeBox:interact()
    if self:is_full() then
        self.honey = 0
        game.player.inventory:add(Honey())
    end
end

Shop = Class {
    init = function(self)
        self.inventory = Inventory()
    end
}

function Shop:draw()
    love.graphics.setColor(.6, .2, .1)
    love.graphics.circle("fill", 0, 0, 10)
end

function Shop:interact()
    for i, inventory_row in ipairs(game.player.inventory.items) do
        for j, item in ipairs(inventory_row) do
            if item.name == "honey" then
                self.inventory.items[i][j] = item
                game.player.inventory.items[i][j] = nil
            end
        end
    end
    self.inventory:open()
end

function Shop:update(dt)
end

Honey = Class {
    init = function(self)
        self.name = "honey"
    end
}
