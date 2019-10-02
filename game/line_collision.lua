local math2 = require "util.math2"

local LineCollision = {}

function LineCollision:new(x, y, direction, length)
  return setmetatable({x=x, y=y, direction=direction, length=length}, {__index=self})
end
function LineCollision:getLeft()
  return LineCollision.calcPoint(self.length / 2, self.direction - math.pi / 2, self.x, self.y)
end
function LineCollision:getRight()
  return LineCollision.calcPoint(self.length / 2, self.direction + math.pi / 2, self.x, self.y)
end

function LineCollision:reflect(x0, y0, x1, y1)
  local px1, py1 = self:getLeft()
  local px2, py2 = self:getRight()
  return math2.reflectPoint(px1, py1, px2, py2, x0, y0, x1, y1)
end
function LineCollision:intersection(x0, y0, x1, y1)
  local px1, py1 = self:getLeft()
  local px2, py2 = self:getRight()
  return math2.intersectionTwoLineSegments(px1, py1, px2, py2, x0, y0, x1, y1)
end

function LineCollision:draw(r, g, b, lineWidth)
  lineWidth = lineWidth or 2
  love.graphics.push()
  love.graphics.setColor(r, g, b)
  love.graphics.setLineWidth(lineWidth)

  local x1, y1 = self:getLeft()
  local x2, y2 = self:getRight()
  love.graphics.line(x1 * 64 + 64, y1 * 64 + 64, x2 * 64 + 64, y2 * 64 + 64)
  love.graphics.pop()
end

function LineCollision.calcPoint(length, direction, x, y)
  x, y = x or 0, y or 0
  direction = direction or 0
  return x + math.cos(direction) * length, y + math.sin(direction) * length
end

return LineCollision
