----[[ Ini ]]------------------------------------------------------------------------------------------------------------------
local AddOnName, Env = ... local ADDON = Env[1] 
local D = ADDON.development
----[[ Ace Ini ]]--------------------------------------------------------------------------------------------------------------
local AceConfigRegistry	= LibStub("AceConfigRegistry-3.0")
----[[ Lua Ini ]]--------------------------------------------------------------------------------------------------------------
local select, unpack						= select, unpack
local type	 								= type
local sub, find, format 				= string.sub, string.find, string.format
local floor, ceil, min, max			= math.floor, math.ceil, math.min, math.max
----[[ WoW Ini ]]--------------------------------------------------------------------------------------------------------------
local GetSpellInfo, GetTime  = GetSpellInfo, GetTime


----[[ Locals ]]---------------------------------------------------------------------------------------------------------------
local function constructTextField(name,text,parent,anchor,width,header)
	parent[name] = parent:CreateFontString(nil,"OVERLAY",'PQIFont')
	parent[name]:SetText(text)
	parent[name]:SetJustifyH("LEFT")
	parent[name]:SetWordWrap(false)	
	parent[name]:SetWidth(width)	
	if header then
		parent[name]:SetTextColor(unpack(ADDON.colors.blue))
		if name == 'field1' then parent[name]:SetPoint("TOPLEFT",anchor,"TOPLEFT",25,-4) 
		else parent[name]:SetPoint("LEFT",anchor,"RIGHT",6,0) end	
	else
		if name == 'field1' then parent[name]:SetPoint("TOPLEFT",anchor,"TOPRIGHT",5,-5) 
		else parent[name]:SetPoint("LEFT",anchor,"RIGHT",6,0) end
	end	
end
----[[ AbilityLog Scripts ]]---------------------------------------------------------------------------------------------------
local function row_OnEnter(self,...)
	self.TTShow = true
	self.obj:UpdateTT()	
end
local function row_OnLeave(self,...)
	self.TTShow = false
	GameTooltip:Hide()	
