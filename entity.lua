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
        self.name = "Bee box"
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
        love.graphics.line(-5, 5, self.honey - 5, 5)
    end
end

function BeeBox:interact()
    if self:is_full() then
        self.honey = 0
        GAME.player.inventory:add(Honey())
    end
end

Shop = Class {
    init = function(self)
        self.inventory = Inventory("Shop")
    end
}

function Shop:draw()
    love.graphics.setColor(.6, .2, .1)
    love.graphics.circle("fill", 0, 0, 10)
end

function Shop:interact()
    for i = 1, GAME.player.inventory.grid_width do
        for j = 1, GAME.player.inventory.grid_height do
            local item = GAME.player.inventory.items[i][j]
            if item and item.name == "honey" then
                self.inventory.items[i][j] = item
                GAME.player.inventory.items[i][j] = nil
            end
        end
    end
    local content = {}
    content[ScreenCoords(0, 0)] = self.inventory
    content[ScreenCoords(self.inventory:get_width()+10, 0)] = GAME.player.inventory
    Dialog("Shop", content):open()
end

function Shop:update(dt)
    if math.random() < (1 - 1 / (dt + 1)) / 5 then
        self:try_to_sell_honey()
    end
end

function Shop:try_to_sell_honey()
    for i = 1, self.inventory.grid_width do
        for j = 1, self.inventory.grid_height do
            if self.inventory.items[i][j] and self.inventory.items[i][j].name == "honey" then
                self.inventory.items[i][j] = nil
                GAME.player.money = GAME.player.money + 10
                return
            end
        end
    end
end

GeneralStore = Class {
    init = function(self)
        self.inventory = ShopInventory("GeneralStore")
        self.inventory:add(BeeBox())
        self.inventory:add(BeeBox())
        self.inventory:add(BeeBox())
        self.inventory:add(BeeBox())
        self.inventory:add(BeeBox())
        self.inventory:add(BeeBox())
        self.inventory:add(BeeBox())
        self.inventory:add(BeeBox())
        self.inventory:add(BeeBox())
        self.inventory:add(BeeBox())
    end
}

function GeneralStore:draw()
    love.graphics.setColor(.6, .6, .6)
    love.graphics.circle("fill", 0, 0, 10)
end

function GeneralStore:interact()
    local content = {}
    content[ScreenCoords(0, 0)] = self.inventory
    content[ScreenCoords(self.inventory:get_width()+10, 0)] = GAME.player.inventory
    Dialog("General Store", content):open()
end

function GeneralStore:update(dt)
end

Honey = Class {
    init = function(self)
        self.name = "honey"
    end
}
