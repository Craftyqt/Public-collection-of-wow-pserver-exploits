if FirstRun == nil then	
	Nova_TextValue1 = {
		[1] = 	{Text = "|cFFFF6060Enable Cooldown|cffffffff" },
		[2] = 	{Text = "|cFFFFFAFALeft Shift|cffffffff" },
		[3] = 	{Text = "|cFFFFFAFALeft Control|cffffffff" },
		[4] = 	{Text = "|cFFFFFAFALeft Alt|cffffffff" },
		[5] = 	{Text = "|cFFFFFAFARight Shift|cffffffff" },
		[6] = 	{Text = "|cFFFFFAFARight Control|cffffffff" },
		[7] = 	{Text = "|cFFFFFAFARight Alt|cffffffff" }
	}
	
	Nova_TextValue2 = {
		[1] = 	{Text = "|cFF66CDAA1|cffffffff" },
		[2] = 	{Text = "|cFF66CDAA2|cffffffff" },
		[3] = 	{Text = "|cFF66CDAA3|cffffffff" },
		[4] = 	{Text = "|cFF66CDAA4|cffffffff" },
		[5] = 	{Text = "|cFF66CDAA5|cffffffff" },
		[6] = 	{Text = "|cFF66CDAA6|cffffffff" },
		[7] = 	{Text = "|cFF66CDAA7|cffffffff" }
	}


	function UpdateCD(self)
		local Checkbox_ID = UIDropDownMenu_GetSelectedID(Nova_DropDownMenu)
		print(Checkbox_ID, self.Var1)
		if self.Var1 > 1 then
			local ModNumber = UpdateMod()
			if ModNumber > 0 and _G['Nova_Checkbox1']:GetChecked() then
				SetCVar('Nova_'..string.gsub(Nova_Cooldown[Checkbox_ID].Text,"%s","_"), ModNumber)
			end
		else
			if self:GetChecked() then
				SetCVar('Nova_'..string.gsub(Nova_Cooldown[Checkbox_ID].Text,"%s","_")..'_Enabled', 1)
			else
				SetCVar('Nova_'..string.gsub(Nova_Cooldown[Checkbox_ID].Text,"%s","_")..'_Enabled', 0)
			end
			
			for i=2, 7 do
				_G['Nova_Checkbox'..tostring(i)]:SetEnabled(GetCVar('Nova_'..string.gsub(Nova_Cooldown[Checkbox_ID].Text,"%s","_")..'_Enabled'))
			end
		end
	end
	
	function UpdateMod()
		local Total = 0
		for i=2, 7 do
			if _G['Nova_Checkbox'..tostring(i)]:GetChecked() then
				Total = Total + (2 ^ (i - 2))
			end
		end
	
		return Total
	end

	function SetupCheckButtons()
		local Total = GetCVar('Nova_'..string.gsub(Nova_Cooldown[UIDropDownMenu_GetSelectedID(Nova_DropDownMenu)].Text, "%s", "_"))
		for y=7, 2, -1 do
			if Total - (2 ^ (y - 2)) >= 0 then
				Total = Total - ( 2 ^ (y - 2))
				_G['Nova_Checkbox'..tostring(y)]:SetChecked(true)
			else
				_G['Nova_Checkbox'..tostring(y)]:SetChecked(false)
			end
		end
		if GetCVarBool('Nova_'..string.gsub(Nova_Cooldown[UIDropDownMenu_GetSelectedID(Nova_DropDownMenu)].Text,"%s","_").."_Enabled") then
			_G['Nova_Checkbox1']:SetChecked(true)
		else
			_G['Nova_Checkbox1']:SetChecked(false)
			for m=2, 7 do
				_G['Nova_Checkbox'..tostring(m)]:SetEnabled(false)
			end
		end
	end

	function RefreshFrameBoxes()
		if Nova_Value then
			for i=1, #Nova_Value do
				if Nova_Value[i].Var1 ~= nil then
					_G['Nova_EditBox'..tostring(i)]:SetNumber(tonumber(GetCVar('Nova_'..string.gsub(Nova_Value[i].Text,"%s","_"))))
				end
				if Nova_Value[i].Var2 ~= nil then
					_G['Nova_CheckboxEnabled'..tostring(i)]:SetChecked(GetCVarBool('Nova_'..string.gsub(Nova_Value[i].Text, '%s', '_')..'_Enabled'))
				end
			end
		end
	end

	FirstRun = true
