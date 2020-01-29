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

----[[ Menu Methods ]]---------------------------------------------------------------------------------------------------------
local methods = {
	['xxx'] = function(self,...)				
			
	end,
	['SetMenu'] = function(self,menuData)
		self:ClearMenu()
		for i = 1,#menuData do
			if not self.menuItems[i] then self:AddMenuItem(i) end
			self:SetMenuItem(self.menuItems[i],menuData[i])		
		end
		self:SetHeight(self.paddingTop + (#menuData * self.menuItemHeight)  + self.paddingBottom)		
	end,
	['ClearMenu'] = function(self)
		for i = 1,#self.menuItems do
		
			self.menuItems[i].text:SetText()
			self.menuItems[i].checked = nil
		end		
	end,
	['RefreshMenu'] = function(self)
		for i = 1,#self.menuItems do		
			self.menuItems[i]:checked()
		end		
	end,
	['SetMenuItem'] = function(self,menuItem,menuItemData)		
		--menuItem:SetScript("OnClick", function(self)	menuData[i].onClick(self) end)
			
		menuItem.text:SetText(menuItemData.name)
		menuItem.checked	= menuItemData.checked
		menuItem.onClick	= menuItemData.onClick				
	end,
	['ClickSelectedMenuItem'] = function(self)		
		if self.selectedMenuItem then self.selectedMenuItem:onClick() end			
		self:Hide()
	end,		
	['AddMenuItem'] = function(self,index)			
		local menuItem = CreateFrame("Button",nil,self)
		menuItem:SetHeight(self.menuItemHeight)		
		menuItem:SetScript("OnEnter", function(this)	
			this.highlight:Show()
			self.selectedMenuItem = menuItem
		end)
		menuItem:SetScript("OnLeave", function(this)
			self.selectedMenuItem = nil
			this.highlight:Hide()
		end)
		menuItem:SetScript("OnReceiveDrag", function(this)	
			D.P("menuItem:SetScript(OnReceiveDrag")
			--menuData[i].onClick(self)
		end)				
		if index==1 then
			menuItem:SetPoint("TOPLEFT",self,"TOPLEFT",0,-self.paddingTop)
			menuItem:SetPoint("TOPRIGHT",self,"TOPRIGHT",0,-self.paddingTop)
		else
			menuItem:SetPoint("TOPLEFT",self.menuItems[index-1],"BOTTOMLEFT",0,0)
			menuItem:SetPoint("TOPRIGHT",self.menuItems[index-1],"BOTTOMRIGHT",0,0)
		end
		
		menuItem.text = menuItem:CreateFontString(nil,"OVERLAY","PQIFont")
		menuItem.text:SetTextColor(1,1,1)
		menuItem.text:SetJustifyH("LEFT")
		menuItem.text:SetPoint("TOPLEFT",menuItem,"TOPLEFT",18,-2)
		menuItem.text:SetPoint("BOTTOMRIGHT",menuItem,"BOTTOMRIGHT",-8,0)		
		menuItem.highlight = menuItem:CreateTexture(nil, "OVERLAY")
		menuItem.highlight:SetTexture(1,1,1,.2)
		menuItem.highlight:SetBlendMode("ADD")		
		menuItem.highlight:ClearAllPoints()
		menuItem.highlight:SetPoint("TOPRIGHT",menuItem,"TOPRIGHT",0,0)
		menuItem.highlight:SetPoint("BOTTOMLEFT",menuItem,"BOTTOMLEFT",0,0)
		menuItem.highlight:Hide()
		menuItem.check = menuItem:CreateTexture("OVERLAY")	
		menuItem.check:SetSize(16,16)		
		menuItem.check:SetPoint("TOPLEFT",menuItem,"TOPLEFT",3,-1)
		menuItem.check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
		menuItem.check:Hide()		
		--menuItem.checked		= menuData[i].checked
		
		self.menuItems[index] = menuItem	
	end,	
}			
----[[ Menu Constructor ]]-----------------------------------------------------------------------------------------------------
function ADDON:CreateMenu(name,parent)	
local menu = CreateFrame("Frame",nil,parent)
	-- Default Sttings ---------------------------------
	menu.menuItemHeight		=	16
	menu.paddingTop			=	6
	menu.paddingBottom		=	6
	----------------------------------------------------	
	menu:SetFrameStrata("FULLSCREEN_DIALOG")
	menu:SetSize(150,100)
	menu:SetPoint("TOP",parent,"BOTTOM",0,-4)	 
	menu:SetScript("OnShow", function()
		menu:RefreshMenu()
	end)	
	----------------------------------------------------	
	menu.menuItems 			= {}		
	----------------------------------------------------
	for method, func in pairs(methods) do
		menu[method] = func
	end
	----------------------------------------------------	
	return menu
end

