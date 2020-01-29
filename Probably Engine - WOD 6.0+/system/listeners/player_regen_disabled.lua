-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register("PLAYER_REGEN_DISABLED", function(...)
  ProbablyEngine.module.player.combat = true
  ProbablyEngine.module.player.combatTime = GetTime()
end)
