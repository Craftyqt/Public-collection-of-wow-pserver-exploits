-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local L = ProbablyEngine.locale.get

local stringLen = string.len

local log_height = 16
local log_items = 10
local abs_height = log_height * log_items + log_height
local delta = 0

PE_ActionLog = CreateFrame("Frame", "PE_ActionLog", UIParent)
local ActionLog = PE_ActionLog
ActionLog.show = false
ActionLog:SetFrameLevel(90)
ActionLog:SetWidth(500)
ActionLog:SetHeight(abs_height)
ActionLog:SetPoint("CENTER", UIParent)
ActionLog:SetMovable(true)
ActionLog:EnableMouseWheel(true)

local ActionLog_texture = ActionLog:CreateTexture(nil, "BACKGROUND")
ActionLog_texture:SetTexture(0,0,0,0.9)
ActionLog_texture:SetAllPoints(ActionLog)
ActionLog.texture = ActionLogHeader_texture

ActionLog:SetScript("OnMouseDown", function(self, button)
  if not self.isMoving then
   self:StartMoving()
   self.isMoving = true
  end
end)
ActionLog:SetScript("OnMouseUp", function(self, button)
  if self.isMoving then
   self:StopMovingOrSizing()
   self.isMoving = false
  end
end)
ActionLog:SetScript("OnHide", function(self)
  if self.isMoving then
   self:StopMovingOrSizing()
   self.isMoving = false
  end
end)
ActionLog:SetScript("OnMouseWheel", function(self, mouse)
  local top = #ProbablyEngine.actionLog.log - log_items

  if IsShiftKeyDown() then
    if mouse == 1 then
      delta = top
    elseif mouse == -1 then
      delta = 0
    end
  else
    if mouse == 1 then
      if delta < top then
        delta = delta + mouse
      end
    elseif mouse == -1 then
      if delta > 0 then
        delta = delta + mouse
      end
    end
  end

  ProbablyEngine.actionLog.update()
end)


local ActionLogDivA = CreateFrame("Frame", nil , PE_ActionLog)
ActionLogDivA:SetFrameLevel(99)
ActionLogDivA:SetWidth(1)
ActionLogDivA:SetHeight(abs_height)
ActionLogDivA:SetPoint("LEFT", PE_ActionLog, 125, 0)
ActionLogDivA:SetMovable(true)

local ActionLogDivA_texture = ActionLogDivA:CreateTexture(nil, "BACKGROUND")
ActionLogDivA_texture:SetTexture(0,0,0,0.5)
ActionLogDivA_texture:SetAllPoints(ActionLogDivA)
ActionLogDivA.texture = ActionLogDivA_texture

local ActionLogDivB = CreateFrame("Frame", nil , PE_ActionLog)
ActionLogDivB:SetFrameLevel(99)
ActionLogDivB:SetWidth(1)
ActionLogDivB:SetHeight(abs_height)
ActionLogDivB:SetPoint("LEFT", PE_ActionLog, 375, 0)
ActionLogDivB:SetMovable(true)

local ActionLogDivB_texture = ActionLogDivB:CreateTexture(nil, "BACKGROUND")
ActionLogDivB_texture:SetTexture(0,0,0,0.5)
ActionLogDivB_texture:SetAllPoints(ActionLogDivB)
ActionLogDivB.texture = ActionLogDivB_texture


PE_ActionLog:Hide()

local ActionLogHeader = CreateFrame("Frame", nil, PE_ActionLog)
ActionLogHeader:SetFrameLevel(92)
ActionLogHeader:SetHeight(log_height)
ActionLogHeader:SetPoint("TOPLEFT", PE_ActionLog, "TOPLEFT")
ActionLogHeader:SetPoint("TOPRIGHT", PE_ActionLog, "TOPRIGHT")
local ActionLogHeader_texture = ActionLogHeader:CreateTexture(nil, "BACKGROUND")
ActionLogHeader_texture:SetTexture(0.15,0.15,0.15,1)
ActionLogHeader_texture:SetGradient("VERTICAL", 0.8,0.8,0.8, 0,0,0)
ActionLogHeader_texture:SetAllPoints(ActionLogHeader)
ActionLogHeader.texture = ActionLogHeader_texture


ActionLogHeader.statusTextA = ActionLogHeader:CreateFontString('PE_ActionLogHeaderText')
ActionLogHeader.statusTextA:SetFont("Fonts\\ARIALN.TTF", 10)
ActionLogHeader.statusTextA:SetPoint("LEFT", ActionLogHeader, 5, 0)
ActionLogHeader.statusTextA:SetText("Action")

ActionLogHeader.statusTextB = ActionLogHeader:CreateFontString('PE_ActionLogHeaderText')
ActionLogHeader.statusTextB:SetFont("Fonts\\ARIALN.TTF", 10)
ActionLogHeader.statusTextB:SetPoint("LEFT", ActionLogHeader, 130, 0)
ActionLogHeader.statusTextB:SetText("Description")

ActionLogHeader.statusTextC = ActionLogHeader:CreateFontString('PE_ActionLogHeaderText')
ActionLogHeader.statusTextC:SetFont("Fonts\\ARIALN.TTF", 10)
ActionLogHeader.statusTextC:SetPoint("LEFT", ActionLogHeader, 380, 0)
ActionLogHeader.statusTextC:SetText("Time")

