----[[ Ini ]]------------------------------------------------------------------------------------------------------------------
local AddOnName, Env = ... local ADDON = Env[1] 
local D = ADDON.development
----[[ Ace Ini ]]--------------------------------------------------------------------------------------------------------------
local AceConfigRegistry	= LibStub("AceConfigRegistry-3.0")
local AceGUI = LibStub("AceGUI-3.0")
----[[ Lua Ini ]]--------------------------------------------------------------------------------------------------------------
local select, unpack						= select, unpack
local type	 								= type
local sub, find, format 				= string.sub, string.find, string.format
local floor, ceil, min, max			= math.floor, math.ceil, math.min, math.max
----[[ WoW Ini ]]--------------------------------------------------------------------------------------------------------------
local GetSpellInfo, GetTime  = GetSpellInfo, GetTime


----[[ Constants ]]------------------------------------------------------------------------------------------------------------
local HOTKEY_LIST 	= { la="la", ra="ra", ls="ls", rs="rs", lc="lc", rc="rc" }
local CVAR_RVBUFFER 	= 10
local ROTATIONDB_SETCOUNT	= 10

for buffer = 1, CVAR_RVBUFFER do	
	 ADDON:SetCVar('PQI_RVUpdate'..buffer,'')	
end	



----[[ rotationConfig Scripts ]]------------------------------------------------------------------------------------------------