end

if not MiniMapCreated then
	function MiniMapCreation()
		--CREATE MINIMAP FRAME
		MiniMap_Frame = CreateFrame('Frame', 'MiniMap_Frame', Minimap)
		MiniMap_Frame:SetFrameLevel(4)
		MiniMap_Frame:SetHeight(45)
		MiniMap_Frame:SetWidth(45)
		MiniMap_Frame:SetMovable(true)
		MiniMap_Frame:EnableMouse(true)
		MiniMap_Frame:RegisterForDrag("RightButton")
		MiniMap_Frame:SetScript("OnDragStart", MiniMap_Frame.StartMoving)
		MiniMap_Frame:SetScript("OnDragStop", MiniMap_Frame.StopMovingOrSizing)
	--	MiniMap_Frame:SetScript("OnAttributeChanged", function()if Nova_MinimapCheck:GetChecked() == 1 and not MiniMap_Frame:IsShown() then MiniMap_Frame:Show() elseif Nova_MinimapCheck:GetChecked() == nil and MiniMap_Frame:IsShown() == 1 then MiniMap_Frame:Hide() end end)
		MiniMap_Frame:SetBackdrop(
									{bgFile = "Interface/CHARACTERFRAME/TotemBorder",
									tile = false, tileSize = 45, edgeSize = 45,
									insets = { left = 6, right = 6, top = 6, bottom = 6 }
									});
		MiniMap_Frame:SetPoint('LEFT', 150,60)
		MiniMap_Frame:Show()
		
		--CREATE MINIMAP BUTTON
		Nova_MapButton = CreateFrame('Button', 'Nova_MapButton', MiniMap_Frame)
		Nova_MapButton:ClearAllPoints()
		Nova_MapButton:SetPoint("CENTER")
		Nova_MapButton:RegisterForClicks("LeftButtonDown")
		Nova_MapButton:SetHeight(15)
		Nova_MapButton:SetWidth(15)
		Nova_MapButton:SetScript('OnClick', function() RunMacroText('/nova') end )
		Nova_MapButton:SetBackdrop(
									{bgFile = "Interface/CHARACTERFRAME/TemporaryPortrait", 
									tile = false, tileSize = 16, edgeSize = 16 
									})
		Nova_MapButton:Show()
	end

	MiniMapCreated = true
end


if not FrameCreated then

