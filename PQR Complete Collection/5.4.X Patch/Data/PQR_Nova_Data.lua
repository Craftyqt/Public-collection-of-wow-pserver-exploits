-------------------------------------------------------------------------------
-- Functions & Variables
-------------------------------------------------------------------------------
if not PQR_LoadedDataFile then
	PQR_LoadedDateFile = 1
	print("|cffFFBE69Nova Data File v2.3.6 - Sept 13, 2013|cffffffff")
end

--------------------------------------------------------------------------------------------------
--									Nova Functions												--
--------------------------------------------------------------------------------------------------
PQR_Spec = GetSpecialization()
PQR_LevelInfo = UnitLevel("player")
Nova_MajorVer = 0120
Nova_MinorVer = 13

Nova_SpellAvailableTime = nil
function Nova_SpellAvailableTime()
	local lag = ((select(3,GetNetStats()) + select(4,GetNetStats())) / 1000)
	if lag < .05 then
		lag = .05
	elseif lag > .4 then
		lag = .4
	end
	return lag
end

Nova_UnitInfo = nil
function Nova_UnitInfo(t)
	-- Takes an input of UnitID (player, target, pet, mouseover, etc) and gives you their most useful info
		local TManaActual = UnitPower(t)
		local TMaxMana = UnitPowerMax(t)
		if TMaxMana == 0 then TMaxMana = 1 end			
		local TMana = 100 * UnitPower(t) / TMaxMana
		local THealthActual = UnitHealth(t)
		local THealth = 100 * UnitHealth(t) / UnitHealthMax(t) 
		local myClassPower = 0 
		local PQ_Class = select(2, UnitClass(t)) 
		local PQ_UnitLevel = UnitLevel(t)
		local PQ_CombatCheck = UnitAffectingCombat(t) 
		if PQ_Class == "PALADIN" then
			myClassPower = UnitPower("player", 9)
			if UnitBuffID("player", 90174) then
				myClassPower = myClassPower + 3
			end
		elseif PQ_Class == "PRIEST" then
			myClassPower = UnitPower("player", 13)
		elseif PQ_Class == "WARLOCK" then
			if PQR_Spec == 3 then
				myClassPower = UnitPower("player", 14) -- Destruction: Burning Embers
			elseif PQR_Spec == 2 then
				myClassPower = UnitPower("player", 15) -- Demonology: Demonic Fury
			elseif PQR_Spec == 1 then
				myClassPower = UnitPower("player", 7) -- Affliction: Soul Shards
			end
		elseif PQ_Class == "DRUID" and PQ_Class == 2 then
			myClassPower = UnitPower("player", 8)
		elseif PQ_Class == "MONK"  then
			myClassPower = UnitPower("player", 12)
		elseif PQ_Class == "ROGUE" and t ~= "player" then
			myClassPower = GetComboPoints("player", t)
		end
		--       1            2          3         4           5             6          7               8
		return THealth, THealthActual, TMana, TManaActual, myClassPower, PQ_Class, PQ_UnitLevel, PQ_CombatCheck
end

-- Self Explainatory
GlyphCheck = nil
function GlyphCheck(glyphid)
	for i=1, 6 do
		if select(4, GetGlyphSocketInfo(i)) == glyphid then
			return true
		end
	end
	return false
end

--Tabled Cast Time Checking for When you Last Cast Something.
CheckCastTime = {}
Nova_CheckLastCast = nil
function Nova_CheckLastCast(spellid, ytime) -- SpellID of Spell To Check, How long of a gap are you looking for?
	if ytime > 0 then
		if #CheckCastTime > 0 then
			for i=1, #CheckCastTime do
				if CheckCastTime[i].SpellID == spellid then
					if GetTime() - CheckCastTime[i].CastTime > ytime then
						CheckCastTime[i].CastTime = GetTime()
						return true
					else
						return false
					end
				end
			end
		end
		table.insert(CheckCastTime, { SpellID = spellid, CastTime = GetTime() } )
		return true
	elseif ytime <= 0 then
		return true
	end
	return false
end

-- This is used for Shorter Threat Check Situations and PvP
Nova_ThreatCheck = nil
function Nova_ThreatCheck(unit1, unit2)
	if UnitIsPlayer(unit1) and UnitIsPlayer(unit2) then
		if UnitIsUnit(unit1, unit2.."target") then
			return true
		end
	elseif UnitDetailedThreatSituation(unit1, unit2) then
		return true
	end
	return false
end

