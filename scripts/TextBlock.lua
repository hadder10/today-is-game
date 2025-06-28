local TextBlock = {}
TextBlock.__index = TextBlock

function TextBlock:new(x, y, width, text, align, color)
    local block = {
        x = x,
        y = y,
        width = width,
        text = text,
        align = align or "center",
        color = color or { 0, 0, 0 }
    }
    setmetatable(block, TextBlock)
    return block
end

function TextBlock:draw()
    love.graphics.setColor(unpack(self.color))
    love.graphics.printf(self.text, self.x, self.y, self.width, self.align)
    love.graphics.setColor(1, 1, 1)
end

return TextBlock
