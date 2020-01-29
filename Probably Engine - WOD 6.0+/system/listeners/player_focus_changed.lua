-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register("PLAYER_FOCUS_CHANGED", function(...)
  ProbablyEngine.module.player.focus = Unit
end)

ProbablyEngine.listener.register("PLAYER_TARGET_CHANGED", function(...)
  if ProbablyEngine.faceroll.rolling then
  	ProbablyEngine.faceroll.activeFrame:Hide()
  end
end)
