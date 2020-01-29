----[[ Ini ]]------------------------------------------------------------------------------------------------------------------
local AddOnName, Env = ...
local ADDON = LibStub("AceAddon-3.0"):NewAddon(AddOnName,'AceHook-3.0',"AceConsole-3.0","AceEvent-3.0","AceTimer-3.0")
Env[1], _G[AddOnName] = ADDON, ADDON
ADDON.mediaPath = [[Interface\AddOns\]]..AddOnName..[[\media\]]
----[[ Dev Ini ]]--------------------------------------------------------------------------------------------------------------
ADDON.development = _DiesalDevelopment or {}
setmetatable(ADDON.development,{ __index = function(t, k) return function() return end end })
local D = ADDON.development
----[[ Lua Ini ]]--------------------------------------------------------------------------------------------------------------
local print, type, select, tostring, tonumber						= print, type, select, tostring, tonumber
local ipairs, pairs	 														= ipairs, pairs
local floor, modf 															= math.floor, math.modf
local table_remove, table_concat 										= table.remove, table.concat
local sub, format, match, lower											= string.sub, string.format, string.match, string.lower
----[[ WoW Ini ]]--------------------------------------------------------------------------------------------------------------
local GetSpecialization, GetSpecializationInfo						= GetSpecialization, GetSpecializationInfo
local RegisterCVar, SetCVar, GetCVar									= RegisterCVar, SetCVar, GetCVar
----[[ Fonts ]]----------------------------------------------------------------------------------------------------------------
local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("font","Calibri Bold",ADDON.mediaPath..[[calibrib.ttf]])
LSM:Register("font","Calibri",ADDON.mediaPath..[[calibri.ttf]])

CreateFont("PQIFont")
CreateFont("PQIFont_pixel")
PQIFont:SetFont( ADDON.mediaPath..[[calibrib.ttf]], 11 )
PQIFont_pixel:SetFont( ADDON.mediaPath..[[FFF Intelligent Thin Condensed.ttf]], 8, "OUTLINE, MONOCHROME" )
----[[ constants ]]------------------------------------------------------------------------------------------------------------
ADDON.version = GetAddOnMetadata(AddOnName, "Version")
ADDON.myname, _ = UnitName("player")
ADDON.myrealm = GetRealmName()
----[[ ADDON API ]] -----------------------------------------------------------------------------------------------------------
--  [1] = 'Disabled', [2] = 'Spell Logging', [10] = 'All'
function	ADDON:Debug(debugLevel,s)	
	if ADDON.db.global.debugLevel == debugLevel then
		ChatFrame1:AddMessage(format("|cff00ffff<|cff00aaff%s|cff00ffff>|r %s",'PQI Debug',s))	 
	end
end
function ADDON:TableCopy(t,lowercase)
	if not t then D.P('ADDON:TableCopy(t) t=nil') return end
	local ct = {}	
  	for key,val in pairs(t) do
  		if lowercase and type(val) == 'string' then 
  			ct[key] = lower(val)
  		else
  			ct[key] = val
  		end  		
  	end  
	return ct
end
function ADDON:Print(s,...)
	if not s then return end
	print(format("|cff00ffff<|cff00aaff%s|cff00ffff>|r %s",AddOnName,s))	 
	return self:Print(...)
end
function ADDON:Error(s,...)
	if not s then return end
	print(format("|cff00aaff<%s>|cffff0000 %s",AddOnName,s))	
	return self:Error(...)
end
function ADDON:SendMsg(p,m,c,t)	
	SendAddonMessage(p,m,c,t)
end 
function ADDON:SetCVar(cvar,value)
	if not GetCVar(cvar) then 
		RegisterCVar(cvar,value)		
	else
		SetCVar(cvar,value)
	end	
end
function ADDON:Hex2Color(value)
	if not value or type(value) == "table" then return value end 
	local rhex, ghex, bhex = sub(value, 1, 2), sub(value, 3, 4), sub(value, 5, 6)
	return tonumber(rhex, 16)/255, tonumber(ghex, 16)/255, tonumber(bhex, 16)/255, format('|cff%s',value)
end
function ADDON:Pack(...)
	local t = {}
	for i=1 ,select('#',...) do
		t[i] = select(i,...)
	end	
   return t
