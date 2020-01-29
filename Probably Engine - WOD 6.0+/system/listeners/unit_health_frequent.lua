-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register("UNIT_HEALTH_FREQUENT", function(unitID)
  ProbablyEngine.raid.updateHealth(unitID)
end)
