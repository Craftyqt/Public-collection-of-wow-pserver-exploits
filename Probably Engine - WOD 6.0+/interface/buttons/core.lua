-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.
local L = ProbablyEngine.locale.get

ProbablyEngine.buttons.create('MasterToggle', nil, function(self, button)
  if button == "LeftButton" then
    self.checked = not self.checked
    self:SetChecked(self.checked)
    ProbablyEngine.config.write('button_states', 'MasterToggle', self.checked)
    if self.checked then
      _G['PE_Buttons_MasterToggleHotKey']:SetText('On')
    else
      _G['PE_Buttons_MasterToggleHotKey']:SetText('Off')
    end
  else
    local dropdown = CreateFrame("Frame", "Test_DropDown", self, "UIDropDownMenuTemplate");
    UIDropDownMenu_Initialize(dropdown, ProbablyEngine.rotation.list_custom, "MENU");
    ToggleDropDownMenu(1, nil, dropdown, self, 0, 0);
    -- Don't toggle the state, I'm not sure why a return value can't handle this
    self.checked = self.checked
    self:SetChecked(self.checked)
  end
end, L('toggle'), L('toggle_tooltip'))

ProbablyEngine.toggle.create('cooldowns', 'Interface\\ICONS\\Achievement_BG_winAB_underXminutes', L('cooldowns'), L('cooldowns_tooltip'))
ProbablyEngine.toggle.create('multitarget', 'Interface\\ICONS\\Ability_Druid_Starfall', L('multitarget'), L('multitarget_tooltip'))
ProbablyEngine.toggle.create('interrupt', 'Interface\\ICONS\\Ability_Kick.png', L('interrupt'), L('interrupt_tooltip'))
