-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register("PLAYER_LOGIN", function(...)
  ProbablyEngine.print('Initializing!')
  ProbablyEngine.rotation.auto_unregister()
  ProbablyEngine.listener.trigger("PLAYER_SPECIALIZATION_CHANGED", "player")
  ProbablyEngine.listener.trigger("ACTIONBAR_SLOT_CHANGED", "player")
  ProbablyEngine.interface.init()
  ProbablyEngine.module.player.init()
  ProbablyEngine.raid.build()
end)