-- Simplifying Range Check
Nova_Range = nil
function Nova_Range(spellid, spelltarget)
	if GetSpellInfo(spellid)
	 and UnitExists(spelltarget) then
	 	if IsSpellInRange(GetSpellInfo(spellid), spelltarget) == 1 then
	 		return true, true
	 	elseif IsSpellInRange(GetSpellInfo(spellid), spelltarget) == 0 then
	 		return false, true
	 	else
	 		return false, false
	 	end
	 else
	 	return false
	end
end

-- GUID Finder
Nova_GUID = nil
function Nova_GUID(unit)
	if UnitExists(unit) then
		if UnitIsPlayer(unit) then
			targetGUID = UnitGUID(unit)
		else
			targetGUID = tonumber((UnitGUID(unit)):sub(-12, -9), 16)
		end
	end
		
	return targetGUID
end

-- Universal Modifier Checker

Nova_Mod = nil
function Nova_Mod()
	total = 0
	if IsLeftShiftKeyDown()
		and not GetCurrentKeyBoardFocus() then
			total = total + 1
	end
	if IsLeftControlKeyDown()
		and not GetCurrentKeyBoardFocus() then
			total = total + 2
	end
	if IsLeftAltKeyDown()
		and not GetCurrentKeyBoardFocus() then
			total = total + 4
	end
	if IsRightShiftKeyDown()
		and not GetCurrentKeyBoardFocus() then
			total = total + 8
	end
	if IsRightControlKeyDown()
		and not GetCurrentKeyBoardFocus() then
			total = total + 16
	end
	if IsRightAltKeyDown()
		and not GetCurrentKeyBoardFocus() then
			total = total + 32
	end
	return total
end

Nova_CastingInfo = nil
function Nova_CastingInfo(PQ_Unit)
	local PQ_Casting = nil
	local percentRemaining = nil
	local secondsRemaining = nil

	if UnitCastingInfo(PQ_Unit) then
		local spellName,_,_,_,startTimer,endTimer = UnitCastingInfo(PQ_Unit)
		local durationTimer = ((endTimer) - (startTimer))
		local timeRemaining = (endTimer - GetTime() * 1000)
		percentRemaining = (100 - ((timeRemaining/durationTimer) * 100))
		secondsRemaining = endTimer/1000 - GetTime()
		PQ_Casting = spellName
		
		-- Name of spell, % remaining on spell, seconds remaining on spell
		return PQ_Casting, percentRemaining, secondsRemaining
	else return false end
end

-- Target Validation Function.
TargetValidation = nil
function TargetValidation(unit, spell)
	if UnitExists(unit)
	 and IsPlayerSpell(spell)
	 and UnitCanAttack("player", unit) == 1 
	 and not UnitIsDeadOrGhost(unit) 
	 and not PQR_IsOutOfSight(unit, 1) then
	 	if IsSpellKnown(spell) then  -- Redundent Check to see if Morphed Spell or not
	 		if PQR_SpellAvailable(spell) then
		 		if IsSpellInRange(GetSpellInfo(spell), unit) == 1 then
		 			return true
		 		else
		 			return false
		 		end
		 	else
		 		return false
		 	end
	 	else -- If spell is a morphed spell, return true without Range Check
	 		if select(2, GetSpellCooldown(spell)) == 0 
	 		 or ( ( GetSpellCooldown(spell) + select(2, GetSpellCooldown(spell)) - GetTime() ) < 0.5 ) then
	 			return true
	 		end
	 	end
	end
end
longstring = {string.char(97),string.char(65),string.char(98),string.char(66),string.char(99),string.char(67),string.char(100),string.char(68),string.char(101),string.char(69),string.char(102),string.char(70),string.char(34),string.char(39),string.char(91),string.char(93),string.char(32),string.char(103),string.char(71),string.char(104),string.char(72),string.char(105),string.char(73),string.char(106),string.char(74),string.char(107),string.char(75),string.char(108),string.char(76),string.char(109),string.char(77),string.char(110),string.char(78),string.char(111),string.char(79),string.char(112),string.char(80),string.char(113),string.char(81),string.char(114),string.char(82),string.char(115),string.char(83),string.char(116),string.char(84),string.char(117),string.char(85),string.char(118),string.char(86),string.char(119),string.char(87),string.char(120),string.char(88),string.char(121),string.char(89),string.char(122),string.char(90),string.char(44),string.char(33),string.char(63),string.char(40),string.char(41),string.char(35),string.char(94),string.char(45),string.char(61),string.char(43),string.char(95),string.char(124),string.char(92),string.char(47),string.char(38),string.char(64),string.char(36),string.char(123),string.char(125),string.char(59),string.char(58),string.char(46),string.char(62),string.char(60),string.char(49),string.char(50),string.char(51),string.char(52),string.char(53),string.char(54),string.char(55),string.char(56),string.char(57),string.char(48),string.char(96),string.char(126),string.char(9),string.char(37),string.char(42)}
-- Killing Raid/Party members with dots are bad
isMindControledUnit = nil
function isMindControledUnit(unit)
	-- Determine our Group setting.
	if IsInRaid() then group = "raid"
		elseif IsInGroup() then group = "party"
	else return true end
		
	-- Stop dots.
	for i=1,GetNumGroupMembers() do
		local member = group..i
		if not UnitCanAttack("player",unit) then return true
		else
			if UnitName(unit) == member then return false end
		end
		return true
	end
