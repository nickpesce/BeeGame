require "map"
Camera = require "hump.camera"

function love.load()
    camera = Camera(0, 0)
    map = Map(4)
end

function love.wheelmoved(dx, dy)
    if dy > 0 then
        camera:zoom(0.9)
    elseif dy < 0 then
        camera:zoom(1.1)
    end
end

function love.mousemoved(x, y, dx, dy)
    if love.mouse.isDown(1) then
        camera:move(-dx, -dy)
    end
end

function love.draw()
    camera:attach()

    map:draw()

    camera:detach()
end
