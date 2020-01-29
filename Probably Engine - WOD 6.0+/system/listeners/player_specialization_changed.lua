-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

-- This shit fires all the time... wtf blizz, don't be stupid.
ProbablyEngine.listener.register("PLAYER_SPECIALIZATION_CHANGED", function(unitID)
  if unitID ~= 'player' then return end

  ProbablyEngine.module.player.updateSpec()
end)
