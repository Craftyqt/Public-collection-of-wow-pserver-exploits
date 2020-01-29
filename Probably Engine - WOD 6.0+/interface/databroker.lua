-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local L = ProbablyEngine.locale.get
local ldb = LibStub("LibDataBroker-1.1")

ProbablyEngine.dataBroker = { }

ProbablyEngine.dataBroker.icon = ldb:NewDataObject("PEToggle", {
    type = "launcher",
    icon = "Interface\\Icons\\achievement_Goblinhead",
    label = "Probably",
    tocname = "Probably",
    OnClick = function(self, button)
        if IsShiftKeyDown() or IsAltKeyDown() or IsControlKeyDown() then
            if not self.button_moving then
                ProbablyEngine.buttons.frame:Show()
                self.button_moving = true
            else
                ProbablyEngine.buttons.frame:Hide()
                self.button_moving = false
            end
        else
            if button == 'RightButton' then
                ProbablyEngine.interface.showProbablyConfig()
            else
                ProbablyEngine.buttons.toggle('MasterToggle')
            end
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddDoubleLine('|r|cffffffff'..L('left_click')..'|r', L('help_toggle'))
        tooltip:AddDoubleLine('|r|cffffffff'..L('mod_click')..'|r', L('unlock_buttons'))
        tooltip:AddDoubleLine('|r|cffffffff'..L('right_click')..'|r', L('open_config'))
    end
})

ProbablyEngine.dataBroker.spell = ldb:NewDataObject("PECurrentSpell", {
    type = "data source",
    text = L('none'),
    label = L('current_spell'),
})

ProbablyEngine.dataBroker.previous_spell = ldb:NewDataObject("PEPreviousSpell", {
    type = "data source",
    text = L('none'),
    label = L('previous_spell'),
})