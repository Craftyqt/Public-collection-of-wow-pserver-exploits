-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local UnitClass = UnitClass
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS
local L = ProbablyEngine.locale.get

local player = {
  castCache = {},
  behind = false,
  behindTime = 0,
  infront = true,
  infrontTime = 0,
  moving = false,
  movingTime = 0
}

function player.updateSpec()
  local spec = GetSpecialization()
  local name, classFileName, classID = UnitClass('player')
  local color = RAID_CLASS_COLORS[classFileName]
  local specID, specName, _, specIcon = player.classID
  if spec then
    specID, specName, _, specIcon = GetSpecializationInfo(spec)
  end

  if specID ~= player.specID then
    if specIcon then
      ProbablyEngine.buttons.icon('MasterToggle', specIcon)
    else
      ProbablyEngine.buttons.icon('MasterToggle', 'Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES')
      local coords = CLASS_ICON_TCOORDS[player.classFileName]
      ProbablyEngine.buttons.buttons.MasterToggle.icon:SetTexCoord(unpack(coords))
    end

    ProbablyEngine.rotation.activeRotation = ProbablyEngine.rotation.rotations[specID]
    if ProbablyEngine.rotation.oocrotations[specID] then
      ProbablyEngine.rotation.activeOOCRotation = ProbablyEngine.rotation.oocrotations[specID]
    else
      ProbablyEngine.rotation.activeOOCRotation = false
    end
    ProbablyEngine.buttons.resetButtons()
    if ProbablyEngine.rotation.buttons[specID] then
      ProbablyEngine.rotation.add_buttons()
    end
    player.specID = specID
    player.specName = specName and specName or player.className

    ProbablyEngine.print('|c' .. color.colorStr .. player.specName .. ' ' .. name .. '|r ' .. L('rotation_loaded'))
    ProbablyEngine.rotation.loadLastRotation()
  end
end

function player.init()
  local name, classFileName, classID = UnitClass('player')
  player.classID = classID
  player.className = name
  player.classFileName = classFileName
  player.updateSpec()
end

local nextCastIndex = 1
function player.cast(spell)
  player.castCache[nextCastIndex] = spell
  nextCastIndex = nextCastIndex % 10 + 1
end

function player.casted(query)
  local count = 0

  for i = 1, 10 do
    if query == player.castCache[i] then
      count = count + 1
    end
  end

  return count
end

ProbablyEngine.module.register("player", player)
