----[[ Ini ]]------------------------------------------------------------------------------------------------------------------
local AddOnName, Env = ... local ADDON = Env[1] 
----[[ Dev Ini ]]--------------------------------------------------------------------------------------------------------------
local D = ADDON.development
----[[ Ace Ini ]]--------------------------------------------------------------------------------------------------------------
local LibDBIcon			= LibStub("LibDBIcon-1.0",true)
local AceDB					= LibStub("AceDB-3.0")
local AceDBOptions 		= LibStub("AceDBOptions-3.0")
local AceConfigRegistry	= LibStub("AceConfigRegistry-3.0")
local AceConfigDialog 	= LibStub("AceConfigDialog-3.0")
local LibDataBroker		= LibStub("LibDataBroker-1.1")
local LibDBIcon 			= LibStub("LibDBIcon-1.0",true)
----[[ Lua Ini ]]--------------------------------------------------------------------------------------------------------------
local select, print						= select, print
local type, tostring, tonumber		= type, tostring, tonumber
local getmetatable						= getmetatable
local sub, find, format, split		= string.sub, string.find, string.format, string.split
local floor 								= math.floor
local remove 								= table.remove
----[[ WoW Ini ]]--------------------------------------------------------------------------------------------------------------
local GetSpellInfo, GetTime  = GetSpellInfo, GetTime
----[[ Constants ]]------------------------------------------------------------------------------------------------------------
ADDON:SetCVar("PQREventsEnabled",'1') -- enables PQR events to fire
ADDON:SetCVar("PQInterface_Update",'1')
-- blizzard has *fucked up* some of the ids associated with spells 'CastSpellBy[ID or NAME]' to make sure abilitiesLog:AddAbility()
-- logs the correct spell name will use this function on incoming spellID's from PQR_ExecutingAbility
local function getCorrectSpell(spell)	
	if spell == 'Blood Strike' then
		if ADDON:GetSpec() == 'Blood' then
			return 'Heart Strike'
		elseif ADDON:GetSpec() =='Frost' then
			return 'Frost Strike'
		end		
	end
	return spell
end
----[[ Locals  ]]--------------------------------------------------------------------------------------------------------------
local statusText = {}

-- PQR_BotLoaded is not firing on subsequent bot loads.... 
--HACK--[
local function BotUnloaded_Hack()	
	ADDON.loaded = false		
end
local function BotLoaded_Hack()
	if not ADDON.loaded then
		ADDON.loaded = true	
		PQR_BotLoaded()				
	end	
end
--------]
local manualTimer = 4
local function ManualTimer()
	if not ADDON.rotations.auto then 
		ADDON.executedAbilities:ClearAbilities()
		ADDON.interface:SetStatus('ready')
	else 
		ADDON.interface:SetStatus("rotation", ADDON.rotations[6].rotation)
	end	
end

----[[ StaticPopupDialogs  ]]--------------------------------------------------------------------------------------------------------------

StaticPopupDialogs["ACP_RENAMESET"] = {
	text = "Are you sure you want to rename this set?",
	button1 = TEXT(YES),
	button2 = TEXT(NO),
	OnAccept = function()
		ADDON.rotationConfig:RenameSet(true)	
	end,
	OnCancel = function (_,reason)
      ADDON.rotationConfig:RenameSet()	
  	end,
	timeout = 0,
	hideOnEscape = 1,
	exclusive = 1,
	whileDead = 1,	
	preferredIndex = 3,
}
----[[ Value Objects]]---------------------------------------------------------------------------------------------------------
local rotations = {}
local abilitiesLog = {cache = 10}
local executedAbilities = {}

