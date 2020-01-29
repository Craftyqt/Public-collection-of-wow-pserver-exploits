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
local rotation, ability, rotationMode

----[[ Interface Scripts ]]----------------------------------------------------------------------------------------------------
local function interface_OnEnter(self,...)
	if self.drag then return end	
	self.anchor,self.yOffset = ADDON:GetTTAnchor(self)	
	self.showTT = true
	self:UpdateTT()
end 
local function interface_OnLeave(self,...)
	self.showTT = false
	GameTooltip:Hide()
end
local function interface_OnMouseWheel(self,delta)	
	--ADDON.options.args.general.args.rows.min = 200
	--ADDON.options.args.general.args.rows.max = 600	
	--ADDON.options.args.general.args.rows.step = 10	
	
	if delta > 0 then		
		delta = min(ADDON.db.profile.interface.width + 10, 600 ) -- mays well recycle delta as its orignal value is no longer needed
	else
		delta = max(ADDON.db.profile.interface.width - 10, 200 )
	end
	ADDON.db.profile.interface.width = delta
	self:Update()
	AceConfigRegistry:NotifyChange(AddOnName)	
end
local function customText_OnTimer(self)
	UIFrameFadeOut(self.text, 1, 1, 0)	
end


----[[ Interface Methods ]]----------------------------------------------------------------------------------------------------
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
		self.db.left		= ADDON:Round(self:GetLeft())
		self.db.bottom		= ADDON:Round(self:GetBottom()) 
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT",self.db.left,self.db.bottom)
	end,
	['Update'] = function(self)
		if not ADDON:IsEnabled() then return false end	
		if not self.db.customText then self.customText:Hide() end				
		self:SetSize(self.db.width,self.customText:IsVisible() and self.customTextHeight + 1 + self.statusBarHeight  or self.statusBarHeight )		
	
		self:SetPosition()		
		if not self.db.statusIconCount then self.statusIconCount:Hide() else self.statusIconCount:Show() end			
	end,	
	['UpdateTT'] = function(self)		
		if not self.showTT then return end		
		GameTooltip:SetOwner(self, self.anchor, 0, self.yOffset) 
		GameTooltip:AddLine('PQInterface Remote',0,.66,1)
		if ADDON.rotations and ADDON.rotations[1] then
			GameTooltip:AddLine(' ')
			GameTooltip:AddDoubleLine("Rotation 1:",format("%s|cff00aaff %s",ADDON.rotations[1].rotation,ADDON.rotations[1].author), 0, .66, 1, 1, 1,1)	
			GameTooltip:AddDoubleLine("Rotation 2:",format("%s|cff00aaff %s",ADDON.rotations[2].rotation,ADDON.rotations[2].author), 0, .66, 1, 1, 1,1)	
			GameTooltip:AddDoubleLine("Rotation 3:",format("%s|cff00aaff %s",ADDON.rotations[3].rotation,ADDON.rotations[3].author), 0, .66, 1, 1, 1,1)	
			GameTooltip:AddDoubleLine("Rotation 4:",format("%s|cff00aaff %s",ADDON.rotations[4].rotation,ADDON.rotations[4].author), 0, .66, 1, 1, 1,1)	
			GameTooltip:AddDoubleLine("Interrupt:" ,format("%s|cff00aaff %s",ADDON.rotations[5].rotation,ADDON.rotations[5].author), 0, .66, 1, 1, 1,1)	
		end
		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine("Right Click:","Panel Menu", 0, .66, 1, 1, .83, 0)
		GameTooltip:AddDoubleLine("Mouse Wheel:","Adjust Width", 0, .66, 1, 1, .83, 0)		
		GameTooltip:Show()
	end,
	['SetStatusText']	 = function(self,text,color)		
		if not text then return end  --fail silently		
		color = color or "red"  
		self.statusText:SetText(text)			
		self.statusText:SetTextColor(unpack(ADDON.colors[color]))			
	end,	
	['SetStatus'] = function (self,type,data)
		if 		type == 'ability' then
			if not data then return D.P('NO DATA')end			
			local modeColor = data.mode=="auto" and "00ff00" or data.mode=="manual" and "ffaa00" or data.mode=="interrupt" and "00a8ff"		
			self.statusText:SetFormattedText("|cff%s%s: |cffffffff%s",modeColor,data.rotation,data.abilityName)			
			self:SetStatusIconCount(1)				
			if data.spellID then self:SetStatusIcon(data.spellID == 0 and 4038 or data.spellID)	end			
		elseif	type == 'rotation' then						
			self.statusText:SetFormattedText("|cff00ff00%s: |cffffffff%s",data,'Running...')	
			self:SetStatusIcon(true)			
			self:SetStatusIconCount()
		elseif	type == 'ready' then 			
			self:SetStatusText("PQR: Ready","blue")		
			self:SetStatusIcon(true)	
		elseif	type == 'unloaded' then			
			self:SetStatusText("PQR: Unloaded","red")
			self:SetStatusIcon()						
		else --initialize
			self:SetStatusText("PQR: Not Loaded","red")
			self:SetStatusIcon()		
		end		
	end,
	['SetStatusIconCount'] = function(self,count)		
		self.statusIconCount:SetText(count==0 and nil or count)
	end,
	['SetStatusIcon'] = function(self,spellID,count)
		if spellID == true then 
			self:SetStatusIconCount()
			self.statusIcon.icon:SetTexCoord(0,.5625,0,.5625)
			self.statusIcon.icon:SetTexture(ADDON.mediaPath.."PQRIconOn")
			UIFrameFadeOut(self.statusIcon.iconOff, 1, self.statusIcon.iconOff:GetAlpha(), 0)		
		elseif type(spellID) == 'number'  then			 
			self.statusIcon.icon:SetTexCoord(.08, .92, .08, .92)
			self.statusIcon.icon:SetTexture(select(3,GetSpellInfo(spellID)))		
		else
			self:SetStatusIconCount()
			UIFrameFadeIn(self.statusIcon.iconOff, 1, self.statusIcon.iconOff:GetAlpha(), 1)			
		end		
	end,
	['SetInterrupt'] = function(self,on)		
		if on then			
			self.interrupt.icon:SetTexture(0,1,0,.4)		
		else 				
			self.interrupt.icon:SetTexture(1,0,0,.4)		
		end
	end,	
	['SetCustomText'] = function(self,text,color,fadeOut)		
		if not self.customText:IsVisible() then self.customText:Show() self:Update() end	
		color = color and ADDON:Pack(ADDON:Hex2Color(color)) or ADDON.colors.purple		
		UIFrameFadeRemoveFrame(self.customText.text)
		self.customText.text:SetTextColor(color[1],color[2],color[3])	
		self.customText.text:SetText(text)
		ADDON:CancelTimer(self.customText.timer, true)
		if fadeOut then		
			self.customText.timer = ADDON:ScheduleTimer(customText_OnTimer, (fadeOut and type(fadeOut)=="number" and fadeOut or 10),self.customText)	
		end
	end,	
}
----[[ Interface Constructor ]]---------------------------------------------------------------------------------------------------
function ADDON:ConstructInterface()
	local interface = CreateFrame("Button",nil,UIParent)
	---- Settings ---------------------------------------------------------------	
	interface.statusBarHeight	= 20
	interface.customTextHeight	= 14
	-----------------------------------------------------------------------------	
	interface:SetFrameStrata('HIGH')
	interface:SetFrameLevel(10)	
	interface:SetMovable(true)
	interface:EnableMouse(true)
	interface:EnableMouseWheel(true)	
	interface:RegisterForDrag("LeftButton")	
	interface:SetScript("OnMouseUp", function(this,button)		
		if button ~='RightButton' then return end
		interface.menu:ClickSelectedMenuItem()	
	end)	
	interface:SetScript("OnMouseDown", function(this,button)
		if button ~='RightButton' then return end
		interface.menu:Show()
	end)	
	interface:SetScript("OnDragStart", function(this,button)
		--D.P("OnDragStart",button,...)				
		interface.showTT = false
		GameTooltip:Hide()			
		interface.drag = true	
		interface:StartMoving()		
	end)
	interface:SetScript("OnDragStop", function(this)
			
		interface.drag = false
		interface:StopMovingOrSizing()
		interface:SavePosition()	
	end)	
	interface:SetScript("OnEnter", interface_OnEnter) 
	interface:SetScript("OnLeave", interface_OnLeave) 
	interface:SetScript("OnMouseWheel", interface_OnMouseWheel)
	local menuData = {
		{	name = 'Rotation Configurator',
			onClick = function(self)
				ADDON.db.profile.rotationConfig.show = not ADDON.db.profile.rotationConfig.show
				ADDON.rotationConfig:Update()
				AceConfigRegistry:NotifyChange(AddOnName)					
			end,
			checked = function(self) if ADDON.db.profile.rotationConfig.show then self.check:Show() else self.check:Hide() end end,
		},			
		{	name = 'Ability Log',onClick = function(self)
				ADDON.db.profile.abilityLog.show = not ADDON.db.profile.abilityLog.show
				ADDON.abilityLog:Update()	
				AceConfigRegistry:NotifyChange(AddOnName)							
			end,	
			checked = function(self) if ADDON.db.profile.abilityLog.show then self.check:Show() else self.check:Hide() end end,
		}
	}		
	local menu = ADDON:CreateMenu(nil,interface)
	menu:SetMenu(menuData)
	menu:Hide()
	
	local statusBar = CreateFrame("Frame",nil,interface)	
	statusBar:SetPoint("TOPLEFT",0,0)
	statusBar:SetPoint("TOPRIGHT",0,0)
	statusBar:SetHeight(interface.statusBarHeight)
	
	local statusIcon = CreateFrame("Frame",nil,statusBar)
	statusIcon:SetWidth(interface.statusBarHeight-2) 
	statusIcon:SetPoint("TOPLEFT",1,-1) 
	statusIcon:SetPoint("BOTTOMLEFT",-1,1)	
	statusIcon.icon = statusBar:CreateTexture(nil,'BACKGROUND')
	statusIcon.icon:SetAllPoints(statusIcon) 
	statusIcon.icon:SetTexCoord(.08, .92, .08, .92)	
	statusIcon.iconOff = statusBar:CreateTexture(nil,'BACKGROUND',nil,1)
	statusIcon.iconOff:SetAllPoints(statusIcon) 
	statusIcon.iconOff:SetTexCoord(0,.5625,0,.5625)
	statusIcon.iconOff:SetTexture(ADDON.mediaPath.."PQRIconOff")
	
	local statusIconCount = statusIcon:CreateFontString(nil,"OVERLAY",'PQIFont_pixel')
	statusIconCount:SetPoint("CENTER",1,1)		
	
	local interrupt = CreateFrame("Frame",nil,statusBar)
	interrupt:SetWidth(interface.statusBarHeight-2) 	
	interrupt:SetPoint("TOPRIGHT",-1,-1) 
	interrupt:SetPoint("BOTTOMRIGHT",-1,1)	
	interrupt.icon = interrupt:CreateTexture(nil,'BACKGROUND',-8)
	interrupt.icon:SetTexture(ADDON.mediaPath.."PQRLights")	
	interrupt.icon:SetAllPoints() 		
	
	local statusText = statusBar:CreateFontString(nil,"OVERLAY",'PQIFont')
	statusText:SetPoint("TOPLEFT",statusIcon,"TOPRIGHT",5,-4) 
	statusText:SetPoint("BOTTOMRIGHT",interrupt,"BOTTOMLEFT",-4,2)	
	statusText:SetJustifyH("LEFT")
	statusText:SetWordWrap(false)		
	
	local customText = CreateFrame("Frame",nil,interface)
	customText:SetPoint("TOPLEFT",3,-4 - interface.statusBarHeight )
	customText:SetPoint("TOPRIGHT",-3,-4 - interface.statusBarHeight )
	customText:SetHeight(interface.customTextHeight)	
	customText:Hide()
	customText.text = customText:CreateFontString(nil,"OVERLAY",'PQIFont')
	customText.text:SetPoint("BOTTOMLEFT",6,4) 
	customText.text:SetPoint("BOTTOMRIGHT",-4,4)
	customText.text:SetJustifyH("CENTER")
	customText.text:SetJustifyV("BOTTOM")
	customText.text:SetWordWrap(false)		
	-----------------------------------------------------------------------------
	interface.statusBar 			= statusBar	
	interface.menu 				= menu	
	interface.interrupt			= interrupt	
	interface.statusIcon 		= statusIcon
	interface.statusIconCount 	= statusIconCount	
	interface.statusText 		= statusText	
	interface.customText 		= customText
		
	interface.db 					= self.db.profile.interface		
	-----------------------------------------------------------------------------
	for method, func in pairs(methods) do
		interface[method] = func
	end	
	--- Skin --------------------------------------------------------------------
	ADDON:SkinInterface(interface)
	ADDON:SkinMenu(menu)
	--- Initialize --------------------------------------------------------------
	interface:Update()
	interface:SetStatus()	
	interface:SetInterrupt()
	
	return interface
end