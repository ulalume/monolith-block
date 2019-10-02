return function (scene, player)
  player.lineCollision.length = math.min(1.5, player.lineCollision.length + 0.1)
end
