--local Timer = require "util.timer"

local itemCommands = {
  require "game.item.addBall",
  require "game.item.speedDown",
  require "game.item.speedUp",
  require "game.item.shrinkPlayer",
  require "game.item.extendPlayer",
}
local quads = require "game.util.quads"

local itemImage = love.graphics.newImage("assets/item.png")
local sprites = quads(itemImage, 8, 8)

local ItemData = {}
function ItemData:new(ball)
  --timer = Timer:new(3)
  --timer.time = love.math.random() * 3
  --timer.count = love.math.random(0, #itemCommands - 1)
  --print(timer.time, timer.count)
  return setmetatable(
    {
      --timer = timer,
      itemNumber = love.math.random(1, #itemCommands),
      ball = ball,
    },
    {
      __index=self,
    }
  )
end
function ItemData:changeNextRandomItem()
  local next = love.math.random(1, #itemCommands)
  while self.itemNumber == next do
    next = love.math.random(1, #itemCommands)
  end
  self.itemNumber = next
end
function ItemData:update(dt, players, playerGoals)
  --self.timer:executable(dt)
  self.ball:update(dt, players, playerGoals)
end
function ItemData:getCommand()
  --return itemCommands[(self.timer.count % #itemCommands) + 1]
  return itemCommands[((self.itemNumber - 1) % #itemCommands) + 1]
end
function ItemData:draw()
  --self.ball:drawImage(itemImage, sprites[(self.timer.count % #itemCommands) + 1])
  self.ball:drawImage(itemImage, sprites[((self.itemNumber - 1) % #itemCommands) + 1])
end
return ItemData
