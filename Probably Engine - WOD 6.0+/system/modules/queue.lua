-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local GetActionInfo = GetActionInfo
local GetSpellCooldown = GetSpellCooldown
local GetSpellInfo = GetSpellInfo
local IsUsableSpell = IsUsableSpell
local hooksecurefunc = hooksecurefunc

local config = ProbablyEngine.config
local player = ProbablyEngine.module.player

local queue = {
  spellQueue = nil,
  macroQueue = nil
}
ProbablyEngine.module.register('queue', queue)

function queue.addSpell(spellName)
  if spellName and queue.spellQueue ~= spellName then
    queue.spellQueue = spellName
    ProbablyEngine.debug.print(spellName .. ' was queued for casting.', 'queue')
  end
end

function queue.addMacro(macroID)
  if queue.macroQueue ~= macroID then
    queue.macroQueue = macroID
    ProbablyEngine.debug.print('Macro ID ' .. macroID .. ' was queued for casting.', 'queue')
  end
end

local function useAction(slot, target, button)
  if not player.combat
     or not config.read('button_states', 'MasterToggle', false)
     or not button then
    return false
  end

  local actionType, actionID = GetActionInfo(slot)
  if actionType == 'spell' then
    local spell = GetSpellName(actionID)
    local isUsable, notEnoughMana = IsUsableSpell(spell)
    if not isUsable or notEnoughMana or select(2, GetSpellCooldown(spell)) - select(2, GetSpellCooldown(61304)) > 0 then
      return false
    end

    queue.addSpell(spell)
  end
end
hooksecurefunc('UseAction', useAction)
