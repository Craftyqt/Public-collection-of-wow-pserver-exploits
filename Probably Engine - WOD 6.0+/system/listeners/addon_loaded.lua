-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local L = ProbablyEngine.locale.get

ProbablyEngine.listener.register("ADDON_LOADED", function(...)

  local addon = ...

  if string.lower(addon) ~= string.lower(ProbablyEngine.addonReal) then return end

  -- load all our config data
  ProbablyEngine.config.load(ProbablyEngine_ConfigData)

  -- load our previous button states
  ProbablyEngine.buttons.loadStates()

  -- Turbo
  ProbablyEngine.config.read('pe_turbo', false)

  -- Dynamic Cycle
  ProbablyEngine.config.read('pe_dynamic', false)

end)
