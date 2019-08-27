local Player = require "game.player"
local Ball = require "game.ball"
local LineCollision = require "game.line_collision"

local scene = {}
function scene:new(monolith, musicSystem, activeControllers)
  return setmetatable(
    {
      musicSystem=musicSystem,
      monolith=monolith,
      activeControllers=activeControllers,

      players={},
      playerGoals={},
      ball=Ball:new(),
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

  self.ball = Ball:new(self.musicSystem)
  self.players={}
  self.playerGoals={}

  local bottom, middle, top = 1, 0, -1
  local x = {middle, middle, bottom, top}
  local y = {bottom, top, middle, middle}
  local direction = {math.pi / 2 * 3, math.pi / 2, math.pi, 0}

  for index, isActive in ipairs(self.activeControllers) do
    local player = Player:new(index, x[index], y[index], direction[index], self.monolith.input)
    local goal = LineCollision:new(x[index], y[index], direction[index], 2.0 + 0.2)
    table.insert(self.players, player)
    table.insert(self.playerGoals, goal)

    if isActive == false then
      player:death()
    end
  end
end

function scene:update(dt)
  local allPlayersAreDied = true
  for _, player in ipairs(self.players) do
    player:update(dt)
    allPlayersAreDied = allPlayersAreDied and player.isDied
  end

  self.ball:update(dt, self.players, self.playerGoals)

  if allPlayersAreDied then love.event.quit() end

end

function scene:draw()
  love.graphics.setColor(1, 1, 1)
  for _, player in ipairs(self.players) do
    player:draw()
  end
  self.ball:draw()
end

return scene