----[[ rotationConfig Methods ]]------------------------------------------------------------------------------------------------
local methods = {
	['AddRotation'] = function(self,rotation)				
		local index = 1
		if #self.rotations > 0 then			
			for i=1, #self.rotations do
				if self.rotations[i].id == rotation.id then 
					index = i
				break end
				index = i+1
			end
		end		
		if rotation.abilityCount > 0 then 
			rotation.sectionCount = 1
		else			
			rotation.sectionCount = 0
		end		
		for i=1, rotation.abilityCount do
			local ability = rotation.abilities[i]
			if ability.newSection then 
				if i==1 then
					ability.newSection = nil 
				else
					rotation.sectionCount = rotation.sectionCount + 1
				end
			end			
		end		
		self.rotations[index] = rotation
		self:AddRotationDB(rotation)		
		self:SetActiveRotation(index)	
		self.db.show = true
		self:Update()		
		
		if #self.rotations > 1 then			
			self.nextButton:Show()
			self.prevButton:Show()			
			
			local menuData = {}	
			for i = 1, #self.rotations do	
				menuData[i] = {}
				menuData[i].name = format("%s|cff00aaff %s",self.rotations[i].name,self.rotations[i].author)
				menuData[i].onClick = function(this)
					self:SetActiveRotation(i)
				end
				menuData[i].checked = function(this)
					if self.rotations[i].id == self.activeRotation.id then this.check:Show() else this.check:Hide() end 
				end			
			end
			self.menuActive = true			
			self.menu:SetMenu(menuData)
		else
			self.menuActive = nil
		end		 
	end,
	['AddRotationDB'] = function(self,rotation)		
		local index = 1	
		-- find database index
		if #self.db.rotations > 0 then 
			for d=1, #self.db.rotations do				
				if self.db.rotations[d].id == rotation.id then 					
					index = d
				break	end
				index = d+1
			end
		end
		-- construct new database		
		if not self.db.rotations[index] then
			self.db.rotations[index] = {
				currentSet 		= 1,
				id 				= rotation.id,
				name 				= rotation.name,
				author 			= rotation.author,
				abilityCount 	= rotation.abilityCount,
				hotkeyCount 	= rotation.hotkeyCount,				
				sets 				= {},					
			}		
		end
		-- update database		
		local rotationDB = self.db.rotations[index]	
		for s=1,ROTATIONDB_SETCOUNT do 
			-- add new set iff not already there
			if not rotationDB.sets[s] then
				rotationDB.sets[s] = {
					name = "set"..s,
					id 			= rotation.id,
					--author 		= rotation.author,
					--rName			= rotation.name,			
					abilities	= {},
					hotkeys 		= {},					
				}
			end			
			-- update abilties
			for a = 1, rotation.abilityCount do
				if not rotationDB.sets[s].abilities[a] then
					rotationDB.sets[s].abilities[a] = {}
				end
				local abilityDB = rotationDB.sets[s].abilities[a]
				local ability = rotation.abilities[a]
				-- iff current ability database dosnt exist or has a new name use incoming rotation settings
				if not abilityDB.id or abilityDB.id ~= ability.id then
					abilityDB.id		= ability.id
					abilityDB.name 	= ability.name
					abilityDB.enable 	= ability.enable
					abilityDB.boss		= ability.boss
					if abilityDB.value then abilityDB.value = ability.value end	--reset the value			
				end				
				if type(abilityDB.boss) ~='boolean' then abilityDB.boss = ability.boss end
				abilityDB.widget = ability.widget
				if ability.widget then 
					if ability.widget.type == 'txtbox' then
						if abilityDB.values then 
							abilityDB.value = nil
							abilityDB.values = nil
						end
						if not abilityDB.value then abilityDB.value = ability.widget.value end
					elseif ability.widget.type == 'numbox' then
						if abilityDB.values then 
							abilityDB.value = nil
							abilityDB.values = nil
						end
						if not abilityDB.value then abilityDB.value = ability.widget.value end						
					elseif ability.widget.type =='select' then
						if not abilityDB.values then abilityDB.values = ability.widget.values end
						if not abilityDB.value then
							 abilityDB.value = ability.widget.value				
						else											
							if not ability.widget.values[abilityDB.value] then							
								for k, v in pairs (ability.widget.values) do
									 abilityDB.value = k break
								end
							end 
						end
					end
				end
			end
			-- remove unused abilities		
			if rotation.abilityCount < #rotationDB.sets[s].abilities then 
				for a = rotation.abilityCount + 1 , #rotationDB.sets[s].abilities do
					rotationDB.sets[s].abilities[a] = nil					
				end				
			end
			-- update hotkeys		
			for h = 1, rotation.hotkeyCount do
				if not rotationDB.sets[s].hotkeys[h] then
					rotationDB.sets[s].hotkeys[h] = {}
				end
				local hotkeyDB = rotationDB.sets[s].hotkeys[h]
				local hotkey = rotation.hotkeys[h]				
				if hotkeyDB.id ~= hotkey.id then
					hotkeyDB.id 		= hotkey.id
					hotkeyDB.name		= hotkey.name
					hotkeyDB.enable 	= hotkey.enable
					hotkeyDB.keys 		= ADDON:TableCopy(hotkey.hotkeys,'lowercase')
				end				
			end
			-- remove unused hotkeys
			if rotation.hotkeyCount < #rotationDB.sets[s].abilities then 
				for a = rotation.abilityCount + 1 , #rotationDB.sets[s].hotkeys do
					rotationDB.sets[s].hotkeys[h] = nil					
				end				
			end
							
		end		
		--dump('rotation',rotation)			
		--dump('db.rotations',self.db.rotations)	
	end,	
	['SetActiveRotation'] = function(self,rotationNum)			
		self.activeRotation 		= self.rotations[rotationNum]	
		self.activeRotationNum	= rotationNum		
		for d=1,#self.db.rotations do
			if self.activeRotation.id == self.db.rotations[d].id then 
				self.activeRotationDB = self.db.rotations[d]
			end				
		end
		
		self:DrawVariables()
		self:ClearRotation()
		self:DrawRotation()
		self:UpdateRotation()		
			
	end,
	['DrawVariables'] = function(self) 
		local rotationDB = self.activeRotationDB.sets[1]
		local n = "\n"
		--------------------------------------------------------------------------------------------------------------------
		local newline = "\n"
		local p = '\n\n'
		local s = format('%s%s%s%s',ADDON.colors.grey[4],
				'This is a suggested use of variables for profile developers to implement within their PQR Ability code. Copy ',
				'and paste each line to the top line of each ability in PQR respectively.',p)						
		if rotationDB.abilities[1] then s = format('%s%s%s%s%s%s',s,ADDON.colors.grey[4],
				'Abilities:',n,
				'-----------------------------------------------------------------------------------------------------------------',n) end						
		for i=1,#rotationDB.abilities do	s = format('%s'..ADDON.colors.blue[4]..'%s|r%s%s'..ADDON.colors.blue[4]..'%s%s',s,
				'if not ',rotationDB.abilities[i].id,'_enable ','then return false end',n)			
			if type(rotationDB.abilities[i].boss) == 'boolean' then s = format('%s'..ADDON.colors.blue[4]..'%s|r%s%s'..ADDON.colors.blue[4]..'%s%s',s,
				'if not ',rotationDB.abilities[i].id,'_boss ','then return false end',n) end
			if rotationDB.abilities[i].value then s = format('%s'..ADDON.colors.blue[4]..'%s|r%s'..ADDON.colors.orange[4]..'%s|r%s%s%s',s,
				'local ','v','=',rotationDB.abilities[i].id,'_value ',n) end			
		end
		if rotationDB.hotkeys[1] then s = format('%s%s%s%s%s%s%s',s,n,ADDON.colors.grey[4],
				'Hotkeys:',n,
				'-----------------------------------------------------------------------------------------------------------------',n) end		
		for i=1,#rotationDB.hotkeys do s = format('%s'..ADDON.colors.blue[4]..'%s|r%s%s'..ADDON.colors.blue[4]..'%s%s%s'..ADDON.colors.purple[4]..'%s'..ADDON.colors.orange[4]..'%s'..ADDON.colors.purple[4]..'%s'..ADDON.colors.orange[4]..'%s|r%s%s'..ADDON.colors.orange[4]..'%s'..ADDON.colors.blue[4]..'%s%s',s,
				'if not ',rotationDB.hotkeys[i].id,'_enable ','then return false end',n,
				'if not ','PQI',':','IsHotkeys','( ',rotationDB.hotkeys[i].id,'_key ',' ) ','then return false end',n) 
		end
						
		s = format('%s%s%s%s%s',s,n,ADDON.colors.grey[4],
				'This section contains plain variables for manual use.',p)						
		if rotationDB.abilities[1] then s = format('%s%s%s%s%s%s',s,ADDON.colors.grey[4],
				'Abilities:',n,
				'-----------------------------------------------------------------------------------------------------------------',n) end					
		for i=1,#rotationDB.abilities do	s = format('%s|r%s%s%s',s,					
			rotationDB.abilities[i].id,'_enable',n)
			if type(rotationDB.abilities[i].boss) == 'boolean' then s = format('%s|r%s%s%s',s,					
			rotationDB.abilities[i].id,'_boss',n) end
			if rotationDB.abilities[i].value then s = format('%s|r%s%s%s',s,					
			rotationDB.abilities[i].id,'_value',n) end			
		end
		if rotationDB.hotkeys[1] then s = format('%s%s%s%s%s%s%s',s,n,ADDON.colors.grey[4],
				'Hotkeys:',n,
				'-----------------------------------------------------------------------------------------------------------------',n) end			
		for i=1,#rotationDB.hotkeys do s = format('%s|r%s%s%s%s%s%s',s,					
			rotationDB.hotkeys[i].id,'_enable',n,
			rotationDB.hotkeys[i].id,'_key',n)									
		end
		self.codeWindow.editBox:SetText(s)
	end,
	['ClearRotation'] = function(self)		
		for i=1,#self.abilityRows do
			self.abilityRows[i]:Hide()		
		end
		for i=1,#self.abilitySections do
			self.abilitySections[i]:Hide()		
		end
		for i=1,#self.hotkeyRows do
			self.hotkeyRows[i]:Hide()		
		end
					
	end,
	['DrawRotation'] = function(self)
		self:SetText(format("%s|cff00aaff %s",self.activeRotation.name,self.activeRotation.author))		
		self:DrawAbilities()
		self:DrawHotkeys()
		
		
		local abilityHeight = 0
		local hotkeyCount = 0
		
		if self.activeRotation.abilityCount > 0 then
			abilityHeight = (self.activeRotation.abilityCount*self.rowHeight) + (9 * self.activeRotation.sectionCount)  -- 8 section Height
		end
		if self.activeRotation.hotkeyCount > 0 then
			hotkeyCount = self.hotkeyContainer:GetHeight() +2
		end
		
		if self.activeRotation.abilityCount < 1 then 
			self.hotkeyContainer:SetPoint("TOPLEFT",1,-self.titleHeight)
			self.hotkeyContainer:SetPoint("TOPRIGHT",-1,-self.titleHeight)
		else 			
			self.hotkeyContainer:SetPoint("TOPLEFT",1,-(abilityHeight+self.titleHeight))
			self.hotkeyContainer:SetPoint("TOPRIGHT",-1,-(abilityHeight+self.titleHeight))
		end	
		
		local height = self.titleHeight + abilityHeight + hotkeyCount	
		self.footer:SetPoint("TOPLEFT",1,-height)
		self.footer:SetPoint("TOPRIGHT",-1,-height)
		height = height + self.footer:GetHeight() + 1 --	footer margin 
		self.frame:SetHeight(height)
	end,
	['DrawAbilities'] = function(self)				
		local bossColumn
		local currentSection
		--construct abilitySections
		for i=1, self.activeRotation.sectionCount do
			if not self.abilitySections[i] then
				local section = CreateFrame("Frame",nil,self.frame)
				section:SetPoint("LEFT",1,0)
				section:SetPoint("RIGHT",-1,0)					
				ADDON:SkinSection(section)
				self.abilitySections[i] = section
			end
			self.abilitySections[i]:Show()
		end
		for i=1, self.activeRotation.abilityCount do 			
			-- Construct New ability ---------------------------------------
			if not self.abilityRows[i] then				 		
				local row = CreateFrame("Frame",nil,self.frame)
				row:SetPoint("LEFT",3,0)
				row:SetPoint("RIGHT",-3,0)					
				row:SetHeight(self.rowHeight)
				row:SetScript("OnEnter", function(this,...)					
					self:ShowToolTip(row,"ANCHOR_TOPLEFT",0,2,row.toolTip,row.rotationToolTip)												
				end)
				row:SetScript("OnLeave", function(this,...)	GameTooltip:Hide() end)	
				local enable = CreateFrame('CheckButton', nil, row, "UICheckButtonTemplate")
				enable.toolTip = 'enable ability'						
				enable:SetPoint("BOTTOMLEFT",0, 0 )
				enable:SetSize(16,16)			
				enable:RegisterForClicks('LeftButtonDown')	
				enable:SetScript("OnEnter", function(this,...)					
					self:ShowToolTip(enable,"ANCHOR_TOPLEFT",0,2,enable.toolTip,enable.rotationToolTip)												
				end)
				enable:SetScript("OnLeave", function(this,...)	GameTooltip:Hide() end)	
				enable:SetScript('OnClick', function(this)				
					if this:GetChecked() then					
						self.activeRotationDB.sets[self.activeRotationDB.currentSet].abilities[i].enable = true
					else
						self.activeRotationDB.sets[self.activeRotationDB.currentSet].abilities[i].enable = false
					end
					self:UpdatePQRVariables()				
				end)						
				local boss = CreateFrame('CheckButton', nil, row, "UICheckButtonTemplate")	
				boss.toolTip = 'enable ability on boss only'							
				boss:SetPoint("BOTTOMLEFT",15, 2 )
				boss:SetSize(16,16)			
				boss:RegisterForClicks('LeftButtonDown')	
				boss:SetScript("OnEnter", function(this,...)					
					self:ShowToolTip(boss,"ANCHOR_TOPLEFT",0,2,boss.toolTip,boss.rotationToolTip)												
				end)
				boss:SetScript("OnLeave", function(this,...)	GameTooltip:Hide() end)	
				boss:SetScript('OnClick', function(this)
					if this:GetChecked() then					
						self.activeRotationDB.sets[self.activeRotationDB.currentSet].abilities[i].boss = true
					else
						self.activeRotationDB.sets[self.activeRotationDB.currentSet].abilities[i].boss = false
					end
					self:UpdatePQRVariables()		
				end)						
				local text = row:CreateFontString(nil,"OVERLAY",'PQIFont')				
				text:SetJustifyH("LEFT")				
				text:SetHeight(1)
				text:SetWordWrap(false)	
				text:SetPoint("BOTTOM",0,8)					 					
				local txtBox = CreateFrame('EditBox', nil, row)
				txtBox:SetAutoFocus(false)
				txtBox:ClearAllPoints()				
				txtBox:SetHeight(16)
				txtBox.defaultWidth = 40
				txtBox:SetHistoryLines(1)
				txtBox:SetJustifyH("CENTER")
				txtBox:SetJustifyV("CENTER")
				txtBox:SetTextInsets(0,0,2,0) 
				txtBox:SetPoint("BOTTOM",0,1)
				txtBox:SetPoint("RIGHT",-2,0)							
				txtBox:SetFontObject("PQIFont")
				txtBox:SetScript('OnEnterPressed',  function(this)
					this:ClearFocus()
					this:SetCursorPosition(0)
					if self.activeRotationDB.sets[self.activeRotationDB.currentSet].abilities[i].widget.type =='txtbox' then					
						self.activeRotationDB.sets[self.activeRotationDB.currentSet].abilities[i].value = this:GetText()
						self:UpdatePQRVariables()
					end					 
				end)				
				txtBox:SetScript('OnEscapePressed', function(this)
					this:ClearFocus()
					this:SetText(this.oldText)	
				end)
				txtBox:SetScript('OnEditFocusGained', function(this)
					GameTooltip:Hide()
					this.oldText = this:GetText()						
				end)
				txtBox:SetScript("OnEnter", function(this,...)					
					self:ShowToolTip(txtBox,"ANCHOR_TOPRIGHT",0,2,txtBox.toolTip,txtBox.rotationToolTip)												
				end)
				txtBox:SetScript("OnLeave", function(this,...)	GameTooltip:Hide() end)									
				local select = ADDON:CreateSelect(nil,row)					
				select:SetPoint("BOTTOM",-1,1)
				select:SetPoint("RIGHT",-2,-1)
				select.defaultWidth = 40
				select.frame:SetTextInsets(-3,13,1,0)									
				select:SetHeight(16)	
				select.button:SetAllPoints()					
				select:SetScript("OnValueChange", function(this,key,checked,selctionTable)
					if self.activeRotationDB.sets[self.activeRotationDB.currentSet].abilities[i].widget.type =='select' then											
						self.activeRotationDB.sets[self.activeRotationDB.currentSet].abilities[i].value = key
						self:UpdatePQRVariables()
					end
				end)
				select.button:SetScript("OnEnter", function(this,...)					
					self:ShowToolTip(this,"ANCHOR_TOPRIGHT",0,2,select.toolTip,select.rotationToolTip)												
				end)
				select.button:SetScript("OnLeave", function(this,...)	GameTooltip:Hide() end)					
											
				local numBox = ADDON:CreateNumBox(nil,row)
				numBox:SetHeight(16)
				numBox.defaultWidth = 40			
				numBox:SetTextInsets(0,0,2,0) 	
				numBox:SetPoint("BOTTOM",0,1)	
				numBox:SetPoint("RIGHT",-2,0)	
				numBox:SetScript('OnEnterPressed', function(this)
					if self.activeRotationDB.sets[self.activeRotationDB.currentSet].abilities[i].widget.type =='numbox' then										
						self.activeRotationDB.sets[self.activeRotationDB.currentSet].abilities[i].value = numBox:GetNumber()
						self:UpdatePQRVariables()
					end							
				end)	
				numBox:SetScript("OnMouseWheel", function(this,delta,...)								
							self.activeRotationDB.sets[self.activeRotationDB.currentSet].abilities[i].value = numBox:GetNumber()
							self:UpdatePQRVariables()
						end) 
				numBox:SetScript("OnEnter",function(this,...)
					numBox.toolTip = 'Mouse wheel:|cfffed200 Adjust value by '..numBox.step
					self:ShowToolTip(numBox.frame,"ANCHOR_TOPRIGHT",0,2,numBox.toolTip,numBox.rotationToolTip)												
				end)
				numBox:SetScript("OnLeave", function(this,...)
					GameTooltip:Hide()							
				end)
				------------------------------------------------------------			
				row.abilityNum			= i
				row.enable				= enable
				row.boss					= boss
				row.text					= text
				
				row.numBox				= numBox
				row.select				= select
				row.txtBox				= txtBox
				-- Skin ----------------------------------------------------
				ADDON:SkinNumBox(numBox)
				ADDON:SkinEditBox(txtBox)
				ADDON:SkinWidgetSelect(select)					
				-------------------------------------------------------------
				self.abilityRows[i] 	= row
			end
			----------------------------------------------------------------
			local ability = self.activeRotation.abilities[i]
			local widget = self.activeRotation.abilities[i].widget
			local row = self.abilityRows[i]			
			-- update sections ---------------------------------------------
			if i==1 then 
				currentSection = 1					
				row:SetPoint("TOP",3,-(self.titleHeight+3))	
				self.abilitySections[currentSection]:SetPoint("TOP",row,"TOP",0,3)
				self.abilitySections[currentSection]:SetHeight(self.rowHeight+7)				
			else
				if ability.newSection then					
					currentSection = currentSection + 1
					self.abilitySections[currentSection]:SetPoint("TOP",row,"TOP",0,-6)
					self.abilitySections[currentSection]:SetHeight(self.rowHeight+7) 
					row:SetHeight(self.rowHeight+9) -- 10 New section Gap Height
				else
					self.abilitySections[currentSection]:SetHeight(self.abilitySections[currentSection]:GetHeight()+self.rowHeight)
					row:SetHeight(self.rowHeight)
				end				
				row:SetPoint("TOP",self.abilityRows[i-1],"BOTTOM",0,0)					
			end 	
			-- reset Row ---------------------------------------------------						
			row.select:Hide()
			row.txtBox:Hide()
			row.numBox:Hide()
			row.boss:Hide()
			row.text:SetPoint("RIGHT",-4,0)				
			-- update Row ---------------------------------------------------
			row:Show()
			row.text:SetText(ability.name)			
			row.rotationToolTip = ability.tooltip					
			if ability.boss then 		
				bossColumn = true
				row.boss:Show()									
			end
			if widget then 			
				if widget.type =='txtbox' then 
					row.txtBox:Show()				
					row.txtBox.rotationToolTip = widget.tooltip
					if widget.width then
						row.txtBox:SetWidth(widget.width)
						row.text:SetPoint("RIGHT",-(widget.width +4),0)
					else
						row.txtBox:SetWidth(row.txtBox.defaultWidth)
						row.text:SetPoint("RIGHT",-(row.txtBox.defaultWidth+4),0)					
					end
				end				
				if widget.type =='select' then								
					row.select:Show()				
					row.select:SetList(widget.values)				
					row.select.rotationToolTip = widget.tooltip
					if ability.widget.width then
						row.select:SetWidth(widget.width)
						row.text:SetPoint("RIGHT",-(widget.width+8),0)
					else
						row.select:SetWidth(row.select.defaultWidth)
						row.text:SetPoint("RIGHT",-(row.select.defaultWidth+8),0)
					end
				end
				if widget.type =='numbox' then				
					row.numBox:Show()	
					row.numBox.step 	= widget.step or 1
					row.numBox.min 	= widget.min or 0
					row.numBox.max 	= widget.max or 100				
					row.numBox.rotationToolTip = widget.tooltip
					if widget.width then
						row.numBox:SetWidth(widget.width)
						row.text:SetPoint("RIGHT",-(widget.width+4),0)
					else
						row.numBox:SetWidth(row.numBox.defaultWidth)
						row.text:SetPoint("RIGHT",-(row.numBox.defaultWidth+4),0)
					end									
				end		
			end
		end
		if bossColumn then 
			for i = 1,self.activeRotation.abilityCount do			
				self.abilityRows[i].text:SetPoint("LEFT",34,0)
			end				
		else
			for i = 1,self.activeRotation.abilityCount do						
				self.abilityRows[i].text:SetPoint("LEFT",17,0)
			end
		end			
	end,		
	['DrawHotkeys'] = function(self)		
		if self.activeRotation.hotkeyCount < 1 then self.hotkeyContainer:SetHeight(-2) return end		
		for i = 1,self.activeRotation.hotkeyCount do 			
			if not self.hotkeyRows[i] then -- construct new hotkeyRow			
				local row = CreateFrame("Frame",nil,self.hotkeyContainer)
				row:SetHeight(26)
				row:SetScript("OnEnter", function(this,...)					
					self:ShowToolTip(row,"ANCHOR_TOPLEFT",16,-2,row.toolTip,row.rotationToolTip)												
				end)
				row:SetScript("OnLeave", function(this,...)	GameTooltip:Hide() end)										
				local enable = CreateFrame('CheckButton', nil, row, "UICheckButtonTemplate")	
				enable.toolTip = 'enable hotkey'								
				enable:SetPoint("TOPLEFT",-1, -3 ) 
				enable:SetSize(16,16)			
				enable:RegisterForClicks('LeftButtonDown')	
				enable:SetScript("OnEnter", function(this,...)					
					self:ShowToolTip(enable,"ANCHOR_TOPLEFT",0,2,enable.toolTip,enable.rotationToolTip)												
				end)
				enable:SetScript("OnLeave", function(this,...)	GameTooltip:Hide() end)	
				enable:SetScript('OnClick', function(this)
					if this:GetChecked() then					
						self.activeRotationDB.sets[self.activeRotationDB.currentSet].hotkeys[i].enable = true
					else
						self.activeRotationDB.sets[self.activeRotationDB.currentSet].hotkeys[i].enable = false
					end
					self:UpdatePQRVariables()
				end)	
				local text = row:CreateFontString(nil,"OVERLAY",'PQIFont')
				text:SetPoint("TOPLEFT",16,3)	text:SetPoint("BOTTOMRIGHT",-44,0)	 
				text:SetJustifyH("LEFT")
				text:SetWordWrap(false)				
				local hotkeySelect = ADDON:CreateSelect(nil,row,true)										
				hotkeySelect:SetPoint("TOP",0,-2)
				hotkeySelect:SetPoint("RIGHT",-1,0)
				hotkeySelect:SetWidth(40)
				hotkeySelect:SetHeight(16)	
				hotkeySelect.frame:SetTextInsets(-3,13,1,0)				
				hotkeySelect.button:SetAllPoints()					
				hotkeySelect:SetList( HOTKEY_LIST )
				hotkeySelect:SetScript("OnValueChange", function(this,key,checked,selctionTable)											
					self.activeRotationDB.sets[self.activeRotationDB.currentSet].hotkeys[i].keys = selctionTable					
					self:UpdatePQRVariables()				
				end)
				hotkeySelect.button:SetScript("OnEnter", function(this,...)					
					self:ShowToolTip(this,"ANCHOR_TOPRIGHT",0,2,hotkeySelect.toolTip,hotkeySelect.rotationToolTip)												
				end)
				hotkeySelect.button:SetScript("OnLeave", function(this,...)	GameTooltip:Hide() end)	
				-- construct -----------------------------------------
				row.enable				= enable				
				row.text					= text
				row.hotkeySelect		= hotkeySelect				
				-- Skin ----------------------------------------------				
				ADDON:SkinWidgetSelect(hotkeySelect)
				------------------------------------------------------
				self.hotkeyRows[i] 	= row
			end
			---------------------------------------------------------	
			local hotkey = self.activeRotation.hotkeys[i]
			local row = self.hotkeyRows[i]	
			-- update Row -------------------------------------------
			row:Show()
			row:SetPoint("TOPLEFT",3,-self.hotkeyContainerPaddingTop-((i-1)*self.rowHeight))
			row:SetPoint("TOPRIGHT",-3,-self.hotkeyContainerPaddingTop-((i-1)*self.rowHeight))	
			row.text:SetText(hotkey.name)				
			row.rotationToolTip = hotkey.tooltip			
		end
		self.hotkeyContainer:SetHeight(self.hotkeyContainerPaddingTop+self.hotkeyContainerPaddingBottom+(self.activeRotation.hotkeyCount*self.rowHeight))					
	end,	
	['UpdateRotation'] = function(self)		
		local currentSetDb = self.activeRotationDB.sets[self.activeRotationDB.currentSet]		
		-- Abilities	-------------------------------------------------		
		for i=1,self.activeRotation.abilityCount do 		
			local ability 		= self.activeRotation.abilities[i]
			local abilityDb	= currentSetDb.abilities[i]				
			local row			= self.abilityRows[i]
			local widget		= self.activeRotation.abilities[i].widget			
				
			row.enable:SetChecked(abilityDb.enable)
			row.boss:SetChecked(abilityDb.boss)
			if widget then 
				if widget.type == 'txtbox' then 
					row.txtBox:SetText(abilityDb.value)	
					row.txtBox:SetCursorPosition(0) 			
				end
				if widget.type == 'select' then
					row.select:SetValue(abilityDb.value)				
				end
				if widget.type == 'numbox' then					
					row.numBox:SetNumber(abilityDb.value)	
					row.numBox:SetCursorPosition(0) 					
				end
			end	
			if self.db.lock then				
				row.enable:EnableMouse(false)
				row.boss:EnableMouse(false) 
				row.txtBox:EnableMouse(false)
				row.numBox:EnableMouse(false)
				row.numBox:EnableMouseWheel(false)
				row:EnableMouse(false)
				row.select:EnableMouse(false)
			else				
				row.enable:EnableMouse(true)
				row.boss:EnableMouse(true) 	
				row.txtBox:EnableMouse(true)
				row.numBox:EnableMouse(true)
				row.numBox:EnableMouseWheel(true)
				row:EnableMouse(true)
				row.select:EnableMouse(true)
			end
		end 
		-- Hotkeys ----------------------------------------------------		
		for i=1,self.activeRotation.hotkeyCount do 			
			local hotkey 	= self.activeRotation.hotkeys[i]
			local hotkeyDb	= currentSetDb.hotkeys[i]				
			local row		= self.hotkeyRows[i]						
			row.enable:SetChecked(hotkeyDb.enable)						
			row.hotkeySelect:SetValues(hotkeyDb.keys)	
			if self.db.lock then
				row.enable:EnableMouse(false)				
				row:EnableMouse(false)
				row.hotkeySelect:EnableMouse(false)
			else
				row.enable:EnableMouse(true)				
				row:EnableMouse(true)
				row.hotkeySelect:EnableMouse(true)
			end			
		end
		-- footer ----------------------------------------------------
		local setsList = {}		
		for s=1, #self.activeRotationDB.sets do
			setsList[s] = self.activeRotationDB.sets[s].name
		end	
		self.setSelector:SetList( setsList )
		self.setSelector:SetValue( self.activeRotationDB.currentSet )
		-- Lock ----------------------------------------------------
		if self.db.lock then
			self.setSelector.frame:EnableMouse(false)
			self.lockButton.icon:SetTexCoord(0.25,.5,0,.25)
		else
			self.setSelector.frame:EnableMouse(true)
			self.lockButton.icon:SetTexCoord(0,.25,0,.25)
		end		
		self:UpdatePQRVariables()		
	end,	
	['UpdatePQRVariables'] = function(self)		
		--dump('PQI_RVUpdate',self.activeRotationDB.sets[self.activeRotationDB.currentSet])
		
		for buffer = 1, CVAR_RVBUFFER do 			
			if self.lastRotationUpdated == self.activeRotation.name or GetCVar('PQI_RVUpdate'..buffer) == '' then
				SetCVar('PQI_RVUpdate'..buffer,ADDON:Serialize(self.activeRotationDB.sets[self.activeRotationDB.currentSet]))
				break
			end			
		end		
		self.lastRotationUpdated = self.activeRotation.name		
	end,	
	['SetPosition'] = function(self)
		self:ClearAllPoints()
		
		if self.db.left and self.db.bottom then
			self:SetPoint("BOTTOMLEFT",self.db.left,self.db.bottom)
		else			
			self:ClearAllPoints()
			self:SetPoint("CENTER")
		end		
	end,
	['SavePosition'] = function(self)	
		self.db.left	= ADDON:Round(self:GetLeft())
		self.db.bottom	= ADDON:Round(self:GetBottom())		
		
		self:ClearAllPoints()		
		self:SetPoint("BOTTOMLEFT",self.db.left,self.db.bottom)
	end,	
	['Update'] = function(self)
		if not ADDON:IsEnabled() then return false end	
		if self.db.show then self:Show() else self:Hide() end
		ADDON:SetCVar('PQI_VarDebug',tostring(self.db.varDebug))				
		self:SetWidth(self.db.width)			
		self:SetPosition()									
	end,	
	['ShowToolTip'] = function(self,anchor,anchorType,xOffset,yOffset,toolTip,rotationToolTip)
		
		if not self.db.toolTips and not self.db.rotationToolTips then return end	
		if not toolTip and not rotationToolTip then return end
			
		GameTooltip:SetOwner(anchor, anchorType , xOffset, yOffset) 
		if rotationToolTip and self.db.rotationToolTips then GameTooltip:AddLine(rotationToolTip,ADDON.colors.purple[1],ADDON.colors.purple[2],ADDON.colors.purple[3],true) end	
		if toolTip and self.db.toolTips then GameTooltip:AddLine(toolTip,ADDON.colors.blue[1],ADDON.colors.blue[2],ADDON.colors.blue[3])	end
		GameTooltip:Show()
	end,	
	['RenameSet'] = function(self,rename)
		local oldName = self.setSelector.oldText
		local newName = self.setSelector:GetText()	
		if rename then
			if newName == "" then
				ADDON:Print("Invalid Name")								
			else
				ADDON:Print(format("|cff00aaff%s |rrenamed to |cff00aaff%s",oldName,newName))				 
				ADDON.rotationConfig.activeRotationDB.sets[ADDON.rotationConfig.activeRotationDB.currentSet].name = newName
			end
		else
			ADDON.rotationConfig.activeRotationDB.sets[ADDON.rotationConfig.activeRotationDB.currentSet].name = oldName			
		end
		ADDON.rotationConfig:UpdateRotation()	
		--popup:Hide()	
	end,
	['DatabaseUpdate'] = function(self)
		for i = 1, #self.rotations do
			self:AddRotationDB(self.rotations[i])			
		end
		if #self.rotations > 0 then self:SetActiveRotation(self.activeRotationNum) end
	end,
}
----[[ rotationConfig Constructor ]]-----------------------------------------------------------------------------------------------
function ADDON:ConstructRotationConfig()	
	local rotationConfig = CreateFrame("Button",nil,UIParent)  -- Title Bar
	---- Settings ---------------------------------------------------------------
	rotationConfig.rowHeight 								= 19
	rotationConfig.titleHeight								= 20	
	rotationConfig.hotkeyContainerPaddingTop			= 2	
	rotationConfig.hotkeyContainerPaddingBottom		= 4
	-----------------------------------------------------------------------------		
	rotationConfig:SetFrameStrata('MEDIUM')
	rotationConfig:SetFrameLevel(100)	
	rotationConfig:SetHeight(rotationConfig.titleHeight) 
	rotationConfig:SetMovable(true)
	rotationConfig:EnableMouse(true)	
	rotationConfig:EnableMouseWheel(true)	
	rotationConfig:RegisterForDrag("LeftButton")	
	rotationConfig:SetButtonState("pushed", true)
	rotationConfig:SetPushedTextOffset(0,-1)	
	rotationConfig:SetNormalFontObject(PQIFont) 	
	rotationConfig:SetText('No Configurations Loaded')		
	rotationConfig:SetScript("OnDragStart", function(this,button)
		GameTooltip:Hide()				
		rotationConfig:StartMoving()		
	end)
	rotationConfig:SetScript("OnDragStop", function(this,...)		
		rotationConfig:StopMovingOrSizing()
		rotationConfig:SavePosition()	
	end) 
	rotationConfig:SetScript("OnMouseWheel", function(this,delta)
		if not rotationConfig.db.mouseWheel then return end		
		if delta > 0 then		
			delta = min(this.db.width + 10, 600 ) -- mays well recycle delta as its orignal value is no longer needed
		else
			delta = max(this.db.width - 10, 200 )
		end
		rotationConfig.db.width = delta
		AceConfigRegistry:NotifyChange(AddOnName)	
		rotationConfig:Update()	
	end) 
	rotationConfig:SetScript("OnDoubleClick", function(this)		
		GameTooltip:Hide()		
		rotationConfig.db.show = false
		AceConfigRegistry:NotifyChange(AddOnName)			
		rotationConfig:Update()		
	end) 	
	rotationConfig:SetScript("OnEnter", function(this,...)
		if not rotationConfig.db.toolTips then return end		
		GameTooltip:SetOwner(rotationConfig, "ANCHOR_TOP",0,2) 	
		GameTooltip:AddLine('Rotation Configurator',0,.66,1)		
		GameTooltip:AddLine(' ')
		if rotationConfig.menuActive then 
		  GameTooltip:AddDoubleLine("Right Click:","Rotation Selector", 0, .66, 1, 1, .83, 0)
		end
		GameTooltip:AddDoubleLine("DoubleClick:","Close Window", 0, .66, 1, 1, .83, 0)	
		GameTooltip:AddDoubleLine("Mouse Wheel:","Adjust Width", 0, .66, 1, 1, .83, 0)		
		GameTooltip:Show()												
	end)
	rotationConfig:SetScript("OnLeave", function(this,...)	GameTooltip:Hide() end)
	rotationConfig:SetScript("OnMouseUp", function(this,button)		
		if not rotationConfig.menuActive then return false end
		if button ~='RightButton' then return end
		rotationConfig.menu:ClickSelectedMenuItem()	
	end)	
	rotationConfig:SetScript("OnMouseDown", function(this,button)		
		if not rotationConfig.menuActive then return false end
		if button ~='RightButton' then return end				
		rotationConfig.menu:Show()
	end)	
	rotationConfig.tooltip = 'Right Click:|cfffed200 Configuration Variables \n|rDouble Click:|cfffed200 Lock Configuration'	
	
	local frame = CreateFrame("Frame",nil,rotationConfig)	
	frame:SetFrameLevel(rotationConfig:GetFrameLevel()-10)		
	frame:SetPoint('TOPRIGHT')
	frame:SetPoint('TOPLEFT')
	frame:SetHeight(rotationConfig.titleHeight)	
	local menu = ADDON:CreateMenu(nil,rotationConfig)
	--menu:SetMenu(menuData)
	menu:Hide()	
	
	local nextButton = CreateFrame("Button",nil,rotationConfig)	
	nextButton:SetSize(rotationConfig.titleHeight,rotationConfig.titleHeight)
	nextButton:SetPoint("TOPRIGHT",0,0)
	nextButton:SetScript("OnMouseDown", function(this,...)
		if rotationConfig.activeRotationNum >= #rotationConfig.rotations then
			rotationConfig:SetActiveRotation(1)
		else
			rotationConfig:SetActiveRotation(rotationConfig.activeRotationNum+1)
		end		
	end) 
	nextButton:SetScript("OnEnter", function(this,...)					
		rotationConfig:ShowToolTip(nextButton,"ANCHOR_TOPRIGHT",0,2,nextButton.toolTip)												
	end)
	nextButton:SetScript("OnLeave", function(this,...)	GameTooltip:Hide() end)	
	nextButton:Hide()	
	nextButton.toolTip = 'Next configuration'		
	nextButton.icon = nextButton:CreateTexture(nil, 'ARTWORK')
	nextButton.icon:SetSize(12,10)
	nextButton.icon:SetPoint('CENTER',1,0)
	nextButton.icon:SetTexture([[Interface\Buttons\SquareButtonTextures]])
	nextButton.icon:SetTexCoord(0.01562500, 0.20312500, 0.01562500, 0.20312500)	
	SquareButton_SetIcon(nextButton, 'RIGHT')		
	local prevButton = CreateFrame("Button",nil,rotationConfig)	
	prevButton:SetSize(rotationConfig.titleHeight,rotationConfig.titleHeight)
	prevButton:SetPoint("TOPLEFT",0,0)		
	prevButton:SetScript("OnMouseDown", function(this,...)
		if rotationConfig.activeRotationNum <= 1 then
			rotationConfig:SetActiveRotation(#rotationConfig.rotations)
		else
			rotationConfig:SetActiveRotation(rotationConfig.activeRotationNum-1)
		end	
	end) 
	prevButton:SetScript("OnEnter", function(this,...)					
		rotationConfig:ShowToolTip(prevButton,"ANCHOR_TOPLEFT",0,2,prevButton.toolTip)												
	end)
	prevButton:SetScript("OnLeave", function(this,...)	GameTooltip:Hide() end)	
	prevButton:Hide()
	prevButton.toolTip = 'Previous configuration'		
	prevButton.icon = prevButton:CreateTexture(nil, 'ARTWORK')
	prevButton.icon:SetSize(12,10)
	prevButton.icon:SetPoint('CENTER',-1,0)
	prevButton.icon:SetTexture([[Interface\Buttons\SquareButtonTextures]])
	prevButton.icon:SetTexCoord(0.01562500, 0.20312500, 0.01562500, 0.20312500)	
	SquareButton_SetIcon(prevButton, 'LEFT')
		
	local hotkeyContainer = CreateFrame("Frame",nil,frame)		
	local footer = CreateFrame("Frame",nil,frame)		
	footer:SetHeight(22)		
	local setSelector = ADDON:CreateSelect(nil,footer)		
	setSelector:SetPoint("TOPLEFT",20,-3)
	setSelector:SetPoint("RIGHT",-3,-1)	
	setSelector:SetHeight(16)		
	setSelector:SetScript("OnValueChange", function(self,key,checked,selectionTable)
		self.obj.activeRotationDB.currentSet = key	
		self.obj:UpdateRotation()				
	end)	
	setSelector.frame:EnableMouse(true)
	setSelector.frame:HookScript("OnEnterPressed", function(this)
		if setSelector.oldText ~= 	setSelector:GetText() then StaticPopup_Show ("ACP_RENAMESET")	end	
	end)		
	setSelector.frame.toolTip = '|cff00aaffDouble Click:|cfffed200 Rename Set'	
	setSelector.obj = rotationConfig		
	
	local lockButton = CreateFrame("Button",nil,footer)
	lockButton.toolTip = '|cff00aaffRight Click:|cfffed200 Configuration Variables \n|cff00aaffDouble Click:|cfffed200 Lock Configuration'			
	lockButton:SetSize(16,16)	
	lockButton:SetNormalFontObject(PQIFont) 	
	lockButton:SetPoint("TOPLEFT",3,-3)
	lockButton:RegisterForClicks("RightButtonUp","LeftButtonUp")
	lockButton:SetScript("OnClick",function(this, button,...) 
		if button == 'LeftButton' then return end		
		if rotationConfig.codeWindow:IsShown() then
		rotationConfig.codeWindow:Hide() 
		else
		rotationConfig.codeWindow:Show()	
		end
		rotationConfig:DrawVariables()
	end)
	lockButton:SetScript("OnDoubleClick", function(self, button,...)	
		if button == 'RightButton' then return end
		rotationConfig.db.lock = not rotationConfig.db.lock
		rotationConfig:UpdateRotation()
	end) 
	lockButton:SetScript("OnEnter", function(this,...)					
		rotationConfig:ShowToolTip(lockButton,"ANCHOR_TOPLEFT",0,2,lockButton.toolTip)												
	end)
	lockButton:SetScript("OnLeave", function(this,...)	GameTooltip:Hide() end)			
	local codeWindow = CreateFrame("Frame", nil, UIParent)
	codeWindow:SetSize(600, 500)
	codeWindow:SetPoint('CENTER')
	codeWindow:Hide()
	codeWindow:EnableMouse(true)
	codeWindow:SetFrameStrata("DIALOG")
	codeWindow.title = CreateFrame("Button",nil,codeWindow)
	codeWindow.title:SetText('Rotation Variables')
	codeWindow.title:SetNormalFontObject(PQIFont) 	
	codeWindow.title:SetPoint("TOPLEFT",0,0)
	codeWindow.title:SetPoint("TOPRIGHT",0,0)
	codeWindow.title:SetHeight(22)
	codeWindow.title:EnableMouse(false)
	codeWindow.closeButton = CreateFrame("Button",nil,codeWindow.title)
	codeWindow.closeButton:SetSize(22,22)
	codeWindow.closeButton:SetPoint("TOPRIGHT",0,0)	
	codeWindow.closeButton:SetText('|cffffd300X')
	codeWindow.closeButton:SetNormalFontObject(PQIFont) 	
	codeWindow.closeButton:SetScript("OnMouseDown", function(this,...)
		codeWindow:Hide()
	end) 	
	codeWindow.closeButton:SetScript("OnLeave", OnLeave) 
	codeWindow.closeButton.obj = rotationConfig		
	codeWindow.scrollArea = CreateFrame("ScrollFrame", 'codeWindow', codeWindow, "UIPanelScrollFrameTemplate")	
	codeWindow.scrollArea:SetPoint("TOPLEFT", codeWindow, "TOPLEFT", 1, -29)
	codeWindow.scrollArea:SetPoint("BOTTOMRIGHT", codeWindow, "BOTTOMRIGHT", -25, 11)	
	codeWindow.editBox = CreateFrame("EditBox", nil, codeWindow)
	codeWindow.editBox:SetMultiLine(true)
	codeWindow.editBox:SetMaxLetters(99999)
	codeWindow.editBox:EnableMouse(true)
	codeWindow.editBox:SetAutoFocus(false)	
	codeWindow.editBox:SetFontObject('PQIFont')
	codeWindow.editBox:SetTextInsets(8,8,0,0)	
	codeWindow.editBox:SetWidth(codeWindow.scrollArea:GetWidth())	
	codeWindow.editBox:SetScript("OnEscapePressed", function() codeWindow:Hide() end)
	codeWindow.scrollArea:SetScrollChild(codeWindow.editBox)	
	-----------------------------------------------------------------------
	rotationConfig.frame										= frame
	rotationConfig.menu										= menu	                                                                   
	rotationConfig.nextButton				            = nextButton                                                          
	rotationConfig.prevButton				            = prevButton 
	rotationConfig.lockButton				            = lockButton                                                          
	rotationConfig.hotkeyContainer		            = hotkeyContainer                                                     
	rotationConfig.footer					            = footer                                                              
	rotationConfig.setSelector				            = setSelector                                                         
	rotationConfig.codeWindow				            = codeWindow                                                          
	                                                                                                                      
	rotationConfig.rowCount					            = 0	--active row count not total rows drawn and hidden              
	rotationConfig.abilitySections		            = {}  --recyclable frames                                             
	rotationConfig.abilityRows				            = {} 	--recyclable frames                                             
	rotationConfig.hotkeyRows				            = {}	--recyclable frames                                             
	rotationConfig.activeRotation			            = {} 	                                                                 
	rotationConfig.activeRotationDB		            = {}                                                                  
	rotationConfig.rotations				            = {}                                                             
	
	rotationConfig.db 										= self.db.profile.rotationConfig	
	-----------------------------------------------------------------------
	for method, func in pairs(methods) do
		rotationConfig[method] = func
	end
	-----------------------------------------------------------------------
	ADDON:SkinRotationConfig(rotationConfig)	
	ADDON:SkinButtonLock(lockButton)	
	ADDON:SkinMenu(menu)
	ADDON:SkinButton(prevButton)
	ADDON:SkinButton(nextButton)
	ADDON:SkinButton(codeWindow.closeButton)
	ADDON:SkinSetSelect(setSelector)
	
	-----------------------------------------------------------------------
	--rotationConfig.db.rotations = {} -- wipe Database	
	rotationConfig:Update()		
	return rotationConfig	
end
