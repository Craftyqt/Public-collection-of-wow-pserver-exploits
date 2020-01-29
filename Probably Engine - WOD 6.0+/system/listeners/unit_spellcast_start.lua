-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local function castStart(unitID)
  if unitID == 'player' then
    if ProbablyEngine.module.queue.spellQueue == name then
      ProbablyEngine.module.queue.spellQueue = nil
    end
    ProbablyEngine.module.player.casting = true
    ProbablyEngine.parser.lastCast = UnitCastingInfo('player')
    ProbablyEngine.dataBroker.previous_spell.text = ProbablyEngine.parser.lastCast
  elseif unitID == 'pet' then
    ProbablyEngine.module.pet.casting = true
  end
end

ProbablyEngine.listener.register('UNIT_SPELLCAST_START', castStart)