local ActionLogClose = CreateFrame("Button", "PE_TrackerClose", PE_ActionLog)
ActionLogClose:SetFrameLevel(93)
ActionLogClose:SetWidth(20)
ActionLogClose:SetHeight(log_height)
ActionLogClose:SetPoint("TOPRIGHT", ActionLogHeader, 2, -1)

ActionLogClose.statusText = ActionLogHeader:CreateFontString('PE_ActionLogCloseX')
ActionLogClose.statusText:SetFont("Fonts\\ARIALN.TTF", 20)ActionLogClose.statusText:SetPoint("CENTER", ActionLogClose)
ActionLogClose.statusText:SetText("×")

ActionLogClose:SetScript("OnMouseUp", function(self, button)
  PE_ActionLog:Hide()
end)

local ActionLogItem = { }

for i = 1, (log_items) do

  ActionLogItem[i] = CreateFrame("Frame", nil, PE_ActionLog)
  ActionLogItem[i]:SetFrameLevel(94)
  local texture = ActionLogItem[i]:CreateTexture(nil, "BACKGROUND")
  texture:SetAllPoints(ActionLogItem[i])

  if (i % 2) == 1 then
    texture:SetTexture(0.15,0.15,0.15,1)
  else
    texture:SetTexture(0.1,0.1,0.1,1)
  end

  ActionLogItem[i].texture = texture


  ActionLogItem[i]:SetHeight(log_height)
  ActionLogItem[i]:SetPoint("LEFT", PE_ActionLog, "LEFT")
  ActionLogItem[i]:SetPoint("RIGHT", PE_ActionLog, "RIGHT")


  ActionLogItem[i].itemA = ActionLogItem[i]:CreateFontString('itemA')
  ActionLogItem[i].itemA:SetFont("Fonts\\ARIALN.TTF", 10)
  ActionLogItem[i].itemA:SetShadowColor(0,0,0, 0.8)
  ActionLogItem[i].itemA:SetShadowOffset(-1,-1)
  ActionLogItem[i].itemA:SetPoint("LEFT", ActionLogItem[i], 5, 0)

  ActionLogItem[i].itemB = ActionLogItem[i]:CreateFontString('itemA')
  ActionLogItem[i].itemB:SetFont("Fonts\\ARIALN.TTF", 10)
  ActionLogItem[i].itemB:SetShadowColor(0,0,0, 0.8)
  ActionLogItem[i].itemB:SetShadowOffset(-1,-1)
  ActionLogItem[i].itemB:SetPoint("LEFT", ActionLogItem[i], 130, 0)

  ActionLogItem[i].itemC = ActionLogItem[i]:CreateFontString('itemA')
  ActionLogItem[i].itemC:SetFont("Fonts\\ARIALN.TTF", 10)
  ActionLogItem[i].itemC:SetShadowColor(0,0,0, 0.8)
  ActionLogItem[i].itemC:SetShadowOffset(-1,-1)
  ActionLogItem[i].itemC:SetPoint("LEFT", ActionLogItem[i], 380, 0)


  local position = ((i * log_height) * -1)
  ActionLogItem[i]:SetPoint("TOPLEFT", PE_ActionLog, "TOPLEFT", 0, position)

end

ProbablyEngine.actionLog = {
  log = {}
}

ProbablyEngine.actionLog.insert = function(type, spell, spellIcon, target)
  if spellIcon then
    if ProbablyEngine.actionLog.log[1] and ProbablyEngine.actionLog.log[1]['event'] == type and ProbablyEngine.actionLog.log[1]['description'] == spell and ProbablyEngine.actionLog.log[1]['target'] == target then
      ProbablyEngine.actionLog.log[1]['count'] = ProbablyEngine.actionLog.log[1]['count'] + 1
    else
      table.insert(ProbablyEngine.actionLog.log, 1, {
        event = type,
        target = target or '',
        icon = spellIcon,
        description = spell,
        count = 1,
        time = date("%H:%M:%S")
      })

      if delta > 0 and delta < #ProbablyEngine.actionLog.log - log_items then
        delta = delta + 1
      end
    end
  end
end

ProbablyEngine.actionLog.updateRow = function (row, a, b, c)
  ActionLogItem[row].itemA:SetText(a)
  ActionLogItem[row].itemB:SetText(b)
  ActionLogItem[row].itemC:SetText(c)
end

ProbablyEngine.actionLog.update = function ()
  local offset = 0
  for i = log_items, 1, -1 do
    offset = offset + 1
    local item = ProbablyEngine.actionLog.log[offset + delta]
    if not item then
      ProbablyEngine.actionLog.updateRow(i, '', '', '')
    else
      local target = stringLen(item.target) > 0 and ' @ (' .. item.target .. ')' or ''
      ProbablyEngine.actionLog.updateRow(i, item.event, 'x' .. item.count .. ' ' .. '|T' .. item.icon .. ':-1:-1:0:0|t' .. item.description .. target, item.time)
    end
  end
end

ProbablyEngine.timer.register("updateActionLog", function()
  if not PE_ActionLog:IsShown() then return end

  ProbablyEngine.actionLog.update()
end, 100)
