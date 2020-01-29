-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local L = ProbablyEngine.locale.get
local icon = LibStub("LibDBIcon-1.0")


ProbablyEngine.interface.minimap = { }

function ProbablyEngine.interface.minimap.create()
  if not ProbablyEngine_ConfigData.minimap then
    ProbablyEngine_ConfigData.minimap = {
      hide = false,
    }
  end
  icon:Register("ProbablyEngine", ProbablyEngine.dataBroker.icon, ProbablyEngine_ConfigData.minimap)
end