return function (scene, player)
  player.lineCollision.length = math.max(0.1, player.lineCollision.length - 0.1)
end
