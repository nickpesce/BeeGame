PipeSystem = Class {
    init = function(self)
        self.pipes = {}
        self.honey_contents = 0
        self.time_to_next_empty = 0
        GAME.updatables[self] = true
    end
}

function PipeSystem:add(coords, pipe)
    self.pipes[coords] = pipe
end

function PipeSystem:update(dt)
    local neighbors = {}
    for coords, pipe in pairs(self.pipes) do
        for _, neighbor in ipairs(HexCoords(coords.q, coords.r):neighbors()) do
            neighbors[neighbor] = true
        end
    end

    for neighbor, _ in pairs(neighbors) do
        local neighbor_tile = GAME.map.tiles[neighbor:key()]
        if neighbor_tile and neighbor_tile.entity then
            if neighbor_tile.entity.type == "Shop" and self.honey_contents > 0 and self.time_to_next_empty <= 0 then
                self.honey_contents = self.honey_contents - 1
                neighbor_tile.entity.inventory:add(Honey())
            end
            if neighbor_tile.entity.type == "BeeBox" and neighbor_tile.entity:is_full() and self.honey_contents == 0 then
                self.honey_contents = self.honey_contents + 1
                neighbor_tile.entity.honey = 0
            end
        end
    end
    if self.time_to_next_empty == 0 and self.honey_contents > 0 then
        self.time_to_next_empty = 1
    else
        self.time_to_next_empty = math.max(self.time_to_next_empty - dt, 0)
    end
end
