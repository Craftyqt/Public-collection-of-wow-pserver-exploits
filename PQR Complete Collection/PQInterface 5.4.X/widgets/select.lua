---[[ Ini ]]------------------------------------------------------------------------------------------------------------------
local AddOnName, Env = ...
local ADDON = Env[1] 
local D = ADDON.development
----[[ Ace Ini ]]--------------------------------------------------------------------------------------------------------------

----[[ Lua Ini ]]--------------------------------------------------------------------------------------------------------------
local select, unpack						= select, unpack
local type	 								= type
local sub, find, format 				= string.sub, string.find, string.format
local floor, ceil, min, max			= math.floor, math.ceil, math.min, math.max
----[[ WoW Ini ]]--------------------------------------------------------------------------------------------------------------
local GetSpellInfo, GetTime  = GetSpellInfo, GetTime

----[[ Locals ]]---------------------------------------------------------------------------------------------------------------
local selectPool = {}

----[[ SelectItem Methods ]]---------------------------------------------------------------------------------------------------
local methods = {
	['SetSelected'] = function(self,selected)				
		if selected then 
			self.selected = true
			self.check:Show()
		else
			self.selected = false
			self.check:Hide()
		end	
	end,
	['SetText'] = function(self,...)				
		self.text:SetText(...)	
	end,
}
----[[ SelectItem Construct ]]-------------------------------------------------------------------------------------------------
local function CreateSelectItem(select,index)	
	local selectItem = CreateFrame("Button", nil,select.pullout)	
	selectItem:SetHeight(select.itemHeight)
	selectItem:SetFrameStrata("FULLSCREEN_DIALOG")
	selectItem:SetScript("OnEnter", function(self,...)	self.highlight:Show() end)
	selectItem:SetScript("OnLeave", function(self,...) self.highlight:Hide() end)
	selectItem:SetScript("OnClick", function(self, button, down)			
		local selectionTable = {}
		if select.multiSelect then		
			self:SetSelected(not self.selected)	
			local text
			for i=1,#select.selectItems do
				if select.selectItems[i].selected then
					if text then
						text = text..','..select.selectItems[i].value
					else 
						text = select.selectItems[i].value
					end				
					selectionTable[#selectionTable+1] = select.selectItems[i].key
				end
			end
			select:SetText(text)	
		else
			for i=1,#select.selectItems do
				select.selectItems[i]:SetSelected(false)
			end
			self:SetSelected(true)
			select:SetText(self.value)
			selectionTable = {self.key}
			if select.open then 
				select.pullout:Hide()
				select.open = false
			end 	
		end
		if select.scripts.OnValueChange then select.scripts.OnValueChange(select,self.key,self.selected,selectionTable) end
	end)	
	selectItem:Hide()
	selectItem.obj = select	
	if index == 1 then
		selectItem:SetPoint("TOPLEFT",select.pullout,"TOPLEFT",0,-6)
		selectItem:SetPoint("TOPRIGHT",select.pullout,"TOPRIGHT",0,-6)
	else
		selectItem:SetPoint("TOPLEFT",select.selectItems[index-1],"BOTTOMLEFT",0,0)
		selectItem:SetPoint("TOPRIGHT",select.selectItems[index-1],"BOTTOMRIGHT",0,0)
	end	
	local text = selectItem:CreateFontString(nil,"OVERLAY","PQIFont")
	text:SetTextColor(1,1,1)
	text:SetJustifyH("LEFT")
	text:SetPoint("TOPLEFT",selectItem,"TOPLEFT",14,0)
	text:SetPoint("BOTTOMRIGHT",selectItem,"BOTTOMRIGHT",-6,0)	

	local highlight = selectItem:CreateTexture(nil, "OVERLAY")
	highlight:SetTexture(1,1,1,.2)
	highlight:SetBlendMode("ADD")
	highlight:SetHeight(select.itemHeight)
	highlight:ClearAllPoints()
	highlight:SetPoint("RIGHT",selectItem,"RIGHT",-5,0)
	highlight:SetPoint("LEFT",selectItem,"LEFT",5,0)
	highlight:Hide()	

	local check = selectItem:CreateTexture("OVERLAY")	
	check:SetWidth(select.itemHeight-1)
	check:SetHeight(select.itemHeight-1)
	check:SetPoint("LEFT",selectItem,"LEFT",1,-1)
	check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
	check:Hide()
	-----------------------------------------------------------------------------	
	selectItem.text 		= text
	selectItem.highlight = highlight		
	selectItem.check 		= check	
	-----------------------------------------------------------------------------				
	for method, func in pairs(methods) do
		selectItem[method] = func
	end
	return selectItem
end
----[[ Select Methods ]]-------------------------------------------------------------------------------------------------------
local methods = {
	['SetSize'] = function(self,width,height)				
		self.frame:SetSize(width,height)
		self.button:SetWidth(height)
	end,
	['SetHeight'] = function(self,height)				
		self.frame:SetHeight(height)
		self.button:SetWidth(height)
	end,
	['SetWidth'] = function(self,width)				
		self.frame:SetWidth(width)		
	end,	
	['SetPoint'] = function(self,...)				
		self.frame:SetPoint(...)	
	end,
	['SetList'] = function(self,list,order)		
						
		self.list = list
		self.itemCount = 0		
		self:ClearItems()		
		if not list then return end
		local sortlist = {}
		
		if type(order) ~= "table" then
			for v in pairs(list) do
				sortlist[#sortlist + 1] = v
			end
			table.sort(sortlist)
			
			for i, key in ipairs(sortlist) do
				self.itemCount = i
				
				self:AddItem( {[key] = list[key]},'setList')
				sortlist[i] = nil
			end
		else
			
			for i, key in ipairs(order) do
				self.itemCount = i				
				self:AddItem( {[key] = list[key]},'setList')
			end
		end		
	end,	
	['AddItem'] = function(self,listItem,source)
		if source ~= 'setList' then self.itemCount = self.itemCount + 1 end 
			
		for i=1, self.itemCount do
			if not self.selectItems[i] then self.selectItems[i] = CreateSelectItem(self,i)	end -- create item		 	
			local selectItem = self.selectItems[i]
			if not selectItem:IsShown() then
				for key,value in pairs(listItem) do
					selectItem.key		= key
					selectItem.value	= value					
				end
				selectItem:SetText(selectItem.value) 
				selectItem:Show()				
			end	
		end
					
		self:UpdateSize()
	end,
	['ClearItems'] = function(self)				
		for i=1, #self.selectItems do
			local selectItem = self.selectItems[i] 
			selectItem:Hide()
			selectItem.key = nil
			selectItem.value = nil
			selectItem.selected = nil
		end			
	end,
	['SetValue'] = function(self,key)			
		if self.multiSelect then return end
		for i=1,#self.selectItems do
			self.selectItems[i]:SetSelected(false)			
			if self.selectItems[i].key == key then
				self.selectItems[i]:SetSelected(true)
				self:SetText(self.selectItems[i].value)				
			end
		end				
	end, 
	['SetValues'] = function(self,keyTable)	
		if not self.multiSelect or type(keyTable) ~='table' then return end
		local text
		for i=1,#self.selectItems do
			self.selectItems[i]:SetSelected(false)
			for k=1, #keyTable do			
				if self.selectItems[i].key == keyTable[k] then
					if text then
						text = text..','..self.selectItems[i].value
					else 
						text = self.selectItems[i].value
					end
					self.selectItems[i]:SetSelected(true)
				end
			end
			self:SetText(text)
		end				
	end,
	['SetScript'] = function(self,script,func)	
		self.scripts[script]	= func	
	end,
	['GetText'] = function(self,text)		
		return self.frame:GetText()		
	end,
	['SetText'] = function(self,text)		
		self.frame:SetText(text or '')	
		self.frame:SetCursorPosition(0)  -- make sure text is shown ????
		
		--.frame:SetJustifyH('RIGHT')		
		--D.Stack()
		--D.P(text)	
		--D.P(self.frame:GetText())	
		
	end,
	['UpdateSize'] = function(self)	
		self.pullout:SetHeight(self.pulloutTop+(self.itemCount*self.itemHeight)+self.pulloutBot)		
	end,
	['Show'] = function(self)	
		self.frame:Show()		
	end,
	['Hide'] = function(self)	
		self.frame:Hide()		
	end,		
	['EnableMouse'] = function(self,...)	
		self.button:EnableMouse(...)		
	end,	
}
----[[ Select Construct ]]-----------------------------------------------------------------------------------------------------
function ADDON:CreateSelect(name,parent,multiSelect)
	parent = parent or UIParent
	local select = {}	
	-- Default settings ---------------------------------
	select.anchorType 	= "ANCHOR_TOPRIGHT"
	select.xOffset 		= 0
	select.yOffset 		= 2
	select.pulloutTop		= 5
	select.itemHeight		= 14
	select.pulloutBot		= 5
	-----------------------------------------------------
	local frame = CreateFrame("EditBox",name,parent)
	frame:SetAutoFocus(false)	
	
	frame:EnableMouse(false)
	frame:SetJustifyH('RIGHT')		
	--frame:SetJustifyV("BOTTOM")	
	frame:SetTextInsets(0,18,1,0)						
	frame:SetFontObject("PQIFont")	
	frame:SetMultiLine(false)	
	frame:SetScript('OnEnterPressed',  function(this,...)
		GameTooltip:Hide()
		this:ClearFocus()		
	end)				
	frame:SetScript('OnEscapePressed', function(this,...)
		this:ClearFocus()	
		this:SetText(select.oldText)		
	end)
	frame:SetScript('OnEditFocusGained', function(this)		
		select.oldText = this:GetText()			
	end)
	frame:SetScript('OnEditFocusLost', function(this)			
			
	end)							
	local button = CreateFrame("Button",nil,frame)
	button:SetPoint('TOPRIGHT')
	button:SetPoint('BOTTOMRIGHT')
	button:SetScript("OnClick", function(self, button, down)
		frame:ClearFocus()		
		-- close any other widgets that may be open 
		for s=1,#selectPool do
			if selectPool[s] ~= self.obj then 
				local select = selectPool[s]				
				select.pullout:Hide()
				select.open = false						
			end
		end		
		if self.obj.open then 
			self.obj.pullout:Hide()
			self.obj.open = false
		else 
			self.obj.pullout:Show()
			self.obj.open = true		
		end	
	end)	
	button.obj = select	
	local pullout = CreateFrame("Frame",nil,frame)
	pullout:SetFrameStrata("FULLSCREEN_DIALOG")
	pullout:SetPoint('TOPRIGHT',frame,'BOTTOMRIGHT',0,-2)
	pullout:SetPoint('TOPLEFT',frame,'BOTTOMLEFT',0,-2)
	pullout:SetHeight(60)
	pullout:Hide()
	----------------------------------------------------
	select.multiSelect	= multiSelect
	select.open 			= false	
	select.itemCount 		= 0
	select.scripts			= {}
	select.list 			= {}
	select.selectItems	= {}		
	select.pullout			= pullout
	select.frame			= frame
	select.button 			= button	
	----------------------------------------------------
	for method, func in pairs(methods) do
		select[method] = func
	end
	----------------------------------------------------
	selectPool[#selectPool+1] = select
	return select	
end