function FrameCreation(ValueTable, CooldownTable, FrameName, FrameName2)
	Nova_Value = ValueTable or nil
	Nova_Cooldown = CooldownTable or nil
	Nova_TableSize = 0
	if Nova_Cooldown then
		Nova_TableSize = #Nova_Cooldown
	end
	Nova_FrameName = FrameName or 'Nova Options'
	Nova_CDFrameName = FrameName2 or 'Cooldown Options'

	------------------------------------------------------------------
	--						Main Frame 								--
	------------------------------------------------------------------	

	-- CREATE THE MAIN NOVA OPTIONS FRAME
	Nova_Frame = CreateFrame('Frame', 'Nova_Frame', UIParent)
	Nova_Frame:ClearAllPoints()
	Nova_Frame:SetHeight(70)
	Nova_Frame:SetWidth(275)
	Nova_Frame:SetMovable(true)
	Nova_Frame:EnableMouse(true)
	Nova_Frame:RegisterForDrag("LeftButton")
	Nova_Frame:SetScript("OnDragStart", Nova_Frame.StartMoving)
	Nova_Frame:SetScript("OnDragStop", Nova_Frame.StopMovingOrSizing)
	Nova_Frame:SetScript("OnShow", RefreshFrameBoxes)
	Nova_Frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
																edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
																tile = true, tileSize = 16, edgeSize = 16, 
																insets = { left = 4, right = 4, top = 4, bottom = 4 }});
	Nova_Frame:SetBackdropColor(0,0,0,1);
	Nova_Frame:SetPoint('CENTER', 0, 200)
	Nova_Frame:Hide()

	-- TITLE OF MAIN NOVA OPTIONS FRAME
	Nova_Title = CreateFrame('Frame', 'Nova_Title', Nova_Frame)
	Nova_Title:ClearAllPoints()
	Nova_Title:SetHeight(35)
	Nova_Title:SetWidth(150)
	Nova_Title:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
																edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
																tile = true, tileSize = 16, edgeSize = 16, 
																insets = { left = 4, right = 4, top = 4, bottom = 4 }});
	Nova_Title:SetBackdropColor(0,0,0,1);
	Nova_Title:Show()	 
	Nova_Title.text = Nova_Title:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
	Nova_Title.text:SetAllPoints()
	Nova_Title.text:SetJustifyV("LEFT")
	Nova_Title.text:SetJustifyH("CENTER")
	Nova_Title.text:SetText(Nova_FrameName)
	Nova_Title:SetPoint("CENTER", Nova_Frame, "TOP", 0, 0)
	
	
	-- BUTTONS CODE
	--Button to close the normal frame.
	Nova_CloseButton = CreateFrame('Button', 'Nova_CloseButton', Nova_Frame, "UIPanelButtonTemplate")
	Nova_CloseButton:ClearAllPoints()
	Nova_CloseButton:SetPoint("TOPRIGHT", -10, -10, -10, -10)
	Nova_CloseButton:RegisterForClicks("LeftButtonDown")
	Nova_CloseButton:SetSize(20, 20)
	Nova_CloseButton:SetText("|cFFFFFAFA X|cffffffff")
	Nova_CloseButton:SetScript('OnClick', function() Nova_Frame:Hide() end )
	Nova_CloseButton:SetBackdrop({
--									bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
									edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
									tile = false, tileSize = 12, edgeSize = 12, 
									insets = { left = 6, right = 6, top = 6, bottom = 6 }
									})
	Nova_CloseButton:Show()
	
	--LABEL CREATION FOR NOVA_VARIABLES AS WELL AS ALL VALLUES BELOW IT BUT NOT BELOW COOLDOWN USAGE VALUES.
	if Nova_Value then
		local EditBoxLocation = 40
		for i=1, #Nova_Value do
			if #Nova_Value >= 1 and i == 1 then
				Nova_Label = CreateFrame("Frame", Nova_Label, Nova_Frame)
				Nova_Label:ClearAllPoints()
				Nova_Label:SetHeight(14)
				Nova_Label:SetWidth(100)
				Nova_Label:SetPoint("TOP", 0, - (EditBoxLocation - 20) )
				Nova_Label.text = Nova_Label:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
				Nova_Label.text:SetAllPoints()
				Nova_Label.text:SetText("Nova Variables")
				local line1 = Nova_Label:CreateTexture()
				line1:ClearAllPoints()
				line1:SetWidth(40)
				line1:SetHeight(1)
				line1:SetTexture(.9, .9, 0, .8)
				line1:SetPoint("RIGHT", Nova_Label, "LEFT", -4, 0)
				local line2 = Nova_Label:CreateTexture()
				line2:ClearAllPoints()
				line2:SetWidth(40)
				line2:SetHeight(1)
				line2:SetTexture(.9, .9, 0, .8)
				line2:SetPoint("LEFT", Nova_Label, "RIGHT", 4, 0)

				Nova_Frame:SetHeight(Nova_Frame:GetHeight() + 20)
			end
			if Nova_Value[i].Var1 ~= nil then
				local Var = "Nova_EditBox"..tostring(i)
				EB = CreateFrame('EditBox', Var, Nova_Frame, "InputBoxTemplate")
				EB:SetAutoFocus(false)
				EB:ClearAllPoints()
				EB:SetNumeric(true)
				EB:SetHeight(14)
				EB:SetWidth(40)
				EB:SetHistoryLines(1)
				EB:SetJustifyH("CENTER")
				EB:SetJustifyV("CENTER")
				EB:SetPoint("TOPLEFT", 10, - (EditBoxLocation + (17 * i - 1) ) )
				EB:SetMaxLetters(3)
				EB:SetNumber(GetCVar("Nova_"..string.gsub(Nova_Value[i].Text,"%s","_")))
				EB:SetFontObject("GameFontNormal")
				EB:SetScript('OnEnterPressed', function(self) self:ClearFocus() end)
				EB:SetScript('OnEscapePressed', function(self) self:ClearFocus() end)
				EB:SetScript('OnEditFocusLost', function(self) 
									if self:GetNumber() <= 100 and self:GetNumber() >= 0 then
										SetCVar("Nova_"..string.gsub(Nova_Value[i].Text,"%s","_"), self:GetText())
									else
										self:SetNumber(GetCVar("Nova_"..string.gsub(Nova_Value[i].Text,"%s","_")))
									end 
					end)
				EB:Show()
			end
			
			local LabelName = 'Nova_Label'..tostring(i)
			Nova_Label = CreateFrame("Frame", LabelName, Nova_Frame)
			Nova_Label:ClearAllPoints()
			Nova_Label:SetHeight(14)
			Nova_Label:SetWidth(150)
			Nova_Label:SetPoint("TOPLEFT", 40, - (EditBoxLocation + (17 * i - 1) ) )
			Nova_Label.text = Nova_Label:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
			Nova_Label.text:SetAllPoints()
			Nova_Label.text:SetJustifyV("CENTER")
			Nova_Label.text:SetJustifyH("CENTER")
			Nova_Label.text:SetText(Nova_Value[i].Text)
			Nova_Label:SetPoint("Left", 5, 0)

			Nova_Frame:SetHeight(Nova_Frame:GetHeight() + 17)

			if Nova_Value[i].Var2 ~= nil then
				local CBName = "Nova_CheckboxEnabled"..tostring(i)
				Nova_CB = CreateFrame('CheckButton', CBName, Nova_Frame, "UICheckButtonTemplate")
				Nova_CB:ClearAllPoints()
				Nova_CB:SetPoint("LEFT", _G['Nova_Label'..tostring(i)], 'RIGHT', 20, 0 )
				Nova_CB:SetHeight(17)
				Nova_CB:SetWidth(17)
				Nova_CB:RegisterForClicks('LeftButtonDown')
				Nova_CB:SetChecked(GetCVarBool('Nova_'..string.gsub(Nova_Value[i].Text, "%s", "_")..'_Enabled'))
				Nova_CB.Var1 = i
				Nova_CB:SetScript('OnClick', function(self)
					if self:GetChecked() then
						SetCVar('Nova_'..string.gsub(Nova_Value[i].Text, "%s", "_")..'_Enabled', 1)
					else
						SetCVar('Nova_'..string.gsub(Nova_Value[i].Text, "%s", "_")..'_Enabled', 0)
					end
				end)
				Nova_CB:Show()
			end

			if Nova_Value[i].Var1 == nil and Nova_Value[i].Var2 == nil then
				local line1 = _G['Nova_Label'..tostring(i)]:CreateTexture()
				line1:ClearAllPoints()
				line1:SetWidth(40)
				line1:SetHeight(1)
				line1:SetTexture(.9, .9, 0, .8)
				line1:SetPoint("CENTER", _G['Nova_Label'..tostring(i)], "LEFT", 4, 0)
				local line2 = _G['Nova_Label'..tostring(i)]:CreateTexture()
				line2:ClearAllPoints()
				line2:SetWidth(40)
				line2:SetHeight(1)
				line2:SetTexture(.9, .9, 0, .8)
				line2:SetPoint("CENTER", _G['Nova_Label'..tostring(i)], "RIGHT", -4, 0)
			end
			
			if i==#Nova_Value then
				if GetCVar('Nova_OverRide') ~= nil then
					OverRide = CreateFrame('CheckButton', 'Nova_OverRide', Nova_Frame, 'UICheckButtonTemplate')
					OverRide:ClearAllPoints()
					OverRide:SetPoint("TOPLEFT", 20, - (EditBoxLocation + (19 * i) ) )
					OverRide:SetHeight(20)
					OverRide:SetWidth(20)
					OverRide:RegisterForClicks('LeftButtonDown')
					OverRide:SetChecked(GetCVarBool('Nova_OverRide'))
					_G[OverRide:GetName() .. 'Text']:SetText('Over Ride Default Values')	
					OverRide:SetPoint("Left", 5, 0)	
					OverRide:SetScript('OnClick', function(self) 
							if self:GetChecked() then 
								SetCVar('Nova_OverRide', 1) 
							else 
								SetCVar('Nova_OverRide', 0) 
							end	
						end)
					OverRide:Show()

					Nova_Frame:SetHeight(Nova_Frame:GetHeight() + 19)
				end
			end
				
		end
	end

	-- LABEL CREATION FOR MINIMAP ICON SELECTION
	Nova_Label = CreateFrame("Frame", nil, Nova_Frame)
	Nova_Label:ClearAllPoints()
	Nova_Label:SetHeight(15)
	Nova_Label:SetWidth(145)
	Nova_Label.text = Nova_Label:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
	Nova_Label.text:SetAllPoints()
	Nova_Label.text:SetJustifyV("BOTTOM")
	Nova_Label.text:SetJustifyH("RIGHT")
	Nova_Label.text:SetText('|cFF66CDAAEnable Minimap Icon:|cffffffff')
	Nova_Label:SetPoint("BOTTOMLEFT", 5, 10)
	
	Nova_MinimapCheck = CreateFrame('CheckButton', "Nova_MinimapCheck", Nova_Frame, "UICheckButtonTemplate")
	Nova_MinimapCheck:ClearAllPoints()
	Nova_MinimapCheck:SetPoint("BOTTOMLEFT", 155, 5)
	Nova_MinimapCheck:SetHeight(20)
	Nova_MinimapCheck:SetWidth(20)
	Nova_MinimapCheck:SetChecked(true)
	Nova_MinimapCheck:SetScript("OnClick", function() if Nova_MinimapCheck:GetChecked() == 1 and not MiniMap_Frame:IsShown() then MiniMap_Frame:Show() elseif Nova_MinimapCheck:GetChecked() == nil and MiniMap_Frame:IsShown() == 1 then MiniMap_Frame:Hide() end end)
	Nova_MinimapCheck:Show()
	


	------------------------------------------------------------------
	--							Cooldown Frame 						--
	------------------------------------------------------------------
	if Nova_Cooldown then
		--CREATION OF COOLDOWNS FRAME
		Nova_CDFrame = CreateFrame('Frame', 'Nova_CDFrame', Nova_Frame)
		Nova_CDFrame:ClearAllPoints()
		Nova_CDFrame:SetPoint('BOTTOMLEFT', Nova_Frame, 'BOTTOMRIGHT', 2, 0)
		Nova_CDFrame:SetHeight(200)
		Nova_CDFrame:SetWidth(200)
		Nova_CDFrame:EnableMouse(true)
		Nova_CDFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
																	edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
																	tile = true, tileSize = 16, edgeSize = 16, 
																	insets = { left = 4, right = 4, top = 4, bottom = 4 }});
		Nova_CDFrame:SetBackdropColor(0,0,0,1);
		Nova_CDFrame:Show()
		
		--TITLE OF NOVA COOLDOWNS
		Nova_Title1 = CreateFrame('Frame', 'Nova_Title1', Nova_CDFrame)
		Nova_Title1:ClearAllPoints()
		Nova_Title1:SetHeight(35)
		Nova_Title1:SetWidth(150)
		Nova_Title1:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
																	edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
																	tile = true, tileSize = 16, edgeSize = 16, 
																	insets = { left = 4, right = 4, top = 4, bottom = 4 }});
		Nova_Title1:SetBackdropColor(0,0,0,1);
		Nova_Title1:Show()	 
		Nova_Title1.text = Nova_Title1:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
		Nova_Title1.text:SetAllPoints()
		Nova_Title1.text:SetJustifyV("LEFT")
		Nova_Title1.text:SetJustifyH("CENTER")
		Nova_Title1.text:SetText(Nova_CDFrameName)
		Nova_Title1:SetPoint("CENTER", Nova_CDFrame, "TOP", 0, 0)


		--Button to pull-up Cooldown frame as well as hide normal frame
		Nova_CDButton = CreateFrame('Button', 'Nova_CDButton', Nova_Frame, "UIPanelButtonTemplate")
		Nova_CDButton:ClearAllPoints()
		Nova_CDButton:SetPoint("BOTTOMRIGHT", -5, 5)
		Nova_CDButton:RegisterForClicks("LeftButtonDown")
		Nova_CDButton:SetHeight(22)
		Nova_CDButton:SetWidth(85)
		Nova_CDButton:SetText("|cFFFFFAFACooldowns|cffffffff")
		Nova_CDButton:SetScript('OnClick', function() if Nova_CDFrame:IsShown() then Nova_CDFrame:Hide() else Nova_CDFrame:Show() end end )
		Nova_CDButton:Show()

		if not Nova_DropDownMenu then
			local XLocation = 10
			local YLocation = 10
			for i=1, 7 do
				local CBName = "Nova_Checkbox"..tostring(i)
				Nova_CD_CB = CreateFrame('CheckButton', CBName, Nova_CDFrame, "UICheckButtonTemplate")
				Nova_CD_CB:ClearAllPoints()
				Nova_CD_CB:SetPoint("BOTTOMLEFT", Nova_CDFrame, "BOTTOMLEFT", XLocation, (YLocation + (20 * (i - 1))))
				Nova_CD_CB:SetHeight(20)
				Nova_CD_CB:SetWidth(20)
				Nova_CD_CB.Var1 = i
				Nova_CD_CB:RegisterForClicks('LeftButtonDown')
				Nova_CD_CB:SetScript('OnClick', UpdateCD)
				_G[Nova_CD_CB:GetName() .. 'Text']:SetText(Nova_TextValue1[i].Text)
				Nova_CD_CB:Show()
			end


			CreateFrame("Button", "Nova_DropDownMenu", Nova_CDFrame, "UIDropDownMenuTemplate")

			 
			Nova_DropDownMenu:ClearAllPoints()
			Nova_DropDownMenu:SetPoint("TOP", 0, -15)
			Nova_DropDownMenu:Show()
			 
			local function OnClick(self)
			   UIDropDownMenu_SetSelectedID(Nova_DropDownMenu, self:GetID())
			   SetupCheckButtons()
			end
			 
			local function initialize(self, level)
			   local info = UIDropDownMenu_CreateInfo()
			   for i=1, #Nova_Cooldown do
			      info = UIDropDownMenu_CreateInfo()
			      info.text = Nova_Cooldown[i].Text
			      info.value = Nova_Cooldown[i].Text
			      info.func = OnClick
			      UIDropDownMenu_AddButton(info, level)
			   end
			end
			 
			 
			UIDropDownMenu_Initialize(Nova_DropDownMenu, initialize)
			UIDropDownMenu_SetWidth(Nova_DropDownMenu, 100);
			UIDropDownMenu_SetButtonWidth(Nova_DropDownMenu, 124)
			UIDropDownMenu_SetSelectedID(Nova_DropDownMenu, 1)
			UIDropDownMenu_JustifyText(Nova_DropDownMenu, "LEFT")
		end
		SetupCheckButtons()

		
	end

end

FrameCreated = true
end