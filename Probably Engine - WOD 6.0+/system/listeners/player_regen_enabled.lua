-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register("PLAYER_REGEN_ENABLED", function(...)
  ProbablyEngine.module.player.combat = false
  ProbablyEngine.module.player.castCache = {}
end)
