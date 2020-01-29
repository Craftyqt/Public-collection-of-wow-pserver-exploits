-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local L = ProbablyEngine.locale.get

ProbablyEngine.buttons = {
  frame = CreateFrame("Frame", "PE_Buttons", UIParent),
  buttonFrame = CreateFrame("Frame", "PE_Buttons_Container", UIParent),
  buttons = { },
  size = 36,
  scale = 1,
  padding = 6,
  count = 0,
}

-- Masque ?!
local MSQ = LibStub("Masque", true)
local probablySkinGroup
if MSQ then
  probablySkinGroup = MSQ:Group("ProbablyEngine", "Buttons")
end
-- ElvUI ?!
local E, _L, V, P, G
if IsAddOnLoaded("ElvUI") then
  E, _L, V, P, G = unpack(ElvUI)
  ElvSkin = E:GetModule('ActionBars')
  ProbablyEngine.buttons.padding = 3
  ProbablyEngine.buttons.size = 31
end

ProbablyEngine.buttons.frame:SetPoint("CENTER", UIParent)
ProbablyEngine.buttons.frame:SetWidth(170)
ProbablyEngine.buttons.frame:SetHeight(ProbablyEngine.buttons.size+5)
ProbablyEngine.buttons.frame:SetMovable(true)
ProbablyEngine.buttons.frame:SetFrameStrata('HIGH')
ProbablyEngine.buttons.frame:SetAlpha(0.8)

ProbablyEngine.buttons.frame:Hide()
ProbablyEngine.buttons.buttonFrame:Hide()

ProbablyEngine.buttons.statusText = ProbablyEngine.buttons.frame:CreateFontString('PE_StatusText')
ProbablyEngine.buttons.statusText:SetFont("Fonts\\ARIALN.TTF", 16)
ProbablyEngine.buttons.statusText:SetShadowColor(0,0,0, 0.8)
ProbablyEngine.buttons.statusText:SetShadowOffset(-1,-1)
ProbablyEngine.buttons.statusText:SetPoint("CENTER", ProbablyEngine.buttons.frame)
ProbablyEngine.buttons.statusText:SetText("|cffffffff"..L('drag_to_position').."|r")

ProbablyEngine.buttons.frame.texture = ProbablyEngine.buttons.frame:CreateTexture()
ProbablyEngine.buttons.frame.texture:SetAllPoints(ProbablyEngine.buttons.frame)
ProbablyEngine.buttons.frame.texture:SetTexture(0,0,0,0.6)

ProbablyEngine.buttons.frame:SetScript("OnMouseDown", function(self, button)
  if not self.isMoving then
   self:StartMoving()
   self.isMoving = true
  end
end)
ProbablyEngine.buttons.frame:SetScript("OnMouseUp", function(self, button)
  if self.isMoving then
   self:StopMovingOrSizing()
   self.isMoving = false
  end
end)
ProbablyEngine.buttons.frame:SetScript("OnHide", function(self)
  if self.isMoving then
   self:StopMovingOrSizing()
   self.isMoving = false
  end
end)

ProbablyEngine.buttons.create = function(name, icon, callback, tooltipl1, tooltipl2)
  if _G['PE_Buttons_' .. name] then
    ProbablyEngine.buttons.buttons[name] = _G['PE_Buttons_' .. name]
    _G['PE_Buttons_' .. name]:Show()
  else
    ProbablyEngine.buttons.buttons[name] = CreateFrame("CheckButton", "PE_Buttons_"..name, ProbablyEngine.buttons.buttonFrame, "ActionButtonTemplate")
  end
  ProbablyEngine.buttons.buttons[name]:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  local button = ProbablyEngine.buttons.buttons[name]

  button:SetPoint("TOPLEFT", ProbablyEngine.buttons.frame, "TOPLEFT",
    (
      (ProbablyEngine.buttons.size*ProbablyEngine.buttons.count)
      +
      (ProbablyEngine.buttons.count*ProbablyEngine.buttons.padding)
      + 4
    )
  , -3)
  button:SetWidth(ProbablyEngine.buttons.size)
  button:SetHeight(ProbablyEngine.buttons.size)
  button:SetAlpha(1)

  -- theme it, Masque ?
  if probablySkinGroup then
    probablySkinGroup:AddButton(button)
  end
  -- theme it, ElvUI ?
  if ElvSkin then
    ElvSkin.db = E.db.actionbar
    button:CreateBackdrop("ClassColor")
    ElvSkin:StyleButton(button, nil, true)
    button:SetCheckedTexture(nil)
    button:SetPushedTexture(nil)
    button.customTheme = function ()
      button:SetCheckedTexture(nil)
      local state = button.checked
      if state then
        button.backdrop:Show()
      else
        button.backdrop:Hide()
      end
    end
    local originalCallback = callback or false
    callback = function (self, mouseButton)
      if originalCallback then
        originalCallback(self, mouseButton)
      end
      button.customTheme()
    end
  end

  if icon == nil then
    button.icon:SetTexture('Interface\\ICONS\\INV_Misc_QuestionMark')
  else
    button.icon:SetTexture(icon)
  end

  button:SetScript("OnClick", callback)

  if tooltipl1 ~= nil then
    button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("|cffffffff" .. tooltipl1 .. "|r")
      if tooltipl2 then
        GameTooltip:AddLine(tooltipl2)
      end
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self)
      GameTooltip:Hide()
    end)
  end

  button.checked = false

  button:SetPushedTexture(nil)

  _G['PE_Buttons_'..name.."HotKey"]:SetText('Off')
  _G['PE_Buttons_'..name.."HotKey"]:Hide()

  if ProbablyEngine.config.read('buttonVisualText', false) then
    _G['PE_Buttons_'..name.."HotKey"]:Show()
  end

  ProbablyEngine.buttons.count = ProbablyEngine.buttons.count + 1

  ProbablyEngine.buttons.frame:SetWidth(ProbablyEngine.buttons.count * (ProbablyEngine.buttons.size+ProbablyEngine.buttons.padding))

