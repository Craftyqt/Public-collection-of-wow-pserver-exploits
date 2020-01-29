-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local function castSent(unitID, spell)
  if unitID == 'player' then
    ProbablyEngine.parser.lastCast = spell
    ProbablyEngine.dataBroker.previous_spell.text = ProbablyEngine.parser.lastCast
    if ProbablyEngine.module.queue.spellQueue == spell then
      ProbablyEngine.module.queue.spellQueue = nil
    end
  end
end

ProbablyEngine.listener.register('UNIT_SPELLCAST_SENT', castSent)
