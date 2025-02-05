Class = require "hump.class"

--[[
https://www.redblobgames.com/grids/hexagons/#coordinates-axial

# Coordinate Systems:
## Axial Coordinates for the hex grid
All hexagons are flat top

## Screen/pixel coordinates for unaligned entities
]] --
Hexagons = {}
local size = 25

--- Gets the s cubic coordinate from axial coordinates
Hexagons.get_s = function(hex_coords)
    return -hex_coords.q - hex_coords.r
end

Hexagons.get_hex_coords = function(world_coords)
    local q = (2 / 3 * world_coords.x) / size
    local r = (-1 / 3 * world_coords.x + math.sqrt(3) / 3 * world_coords.y) / size
    return Hexagons.round(HexCoords(q, r))
end

Hexagons.round = function(hex_coords)
    local xgrid = math.floor(hex_coords.q + .5)
    local ygrid = math.floor(hex_coords.r + .5);
    local x = hex_coords.q - xgrid
    local y = hex_coords.r - ygrid
    if math.abs(x) >= math.abs(y) then
        return HexCoords(xgrid + math.floor((x + 0.5 * y) + .5), ygrid)
    else
        return HexCoords(xgrid, ygrid + math.floor((y + 0.5 * x) + .5))
    end
end

Hexagons.get_center = function(hex_coords)
    return WorldCoords(size * 3 / 2 * hex_coords.q, size * math.sqrt(3) * (hex_coords.r + hex_coords.q / 2))
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

--- Represents the location of a hexagon in axial coordinates
HexCoords = Class {
    init = function(self, q, r)
        self.q = q
        self.r = r
    end
}

function HexCoords:neighbors()
    return {
        HexCoords(self.q + 1, self.r),
        HexCoords(self.q + 1, self.r - 1),
        HexCoords(self.q, self.r - 1),
        HexCoords(self.q - 1, self.r),
        HexCoords(self.q - 1, self.r + 1),
        HexCoords(self.q, self.r + 1)
    }
end

function HexCoords:key()
    return self.q .. "," .. self.r
end

--- Represents a point in the game
WorldCoords = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
    end
}

--- Represents a pixel on the screen
ScreenCoords = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
    end
}