end
----[[ AbilityLog Methods ]]---------------------------------------------------------------------------------------------------
local methods = {	
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
		--adjust height	
		self.frame:SetHeight(((self.rowHeight+1)*self.db.rows) + self.titleHeight + 1)	
		ADDON.abilitiesLog:SetCache(self.db.rows)		
		-- update rows			
		self:DrawRows()
		self:SetPosition()
		self:RowsMouseEnabled(self.db.tooltips)
		self:RefreshData(ADDON.abilitiesLog)		
	end,
	['UpdateTT'] = function(self)
		if not self.db.tooltips then return end
		local data
		for i=1,self.db.rows do			
			if self.content['row'..i].TTShow and self.content['row'..i].data then data = self.content['row'..i].data break end				
		end
		if not data then return end			
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR" , 0, 0)		
		GameTooltip:AddDoubleLine("Spell:",data.spell, 0, .66, 1, 1, 1,1)
		GameTooltip:AddDoubleLine("SpellID:",data.spellID, 0, .66, 1, 1, 1,1)
		GameTooltip:AddDoubleLine("Ability:",data.abilityName, 0, .66, 1, 1, 1,1)
		GameTooltip:AddDoubleLine("Rotation:",format("%s|cff00aaff %s",data.rotation,data.author), 0, .66, 1, 1, 1,1)	
		GameTooltip:AddDoubleLine("PQR Mode:",data.mode, 0, .66, 1, 1, 1,1)
		GameTooltip:AddDoubleLine("Execute Count:",data.executeCount, 0, .66, 1, 1, 1,1)		
		GameTooltip:Show()
	end,
	['DrawRows'] = function(self)			
		if self.drawnRows < self.db.rows then  -- need to draw more rows
			for i=1, self.db.rows do
				if i > self.drawnRows then -- create a new row
					self:ConstructRow(i)
					self.drawnRows = i					
				end
			end
		elseif self.drawnRows > self.db.rows then -- need to hide rows
			for i=1, self.drawnRows do
				if i > self.db.rows then -- hide row
					self.content['row'..i]:Hide()					
				else -- make sure row is visible									
					self.content['row'..i]:Show()			
				end				
			end
		else 			
			self.content['row'..self.drawnRows]:Show()					
		end		
	end,
	['ConstructRow'] = function(self,rowNumber)
		--if self.content['row'..rowNumber] then self.content['row'..rowNumber]:Show() return end
		self.content['row'..rowNumber] = CreateFrame("Frame",nil,self.content)
		local row = self.content['row'..rowNumber]
		if rowNumber % 2 == 0 then row.even = true end
		row:SetHeight(self.rowHeight)		
		row:SetPoint("LEFT",0,0) row:SetPoint("RIGHT",0,0)
		if rowNumber==1 then	row:SetPoint("TOP",0,0)
		else row:SetPoint("TOP",self.content['row'..rowNumber-1],"BOTTOM",0,-1)	end
		row.icon = row:CreateTexture(nil,'BORDER',0)
		row.icon:SetWidth(self.rowHeight)
		row.icon:SetPoint("TOPLEFT")
		row.icon:SetPoint("BOTTOMLEFT")
		row.icon:SetTexCoord(.08, .92, .08, .92)
		row.count = row:CreateFontString(nil,"OVERLAY",'PQIFont_pixel')
		row.count:SetPoint("CENTER",row.icon,"CENTER",1,1)
		row:EnableMouse(true)		
		row:SetScript("OnEnter", row_OnEnter) 
		row:SetScript("OnLeave", row_OnLeave)			
		
		constructTextField('field1',nil,row,row.icon,self.spellColoumnWidth)	
		constructTextField('field2',nil,row,row.field1,self.abilityColoumnWidth)
		constructTextField('field3',nil,row,row.field2,self.startColoumnWidth)
		constructTextField('field4',nil,row,row.field3,self.castColoumnWidth)		
		ADDON:SkinRow(row)
		row.obj = self
	end,
	['RefreshData'] = function(self)
		self:ClearData()		
		for i=1, self.db.rows do	
			local row = self.content['row'..i]
			if ADDON.abilitiesLog[i] then
				row.data = ADDON.abilitiesLog[i] 										
				row.icon:SetTexture(select(3,GetSpellInfo(row.data.spellID)))
				row.count:SetText(row.data.executeCount)
				row.field1:SetText(row.data.spell)
				row.field2:SetText(row.data.abilityName)				
				if row.data.mode =='manual' then
					local r,g,b = ADDON:Hex2Color('ffaa00') 
					row.field2:SetTextColor(r,g,b,1)
				else
					local r,g,b = ADDON:Hex2Color('00ff00') 
					row.field2:SetTextColor(r,g,b,1)
				end 
				row.field3:SetText(row.data.start)
				row.field4:SetText(row.data.castTime)				
			end
			--row.feild1
		end
		self:UpdateTT()	
	end,
	['ClearData'] = function(self,data)
		--dump("ablitylog",data)	
		for i=1, self.db.rows do
			if self.content['row'..i].data then 
				local row = self.content['row'..i]				
				row.icon:SetTexture(nil)
				row.count:SetText(nil)
				row.field1:SetText(nil)
				row.field2:SetText(nil)
				row.field3:SetText(nil)
				row.field4:SetText(nil)
				row.data = nil
			end		
		end	
	end,
	['RowsMouseEnabled'] = function(self,enable)		
		for i=1, self.drawnRows do
			self.content['row'..i]:EnableMouse(enable)			
		end		
	end,		
}
----[[ AbilityLog Constructor ]]-----------------------------------------------------------------------------------------------
function ADDON:ConstructLog()
	local abilityLog = CreateFrame("Button",nil,UIParent)	
	--- Settings --------------------------------------------------------------------
	abilityLog.width 					= 560	
	abilityLog.titleHeight 			= 20
	abilityLog.rowHeight 			= 19	
	abilityLog.spellColoumnWidth 	= 150	-5
	abilityLog.abilityColoumnWidth= 200 -5
	abilityLog.startColoumnWidth 	= 90	-5
	abilityLog.castColoumnWidth 	= 90	-5		
	-----------------------------------------------------------------------------	
	abilityLog:SetFrameStrata('MEDIUM')
	abilityLog:SetFrameLevel(50)
	abilityLog:SetSize(abilityLog.width,abilityLog.titleHeight )
	abilityLog:SetMovable(true)
	abilityLog:EnableMouse(true)	
	abilityLog:EnableMouseWheel(true)	
	abilityLog:RegisterForDrag("LeftButton")			
	abilityLog:SetScript("OnDragStart", function(this,button)
		GameTooltip:Hide()			
		abilityLog:StartMoving()		
	end)
	abilityLog:SetScript("OnDragStop", function(this,...)
		abilityLog:StopMovingOrSizing()
		abilityLog:SavePosition()	
	end) 
	abilityLog:SetScript("OnMouseWheel", function(this,delta)
			--ADDON.options.args.general.args.rows.min = 10
		--ADDON.options.args.general.args.rows.max = 40	
		if not abilityLog.db.mouseWheel then return end
		if delta > 0 then	
			delta = max(abilityLog.db.rows - 1, 10 )		
		else
			delta = min(abilityLog.db.rows + 1, 40 ) -- mays well recycle delta as its orignal value is no longer needed
		end
		abilityLog.db.rows = delta
		abilityLog:Update()
		AceConfigRegistry:NotifyChange(AddOnName)	
	end) 
	abilityLog:SetScript("OnDoubleClick", function(this,button,...)
		GameTooltip:Hide()		
		abilityLog.db.show = false
		AceConfigRegistry:NotifyChange(AddOnName)			
		abilityLog:Update()
	end) 	
	abilityLog:SetScript("OnEnter", function(this,...)
		if not abilityLog.db.tooltips then return end		
		GameTooltip:SetOwner(abilityLog, "ANCHOR_TOP",0,2) 	
		GameTooltip:AddLine('Ability Log',0,.66,1)		
		GameTooltip:AddLine(' ')
		--GameTooltip:AddDoubleLine("Click:","Panel Menu", 0, .66, 1, 1, .83, 0)
		GameTooltip:AddDoubleLine("DoubleClick:","Close Window", 0, .66, 1, 1, .83, 0)	
		GameTooltip:AddDoubleLine("Mouse Wheel:","Adjust Height", 0, .66, 1, 1, .83, 0)		
		GameTooltip:Show()												
	end)
	abilityLog:SetScript("OnLeave", function(this,...)	GameTooltip:Hide() end)		
	
	local frame = CreateFrame("Frame",nil,abilityLog)	
	frame:SetFrameLevel(abilityLog:GetFrameLevel()-10)
	frame:SetPoint('TOPRIGHT')
	frame:SetPoint('TOPLEFT')		
	
	constructTextField('field1',"Spell",abilityLog,abilityLog,abilityLog.spellColoumnWidth,true)
	constructTextField('field2',"Ability Name",abilityLog,abilityLog.field1,abilityLog.abilityColoumnWidth,true)
	constructTextField('field3',"Start Time",abilityLog,abilityLog.field2,abilityLog.startColoumnWidth,true)
	constructTextField('field4',"Cast Time",abilityLog,abilityLog.field3,abilityLog.castColoumnWidth,true)
	
	local content = CreateFrame("Frame",nil, frame)
	content:SetPoint("TOPLEFT",1,-abilityLog.titleHeight 	)
	content:SetPoint("BOTTOMRIGHT",-1,1) 	
	
	------------------------------------------------------------------------------
	abilityLog.frame 					= frame	
	abilityLog.content 				= content
		
	abilityLog.db 						= self.db.profile.abilityLog	
	abilityLog.drawnRows				= 0
	-----------------------------------------------------------------------------
	for method, func in pairs(methods) do
		abilityLog[method] = func
	end
	--- Skin --------------------------------------------------------------------
	ADDON:SkinAblityLog(abilityLog)
	--- Initialize --------------------------------------------------------------	
	abilityLog:Update()	
	
	return abilityLog	
end

