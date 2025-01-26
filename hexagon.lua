Class = require "hump.class"

--[[
https://www.redblobgames.com/grids/hexagons/#coordinates-axial

# Coordinate Systems:
## Axial Coordinates for the hex grid
All hexagons are flat top

## Screen/pixel coordinates for unaligned entities
]] --
Hexagons = {}
size = 25
side = math.sqrt(3) / 2 * size

--- Gets the s cubic coordinate from axial coordinates
Hexagons.get_s = function(hex_coords)
    return -hex_coords.q - hex_coords.r
end

Hexagons.get_center = function(hex_coords)
    return ScreenCoords(size * 3 / 2 * hex_coords.q, size * math.sqrt(3) * (hex_coords.r + hex_coords.q / 2))
end

Hexagons.get_vertices = function(hex_coords)
    local vertices = {}
    for i = 1, 6 do
        local center = Hexagons.get_center(hex_coords)
        local angle_deg = 60 * i
        local angle_rad = math.pi / 180 * angle_deg
        vertices[2 * i - 1] = center.x + size * math.cos(angle_rad)
        vertices[2 * i] = center.y + size * math.sin(angle_rad)
    end
    return vertices
end

Tile = Class {
    init = function(self, hex_coords)
        self.coords = hex_coords
    end
}

function Tile:draw()
    local vertices = Hexagons.get_vertices(self.coords)
    love.graphics.setColor(0.1, 1, 0.1)
    love.graphics.polygon("fill", vertices)
    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon("line", vertices)
    love.graphics.setColor(0, 0, 0)
    love.graphics.points(Hexagons.get_center(self.coords))
end

--- Represents the location of a hexagon in axial coordinates
HexCoords = Class {
    init = function(self, q, r)
        self.q = q
        self.r = r
    end
}

--- Represents a pixel on the screen
ScreenCoords = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
    end
}
