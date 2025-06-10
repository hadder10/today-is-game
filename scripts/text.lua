TextBlock = {}
TextBlock.__index = TextBlock

function TextBlock:new(x, y, width, text, align, color)
    local obj = setmetatable({}, self)
    obj.x = x or 0
    obj.y = y or 0
    obj.width = width or 400
    obj.text = text or ""
    obj.align = align or "left"
    obj.color = color or { 1, 1, 1 }
    return obj
end

function TextBlock:draw()
    love.graphics.setColor(self.color)
    love.graphics.printf(self.text, self.x, self.y, self.width, self.align)
    love.graphics.setColor(1, 1, 1)
end

function TextBlock:setText(newText)
    self.text = newText
end

function TextBlock:setColor(r, g, b)
    self.color = { r, g, b }
end