end

ProbablyEngine.buttons.text = function(name, text)
  local hotkey = _G['PE_Buttons_'.. name .."HotKey"]
  hotkey:SetText(text);
  hotkey:Show();
end

ProbablyEngine.buttons.setActive = function(name)
  if _G['PE_Buttons_'.. name] then
    _G['PE_Buttons_'.. name].checked = true
    _G['PE_Buttons_'.. name]:SetChecked(true)
    _G['PE_Buttons_'..name.."HotKey"]:SetText('On')
    if _G['PE_Buttons_'.. name].customTheme then
      _G['PE_Buttons_'.. name].customTheme()
    end
    ProbablyEngine.config.write('button_states', name, true)
  end
end

ProbablyEngine.buttons.setInactive = function(name)
  if _G['PE_Buttons_'.. name] then
    _G['PE_Buttons_'.. name].checked = false
    _G['PE_Buttons_'.. name]:SetChecked(false)
    _G['PE_Buttons_'..name.."HotKey"]:SetText('Off')
    if _G['PE_Buttons_'.. name].customTheme then
      _G['PE_Buttons_'.. name].customTheme()
    end
    ProbablyEngine.config.write('button_states', name, false)
  end
end

ProbablyEngine.buttons.toggle = function(name)
  if _G['PE_Buttons_'.. name] then
    local state = _G['PE_Buttons_'.. name].checked
    if state then
      ProbablyEngine.buttons.setInactive(name)
    else
      ProbablyEngine.buttons.setActive(name)
    end
  end
end

ProbablyEngine.buttons.icon = function(name, icon)
  _G['PE_Buttons_'.. name ..'Icon']:SetTexture(icon)
end

ProbablyEngine.buttons.loadStates = function()
  if ProbablyEngine.config.read('uishown', true) then
    ProbablyEngine.buttons.frame:Hide()
    ProbablyEngine.buttons.buttonFrame:Show()
  end
  for name in pairs(ProbablyEngine.buttons.buttons) do
    local state = ProbablyEngine.config.read('button_states', name, false)
    if state == true then
      ProbablyEngine.buttons.setActive(name)
    else
      ProbablyEngine.buttons.setInactive(name)
    end
  end
end

ProbablyEngine.buttons.resetButtons = function ()
  if ProbablyEngine.buttons.buttons then
    local defaultButtons = { 'MasterToggle', 'cooldowns', 'multitarget', 'interrupt' }
    for name, button in pairs(ProbablyEngine.buttons.buttons) do
      -- button text toggles
      if ProbablyEngine.config.read('buttonVisualText', false) then
        _G['PE_Buttons_'..name.."HotKey"]:Show()
      else
        _G['PE_Buttons_'..name.."HotKey"]:Hide()
      end
      local original = false
      for _, buttonName in pairs(defaultButtons) do
        if name == buttonName then
          original = true
          break
        end
      end
      if not original then
        ProbablyEngine.buttons.buttons[name] = nil
        button:Hide()
      end
    end
    ProbablyEngine.buttons.count = table.length(ProbablyEngine.buttons.buttons)
  end
  ProbablyEngine.buttons.frame:SetWidth(ProbablyEngine.buttons.count * (ProbablyEngine.buttons.size+ProbablyEngine.buttons.padding))
end
