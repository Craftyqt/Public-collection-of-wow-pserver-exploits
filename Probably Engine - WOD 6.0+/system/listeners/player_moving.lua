-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register("PLAYER_STARTED_MOVING", function(...)
	ProbablyEngine.module.player.moving = true
	ProbablyEngine.module.player.movingTime = GetTime()
end)

ProbablyEngine.listener.register("PLAYER_STOPPED_MOVING", function(...)
	ProbablyEngine.module.player.moving = false
	ProbablyEngine.module.player.movingTime = GetTime()
end)
