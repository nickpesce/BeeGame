require "hexagon"
require "tile"
require "hump.class"

Map = Class {
    init = function(self, size)
        --- @type table<{HexCoords, Tile}>
        self.tiles = {}
        for q = -size, size do
            for r = math.max(-size, -size - q), math.min(size, size - q) do
                local coords = HexCoords(q, r)
                self.tiles[coords:key()] = Tile(coords)
            end
        end
    end
}

function Map:draw()
    for coords, tile in pairs(self.tiles) do
        tile:draw()
    end
end

function Map:update(dt)
    for coords, tile in pairs(self.tiles) do
        tile:update(dt)
    end
end