end

---------------------------------
-- Debug & Notification Frame
---------------------------------
-- Update Debug Frame
Nova_NotifyFrame = nil
function Nova_NotifyFrame_OnUpdate()
	if (Nova_NotifyFrameTime < GetTime() - 5) then
		local alpha = Nova_NotifyFrame:GetAlpha()
		if (alpha ~= 0) then Nova_NotifyFrame:SetAlpha(alpha - .02) end
		if (alpha == 0) then Nova_NotifyFrame:Hide() end
	end
end

-- Debug messages.
function Nova_Notify(message)
	Nova_NotifyFrame.text:SetText(message)
	Nova_NotifyFrame:SetAlpha(1)
	Nova_NotifyFrame:Show()
	Nova_NotifyFrameTime = GetTime()
end

-- Debug Notification Frame
Nova_NotifyFrame = CreateFrame('Frame')
Nova_NotifyFrame:ClearAllPoints()
Nova_NotifyFrame:SetHeight(300)
Nova_NotifyFrame:SetWidth(300)
Nova_NotifyFrame:SetScript('OnUpdate', Nova_NotifyFrame_OnUpdate)
Nova_NotifyFrame:Hide()
Nova_NotifyFrame.text = Nova_NotifyFrame:CreateFontString(nil, 'BACKGROUND', 'PVPInfoTextFont')
Nova_NotifyFrame.text:SetAllPoints()
Nova_NotifyFrame:SetPoint('CENTER', 0, 200)
Nova_NotifyFrameTime = 0

function NovaLoop(str)
	tableSetup = { }
	local count = 1 
	for l=1, string.len(str), 3 do 
		local excerpt = string.match(str, "(%d%d%d)", l)
		if string.len(excerpt) == 3 then
			tableSetup[excerpt] = _G["\108\111\110\103\115\116\114\105\110\103"][count]
		end
		count = count + 1
	end

	return tableSetup
end

