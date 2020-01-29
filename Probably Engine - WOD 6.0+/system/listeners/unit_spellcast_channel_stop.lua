-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local function channelStop(unitID)
  if unitID == 'player' then
    ProbablyEngine.module.player.casting = false
  elseif unitID == 'pet' then
    ProbablyEngine.module.pet.casting = false
  end
end

ProbablyEngine.listener.register('UNIT_SPELLCAST_CHANNEL_STOP', channelStop)
