require "hexagon"
require "hump.class"

Map = Class {
    init = function(self, size)
        self.tiles = {}
        for q = -size, size do
            for r = math.max(-size, -size - q), math.min(size, size - q) do
                self.tiles[{q, r}] = Tile(HexCoords(q, r))
            end
        end
    end
}

function Map:draw()
    for coords, tile in pairs(self.tiles) do
        local vertices = Hexagons.get_vertices(tile.coords)
        love.graphics.setColor(0.1, 1, 0.1)
        love.graphics.polygon("fill", vertices)
        love.graphics.setColor(1, 1, 1)
        love.graphics.polygon("line", vertices)
        love.graphics.setColor(0, 0, 0)
        local center = Hexagons.get_center(tile.coords)
        love.graphics.points(center.x, center.y)
        love.graphics.print(tile.coords.q .. ", " .. tile.coords.r, center.x - 20, center.y)
    end
end
