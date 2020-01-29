-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register("ADDON_ACTION_FORBIDDEN", function(...)
  -- We can attempt to hide these without totally raping the UI
  local addon, event = ...
  if addon == ProbablyEngine.addonName or addon == string.lower(ProbablyEngine.addonName) then
    StaticPopup1:Hide()
    ProbablyEngine.full = false
    ProbablyEngine.debug.print("Event Forbidden: " .. event, 'action_block')
  end
end)
