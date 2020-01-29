ProbablyEngine.rotation.shared = {
	-- Shared spells for all rotations
}

local LibDispellable = LibStub("LibDispellable-1.0")
-- No one was supposed to use this, fucking retarded...
ProbablyEngine.library.register('coreHealing', {
  needsHealing = function(percent, count)
    return ProbablyEngine.raid.needsHealing(tonumber(percent)) >= count
  end,
  canDispell = function(spell)
    for _, unit in pairs(ProbablyEngine.raid.roster) do
      if LibDispellable:CanDispelWith(unit.unit, GetSpellID(spell)) then
        ProbablyEngine.dsl.parsedTarget = unit.unit
        return true
      end
    end
  end,
  needsDispelled = function(spell)
    for _, unit in pairs(ProbablyEngine.raid.roster) do
      if UnitDebuff(unit.unit, spell) then
        ProbablyEngine.dsl.parsedTarget = unit.unit
        return true
      end
    end
  end,
})