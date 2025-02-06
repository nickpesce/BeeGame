require "inventory"
require "pipe"

Entity = Class {
    init = function(self, type)
        self.type = type
        self.tile = nil
    end
}

function Entity:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.print(0, 0, self.type)
end

function Entity:maybe_connect_to_pipes()
    if self.tile then
        local neighbors = self.tile.coords:neighbors()
        for i, neighbor in ipairs(neighbors) do
            local neighbor_tile = GAME.map.tiles[neighbor:key()]
            if neighbor_tile and neighbor_tile.entity then
                local entity = neighbor_tile.entity
                if (entity.type == "Pipe" and entity.pipe_system == self.pipe_system) or entity.type == "BeeBox" or entity.type == "Shop" then
                    love.graphics.push()
                    love.graphics.rotate((i - 1) * math.pi / 3)
                    love.graphics.rectangle("fill", -2.5, 0, 5, -Hexagons.size)
                    love.graphics.pop()
                end
            end
        end
    end
end

function Entity:place(tile)
    tile.entity = self
    self.tile = tile
end

function Entity:interact()
end

function Entity:update(dt, tile)
end

local BeeBoxSize = 5
BeeBox = Class {
    init = function(self)
        Entity.init(self, "BeeBox")
        self.bee_attributes = {}
        self.honey = 0
        self.name = "Bee box"
    end,
    __includes = Entity
}

function BeeBox:update(dt, tile)
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
    self:maybe_connect_to_pipes()
end

function BeeBox:interact()
    if self:is_full() then
        self.honey = 0
        GAME.player.inventory:add(Honey())
    end
end

Shop = Class {
    init = function(self)
        Entity.init(self, "Shop")
        self.inventory = Inventory()
    end,
    __includes = Entity
}

function Shop:draw()
    love.graphics.setColor(.6, .2, .1)
    love.graphics.circle("fill", 0, 0, 10)
    self:maybe_connect_to_pipes()
end

function Shop:interact()
    local content = {}
    local player_inventory_view = InShopPlayerInventoryView(GAME.player.inventory, self.inventory)
    local shop_inventory_view = ShopInventoryView(self.inventory)
    content[ScreenCoords(0, 0)] = player_inventory_view
    content[ScreenCoords(player_inventory_view:get_width() + 10, 0)] = shop_inventory_view
    Dialog("Shop", content):open()
end

function Shop:update(dt, tile)
    if math.random() < (1 - 1 / (dt + 1)) / 5 then
        self:try_to_sell_honey()
    end
end

function Shop:try_to_sell_honey()
    for i = 1, self.inventory.grid_width do
        for j = 1, self.inventory.grid_height do
            if self.inventory.items[i][j] and self.inventory.items[i][j].type == "honey" then
                self.inventory.items[i][j] = nil
                GAME.player.money = GAME.player.money + 10
                return
            end
        end
    end
end

GeneralStore = Class {
    init = function(self)
        Entity.init(self, "GeneralStore")
        self.inventory = Inventory()
        for _ = 1, 10 do
            self.inventory:add(BeeBox())
            self.inventory:add(Pipe())
        end
        self.inventory_view = ShopInventoryView(self.inventory)
    end,
    __includes = Entity
}

function GeneralStore:draw()
    love.graphics.setColor(.6, .6, .6)
    love.graphics.circle("fill", 0, 0, 10)
end

function GeneralStore:interact()
    local content = {}
    local player_inventory_view = InShopPlayerInventoryView(GAME.player.inventory, self.inventory)
    local store_inventory_view = ShopInventoryView(self.inventory)
    content[ScreenCoords(0, 0)] = player_inventory_view
    content[ScreenCoords(player_inventory_view:get_width() + 10, 0)] = store_inventory_view
    Dialog("General Store", content):open()
end

function GeneralStore:update(dt, tile)
end

Honey = Class {
    init = function(self)
        Entity.init(self, "honey")
    end,
    __includes = Entity
}

function Honey:draw()
    love.graphics.setColor(1, 1, 0)
    love.graphics.circle("fill", 0, 0, 5)
end

Pipe = Class {
    init = function(self)
        Entity.init(self, "Pipe")
        self.pipe_system = nil
    end,
    __includes = Entity
}

function Pipe:draw()
    if self.pipe_system and self.pipe_system.honey_contents > 0 then
        love.graphics.setColor(.9, .9, 0)
    else
        love.graphics.setColor(.3, .3, .3)
    end
    love.graphics.circle("fill", 0, 0, 5)
    self:maybe_connect_to_pipes()
end

function Pipe:update(dt, tile)
end

function Pipe:place(tile)
    Entity.place(self, tile)

    local neighbor_systems = {}
    for _, neighbor in ipairs(tile.coords:neighbors()) do
        local neighbor_tile = GAME.map.tiles[neighbor:key()]
        if neighbor_tile and neighbor_tile.entity and neighbor_tile.entity.type == "Pipe" and neighbor_tile.entity.pipe_system then
            neighbor_systems[neighbor_tile.entity.pipe_system] = true
        end
    end

    local num_neighbors = 0
    for _, _ in pairs(neighbor_systems) do
        num_neighbors = num_neighbors + 1
    end

    if num_neighbors == 0 then
        self.pipe_system = PipeSystem()
        self.pipe_system:add(tile.coords, self)
    elseif num_neighbors == 1 then
        for system, _ in pairs(neighbor_systems) do
            self.pipe_system = system
            system:add(tile.coords, self)
        end
    else
        local new_system = PipeSystem()
        for system, _ in pairs(neighbor_systems) do
            new_system.honey_contents = new_system.honey_contents + system.honey_contents
            for coords, pipe in pairs(system.pipes) do
                pipe.pipe_system = new_system
                new_system:add(coords, pipe)
            end
            self.pipe_system = system
        end
    end
end
