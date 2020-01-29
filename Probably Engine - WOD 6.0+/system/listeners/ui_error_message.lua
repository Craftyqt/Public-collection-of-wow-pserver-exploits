-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register("UI_ERROR_MESSAGE", function(...)
  local error = ...
  if error == SPELL_FAILED_NOT_BEHIND then
    ProbablyEngine.module.player.behind = false
    ProbablyEngine.module.player.behindTime = time()
  elseif error == SPELL_FAILED_UNIT_NOT_INFRONT then
    ProbablyEngine.module.player.infront = false
    ProbablyEngine.module.player.infrontTime = time()
  elseif error == SPELL_FAILED_TARGET_NO_RANGED_WEAPONS then
    ProbablyEngine.module.disarm.fail()
  elseif error == SPELL_FAILED_BAD_TARGETS then
    ProbablyEngine.module.disarm.fail(ProbablyEngine.parser.lastCast)
  end
end)
