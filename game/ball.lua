local math2 = require "util.math2"
local table2 = require "util.table2"

local Ball = {}

function Ball:new(onHit)
  return setmetatable({
    x = 0, y = 0,
    speed = 0.4,
    direction = love.math.random() * math.pi * 2,

    isHitting = false,
    ignoreIndecies = {},
    ox, oy, nx, ny,
    onHit = onHit,
  }, {__index=self})
end

function hitTest(oldX, oldY, newX, newY, collisions, ignoreIndecies)
  ignoreIndecies  = ignoreIndecies or {}
  local players = {}
  for index, collision in ipairs(collisions) do
    if table2.indexOf(ignoreIndecies, index) == nil then
      local player
      if collision.reflect == nil then
        player = collision
        collision = player.lineCollision
        players[index] = player
      end
      local nx, ny, cx, cy = collision:reflect(oldX, oldY, newX, newY)

      -- 衝突検知
      if nx ~= nil then
        local hit = {
          nx=nx,
          ny=ny,
          ox=cx,
          oy=cy,
          collision=collision,
          player=player,
          index=index
        }
        local p = player or players[index - #players]
        if p ~= nil and p.isDied then
          local vx, vy = nx - cx + p.dx / 20, ny - cy + p.dy / 20
          hit.nDirection = math.atan2(vy, vx)
        else
          local vx, vy = nx - cx, ny - cy
          hit.nDirection = math.atan2(vy, vx)
        end
        return hit
      end
    end
  end
  return nil
end

--[[
function Ball:newPos(nowX, nowY, x, y, players, playerGoals, ignorePlayerIndecies)
  -- 処理しない player
  ignorePlayerIndecies = ignorePlayerIndecies or {}

  -- player との衝突判定
  for index, player in ipairs(players) do
    local doit = true
    for _,v in ipairs(ignorePlayerIndecies) do
      doit = doit and v~=index
    end
    doit = doit and self.ignorePlayerIndex~=index
    if doit then
      local rx, ry, cx, cy = player.lineCollision:reflect(nowX, nowY, x, y)

      -- 衝突検知
      if rx ~= nil then
        self.x, self.y = rx, ry
        local vx, vy = rx - cx + player.dx / 5, ry - cy + player.dy / 5
        self.direction = math.atan2(vy, vx)

        self.musicSystem:play(player.index, "jump")

        table.insert(ignorePlayerIndecies, index)
        self.ignorePlayerIndex = index

        self:newPos(cx, cy, rx, ry, players, playerGoals, ignorePlayerIndecies)
        return
      end
    end
  end


  -- player の取りこぼし衝突判定
  local goalIndex = checkGoals(playerGoals, nowX, nowY, x, y, ignorePlayerIndecies, self.ignorePlayerIndex)
  if goalIndex ~= nil then
    self:goCenter()
    self.direction = love.math.random() * math.pi * 2
    players[goalIndex]:death()
    self.musicSystem:play(players[goalIndex].index, "death")
    self.ignorePlayerIndex = nil
    return
  end
  self.ignorePlayerIndex = nil
  self.x, self.y = x, y
end
]]--

function Ball:update(dt, players, playerGoals)
  self.speed = self.speed + dt * 0.020

  local x
  local y
  local hit
  if self.isHitting then
    hit = hitTest(self.ox, self.oy, self.nx, self.ny, table2.merge({}, players, playerGoals), self.ignoreIndecies)
  else
    x = self.x + dt * math.cos(self.direction) * self.speed
    y = self.y + dt * math.sin(self.direction) * self.speed
    hit = hitTest(self.x, self.y, x, y, table2.merge({}, players, playerGoals))
  end

  if hit ~= nil then
    -- player に衝突した場合、player walls も次の衝突から除外
    table.insert(self.ignoreIndecies, hit.index)
    if hit.index <= #players then
      table.insert(self.ignoreIndecies, hit.index + #players)
    else
      table.insert(self.ignoreIndecies, hit.index - #players)
    end

    -- hitting 状態は次のフレームでは移動せず、再び衝突判定をします
    self.isHitting = true
    self.ox = hit.ox
    self.oy = hit.oy
    self.nx = hit.nx
    self.ny = hit.ny
    self.nDirection = hit.nDirection
    if self.onHit ~= nil then
      self.onHit(hit.ox, hit.oy, self, hit.collision, hit.player)
    end
  elseif self.isHitting then
    -- hitting 状態の終了処理
    self.ignoreIndecies = {}
    self.isHitting = false
    self.x = self.nx
    self.y = self.ny
    self.direction = self.nDirection
    self.ox = nil
    self.oy = nil
    self.nx = nil
    self.ny = nil
  else
    -- 通常の移動
    self.x = x
    self.y = y
  end
end

function Ball:goCenter()
  self.x, self.y = 0, 0
  self.ox = nil
  self.oy = nil
  self.nx = nil
  self.ny = nil
  self.isHitting = false
end

function checkGoals(playerGoals, x, y, nextX, nextY, ignorePlayerIndecies, ignorePlayerIndex)
  for index, goal in ipairs(playerGoals) do
    local doit = true
    for _,v in ipairs(ignorePlayerIndecies) do
      doit = doit and v~=index
    end
    doit = doit and ignorePlayerIndex~=index
    if doit then
      local cx, cy = goal:intersection(x, y, nextX, nextY)
      -- 衝突検知
      if cx ~= nil then
        return index
      end
    end
  end
  return nil
end

function Ball:drawColor(r, g, b)
  love.graphics.push()
  love.graphics.setColor(r, g, b)
  love.graphics.circle("fill", self.x * 64 + 64, self.y * 64 + 64, 2, 10)
  love.graphics.setColor(1, 1, 1)
  love.graphics.pop()
end
function Ball:drawImage(image, quad)
  love.graphics.push()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(image, quad, self.x * 64 + 64 - 4, self.y * 64 + 64 - 4)
  love.graphics.pop()
end

return Ball
