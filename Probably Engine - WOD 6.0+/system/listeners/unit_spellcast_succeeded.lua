-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local GetSpellInfo = GetSpellInfo

local ignoreSpells = { 75 }

ProbablyEngine.listener.register("UNIT_SPELLCAST_SUCCEEDED", function(...)
  local unitID, spell, rank, lineID, spellID = ...
  if unitID == "player" then
    local name, _, icon, _, _, _, _, _, _ = GetSpellInfo(spell)
    if ProbablyEngine.module.queue.spellQueue == name then
      ProbablyEngine.module.queue.spellQueue = nil
    end
    ProbablyEngine.actionLog.insert('Spell Cast Succeed', name, icon)
    ProbablyEngine.module.player.cast(spell)
    ProbablyEngine.module.player.infront = true
  end
end)

ProbablyEngine.listener.register("visualCast", "UNIT_SPELLCAST_SUCCEEDED", function(...)
  local activeFrame = ProbablyEngine.faceroll.activeFrame
  local unitID, spell, rank, lineID, spellID = ...
  if unitID == "player" then
    if spell == ProbablyEngine.current_spell then
      activeFrame:Hide()
      ProbablyEngine.current_spell = false
    end
  end
end)