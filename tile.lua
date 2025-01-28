Tile = Class {
    init = function(self, hex_coords)
        self.coords = hex_coords
        self.entity = nil
    end
}

function Tile:draw()
    local vertices = Hexagons.get_vertices(self.coords)
    love.graphics.setColor(0.1, 1, 0.1)
    love.graphics.polygon("fill", vertices)
    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon("line", vertices)
    love.graphics.setColor(0, 0, 0)
    local center = Hexagons.get_center(self.coords)
    love.graphics.points(center.x, center.y)
    --love.graphics.print(self.coords.q .. ", " .. self.coords.r, center.x - 20, center.y)
    if self.entity then
        love.graphics.push()
        love.graphics.translate(center.x, center.y)
        self.entity:draw()
        love.graphics.pop()
    end
end

function Tile:update(dt)
    if self.entity then
        self.entity:update(dt)
    end
end