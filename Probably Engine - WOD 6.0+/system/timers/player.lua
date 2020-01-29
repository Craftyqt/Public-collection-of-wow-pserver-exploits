-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.
local behindResolution = 2
ProbablyEngine.timer.register("player", function()
  if not ProbablyEngine.module.player.behind then
    ProbablyEngine.module.player.behind = true
  end
end, 3000)