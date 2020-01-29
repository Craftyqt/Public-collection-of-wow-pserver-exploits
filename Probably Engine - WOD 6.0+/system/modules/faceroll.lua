-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.faceroll = {
	buttonMap = { },
	lastFrame = false,
	rolling = false
}

ProbablyEngine.faceroll.activeFrame = CreateFrame('Frame', 'activeCastFrame', UIParent)
local activeFrame = ProbablyEngine.faceroll.activeFrame
activeFrame:SetWidth(32)
activeFrame:SetHeight(32)
activeFrame:SetPoint("CENTER", UIParent, "CENTER")
activeFrame.texture = activeFrame:CreateTexture()
activeFrame.texture:SetTexture("Interface/TARGETINGFRAME/UI-RaidTargetingIcon_8")
activeFrame.texture:SetVertexColor(0, 1, 0, 1)
activeFrame.texture:SetAllPoints(activeFrame)
activeFrame:SetFrameStrata('HIGH')
activeFrame:Hide()

local function showActiveSpell()
	if not ProbablyEngine.protected.method then
		local current_spell = ProbablyEngine.current_spell
		local spellButton = ProbablyEngine.faceroll.buttonMap[current_spell]
		if spellButton and current_spell then
			activeFrame:Show()
			activeFrame:SetPoint("CENTER", spellButton, "CENTER")
		else
			activeFrame:Hide()
		end
	else
		ProbablyEngine.faceroll.activeFrame:Hide()
		ProbablyEngine.timer.unregister("visualCast")
	end
end
ProbablyEngine.timer.register("visualCast", showActiveSpell, 50)