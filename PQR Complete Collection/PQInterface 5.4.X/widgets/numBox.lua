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

----[[ NumBox Scripts ]]-------------------------------------------------------------------------------------------------------

----[[ NumBox Methods ]]-------------------------------------------------------------------------------------------------------
local methods = {
	['ClearFocus'] = function(self,...)				
		self.editBox:ClearFocus(...)		
	end,
	['GetNumber'] = function(self,...)						
		return tonumber(self.editBox:GetNumber(...))		
	end,
	['Hide'] = function(self,...)				
		self.frame:Hide(...)	
	end,	
	['SetFocus'] = function(self,...)				
		self.editBox:SetFocus(...)		
	end,	
	['SetNumber'] = function(self,num)				
		local num = tonumber(num)
		
		if not num then num = self.min end
		if	num > self.max then
			num = self.max
		elseif num < self.min then
			num = self.min
		end
		
		self.editBox:SetText(num)
		self:UpdateBar()		
	end,
	['SetSize'] = function(self,...)				
		self.frame:SetSize(...)
		self:UpdateBar()		
	end,
	['SetScript'] = function(self,script,func)				
		self.scripts[script]	= func
	end,	
	['SetWidth'] = function(self,...)				
		self.frame:SetWidth(...)
		self:UpdateBar()		
	end,
	['SetHeight'] = function(self,...)				
		self.frame:SetHeight(...)
		self:UpdateBar()		
	end,	
	['Show'] = function(self,...)				
		self.frame:Show(...)
		self:UpdateBar()		
	end,	
	['SetPoint'] = function(self,...)				
		self.frame:SetPoint(...)
		self:UpdateBar()		
	end,	
	['EnableMouse'] = function(self,...)				
		self.editBox:EnableMouse(...)
	end,
	['EnableMouseWheel'] = function(self,...)	
		self.editBox:EnableMouseWheel(...)		
	end,	
	['SetTextInsets'] = function(self,...)				
		self.editBox:SetTextInsets(...)	
	end,
	['SetCursorPosition'] = function(self,...)				
		self.editBox:SetCursorPosition(...)	
	end,
	['UpdateBar'] = function(self,...)
		local number = self:GetNumber() or self.min		
		local width = ADDON:Round(( (number - self.min) / (self.max - self.min)*(self.frame:GetWidth()-2 )) )			
		if width == 0 then 
			self.bar:Hide()
		else
			self.bar:Show()
			self.bar:SetWidth(width)
		end	
	end,		
}
----[[ NumBox Constructor ]]-----------------------------------------------------------------------------------------------------
function ADDON:CreateNumBox(name,parent)
	parent = parent or UIParent
	local numBox = {}	
	local frame = CreateFrame('Frame', nil, parent)	
							
	local	editBox = CreateFrame('EditBox', nil, frame)
	editBox:SetAllPoints()		
	editBox:SetAutoFocus(false)			
	editBox:SetJustifyH("CENTER")
	editBox:SetJustifyV("CENTER")	
	editBox:SetTextInsets(0,0,0,0)						
	editBox:SetFontObject("PQIFont")		
	editBox:SetScript('OnEnterPressed',  function(this,...)		
		this:ClearFocus()
		numBox:SetNumber(numBox:GetNumber())	
		if numBox.scripts.OnEnter then numBox.scripts.OnEnter(numBox,...) end
	end)				
	editBox:SetScript('OnEscapePressed', function(this,...)		
		this:ClearFocus()
		this:SetNumber(this.oldNumber)	
		if numBox.scripts.OnEscapePressed then numBox.scripts.OnEscapePressed(numBox,...) end
	end)
	editBox:SetScript('OnEditFocusLost', function(this,...)			
		if numBox.scripts.OnEditFocusLost then numBox.scripts.OnEditFocusLost(numBox,...) end					
	end)
	editBox:SetScript('OnEditFocusGained', function(this)
		GameTooltip:Hide()		
		this.oldNumber = this:GetNumber()			
	end)
	editBox:SetScript("OnMouseWheel", function(this,delta,...)		
		if delta > 0 then
			if numBox.step >=1 then 
				numBox:SetNumber(ADDON:Round(numBox:GetNumber(),numBox.step)+numBox.step)
			else
				numBox:SetNumber(numBox:GetNumber()+numBox.step)
			end						
		else
			if numBox.step >=1 then 
				numBox:SetNumber(ADDON:Round(numBox:GetNumber(),numBox.step)-numBox.step)
			else
				numBox:SetNumber(numBox:GetNumber()-numBox.step)
			end
			
		end		
		if numBox.scripts.OnMouseWheel then numBox.scripts.OnMouseWheel(numBox,delta,...) end		
	end)
	editBox:SetScript("OnEnter",function(this,...)		
		if numBox.scripts.OnEnter then numBox.scripts.OnEnter(numBox,...) end					
	end)
	editBox:SetScript("OnLeave", function(this,...)		
		if numBox.scripts.OnLeave then numBox.scripts.OnLeave(numBox,...) end					
	end)
	
	local bar = CreateFrame('Frame', nil, frame)	
	bar:SetPoint('TOPLEFT',1,-1)	
	bar:SetPoint('BOTTOMLEFT',1,1)	
	
	
	
	----------------------------------------------------	
	numBox.editBox			= editBox
	numBox.frame			= frame
	numBox.bar				= bar
	numBox.scripts			= {}	
	-- Default settings --------------------------------		
	numBox.min				= 0
	numBox.max				= 100
	numBox.step				= 1
	----------------------------------------------------
	for method, func in pairs(methods) do
		numBox[method] = func
	end
	----------------------------------------------------	
	return numBox	
end