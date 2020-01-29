-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register("ADDON_ACTION_BLOCKED", function(...)
  -- We can attempt to hide these without totally raping the UI
  local addon, event = ...
  if addon == ProbablyEngine.addonReal then
    StaticPopup1:Hide()
    ProbablyEngine.full = false
    ProbablyEngine.debug.print("Event Blocked: " .. event, 'action_block')
  end
end)
