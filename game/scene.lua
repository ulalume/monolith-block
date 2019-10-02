local Player = require "game.player"
local Ball = require "game.ball"
local LineCollision = require "game.line_collision"

local ItemData = require "game.item-data"

local Timer = require "util.timer"
local table2 = require "util.table2"
local playerColor = require "game.player-color"

local scene = {}
function scene:new(monolith, musicSystem, activeControllers)
  return setmetatable(
    {
      musicSystem=musicSystem,
      monolith=monolith,
      activeControllers=activeControllers,

      players={},
      playerGoals={},
      balls=nil,
      waitingBalls=nil,
      itemTimer=nil,
      items=nil,
    },

    {
      __index=self
    }
  )
end

function scene:reset()
  -- 配置
  --   2P
  -- 4P  3P
  --   1P
  self.items = {}
  self.itemTimer = Timer:new(10)
  self.balls = {Ball:new( function (...) self:onHitBall(...) end )}
  self.waitingBalls = {}
  self.players={}
  self.playerGoals={}

  local bottom, middle, top = 1, 0, -1
  local x = {middle, middle, bottom, top}
  local y = {bottom, top, middle, middle}
  local direction = {math.pi / 2 * 3, math.pi / 2, math.pi, 0}

  for index, isActive in ipairs(self.activeControllers) do
    local player = Player:new(index, x[index], y[index], direction[index], self.monolith.input)
    local goal = LineCollision:new(x[index], y[index], direction[index], 2.0)
    table.insert(self.players, player)
    table.insert(self.playerGoals, goal)
    if isActive == false then
      player:death()
    end
  end
end

function scene:onHitItem(centerX, centerY, ball, targetCollision, targetPlayer)
  local itemData
  for _, item in ipairs(self.items) do
    if item.ball == ball then
      itemData = item
      break
    end
  end

  if itemData  == nil then return end

  if targetPlayer ~= nil and not targetPlayer.isDied then
    itemData:getCommand()(self, targetPlayer)
    table2.removeItem(self.items, itemData)
    local index = table2.indexOf(self.players, targetPlayer)
    self.musicSystem:play(index, "item")
  else
    itemData:changeNextRandomItem()
  end
end

function scene:onHitBall(centerX, centerY, ball, targetCollision, targetPlayer)
  if targetPlayer == nil then
    local index = table2.indexOf(self.playerGoals, targetCollision)
    self.players[index]:death()
    self.musicSystem:play(index, "death")
    if ball.index ~= nil then
      table2.removeItem(self.balls, ball)
    end
  end
end

function scene:update(dt)
  if self.itemTimer:executable(dt) then
    table.insert(self.items, ItemData:new(Ball:new( function (...) self:onHitItem(...) end )))
  end

  local allPlayersAreDied = true
  for index, player in ipairs(self.players) do
    player:update(dt)
    allPlayersAreDied = allPlayersAreDied and player.isDied

    if self.monolith.input:getButtonDown(index, "b") then
      for _,ball in ipairs(self.waitingBalls) do
        if ball.index == index then
          table2.removeItem(self.waitingBalls, ball)
          table.insert(self.balls, ball)
          break
        end
      end
    end
  end
  if allPlayersAreDied then love.event.quit() end

  for _, ball in ipairs(self.waitingBalls) do
    ball.direction = ball.direction + dt * 3
    ball.x = math.cos(ball.direction) * 0.1
    ball.y = math.sin(ball.direction) * 0.1
  end
  for _, ball in ipairs(self.balls) do
    ball:update(dt, self.players, self.playerGoals)
  end
  for _, itemData in ipairs(self.items) do
    itemData:update(dt, self.players, self.playerGoals)
  end


end

function scene:addWaitingBall(playerIndex)
  local ball = Ball:new(function (...) self:onHitBall(...) end )
  ball.index = playerIndex
  table.insert(self.waitingBalls, ball)
end

function scene:draw()

  love.graphics.setColor(1, 1, 1)
  for index, player in ipairs(self.players) do
    if player.isDied then
      player:draw(0.5,0.5,0.5)
    else
      player:draw(unpack(playerColor[index]))
    end
  end

  for _, ball in ipairs(self.waitingBalls) do
    ball:drawColor(unpack(playerColor[ball.index]))
    love.graphics.setColor(unpack(playerColor[ball.index]))
    love.graphics.setLineWidth(1)
    love.graphics.line(64, 64, ball.x *64+ 64, ball.y*64+64)
  end

  for _, ball in ipairs(self.balls) do
    if ball.index == nil then
      ball:drawColor(1, 0, 0)
    else
      ball:drawColor(unpack(playerColor[ball.index]))
    end
  end
  for _, itemData in ipairs(self.items) do
    itemData:draw()
  end
end

return scene
