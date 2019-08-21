
local Ball = {}

function Ball:new(musicSystem)
  return setmetatable({x=0, y=0, direction = love.math.random() * math.pi * 2, speed=0.4, musicSystem=musicSystem}, {__index=self})
end

function Ball:update(dt, players, playerGoals)
  self.speed = self.speed + dt * 0.022

  local x = self.x + dt * math.cos(self.direction) * self.speed
  local y = self.y + dt * math.sin(self.direction) * self.speed

  -- player との衝突判定
  for _, player in ipairs(players) do
    local rx, ry, cx, cy = player.lineCollision:reflect(self.x, self.y, x, y)

    -- 衝突検知
    if rx ~= nil then
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
  for index, goal in ipairs(playerGoals) do
    local cx, cy = goal:intersection(self.x, self.y, x, y)

    -- 衝突検知
    if cx ~= nil then
      self.x, self.y = 0, 0
      self.direction = love.math.random() * math.pi * 2

      self.musicSystem:play(players[index].index, "death")
      players[index]:death()
      return
    end
  end

  self.x, self.y = x, y
end

function Ball:draw()
  love.graphics.push()
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", self.x * 64 + 64, self.y * 64 + 64, 2, 10)
  love.graphics.pop()
end

return Ball
