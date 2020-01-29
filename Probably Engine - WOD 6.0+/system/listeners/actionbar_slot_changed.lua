-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register('ACTIONBAR_SLOT_CHANGED', function ()
	table.empty(ProbablyEngine.faceroll.buttonMap)
	local bars = {
		"ActionButton",
		"MultiBarBottomRightButton",
		"MultiBarBottomLeftButton",
		"MultiBarRightButton",
		"MultiBarLeftButton"
	}
	for _, group in ipairs(bars) do
		for i =1, 12 do
			local button = _G[group .. i]
			if button then
				local actionType, id, subType = GetActionInfo(ActionButton_CalculateAction(button, "LeftButton"))
				if actionType == 'spell' then
					local spell = GetSpellInfo(id)
					if spell then
						ProbablyEngine.faceroll.buttonMap[spell] = button
					end
				end
			end
		end
	end
end)