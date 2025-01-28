require "hump.class"
require "inventory"
require "hexagon"

Player = Class {
    init = function(self)
        self.location = WorldCoords(0, 0)
        self.inventory = Inventory()
        self.money = 100
    end
}

function Player:update(dt)
    local vx = 0
    local vy = 0
    if love.keyboard.isDown("w") then
        vy = vy - 1
    end
    if love.keyboard.isDown("s") then
        vy = vy +1
    end
    if love.keyboard.isDown("a") then
        vx = vx - 1
    end
    if love.keyboard.isDown("d") then
       vx = vx + 1
    end

    if vx ~= 0 and vy ~= 0 then
        vx = vx * 0.7071
        vy = vy * 0.7071
    end

    self.location = WorldCoords(self.location.x + vx, self.location.y + vy)
end

function Player:draw()
    love.graphics.setColor(0, 0, 1)
    love.graphics.circle("fill", self.location.x, self.location.y, 10)
end
