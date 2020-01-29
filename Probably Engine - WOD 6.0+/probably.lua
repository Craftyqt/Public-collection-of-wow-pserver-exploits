-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine = {
  addonName = "Probably",
  addonReal = "Probably",
  addonColor = "EE2200",
  version = "6.1r16"
}

function ProbablyEngine.print(message)
  print('|c00'..ProbablyEngine.addonColor..'['..ProbablyEngine.addonName..']|r ' .. message)
end
