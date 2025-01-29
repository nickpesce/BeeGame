require "hexagon"
require "tile"
require "hump.class"

Map = Class {
    init = function(self, size)
        --- @type table<{HexCoords: Tile}>
        self.tiles = {}
        for q = -size, size do
            for r = math.max(-size, -size - q), math.min(size, size - q) do
                local coords = HexCoords(q, r)
                self.tiles[coords:key()] = Tile(coords)
            end
        end
        local shop = Tile(HexCoords(0, size+1))
        shop.entity = Shop()
        self.tiles[HexCoords(0, size+1):key()] = shop
        local general_store = Tile(HexCoords(1, size))
        general_store.entity = GeneralStore()
        self.tiles[HexCoords(1, size):key()] = general_store 
        self.tiles[HexCoords(0, 0):key()].entity = BeeBox()
    end
}

function Map:draw()
    for coords, tile in pairs(self.tiles) do
        tile:draw()
    end
end

function Map:update(dt)
    for _, tile in pairs(self.tiles) do
        tile:update(dt)
    end
end