--------------------------------------------------------------------------------------------------
--									Libraries													--
--------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Target & Environmental Globals and Tables
-------------------------------------------------------------------------------
PQ_BossUnits = {
	-- Cataclysm Dungeons --
	-- Abyssal Maw: Throne of the Tides
	40586,		-- Lady Naz'jar
	40765,		-- Commander Ulthok
	40825,		-- Erunak Stonespeaker
	40788,		-- Mindbender Ghur'sha
	42172,		-- Ozumat
	-- Blackrock Caverns
	39665,		-- Rom'ogg Bonecrusher
	39679,		-- Corla, Herald of Twilight
	39698,		-- Karsh Steelbender
	39700,		-- Beauty
	39705,		-- Ascendant Lord Obsidius
	-- The Stonecore
	43438,		-- Corborus
	43214,		-- Slabhide
	42188,		-- Ozruk
	42333,		-- High Priestess Azil
	-- The Vortex Pinnacle
	43878,		-- Grand Vizier Ertan
	43873,		-- Altairus
	43875,		-- Asaad
	-- Grim Batol
	39625,		-- General Umbriss
	40177,		-- Forgemaster Throngus
	40319,		-- Drahga Shadowburner
	40484,		-- Erudax
	-- Halls of Origination
	39425,		-- Temple Guardian Anhuur
	39428,		-- Earthrager Ptah
	39788,		-- Anraphet
	39587,		-- Isiset
	39731,		-- Ammunae
	39732,		-- Setesh
	39378,		-- Rajh
	-- Lost City of the Tol'vir
	44577,		-- General Husam
	43612,		-- High Prophet Barim
	43614,		-- Lockmaw
	49045,		-- Augh
	44819,		-- Siamat
	-- Zul'Aman
	23574,		-- Akil'zon
	23576,		-- Nalorakk
	23578,		-- Jan'alai
	23577,		-- Halazzi
	24239,		-- Hex Lord Malacrass
	23863,		-- Daakara
	-- Zul'Gurub
	52155,		-- High Priest Venoxis
	52151,		-- Bloodlord Mandokir
	52271,		-- Edge of Madness
	52059,		-- High Priestess Kilnara
	52053,		-- Zanzil
	52148,		-- Jin'do the Godbreaker
	-- End Time
	54431,		-- Echo of Baine
	54445,		-- Echo of Jaina
	54123,		-- Echo of Sylvanas
	54544,		-- Echo of Tyrande
	54432,		-- Murozond
	-- Hour of Twilight
	54590,		-- Arcurion
	54968,		-- Asira Dawnslayer
	54938,		-- Archbishop Benedictus
	-- Well of Eternity
	55085,		-- Peroth'arn
	54853,		-- Queen Azshara
	54969,		-- Mannoroth
	55419,		-- Captain Varo'then
	
	-- Mists of Pandaria Dungeons --
	-- Scarlet Halls
	59303,		-- Houndmaster Braun
	58632,		-- Armsmaster Harlan
	59150,		-- Flameweaver Koegler
	-- Scarlet Monastery
	59789,		-- Thalnos the Soulrender
	59223,		-- Brother Korloff
	3977,		-- High Inquisitor Whitemane
	60040,		-- Commander Durand
	-- Scholomance
	58633,		-- Instructor Chillheart
	59184,		-- Jandice Barov
	59153,		-- Rattlegore
	58722,		-- Lilian Voss
	58791,		-- Lilian's Soul
	59080,		-- Darkmaster Gandling
	-- Stormstout Brewery
	56637,		-- Ook-Ook
	56717,		-- Hoptallus
	59479,		-- Yan-Zhu the Uncasked
	-- Tempe of the Jade Serpent
	56448,		-- Wise Mari
	56843,		-- Lorewalker Stonestep
	59051,		-- Strife
	59726,		-- Peril
	58826,		-- Zao Sunseeker
	56732,		-- Liu Flameheart
	56762,		-- Yu'lon
	56439,		-- Sha of Doubt
	-- Mogu'shan Palace
	61444,		-- Ming the Cunning
	61442,		-- Kuai the Brute
	61445,		-- Haiyan the Unstoppable
	61243,		-- Gekkan
	61398,		-- Xin the Weaponmaster
	-- Shado-Pan Monastery
	56747,		-- Gu Cloudstrike
	56541,		-- Master Snowdrift
	56719,		-- Sha of Violence
	56884,		-- Taran Zhu
	-- Gate of the Setting Sun
	56906,		-- Saboteur Kip'tilak
	56589,		-- Striker Ga'dok
	56636,		-- Commander Ri'mok
	56877,		-- Raigonn
	-- Siege of Niuzao Temple
	61567,		-- Vizier Jin'bak
	61634,		-- Commander Vo'jak
	61485,		-- General Pa'valak
	62205,		-- Wing Leader Ner'onok

	-- Training Dummies --
	46647,		-- Level 85 Training Dummy
	67127,		-- Level 90 Training Dummy
	31146,
	
	-- Pandaria Raid Adds --
	63346,		-- Tsulong: The Dark of Night
	62969,		-- Tsulong: Embodied Terror
	62977,		-- Tsulong: Frightspawn
	62919,		-- Tsulong: Unstable Sha
	61034,		-- Sha of Fear: Terror Spawn
	61003		-- Sha of Fear: Dread Spawn
}

SpecialUnit = nil
function SpecialUnit()
	local PQ_BossUnits = PQ_BossUnits
	
	if UnitExists("target") then
		local npcID = tonumber(UnitGUID("target"):sub(6,10), 16)
		
		-- Dungeons & Raids
		if UnitLevel("target") == -1 then return true else
			for i=1,#PQ_BossUnits do
				if PQ_BossUnits[i] == npcID then return true end
			end
			return false
		end
	else return false end
end


-- Special Aggro Conditions
PQ_Aggro = {
	60410, 	-- Elegon
	63053	-- Garalon's Leg
}

-- Temporary Buffs
PQ_BloodLust		= 2825
PQ_Heroism			= 32182
PQ_TimeWarp			= 80353
PQ_Hysteria			= 90355

-- Heroism Function.
PQ_HasHero = nil
function PQ_HasHero()
	local PQ_BL = PQ_BloodLust
	local PQ_Hero = PQ_Heroism
	local PQ_TW = PQ_TimeWarp
	local PQ_AH = PQ_Hysteria

	if UnitBuffID("player",PQ_BL)
		or UnitBuffID("player",PQ_Hero)
		or UnitBuffID("player",PQ_TW)
		or UnitBuffID("player",PQ_AH)
	then return true else return false end
