
local LineCollision = require "game.line_collision"
local math2 = require "util.math2"

local Player = {}
function Player:new(index, x, y, direction, input)
  return setmetatable({
    dx=0,dy=0,
    defaultX=x, defaultY=y,
    index=index,
    lineCollision=LineCollision:new(x, y, direction, 0.4),
    input=input,
    speed=0.9,
    isDied = false
  }, {__index=self})
end

function Player:update(dt)

  local plusDirection

  local d = dt * self.speed
  if self.input:getButton(self.index, "left") then
    plusDirection = -math.pi / 2
  elseif self.input:getButton(self.index, "right") then
    plusDirection = math.pi / 2
  end

  if self.input:getButton(self.index, "a") then d = d * 3 end

  if plusDirection ~= nil then
    local x, y = LineCollision.calcPoint(d, self.lineCollision.direction + plusDirection, self.lineCollision.x, self.lineCollision.y)
      self.dx, self.dy = x - self.lineCollision.x, y - self.lineCollision.y
    if not self.isDied then
      local endX, endY = LineCollision.calcPoint(self.lineCollision.length / 2, self.lineCollision.direction + plusDirection, x, y)
      local inAreaEndX, inAreaEndY = inArea(endX, endY)
      local newX, newY = x - (endX - inAreaEndX), y - (endY - inAreaEndY)
      --self.dx, self.dy = newX - self.lineCollision.x, newY - self.lineCollision.y
      self.lineCollision.x, self.lineCollision.y = newX, newY
    --else
    end
  else
    self.dx, self.dy = 0, 0
  end
  --self.speed = self.speed + dt * 0.008
end

function inArea(x, y)
  x = math2.clamp(x, -1.0, 1.0)
  y = math2.clamp(y, -1.0, 1.0)
  return x, y
end

function Player:draw(r, g, b)
  self.lineCollision:draw(r, g, b)
end

function Player:death()
  self.isDied = true

  self.lineCollision.x = self.defaultX
  self.lineCollision.y = self.defaultY
  self.lineCollision.length = 2
end

return Player