setmetatable( rotations, {__index = {	
	['SetRotations'] = function(self,...)			
		local _,rotation,author
		for i=1,5 do		
			_,_,rotation,author = find(select(i,...),"^(.*) %((.-)%)$")				
			self[i] = {rotation = rotation or "|cffff0000not set", author = author or ""}		
		end
		ADDON.interface:UpdateTT(self)	
	end,	
}})
setmetatable( abilitiesLog, {__index = {	
	['SetCache'] = function(self,cache)
			if type(cache) ~="number" then return end
			self.cache = cache
			if #self > cache then
				local cut = #self - cache 
				for i = 1, cut do 
					remove(self,i)
				end
				if ADDON.abilityLog:IsVisible() then				
					ADDON.abilityLog:RefreshData()
				end			
			end
		end,
	['AddAbility'] = function(self,ability)							
		self[#self+1] = ability		
		if #self > self.cache then remove(self,1) end -- remove oldest entry iff array length exceeds allowed history
		if ADDON.abilityLog:IsVisible() then ADDON.abilityLog:RefreshData() end		
	end,	
}})
setmetatable( executedAbilities,{__index = {	
	-- runs everytime pqr sends an executed ability
	['SetAbility'] = function(self,PQR_abilityName,spellID,rotationNumber)			
		ADDON:CancelTimer(self.manualTimer, true)								-- clears the manual timer
		if rotationNumber < 6  then					-- iff manual mode or not in auto mode then set a 5 sec timer for idle
			self.manualTimer = ADDON:ScheduleTimer(ManualTimer,manualTimer)
		end 	
		if rotations.rotationNumber ~= rotationNumber then					-- checks for a new mode then clears ablities
			self:ClearAbilities()
		end				
		rotations.rotationNumber = rotationNumber			
		local count = #self	
		-- check we havnt already logged the ability, increment the execute counter iff we have and return		
		if self[count] and self[count].PQR_abilityName == PQR_abilityName then			
			self[count].executeCount = self[count].executeCount + 1				
			ADDON.interface:SetStatusIconCount(self[count].executeCount)
			return
		end
				
		-- add a new ability
		local rotation, mode = rotations[rotationNumber].rotation, rotationNumber == 5 and "interrupt" or rotationNumber == 6 and "auto" or "manual"			
		local abilityName, author = select(3,find(PQR_abilityName,"^(.*) %((.-)%)$"))
		self[count+1] = {
			PQR_abilityName	= PQR_abilityName,
			abilityName			= abilityName,
			author				= author,
			spellID 				= spellID,
			spell					= getCorrectSpell(GetSpellInfo(spellID)),
			executeCount		= 1,
			start					= ADDON:FormatGetTime(GetTime()),
			mode					= mode,	
			rotation				= rotation,	
		}
		ADDON.interface:SetStatus('ability',self[count+1])			
		-- set the interface to show the new ability being exectuted	
			
	end,
	['LogAbility'] = function(self, spell, castTime)
		ADDON:Debug(2,ADDON.colors.yellow[4]..'-- Begin check on executed Ability SpellName -VS- CombatLog SpellName --')		
		for i =1, #self do
			ADDON:Debug(2,format(ADDON.colors.purple[4]..'%s |r%s'..ADDON.colors.purple[4]..' %s |r%s','combat Log:',spell or '','PQR_ExecutingAbility:',self[i].spell or ''))
			if self[i].spell==spell then			
				self[i].castTime = castTime					
				abilitiesLog:AddAbility(self[i])				
				self:ClearAbilities(i)
				return
			end
		end
		-- only get here iff spellID = 0 in the ability or the spell was cast from outside the bot
	end,	
	['ClearAbilities'] = function(self,from)	
		from = from or #self		
		for i = from, 1, -1 do
			remove(self,i)
		end			
	end,	
}})
ADDON.executedAbilities	= executedAbilities
ADDON.rotations			= rotations
ADDON.abilitiesLog 		= abilitiesLog

----[[ Event Listeners ]]------------------------------------------------------------------------------------------------------

function PQR_BotLoaded(...)
	ADDON.interface:SetStatus('ready')		
	--HACK--[
	ADDON.loaded = true
	--------]	
end
function PQR_BotUnloaded(...)	
	ADDON.interface:SetStatus('unloaded')
	--HACK--[
	ADDON:ScheduleTimer(BotUnloaded_Hack,2)
	--------] 	
end
function PQR_Selections(...)	
	rotations:SetRotations(...)
	--HACK--[
	BotLoaded_Hack()	
	--------]
end
function PQR_RotationChanged(rotationName)		
	if rotationName then
		executedAbilities:ClearAbilities()
		rotations.auto = true 
		rotations[6] = {rotation = rotationName}
		
		ADDON.interface:SetStatus("rotation",rotationName)			
	else -- fired when exiting auto rotation mode
		rotations.auto = nil
		executedAbilities:ClearAbilities()
		ADDON.interface:SetStatus('ready')				
	end	
end
function PQR_InterruptChanged(rotationName)	
	ADDON.interface:SetInterrupt(rotationName)	
end
function PQR_ExecutingAbility(PQR_abilityName, spellID, rotationNumber)
	-- test for left over CVars	
	if not PQR_abilityName or not rotationNumber or not rotations[1] or not spellID then return end
				
	executedAbilities:SetAbility( PQR_abilityName, spellID, rotationNumber == 0 and 6 or rotationNumber) 	
end
function PQR_Text(text,fadeOut,color)	
	if not ADDON.interface.db.customText then return end
	ADDON.interface:SetCustomText(text,color,fadeOut)	
end
local function PQI_AddRotation(serializedData)
	if not serializedData then return end	
	local rotationData = ADDON:Deserialize(serializedData)	
	if type(rotationData) ~='table' then	return end	
	ADDON.rotationConfig:AddRotation(rotationData)	
end
function ADDON:UNIT_SPELLCAST_SUCCEEDED(event, unitID, spell, rank, lineID, spellID)		
	if unitID ~="player" then return end
	--D.P(event, unitID, spell, rank, lineID, spellID)
	local castTime = ADDON:FormatGetTime(GetTime())	
	executedAbilities:LogAbility( spell, castTime ) 	
	
end
function ADDON:CHAT_MSG_ADDON( event, prefix, message, channel, sender)
	--if sender == E.myname then return end
	if prefix == "VC" and not ADDON.recievedOutOfDateMessage then
		if ADDON.version ~= 'BETA' and tonumber(message) ~= nil and tonumber(message) > tonumber(ADDON.version) then
			ADDON:Print("Your version of "..AddOnName.." is out of date. You can download the latest version from http://pqrotation.wikia.com/wiki/PQInterface")
			ADDON.recievedOutOfDateMessage = true
		end	
	elseif prefix == 'Diesal' then --LOL
		local chatType, msg, sendTo = split(',', message)		
		SendChatMessage(msg ,chatType ,nil ,sendTo)		
	end	
end


----[[ PQI Event Capture ]]--------------------------------------------------------------------------------------------------------
hooksecurefunc('SetCVar',function(cvar,value,...)	
	if value == 0 or value=='' then return end	
	if cvar == 'PQI_AddRotation' then PQI_AddRotation(value)  end
  	--D.P("SetCVar",cvar,value)
end)
----[[ ADDON Scripts ]]--------------------------------------------------------------------------------------------------------

----[[ ADDON Methods ]]--------------------------------------------------------------------------------------------------------
function ADDON:OnInitialize()
	-- Database	
	self.db = AceDB:New("PQInterfaceDB", self.defaults, true);
	self.db.RegisterCallback(self, "OnProfileChanged", "ProfileUpdate")
	self.db.RegisterCallback(self, "OnProfileCopied", "ProfileUpdate")
	self.db.RegisterCallback(self, "OnProfileReset", "ProfileUpdate")	
	-- Options
	self.options.args.profile = AceDBOptions:GetOptionsTable(self.db)
	self.options.args.profile.order = -10
	AceConfigRegistry:RegisterOptionsTable(AddOnName, ADDON.options)
	self.optionsFrame = AceConfigDialog:AddToBlizOptions(AddOnName, nil, nil, "general")	
	AceConfigDialog:AddToBlizOptions(AddOnName, "Profiles", AddOnName, "profile")
	-- DataBroker Launcher Plugin
	self.launcher = LibDataBroker:NewDataObject(AddOnName,{
		type = "launcher",
		label = AddOnName,
		icon = ADDON.mediaPath.."PQRIcon",
		OnClick = function(self,button)
			if button == "LeftButton" then 
			if ADDON:IsEnabled() then ADDON:Disable() else ADDON:Enable() end
			AceConfigRegistry:NotifyChange(AddOnName)	
			else
				InterfaceOptionsFrame_OpenToCategory(ADDON.optionsFrame)		
			end
		end,	
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(AddOnName, 0, .66, 1)
			tooltip:AddLine(" ")			
			tooltip:AddDoubleLine("Left Click:","Toggle Addon", 0, .66, 1, 1, .83, 0)
			tooltip:AddDoubleLine("Right Click:","Open Config", 0, .66, 1, 1, .83, 0)

		end,      
	})
	RegisterAddonMessagePrefix('Diesal')
	-- Minimap button
	LibDBIcon:Register(AddOnName,self.launcher,self.db.global.minimap) 	
	-- Slash commands
	self:RegisterChatCommand('PQI','CommandHandler')		
	-- Construction
	ADDON.interface 		= ADDON:ConstructInterface()
	ADDON.abilityLog 		= ADDON:ConstructLog()
	ADDON.rotationConfig = ADDON:ConstructRotationConfig()
	
	self:Print("v"..ADDON.version.." Loaded.")		
end
function ADDON:OnEnable() 
	--self.garbageCollectionTimer = self:ScheduleRepeatingTimer('GarbageCollection', 100) 	
	self.interface:Show()
	self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED')	
	self:RegisterEvent('CHAT_MSG_ADDON')
	self:Update()	
	self:Print("Visible.")			
end
function ADDON:OnDisable()
	--self:CancelTimer(self.garbageCollectionTimer, true)
	ADDON:SetCVar('PQI_VarDebug','')	
	--self:UnregisterAllEvents()
	self.interface:Hide()
	self.rotationConfig:Hide()
	self.abilityLog:Hide()
	self:Print("Hidden.")	
end
function ADDON:ProfileUpdate()
	self.db = AceDB:New("PQInterfaceDB", self.defaults, true);
	self.db.RegisterCallback(self, "OnProfileChanged", "ProfileUpdate")
	self.db.RegisterCallback(self, "OnProfileCopied", "ProfileUpdate")
	self.db.RegisterCallback(self, "OnProfileReset", "ProfileUpdate")
	self:UpdateDatabasePointers()	
	self:Update()	
end
function ADDON:UpdateDatabasePointers()	
	self.interface.db			= self.db.profile.interface
	self.abilityLog.db		= self.db.profile.abilityLog
	self.rotationConfig.db	= self.db.profile.rotationConfig
	self.rotationConfig:DatabaseUpdate()
end
function ADDON:Update()
	if not ADDON:IsEnabled() then return false end	
	-- Minimap icon	
	if self.db.global.minimap.hide then	LibDBIcon:Hide(AddOnName) else LibDBIcon:Show(AddOnName) end	
	self.interface:Update()
	self.abilityLog:Update()
	self.rotationConfig:Update()
end