end
function ADDON:GetIconCoords(iconX,iconY,iconSize,HozizontalTextureSize,VerticalTextureSize)
	iconSize = iconSize or 16
	HozizontalTextureSize 	= HozizontalTextureSize or 128
	VerticalTextureSize 		= VerticalTextureSize 	or 16
	
	local left  	= (iconX * iconSize - iconSize) / HozizontalTextureSize
	local right 	= (iconX * iconSize) / HozizontalTextureSize
	local top 		= (iconY * iconSize - iconSize) / VerticalTextureSize
	local bottom	= (iconY * iconSize) / VerticalTextureSize
	
	return left,right,top,bottom
end
function ADDON:Round(num,base)	
	local under, over, overV, underV 
	base = base or 1
	under = floor(num/base)
	over = floor(num/base) + 1
	underV = -(under - num/base)
	overV = over - num/base
	if (overV > underV) then
		return under * base
	else
		return over * base
	end
end
function ADDON:FormatGetTime(num)
	if num == 0 then return 0,0,0,0 end
	local seconds,ms = modf (num)
	local c =  ADDON.colors.blue
	local d = format("%02.f", floor(num/86400))
	local h = format("%02.f", floor(num/3600 - (d*24)))
	local m = format("%02.f", floor(num/60 - (h*60) -(d*1440)));
	local s = format("%02.f", floor(num - (m*60) - (h*3600) - (d*86400) ));
	s = s + ms
	local t = format("|cff%02x%02x%02x%s:%s:|r%02.3f",c[1]*255,c[2]*255,c[3]*255, h,m,s)
	return t
end
function ADDON:GetTTAnchor(frame)
	local x, y = frame:GetCenter()
	local screenWidth = GetScreenWidth()
	local screenHeight = GetScreenHeight()
	local point,yOffset
	
	if not x then return "ANCHOR_TOP", 5 end
	
	if (x > (screenWidth / 4) and x < (screenWidth / 4)*3) and y > (screenHeight / 4)*3 then
		point,yOffset = "ANCHOR_BOTTOM", -5 -- TOP
	elseif x < (screenWidth / 4) and y > (screenHeight / 4)*3 then
		point,yOffset = "ANCHOR_BOTTOM", -5 -- TOPLEFT
	elseif x > (screenWidth / 4)*3 and y > (screenHeight / 4)*3 then
		point,yOffset = "ANCHOR_BOTTOM", -5 -- TOPRIGHT
	else
		point,yOffset = "ANCHOR_TOP", 5 		
	end
	return point,yOffset
end
do	-- Serializer ---------------------------	
	local lua_keywords = { 
		["and"] = true,    ["break"] = true,  ["do"] = true,
		["else"] = true,   ["elseif"] = true, ["end"] = true,
		["false"] = true,  ["for"] = true,    ["function"] = true,
		["if"] = true,     ["in"] = true,     ["local"] = true,
		["nil"] = true,    ["not"] = true,    ["or"] = true,
		["repeat"] = true, ["return"] = true, ["then"] = true,
		["true"] = true,   ["until"] = true,  ["while"] = true
	}
	local t = {
		[tostring(1/0)] = "1/0";
		[tostring(-1/0)] = "-1/0";
		[tostring(0/0)] = "0/0";
	}	
	local function serialize_number(number)
		-- no argument checking - called very often
		local text = ("%.17g"):format(number)
		-- on the same platform tostring() and string.format()
		-- return the same results for 1/0, -1/0, 0/0
		-- so we don't need separate substitution table
		return t[text] or text
	end
	local function impl(t, cat, visited)
	local t_type = type(t)
	if t_type == "table" then
		if not visited[t] then
			visited[t] = true

			cat("{")
			-- Serialize numeric indices
			local next_i = 0
			for i, v in ipairs(t) do 
				if i > 1 then -- TODO: Move condition out of the loop
					cat(",")
				end
				impl(v, cat, visited)
				next_i = i
			end
			next_i = next_i + 1
			-- Serialize hash part
			-- Skipping comma only at first element iff there is no numeric part.
			local need_comma = (next_i > 1)
			for k, v in pairs(t) do
				local k_type = type(k)
				if k_type == "string" then
					if need_comma then
						cat(",")
					end
					need_comma = true
					-- TODO: Need "%q" analogue, which would put quotes
					--       only iff string does not match regexp below
					if not lua_keywords[k] and match(k, "^[%a_][%a%d_]*$") then
						cat(k) cat("=")
					else
						cat(format("[%q]=", k))
					end
					impl(v, cat, visited)
				else
					if
					k_type ~= "number" or -- non-string non-number
					k >= next_i or k < 1 or -- integer key in hash part of the table
					k % 1 ~= 0 -- non-integer key
					then
						if need_comma then
							cat(",")
						end
						need_comma = true

						cat("[")
						impl(k, cat, visited)
						cat("]=")
						impl(v, cat, visited)
					end
				end
			end
			cat("}")
			visited[t] = nil
		else
			-- this loses information on recursive tables
			cat('"table (recursive)"')
		end
		elseif t_type == "number" then
			cat(serialize_number(t))
		elseif t_type == "boolean" then
			cat(tostring(t))
		elseif t == nil then
			cat("nil")
		else
			-- this converts non-serializable (functions) types to strings
			cat(format("%q", tostring(t)))
		end
	end
	local function tstr_cat(cat, t)
		impl(t, cat, {})
	end
	ADDON.implode = impl	
