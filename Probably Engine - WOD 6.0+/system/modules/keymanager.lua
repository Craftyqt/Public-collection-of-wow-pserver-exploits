-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.
--[[
ProbablyEngine.keys = {
  frame = CreateFrame("Frame", "PE_CaptureKeyFrame", WorldFrame),
  states = { }
}

ProbablyEngine.keys.frame:EnableKeyboard(true)
ProbablyEngine.keys.frame:SetPropagateKeyboardInput(true)

ProbablyEngine.keys.frame:SetScript("OnKeyDown", function(self, key)
  ProbablyEngine.keys.setState(key, true)
end)

ProbablyEngine.keys.frame:SetScript("OnKeyUp", function(self, key)
  ProbablyEngine.keys.setState(key, nil)
end)

ProbablyEngine.keys.getState = function(key)
  return ProbablyEngine.keys.states[key] or false
end

ProbablyEngine.keys.setState = function(key, state)
  ProbablyEngine.keys.states[key] = state
end]]