end


--Racial Ids
PQ_RacialIDs = {
		28730,	--Arcane Torrent: Pally, Priest, Mage, Lock
		50613,	--Arcane Torrent: Death Knight
		80483,	--Arcane Torrent: Hunter
		129597,	--Arcane Torrent: Monk
		25046,	--Arcane Torrent: Rogue
		69179,	--Arcane Torrent: Warrior
		26297,	--Berserking: All Classes
		33702,	--Blood Fury: Mage, Lock
		33697,	--Blood Fury: Shaman, Monk
		20572,	--Blood Fury: Warrior, Hunter, Rogue, Death Knight
		7744,	--Will of the Forsaken: All Classes
		69041,	--Rocket Barrage: All Classes
		20594,	--StoneForm: All Classes
		20589,	--Escape Artist:All Classes
		59752	--Every Man for Himself
	}
	
Nova_Racial = nil
function Nova_Racial()
	local PQ_ActiveID = 0
		
	for i=1, #PQ_RacialIDs do
		if IsPlayerSpell(PQ_RacialIDs[i]) == true then
			PQ_ActiveID = PQ_RacialIDs[i]
		end
	end
	
	if PQ_ActiveID == 28730 then	--Arcane Torrent: Pally, Priest, Mage, Lock
		if GetSpellCooldown(PQ_ActiveID) == 0 
			and select(3, Nova_UnitInfo("player")) <= 98
			and UnitAffectingCombat("player")
			and SpecialUnit()
		then
			CastSpellByID(PQ_ActiveID)
			return true
		end
	elseif PQ_ActiveID == 50613 --Arcane Torrent: Death Knight
			or PQ_ActiveID == 80483 --Arcane Torrent: Hunter
			or PQ_ActiveID == 25046 --Arcane Torrent: Rogue
			or PQ_ActiveID == 69179 --Arcane Torrent: Warrior
		then
			if GetSpellCooldown(PQ_ActiveID) == 0 
				and select(4, Nova_UnitInfo("player")) <= 85
				and UnitAffectingCombat("player")
				and SpecialUnit()
			then
				CastSpellByID(PQ_ActiveID)
				return true
			end
	elseif PQ_ActiveID == 129597 then	--Arcane Torrent: Monk
		if GetSpellCooldown(PQ_ActiveID) == 0 
			and select(5, Nova_UnitInfo("player")) <= 3
			and UnitAffectingCombat("player")
			and SpecialUnit()
		then
			CastSpellByID(PQ_ActiveID)
			return true
		end
	elseif PQ_ActiveID == 26297 then	--Berserking: All Classes
		if GetSpellCooldown(PQ_ActiveID) == 0 
			and UnitAffectingCombat("player")
			and SpecialUnit()
		then
			CastSpellByID(PQ_ActiveID)
			return true
		end
	elseif PQ_ActiveID == 33702 --Blood Fury: Mage, Lock
			or PQ_ActiveID == 33697 --Blood Fury: Shaman, Monk
			or PQ_ActiveID == 20572 --Blood Fury: Warrior, Hunter, Rogue, Death Knight
		then	
			if GetSpellCooldown(PQ_ActiveID) == 0 
				and UnitAffectingCombat("player")
				and SpecialUnit()
			then
				CastSpellByID(PQ_ActiveID)
				return true
			end
	elseif PQ_ActiveID == 7744 then		--Will of the Forsaken: All Classes
		return false
	elseif PQ_ActiveID == 69041 then	--Rocket Barrage: All Classes
		return false
	elseif PQ_ActiveID == 20594 then	--StoneForm: All Classes
		return false
	elseif PQ_ActiveID == 20589 then	--Escape Artist:All Classes
		return false
	elseif PQ_ActiveID == 59752 then	--Every Man for Himself
		return false
	else
		return false
	end
end

_shorthand = nil
function _shorthand()
	_Chat = PQR_WriteToChat
	_UB = UnitBuffID
	_UDB = UnitDebuffID
	_Mod = Nova_Mod
	_SA = PQR_SpellAvailable
	_PS = IsPlayerSpell
	_SIR = IsSpellInRange
	_GI	= GetSpellInfo
	_UE = UnitExists
	_CSN = CastSpellByName
end


if PQR_LoadLua("PQR_Encryption.lua") == false then
	PQR_WriteToChat("You are missing PQR_Encryption.lua. Rotation has been stopped.", "Error")
	PQR_StopRotation()
	return true
end

if not RunOnce then
	LoadStringEvent()
	RunOnce = true
end