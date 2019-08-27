
local LineCollision = require "game.line_collision"

local Player = {}
function Player:new(index, x, y, direction, input)
  return setmetatable({defX=x,defY=y,index=index, lineCollision=LineCollision:new(x, y, direction, 0.4), input=input, speed=0.5, isDied = false}, {__index=self})
end

function Player:update(dt)
  if isDied then return end

  local plusDirection
  if self.input:getButton(self.index, "left") then
    plusDirection = -math.pi/2
  elseif self.input:getButton(self.index, "right") then
    plusDirection = math.pi/2
  end

  if plusDirection ~= nil then
    local x, y = LineCollision.calcPoint(dt * self.speed, self.lineCollision.direction + plusDirection, self.lineCollision.x, self.lineCollision.y)
    if inArea(LineCollision.calcPoint(self.lineCollision.length / 2, self.lineCollision.direction + plusDirection, x, y)) then self.lineCollision.x, self.lineCollision.y = x, y end
  end

  self.speed = self.speed + dt * 0.02
end

function inArea(...)
  for _, v in ipairs({ ... }) do
    if v < -1 or v > 1 then return false end
  end
  return true
end

function Player:draw()
  if self.isDied == false then
    self.lineCollision:draw(1, 1, 1)
  else
    self.lineCollision:draw(0,1,1)
  end
end

function Player:death()
  self.isDied = true

  self.lineCollision.x = self.defX
  self.lineCollision.y = self.defY
  self.lineCollision.length = 2.1
end

return Player
