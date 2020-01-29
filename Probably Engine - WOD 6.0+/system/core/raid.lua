-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.raid = {
  roster = {}
}

local max = math.max
local GetSpellInfo = GetSpellInfo
local GetNumGroupMembers = GetNumGroupMembers
local IsInRaid = IsInRaid
local UnitCanAssist = UnitCanAssist
local UnitDebuff = UnitDebuff
local UnitExists = UnitExists
local UnitGetIncomingHeals = UnitGetIncomingHeals
local UnitGetTotalHealAbsorbs = UnitGetTotalHealAbsorbs
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitInParty = UnitInParty
local UnitInRange = UnitInRange
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsFriend = UnitIsFriend
local UnitUsingVehicle = UnitUsingVehicle

local function canHeal(unit, ignoreRange)
  if UnitExists(unit)
     and UnitCanAssist('player', unit)
     and UnitIsFriend('player', unit)
     and UnitIsConnected(unit)
     and not UnitIsDeadOrGhost(unit)
     and not UnitUsingVehicle(unit) then

     if not ignoreRange and UnitInParty(unit) and not UnitInRange(unit) then
       return false
     end

     return true
  end

  return false
end

local function getGroupMembers()
  local start, groupMembers = 0, GetNumGroupMembers()

  if IsInRaid() then
    start = 1
  elseif groupMembers > 0 then
    groupMembers = groupMembers - 1
  end

  return start, groupMembers
end

local ancientBarrierDebuffs = { GetSpellInfo(142861), GetSpellInfo(142863), GetSpellInfo(142864), GetSpellInfo(142865) }
local function ancientBarrier(unit)
  if not UnitDebuff(unit, ancientBarrierDebuffs[1]) then
    return false
  end

	local amount
	for i = 2, 4 do
		amount = select(15, UnitDebuff(unit, ancientBarrierDebuffs[i]))
		if amount then
      return amount
		end
	end

	return false
end

local function updateHealth(index)
  if not ProbablyEngine.raid.roster[index] then
    return
  end

  local unit = ProbablyEngine.raid.roster[index].unit

  local incomingHeals = UnitGetIncomingHeals(unit) or 0
  local absorbs = UnitGetTotalHealAbsorbs(unit) or 0

  local health = UnitHealth(unit) + incomingHeals - absorbs
  local maxHealth = UnitHealthMax(unit)

  local ancientBarrierShield = ancientBarrier(unit)
  if ancientBarrierShield then
    health = ancientBarrierShield
  end

  ProbablyEngine.raid.roster[index].health = health / maxHealth * 100
  ProbablyEngine.raid.roster[index].healthMissing = max(0, maxHealth - health)
  ProbablyEngine.raid.roster[index].maxHealth = maxHealth
end

local unitLookup = {}
ProbablyEngine.raid.updateHealth = function (unit)
  if type(unit) == 'number' then
    return updateHealth(unit)
  end

  return updateHealth(unitLookup[unit])
end

ProbablyEngine.raid.build = function ()
  local _, groupMembers = getGroupMembers()
  local rosterLength = #ProbablyEngine.raid.roster
  local prefix = (IsInRaid() and 'raid') or 'party'

  local i, unit
  for i = -2, groupMembers do
    unit = (i == -2 and 'focus') or (i == -1 and 'target') or (i == 0 and 'player') or prefix .. i

    if not ProbablyEngine.raid.roster[i] then ProbablyEngine.raid.roster[i] = {} end
    if not unitLookup[unit] then unitLookup[unit] = i end

    ProbablyEngine.raid.roster[i].unit = unit
    if UnitExists(unit) and not UnitIsDeadOrGhost(unit) and UnitIsConnected(unit) then
      ProbablyEngine.raid.roster[i].class = select(3, UnitClass(unit))
      ProbablyEngine.raid.roster[i].role = UnitGroupRolesAssigned(unit)
      updateHealth(i)
    end
  end

  if groupMembers > rosterLength then
    return
  end

  for i = groupMembers + 1, rosterLength do
    ProbablyEngine.raid.roster[i] = nil
  end
end

ProbablyEngine.raid.lowestHP = function ()
  local lowestUnit = 'player'
  if canHeal('focus') then lowestUnit = 'focus' end

  local lowest = 100

  for _, unit in pairs(ProbablyEngine.raid.roster) do
    if canHeal(unit.unit) and unit.health and unit.health < lowest then
      lowest = unit.health
      lowestUnit = unit.unit
    end
  end

  return lowestUnit
end

ProbablyEngine.raid.raidPercent = function ()
  local start, groupMembers = getGroupMembers()
  local rosterLength = #ProbablyEngine.raid.roster

  if groupMembers == 0 then
    return ProbablyEngine.raid.roster[0].health
  end

  local total = 0
  local groupCount = 0

  local unit
  for i = start, groupMembers do
    unit = ProbablyEngine.raid.roster[i]
    if unit and unit.health then
      total = total + ProbablyEngine.raid.roster[i].health
      groupCount = groupCount + 1
    end
  end

  return total / groupCount
end

ProbablyEngine.raid.needsHealing = function (threshold)
  if not threshold then threshold = 80 end

  local start, groupMembers = getGroupMembers()
  local needsHealing = 0
  local unit
  for i = start, groupMembers do
    unit = ProbablyEngine.raid.roster[i]
    if canHeal(unit.unit) and unit.health and unit.health <= threshold then
      needsHealing = needsHealing + 1
    end
  end

  return needsHealing
end

-- Focus with Tank Role > Another Tank > Tank Role > Focus > Highest Health > Player
ProbablyEngine.raid.tank = function ()
  if canHeal('focus', true) and UnitGroupRolesAssigned('focus') == 'TANK' then
    return 'focus', 'focustank'
  end

  local tanks = {}
  local highestUnit
  local highest = 0
  local playerTank = GetNumGroupMembers() > 0 and UnitGroupRolesAssigned('player') == 'TANK'

  for _, unit in pairs(ProbablyEngine.raid.roster) do
    if unit.role == 'TANK' and canHeal(unit.unit, true) then
      if not playerTank or not UnitIsUnit('player', unit.unit) then
        tanks[#tanks+1] = { unit.unit, unit.health }
      end
    elseif canHeal(unit.unit) and unit.maxHealth and unit.maxHealth > highest then
      highest = unit.maxHealth
      highestUnit = unit.unit
    end
  end

  if #tanks > 0 then
    local lowest
    for _, tank in ipairs(tanks) do
      if canHeal(tank[1]) and tank[2] and UnitInRange(tank[1]) then
        if not lowest or tank[2] < lowest[2] then lowest = tank end
      end
    end

    if lowest then
      return lowest[1], 'tank'
    else
      return tanks[1][1], 'tank'
    end
  end

  if GetNumGroupMembers() > 0 then
    if canHeal('focus') then
      return 'focus', 'focus'
    else
      return highestUnit, 'highest'
    end
  end

  return 'player', 'player'
end

ProbablyEngine.raid.check = function (fn)
  local count = 0

  local start, groupMembers = getGroupMembers()
  local unit
  for i = start, groupMembers do
    if fn(ProbablyEngine.raid.roster[i]) then
      ProbablyEngine.dsl.parsedTarget = ProbablyEngine.raid.roster[i].unit
      count = count + 1
    end
  end

  return count
end
