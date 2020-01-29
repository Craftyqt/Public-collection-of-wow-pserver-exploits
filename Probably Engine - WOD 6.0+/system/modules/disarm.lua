-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local time = time
local UnitGUID = UnitGUID
local module = ProbablyEngine.module
local timer = ProbablyEngine.timer

local disarm = {}
local spells = {
  676, -- Disarm, Warrior
  50541, -- Clench, Hunter Scorpid
  51722, -- Dismantle, Rogue
  64058, -- Psychic Horror, Priest
  91644, -- Snatch, Hunter Bird of Prey
  117368, -- Grapple Weapon, Monk
  118093, -- Disarm, Warlock, Voidreaver / Voidlord
  137461, -- Ring of Peace, Disarmed, Monk
  140023 -- Ring of Peace, Monk
}
local lastTarget
local blacklist = {}
function disarm.fail(spell)
  if not lastTarget then
    return false
  end

  if spell then
    local spellID = GetSpellID(spell)
    local found = false
    for i = 1, #spells do
      if spellID == spells[i] then
        found = true
      end
    end
    if not found then return false end
  end

  local guid = UnitGUID(lastTarget)
  if guid then
    blacklist[guid] = time()
  end
end

function disarm.check(target)
  local guid = UnitGUID(target)
  if blacklist[guid] then
    return false
  else
    for i = 1, #spells do
      if UnitDebuff(target, spells[i]) then
        return false
      end
    end

    lastTarget = target
    return true
  end
end

module.register('disarm', disarm)

function clearDisarms()
  for k, v in pairs(blacklist) do
    if time() - v > 8 then
      blacklist[k] = nil
    end
  end
end

timer.register('clearDisarms', clearDisarms, 1000)
