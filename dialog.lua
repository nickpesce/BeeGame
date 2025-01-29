require "hump.class"
require "hexagon"

local HEADER_HEIGHT = 15
Dialog = Class {
    init = function(self, name, content_map)
        self.name = name
        self.height = HEADER_HEIGHT
        self.width = 100
        self.is_open = false
        --todo map offset to content and use for drawing and mouse clicks
        self.content_map = content_map
        self.location = ScreenCoords(0, 0)
        GAME.dialogs[name] = self
    end
}

function Dialog:toggle()
    if self.is_open then
        self:close()
    else
        self:open()
    end
end

function Dialog:open()
    self.is_open = true
end

function Dialog:close()
    self.is_open = false
end

function Dialog:update(dt)
    if love.mouse.isDown(1) then
        local dialog_rel_x = love.mouse.getX() - self.location.x
        local dialog_rel_y = love.mouse.getY() - self.location.y
        if dialog_rel_x > 0 and dialog_rel_x < 10 and dialog_rel_y > 0 and dialog_rel_y < HEADER_HEIGHT then
            self:close()
        else
            for offset_coords, content in pairs(self.content_map) do
                local content_rel_x = dialog_rel_x - offset_coords.x
                local content_rel_y = dialog_rel_y - offset_coords.y - HEADER_HEIGHT
                if content_rel_x > 0 and content_rel_x < content:get_width() and content_rel_y > 0 and content_rel_y < content:get_height() then
                    content:click(content_rel_x, content_rel_y)
                end
            end
        end
    end


    self:update_content_size()
end

function Dialog:update_content_size()
    for offset_coords, content in pairs(self.content_map) do
        self.height = math.max(self.height, HEADER_HEIGHT + offset_coords.y + content:get_height())
        self.width = math.max(self.width, offset_coords.x + content:get_width())
    end
    self.location = ScreenCoords(love.graphics.getWidth() / 2 - self.width / 2,
        love.graphics.getHeight() / 2 - self.height / 2)
end

function Dialog:draw()
    if not self.is_open then
        return
    end
    love.graphics.push()
    love.graphics.translate(self.location.x, self.location.y)

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, self.width, HEADER_HEIGHT)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("X", 0, 0)
    love.graphics.print(self.name, 20, 0)
    love.graphics.translate(0, HEADER_HEIGHT)
    for offset_coords, content in pairs(self.content_map) do
        love.graphics.push()
        love.graphics.translate(offset_coords.x, offset_coords.y)

        content:draw()

        love.graphics.pop()
    end

    love.graphics.pop()
end