end
function ADDON:Serialize(t)
	local buf = {}
	local cat = function(v) buf[#buf + 1] = v end
	ADDON.implode(t, cat, {})
	return 'return '..table_concat(buf)
end
function ADDON:Deserialize(s)
	local func,err = loadstring(s)
	if err then ADDON:Error(err) end
	return func()
end
function ADDON:GetSpec()	
	local currentSpecNum = GetSpecialization()	
	return currentSpecNum and select(2, GetSpecializationInfo(currentSpecNum)) or 'No Spec'
end

local function commandHelp()
	ADDON:Print('-------------- /PQI commands -----------------')	
	ADDON:Print('"/PQI show||hide"')
	ADDON:Print('"/PQI remote width <width>"')
	ADDON:Print('"/PQI config show||hide"')
	ADDON:Print('"/PQI config width <width>"')
	ADDON:Print('"/PQI log show||hide"')
	ADDON:Print('"/PQI log rows <rows>"')	
end
function ADDON:CommandHandler(msg)
	local command, args = msg:match("^([^%s]+)%s*(.*)$")
	if args then
		local s = args
		args = {} 
		for a in s:gmatch("([^%s]+)%s*") do
			args[#args+1] = a		
		end
	end		
	--dump('arg',args)
	if command =='help' then commandHelp() return end
	if command =='show' then return ADDON:Enable() end
	if command =='hide' then return ADDON:Disable() end
	if command =='remote' then		
		if args and args[1] == 'width' then
			if type(tonumber(args[2]))  == 'number' then	self.interface.db.width = args[2] self.interface:Update() return end						
		end
	end
	if command =='config' then
		if args and args[1] == 'show' then self.rotationConfig.db.show = true self.rotationConfig:Update() return end
		if args and args[1] == 'hide' then self.rotationConfig.db.show = false self.rotationConfig:Update() return end
		if args and args[1] == 'width' then
			if type(tonumber(args[2]))  == 'number' then	self.rotationConfig.db.width = args[2] self.rotationConfig:Update() return end						
		end
	end
	if command =='log' then
		if args and args[1] == 'show' then self.abilityLog.db.show = true self.abilityLog:Update() return end
		if args and args[1] == 'hide' then self.abilityLog.db.show = false self.abilityLog:Update() return end
		if args and args[1] == 'rows' then
			if type(tonumber(args[2]))  == 'number' then	self.abilityLog.db.rows = args[2] self.abilityLog:Update() return end						
		end
	end
	
	--D.CommandHandler(command, args)
	ADDON:Error('Invalid command "/PQI help" for valid commands') 
end

-----------------------------------------------------------------------------
----[[ ADDON Constants ]]------------------------------------------------------------------------------------------------------
ADDON.defaultIcon = select(3,GetSpellInfo(4038))
ADDON.colors = {	
	blue 		= ADDON:Pack(ADDON:Hex2Color('00aaff')),
	red 		= ADDON:Pack(ADDON:Hex2Color('ff0000')),
	green 	= ADDON:Pack(ADDON:Hex2Color('2aff00')),
	orange 	= ADDON:Pack(ADDON:Hex2Color('ffaa00')),
	purple 	= ADDON:Pack(ADDON:Hex2Color('8066ff')),
	yellow 	= ADDON:Pack(ADDON:Hex2Color('ffff00')),
	grey	 	= ADDON:Pack(ADDON:Hex2Color('b2b2b2')),
			
}









