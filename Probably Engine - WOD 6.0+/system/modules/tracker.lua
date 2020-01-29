-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.module.register("tracker", {
	units = { }
})


--local DiesalGUI = LibStub("DiesalGUI-1.0")
--local explore = DiesalGUI:Create('TableExplorer')
--explore:SetTable("Aura Tracker", ProbablyEngine.module.tracker.units, 5)


local tracker = ProbablyEngine.module.tracker

function tracker.add(guid, name, spellId, time)
	if not tracker.units[guid] then
		tracker.units[guid] = {
			guid = guid,
			name = name,
			auras = { }
		}
	end
	local unit = tracker.units[guid]
	if not unit.auras[spellId] then
		unit.auras[spellId] = {
			name = GetSpellName(spellId),
			id = spellId,
			stack = 0,
			time = time
		}
		if explore then explore:BuildTree() end
	end
end

function tracker.remove(guid, spellId)
	if tracker.units[guid] then
		local unit = tracker.units[guid]
		if unit.auras[spellId] then
			unit.auras[spellId] = nil
			if explore then explore:BuildTree() end
		end
	end
end

function tracker.update(type, guid, spellId, amount, crit)
	if tracker.units[guid] then
		local unit = tracker.units[guid]
		if unit.auras[spellId] then
			if not unit.auras[spellId][type] then
				unit.auras[spellId][type] = {
					total = 0,
					avg = 0,
					count = 0,
					last = 0,
					low = 0,
					high = 0,
					crit = false,
					crits = 0,
				}
			end
			local track = unit.auras[spellId][type]
			track.last = amount
			track.total = track.total + amount
			track.count = track.count + 1
			track.avg = track.total / track.count
			if amount > track.high then
				track.high = amount
				if track.low == 0 then
					track.low = amount
				end
			end
			if amount < track.low then
				track.low = amount
			end
			if crit then
				track.crits = track.crits + 1
				track.crit = true
			else
				track.crit = false
			end
			if explore then explore:BuildTree() end
		end
	end
end

function tracker.stack(guid, spellId, amount)
	if tracker.units[guid] then
		local unit = tracker.units[guid]
		if unit.auras[spellId] then
			unit.auras[spellId].stacks = amount
			if explore then explore:BuildTree() end
		end
	end
end

function tracker.query(guid, nameOrId)
	if tracker.units[guid] then
		local unit = tracker.units[guid]
		if unit.auras[spellId] then
			return unit.auras[spellId]
		end
	end
	return false
end

function tracker.handleEvent(...)

	local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags,
	      sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...

	local myself = sourceGUID == destGUID

	-- add aura
	if event == "SPELL_AURA_APPLIED" or event == "SPELL_PERIODIC_AURA_APPLIED" then
		local spellId, spellName, spellSchool = select(12, ...)
		local auraType, amount = select(15, ...)
		tracker.add(destGUID, destName, spellId, timeStamp)

	-- remove aura 
	elseif event == "SPELL_AURA_REMOVED" or event == "SPELL_PERIODIC_AURA_REMOVED" then
		local spellId, spellName, spellSchool = select(12, ...)
		local auraType, amount = select(15, ...)
		tracker.remove(destGUID, spellId, timeStamp)

	elseif event == "SPELL_AURA_APPLIED_DOSE" or event == "SPELL_PERIODIC_AURA_APPLIED_DOSE"
		or event == "SPELL_AURA_REMOVED_DOSE" or event == "SPELL_PERIODIC_AURA_REMOVED_DOSE"  then
		local spellId, spellName, spellSchool = select(12, ...)
		local auraType, amount = select(15, ...)
		tracker.stack(destGUID, spellId, amount)

	-- aura damage
	elseif event == "SPELL_PERIODIC_DAMAGE" then
		local spellId, spellName, spellSchool = select(12, ...)
		local amount, overkill, school, resisted, blocked, absorbed, critical = select(15, ...)
		tracker.update('damage', destGUID, spellId, amount, critical)

	elseif event == "SPELL_PERIODIC_HEAL" then
		local spellId, spellName, spellSchool = select(12, ...)
		local amount, overkill, school, resisted, blocked, absorbed, critical = select(15, ...)
		tracker.update('heal', destGUID, spellId, amount, critical)

	end

end
