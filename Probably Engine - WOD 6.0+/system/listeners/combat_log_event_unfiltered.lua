-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.


local HostileEvents = {
        ['SWING_DAMAGE'] = true,
        ['SWING_MISSED'] = true,
        ['RANGE_DAMAGE'] = true,
        ['RANGE_MISSED'] = true,
        ['SPELL_DAMAGE'] = true,
        ['SPELL_PERIODIC_DAMAGE'] = true,
        ['SPELL_MISSED'] = true
}

local playerGUID = false

ProbablyEngine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)

	if not playerGUID then
		local guid = UnitGUID("player")
		if guid then playerGUID = guid end
	end

	local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...

	if sourceGUID == playerGUID then
		ProbablyEngine.module.tracker.handleEvent(...)
	end

end)

ProbablyEngine.listener.register("UPDATE_MOUSEOVER_UNIT", function(...)

end)
