
local Ball = {}

function Ball:new(musicSystem)
  return setmetatable({x=0, y=0, direction = love.math.random() * math.pi * 2, speed=0.4, musicSystem=musicSystem}, {__index=self})
end

function Ball:update(dt, players, playerGoals)
  self.speed = self.speed + dt * 0.022

  local x = self.x + dt * math.cos(self.direction) * self.speed
  local y = self.y + dt * math.sin(self.direction) * self.speed

  if x < -1.2 or x > 1.2 or y > 1.2 or y < -1.2 then
    self.x = 0
    self.y = 0
    return
  end

  -- player との衝突判定
  for _, player in ipairs(players) do
    local rx, ry, cx, cy = player.lineCollision:reflect(self.x, self.y, x, y)

    -- 衝突検知
    if rx ~= nil then

--[[
      local rx2, ry2, cx2, cy2 = player.lineCollision:reflect(cx+(rx-cy)*1, cy+(ry-cy)*1, rx, ry)
      if rx2~=nil then rx, ry, cx, cy = rx2, ry2, cx2, cy2 end
      local goalIndex = checkGoals(playerGoals, cx+(rx-cy)*0.01, cy+(ry-cy)*0.01, rx, ry)
      if goalIndex ~= nil then
        self:goCenter()
        players[goalIndex]:death()
        self.musicSystem:play(players[goalIndex].index, "death")
        return
      end
--]]

      self.x, self.y = rx, ry
      self.direction = math.atan2(ry - cy, rx - cx)
      if math.random(1, 10) < 3 then
        self.direction = self.direction + (love.math.random() -0.5) * math.pi / 10
      end

      self.musicSystem:play(player.index, "jump")
      return
    end
  end

  -- player の取りこぼし衝突判定
  local goalIndex = checkGoals(playerGoals, self.x, self.y, x, y)
  if goalIndex ~= nil then
    self:goCenter()
    players[goalIndex]:death()
    self.musicSystem:play(players[goalIndex].index, "death")
    return
  end

  self.x, self.y = x, y
end

function Ball:goCenter()
  self.x, self.y = 0, 0
  self.direction = love.math.random() * math.pi * 2
end

function checkGoals(playerGoals, x, y, nextX, nextY)
  for index, goal in ipairs(playerGoals) do
    local cx, cy = goal:intersection(x, y, nextX, nextY)
    -- 衝突検知
    if cx ~= nil then
      return index
    end
  end
  return nil
end

function Ball:draw()
  love.graphics.push()
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", self.x * 64 + 64, self.y * 64 + 64, 2, 10)
  love.graphics.pop()
end

return Ball
