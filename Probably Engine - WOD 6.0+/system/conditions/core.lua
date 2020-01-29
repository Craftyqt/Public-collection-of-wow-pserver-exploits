-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local GetTime = GetTime
local GetSpellBookIndex = GetSpellBookIndex
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local UnitClassification = UnitClassification
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsPlayer = UnitIsPlayer
local UnitName = UnitName
local stringFind = string.find
local stringLower = string.lower
local stringGmatch = string.gmatch

local ProbablyEngineTempTable1 = { }
local rangeCheck = LibStub("LibRangeCheck-2.0")
local LibDispellable = LibStub("LibDispellable-1.0")
local LibBoss = LibStub("LibBossIDs-1.0")

local UnitBuff = function(target, spell, owner)
    local buff, count, caster, expires, spellID
    if tonumber(spell) then
    local i = 0; local go = true
    while i <= 40 and go do
        i = i + 1
        buff,_,_,count,_,_,expires,caster,_,_,spellID = _G['UnitBuff'](target, i)
        if not owner then
        if spellID == tonumber(spell) and caster == "player" then go = false end
        elseif owner == "any" then
        if spellID == tonumber(spell) then go = false end
        end
    end
    else
    buff,_,_,count,_,_,expires,caster = _G['UnitBuff'](target, spell)
    end
    return buff, count, expires, caster
end

local UnitDebuff = function(target, spell, owner)
    local debuff, count, caster, expires, spellID
    if tonumber(spell) then
    local i = 0; local go = true
    while i <= 40 and go do
        i = i + 1
        debuff,_,_,count,_,_,expires,caster,_,_,spellID,_,_,_,power = _G['UnitDebuff'](target, i)
        if not owner then
        if spellID == tonumber(spell) and caster == "player" then go = false end
        elseif owner == "any" then
        if spellID == tonumber(spell) then go = false end
        end
    end
    else
    debuff,_,_,count,_,_,expires,caster = _G['UnitDebuff'](target, spell)
    end
    return debuff, count, expires, caster, power
end

ProbablyEngine.condition.register("dispellable", function(target, spell)
    if LibDispellable:CanDispelWith(target, GetSpellID(GetSpellName(spell))) then
    return true
    end
    return false
end)

ProbablyEngine.condition.register("buff", function(target, spell)
    local buff,_,_,caster = UnitBuff(target, spell)
    if not not buff and (caster == 'player' or caster == 'pet') then
    return true
    end
    return false
end)

ProbablyEngine.condition.register("buff.any", function(target, spell)
    local buff,_,_,caster = UnitBuff(target, spell, "any")
    if not not buff then
    return true
    end
    return false
end)

ProbablyEngine.condition.register("buff.count", function(target, spell)
    if tonumber(spell) then spell = GetSpellInfo(spell) end
    local buff,count,_,caster = UnitBuff(target, spell)
    if not not buff and (caster == 'player' or caster == 'pet') then
    return count
    end
    return 0
end)

ProbablyEngine.condition.register("debuff", function(target, spell)
    local debuff,_,_,caster = UnitDebuff(target, spell)
    if not not debuff and (caster == 'player' or caster == 'pet') then
    return true
    end
    return false
end)

ProbablyEngine.condition.register("debuff.any", function(target, spell)
    local debuff,_,_,caster = UnitDebuff(target, spell, "any")
    if not not debuff then
    return true
    end
    return false
end)

ProbablyEngine.condition.register("debuff.count", function(target, spell)
    local debuff,count,_,caster = UnitDebuff(target, spell)
    if not not debuff and (caster == 'player' or caster == 'pet') then
    return count
    end
    return 0
end)

ProbablyEngine.condition.register("debuff.duration", function(target, spell)
    local debuff,_,expires,caster = UnitDebuff(target, spell)
    if not not debuff and (caster == 'player' or caster == 'pet') then
    return (expires - GetTime())
    end
    return 0
end)

ProbablyEngine.condition.register("buff.duration", function(target, spell)
    local buff,_,expires,caster = UnitBuff(target, spell)
    if not not buff and (caster == 'player' or caster == 'pet') then
    return (expires - GetTime())
    end
    return 0
end)


--[[
ProbablyEngine.condition.register("aura.", function(target, spell)
    local guid = UnitGUID(target)
    if guid then
        local unit = ProbablyEngine.module.tracker.units[guid]
        if unit then
            local aura = unit.auras[GetSpellID(spell)]
            local track = false
            if aura['damage'] and not aura['heal'] then
                track = aura['damage']
            elseif aura['heal'] and not aura['damage'] then
                track = aura['heal']
            end
            if track then
                return track.
            end
        end
    end
    return false
end)
]]

local function smartQueryTracker(target, spell, key)
    local guid = UnitGUID(target)
    if guid then
        local unit = ProbablyEngine.module.tracker.units[guid]
        if unit then
            local aura = unit.auras[GetSpellID(spell)]
            if aura then
                local track = false
                if key == 'stacks' or key == 'time' then
                    track = aura
                else
                    if aura['damage'] and not aura['heal'] then
                        track = aura['damage']
                    elseif aura['heal'] and not aura['damage'] then
                        track = aura['heal']
                    end
                end
                if track then
                    return track[key]
                end
            end
        end
    end
    return false
end

ProbablyEngine.condition.register("aura.crit", function(target, spell)
    return smartQueryTracker(target, spell, 'crit')
end)

ProbablyEngine.condition.register("aura.crits", function(target, spell)
    return smartQueryTracker(target, spell, 'crits')
end)

ProbablyEngine.condition.register("aura.avg", function(target, spell)
    return smartQueryTracker(target, spell, 'avg')
end)

ProbablyEngine.condition.register("aura.last", function(target, spell)
    return smartQueryTracker(target, spell, 'last')
end)

ProbablyEngine.condition.register("aura.low", function(target, spell)
    return smartQueryTracker(target, spell, 'low')
end)

ProbablyEngine.condition.register("aura.high", function(target, spell)
    return smartQueryTracker(target, spell, 'high')
end)

ProbablyEngine.condition.register("aura.total", function(target, spell)
    return smartQueryTracker(target, spell, 'total')
end)

ProbablyEngine.condition.register("aura.stacks", function(target, spell)
    return smartQueryTracker(target, spell, 'stacks')
end)

ProbablyEngine.condition.register("aura.time", function(target, spell)
    return smartQueryTracker(target, spell, 'time')
end)

ProbablyEngine.condition.register("aura.uptime", function(target, spell)
    return smartQueryTracker(target, spell, 'time') - GetTime()
end)

ProbablyEngine.condition.register("stance", function(target, spell)
    return GetShapeshiftForm()
end)

ProbablyEngine.condition.register("form", function(target, spell)
    return GetShapeshiftForm()
end)

ProbablyEngine.condition.register("seal", function(target, spell)
    return GetShapeshiftForm()
end)

ProbablyEngine.condition.register("focus", function(target, spell)
    return UnitPower(target, SPELL_POWER_FOCUS)
end)

ProbablyEngine.condition.register("holypower", function(target, spell)
    return UnitPower(target, SPELL_POWER_HOLY_POWER)
end)

ProbablyEngine.condition.register("shadoworbs", function(target, spell)
    return UnitPower(target, SPELL_POWER_SHADOW_ORBS)
end)

ProbablyEngine.condition.register("energy", function(target, spell)
    return UnitPower(target, SPELL_POWER_ENERGY)
end)

ProbablyEngine.condition.register("solar", function(target, spell)
    return GetEclipseDirection() == 'sun'
end)

ProbablyEngine.condition.register("lunar", function(target, spell)
    return GetEclipseDirection() == 'moon'
end)

ProbablyEngine.condition.register("eclipse", function(target, spell)
    return math.abs(UnitPower(target, SPELL_POWER_ECLIPSE))
end)

ProbablyEngine.condition.register("eclipseRaw", function(target, spell)
    return UnitPower(target, SPELL_POWER_ECLIPSE)
end)

ProbablyEngine.condition.register("timetomax", function(target, spell)
    local max = UnitPowerMax(target)
    local curr = UnitPower(target)
    local regen = select(2, GetPowerRegen(target))
    return (max - curr) * (1.0 / regen)
end)

ProbablyEngine.condition.register("stealable", function(target, spellCast, spell)
    for i=1, 40 do
        local name, _, _, _, _, _, _, _, isStealable, _ = UnitAura(target, i)
        if isStealable then
            if spell then
                if spell == GetSpellName(spell) then
                    return true
                else
                    return false
                end
            end
            return true
        end
    end
    return false
end)

ProbablyEngine.condition.register("tomax", function(target, spell)
    return ProbablyEngine.condition["timetomax"](toggle)
end)

ProbablyEngine.condition.register("rage", function(target, spell)
    return UnitPower(target, SPELL_POWER_RAGE)
end)

ProbablyEngine.condition.register("chi", function(target, spell)
    return UnitPower(target, SPELL_POWER_CHI)
end)

ProbablyEngine.condition.register("demonicfury", function(target, spell)
    return UnitPower(target, SPELL_POWER_DEMONIC_FURY)
end)

ProbablyEngine.condition.register("embers", function(target, spell)
    return UnitPower(target, SPELL_POWER_BURNING_EMBERS, true)
end)

ProbablyEngine.condition.register("soulshards", function(target, spell)
    return UnitPower(target, SPELL_POWER_SOUL_SHARDS)
end)

ProbablyEngine.condition.register("behind", function(target, spell)
    if FireHack then
        return not UnitInfront(target, 'player')
    end
    return ProbablyEngine.module.player.behind
end)

ProbablyEngine.condition.register("infront", function(target, spell)
    if FireHack then
        return UnitInfront(target, 'player')
    end
    return ProbablyEngine.module.player.infront
end)

ProbablyEngine.condition.register("disarmable", function(target, spell)
    return ProbablyEngine.module.disarm.check(target)
end)

ProbablyEngine.condition.register("combopoints", function()
    return GetComboPoints('player', 'target')
end)

ProbablyEngine.condition.register("alive", function(target, spell)
    if UnitExists(target) and UnitHealth(target) > 0 then
    return true
    end
    return false
end)

ProbablyEngine.condition.register('dead', function (target)
    return UnitIsDeadOrGhost(target)
end)

ProbablyEngine.condition.register('swimming', function ()
    return IsSwimming()
end)

ProbablyEngine.condition.register("target", function(target, spell)
    return ( UnitGUID(target .. "target") == UnitGUID(spell) )
end)

--[[
ProbablyEngine.condition.register("player", function(target, spell)
    return UnitName('player') == UnitName(target)
end)--]]

ProbablyEngine.condition.register("player", function (target)
    return UnitIsPlayer(target)
end)

ProbablyEngine.condition.register("exists", function(target)
    return (UnitExists(target))
end)

ProbablyEngine.condition.register("modifier.shift", function()
    return IsShiftKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

ProbablyEngine.condition.register("modifier.control", function()
    return IsControlKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

ProbablyEngine.condition.register("modifier.alt", function()
    return IsAltKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

ProbablyEngine.condition.register("modifier.lshift", function()
    return IsLeftShiftKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

ProbablyEngine.condition.register("modifier.lcontrol", function()
    return IsLeftControlKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

ProbablyEngine.condition.register("modifier.lalt", function()
    return IsLeftAltKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

ProbablyEngine.condition.register("modifier.rshift", function()
    return IsRightShiftKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

ProbablyEngine.condition.register("modifier.rcontrol", function()
    return IsRightControlKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

ProbablyEngine.condition.register("modifier.ralt", function()
    return IsRightAltKeyDown() and GetCurrentKeyBoardFocus() == nil
end)

ProbablyEngine.condition.register("modifier.player", function()
    return UnitIsPlayer("target")
end)

ProbablyEngine.condition.register("classification", function (target, spell)
    if not spell then return false end
    local classification = UnitClassification(target)
    if stringFind(spell, '[%s,]+') then
    for classificationExpected in stringGmatch(spell, '%a+') do
        if classification == stringLower(classificationExpected) then
        return true
        end
    end
    return false
    else
    return UnitClassification(target) == stringLower(spell)
    end
end)

ProbablyEngine.condition.register('boss', function (target, spell)
    local classification = UnitClassification(target)
    if spell == 'true' and (classification == 'rareelite' or classification == 'rare') then
    return true
    end
    if classification == 'worldboss' or LibBoss.BossIDs[tonumber(UnitID(target))] then
    return true
    end
    return false
end)

ProbablyEngine.condition.register("id", function(target, id)
    local expectedID = tonumber(id)
    if expectedID and UnitID(target) == expectedID then
        return true
    end
    return false
end)

ProbablyEngine.condition.register("toggle", function(toggle)
    return ProbablyEngine.condition["modifier.toggle"](toggle)
end)

ProbablyEngine.condition.register("modifier.toggle", function(toggle)
    return ProbablyEngine.config.read('button_states', toggle, false)
end)

ProbablyEngine.condition.register("modifier.taunt", function()
    if ProbablyEngine.condition["modifier.toggle"]('taunt') then
        if UnitThreatSituation("player", "target") then
            local status = UnitThreatSituation("player", "target")
            return (status < 3)
        end
        return false
    end
    return false
end)

ProbablyEngine.condition.register("threat", function(target)
    if UnitThreatSituation("player", target) then
    local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("player", target)
    return scaledPercent
    end
    return 0
end)

ProbablyEngine.condition.register("agro", function(target)
    if UnitThreatSituation(target) and UnitThreatSituation(target) >= 2 then
    return true
    end
    return false
end)


ProbablyEngine.condition.register("balance.sun", function()
    local direction = GetEclipseDirection()
    if direction == 'none' or direction == 'sun' then return true end
end)

ProbablyEngine.condition.register("balance.moon", function()
    local direction = GetEclipseDirection()
    if direction == 'moon' then return true end
end)

ProbablyEngine.condition.register("moving", function(target)
    local speed, _ = GetUnitSpeed(target)
    return speed ~= 0
end)


local movingCache = { }

ProbablyEngine.condition.register("lastmoved", function(target)
    if target == 'player' then
        if not ProbablyEngine.module.player.moving then
            return GetTime() - ProbablyEngine.module.player.movingTime
        end
        return false
    else
        if UnitExists(target) then
            local guid = UnitGUID(target)
            if movingCache[guid] then
                local moving = (GetUnitSpeed(target) > 0)
                if not movingCache[guid].moving and moving then
                    movingCache[guid].last = GetTime()
                    movingCache[guid].moving = true
                    return false
                elseif moving then
                    return false
                elseif not moving then
                    movingCache[guid].moving = false
                    return GetTime() - movingCache[guid].last
                end
            else
                movingCache[guid] = { }
                movingCache[guid].last = GetTime()
                movingCache[guid].moving = (GetUnitSpeed(target) > 0)
                return false
            end
        end
        return false
    end
end)

ProbablyEngine.condition.register("movingfor", function(target)
    if target == 'player' then
        if ProbablyEngine.module.player.moving then
            return GetTime() - ProbablyEngine.module.player.movingTime
        end
        return false
    else
        if UnitExists(target) then
            local guid = UnitGUID(target)
            if movingCache[guid] then
                local moving = (GetUnitSpeed(target) > 0)
                if not movingCache[guid].moving then
                    movingCache[guid].last = GetTime()
                    movingCache[guid].moving = (GetUnitSpeed(target) > 0)
                    return false
                elseif moving then
                    return GetTime() - movingCache[guid].last
                elseif not moving then
                    movingCache[guid].moving = false
                    return false
                end
            else
                movingCache[guid] = { }
                movingCache[guid].last = GetTime()
                movingCache[guid].moving = (GetUnitSpeed(target) > 0)
                return false
            end
        end
        return false
    end
end)

-- DK Power

ProbablyEngine.condition.register("runicpower", function(target, spell)
    return UnitPower(target, SPELL_POWER_RUNIC_POWER)
end)

local runes_t = {
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0
}
local runes_c = {
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0
}

ProbablyEngine.condition.register("runes.count", function(target, rune)
    -- 12 b, 34 f, 56 u
    runes_t[1], runes_t[2], runes_t[3], runes_t[4], runes_c[1], runes_c[2], runes_c[3], runes_c[4] = 0,0,0,0,0,0,0,0
    for i=1, 6 do
        local _, _, c = GetRuneCooldown(i)
        local t = GetRuneType(i)
        runes_t[t] = runes_t[t] + 1
        if c then
            runes_c[t] = runes_c[t] + 1
        end
    end
    if rune == 'frost' then
        return runes_c[3]
    elseif rune == 'blood' then
        return runes_c[1]
    elseif rune == 'unholy' then
        return runes_c[2]
    elseif rune == 'death' then
        return runes_c[4]
    elseif rune == 'Frost' then
        return runes_c[3] + runes_c[4]
    elseif rune == 'Blood' then
        return runes_c[1] + runes_c[4]
    elseif rune == 'Unholy' then
        return runes_c[2] + runes_c[4]
    end
    return 0
end)

ProbablyEngine.condition.register("runes.frac", function(target, rune)
    -- 12 b, 34 f, 56 u
    runes_t[1], runes_t[2], runes_t[3], runes_t[4], runes_c[1], runes_c[2], runes_c[3], runes_c[4] = 0,0,0,0,0,0,0,0
    for i=1, 6 do
        local r, d, c = GetRuneCooldown(i)
        local frac = 1-(r/d)
        local t = GetRuneType(i)
        runes_t[t] = runes_t[t] + 1
        if c then
            runes_c[t] = runes_c[t] + frac
        end
    end
    if rune == 'frost' then
        return runes_c[3]
    elseif rune == 'blood' then
        return runes_c[1]
    elseif rune == 'unholy' then
        return runes_c[2]
    elseif rune == 'death' then
        return runes_c[4]
    elseif rune == 'Frost' then
        return runes_c[3] + runes_c[4]
    elseif rune == 'Blood' then
        return runes_c[1] + runes_c[4]
    elseif rune == 'Unholy' then
        return runes_c[2] + runes_c[4]
    end
    return 0
end)

ProbablyEngine.condition.register("runes.cooldown_min", function(target, rune)
    -- 12 b, 34 f, 56 u
    runes_t[1], runes_t[2], runes_t[3], runes_t[4], runes_c[1], runes_c[2], runes_c[3], runes_c[4] = 0,0,0,0,0,0,0,0
    for i=1, 6 do
        local r, d, c = GetRuneCooldown(i)
        local cd = (r + d) - GetTime()
        local t = GetRuneType(i)
        runes_t[t] = runes_t[t] + 1
        if cd > 0 and runes_c[t] > cd then
            runes_c[t] = cd
        else
            runes_c[t] = 8675309
        end
    end
    if rune == 'frost' then
        return runes_c[3]
    elseif rune == 'blood' then
        return runes_c[1]
    elseif rune == 'unholy' then
        return runes_c[2]
    elseif rune == 'death' then
        return runes_c[4]
    elseif rune == 'Frost' then
        if runes_c[3] < runes_c[4] then
            return runes_c[3]
        end
        return runes_c[4]
    elseif rune == 'Blood' then
        if runes_c[1] < runes_c[4] then
            return runes_c[1]
        end
        return runes_c[4]
    elseif rune == 'Unholy' then
        if runes_c[2] < runes_c[4] then
            return runes_c[2]
        end
        return runes_c[4]
    end
    return 0
end)

ProbablyEngine.condition.register("runes.cooldown_max", function(target, rune)
    -- 12 b, 34 f, 56 u
    runes_t[1], runes_t[2], runes_t[3], runes_t[4], runes_c[1], runes_c[2], runes_c[3], runes_c[4] = 0,0,0,0,0,0,0,0
    for i=1, 6 do
        local r, d, c = GetRuneCooldown(i)
        local cd = (r + d) - GetTime()
        local t = GetRuneType(i)
        runes_t[t] = runes_t[t] + 1
        if cd > 0 and runes_c[t] < cd then
            runes_c[t] = cd
        end
    end
    if rune == 'frost' then
        return runes_c[3]
    elseif rune == 'blood' then
        return runes_c[1]
    elseif rune == 'unholy' then
        return runes_c[2]
    elseif rune == 'death' then
        return runes_c[4]
    elseif rune == 'Frost' then
        if runes_c[3] > runes_c[4] then
            return runes_c[3]
        end
        return runes_c[4]
    elseif rune == 'Blood' then
        if runes_c[1] > runes_c[4] then
            return runes_c[1]
        end
        return runes_c[4]
    elseif rune == 'Unholy' then
        if runes_c[2] > runes_c[4] then
            return runes_c[2]
        end
        return runes_c[4]
    end
    return 0
end)


ProbablyEngine.condition.register("runes.depleted", function(target, spell)
    local regeneration_threshold = 1
    for i=1,6,2 do
        local start, duration, runeReady = GetRuneCooldown(i)
        local start2, duration2, runeReady2 = GetRuneCooldown(i+1)
        if not runeReady and not runeReady2 and duration > 0 and duration2 > 0 and start > 0 and start2 > 0 then
            if (start-GetTime()+duration)>=regeneration_threshold and (start2-GetTime()+duration2)>=regeneration_threshold then
                return true
            end
        end
    end
    return false
end)

ProbablyEngine.condition.register("runes", function(target, rune)
    return ProbablyEngine.condition["runes.count"](target, rune)
end)

ProbablyEngine.condition.register("health", function(target)
    if UnitExists(target) then
        return math.floor((UnitHealth(target) / UnitHealthMax(target)) * 100)
    end
    return 0
end)

ProbablyEngine.condition.register("health.actual", function(target)
    return UnitHealth(target)
end)

ProbablyEngine.condition.register("health.max", function(target)
    return UnitHealthMax(target)
end)

ProbablyEngine.condition.register("mana", function(target, spell)
    if UnitExists(target) then
        return math.floor((UnitMana(target) / UnitManaMax(target)) * 100)
    end
    return 0
end)

ProbablyEngine.condition.register("raid.health", function()
    return ProbablyEngine.raid.raidPercent()
end)

ProbablyEngine.condition.register("modifier.multitarget", function()
    return ProbablyEngine.condition["modifier.toggle"]('multitarget')
end)

ProbablyEngine.condition.register("modifier.cooldowns", function()
    return ProbablyEngine.condition["modifier.toggle"]('cooldowns')
end)

ProbablyEngine.condition.register("modifier.cooldown", function()
    return ProbablyEngine.condition["modifier.toggle"]('cooldowns')
end)

ProbablyEngine.condition.register("modifier.interrupts", function()
    if ProbablyEngine.condition["modifier.toggle"]('interrupt') then
    local stop = ProbablyEngine.condition["casting"]('target')
    if stop then StopCast() end
    return stop
    end
    return false
end)

ProbablyEngine.condition.register("modifier.interrupt", function()
    if ProbablyEngine.condition["modifier.toggle"]('interrupt') then
    return ProbablyEngine.condition["casting"]('target')
    end
    return false
end)

local lastDepWarn = false

ProbablyEngine.condition.register("modifier.last", function(target, spell)
    if not lastDepWarn then
        ProbablyEngine.print('modifier.last has been deprecated, please use lastcast')
        lastDepWarn = true
    end
    return ProbablyEngine.parser.lastCast == GetSpellName(spell)
end)

ProbablyEngine.condition.register("lastcast", function(spell, arg)
    if arg then spell = arg end
    return ProbablyEngine.parser.lastCast == GetSpellName(spell)
end)

ProbablyEngine.condition.register("enchant.mainhand", function()
    return (select(1, GetWeaponEnchantInfo()) == 1)
end)

ProbablyEngine.condition.register("enchant.offhand", function()
    return (select(4, GetWeaponEnchantInfo()) == 1)
end)

ProbablyEngine.condition.register("totem", function(target, totem)
    for index = 1, 4 do
        local _, totemName, startTime, duration = GetTotemInfo(index)
        if totemName == GetSpellName(totem) then
            return true
        end
    end
    return false
end)

ProbablyEngine.condition.register("totem.duration", function(target, totem)
    for index = 1, 4 do
    local _, totemName, startTime, duration = GetTotemInfo(index)
    if totemName == GetSpellName(totem) then
        return floor(startTime + duration - GetTime())
    end
    end
    return 0
end)

ProbablyEngine.condition.register("mushrooms", function ()
    local count = 0
    for slot = 1, 3 do
    if GetTotemInfo(slot) then
        count = count + 1 end
    end
    return count
end)

local function checkChanneling(target)
    local name, _, _, _, startTime, endTime, _, notInterruptible = UnitChannelInfo(target)
    if name then return name, startTime, endTime, notInterruptible end

    return false
end

local function checkCasting(target)
    local name, startTime, endTime, notInterruptible = checkChanneling(target)
    if name then return name, startTime, endTime, notInterruptible end

    local name, _, _, _, startTime, endTime, _, _, notInterruptible = UnitCastingInfo(target)
    if name then return name, startTime, endTime, notInterruptible end

    return false
end

ProbablyEngine.condition.register('casting.time', function(target, spell)
    local name, startTime, endTime = checkCasting(target)
    if not endTime or not startTime then return false end
    if name then return (endTime - startTime) / 1000 end
    return false
end)

ProbablyEngine.condition.register('casting.delta', function(target, spell)
    local name, startTime, endTime, notInterruptible = checkCasting(target)
    if not endTime or not startTime then return false end
    if name and not notInterruptible then
    local castLength = (endTime - startTime) / 1000
    local secondsLeft = endTime / 1000  - GetTime()
    return secondsLeft, castLength
    end
    return false
end)

ProbablyEngine.condition.register('casting.percent', function(target, spell)
    local name, startTime, endTime, notInterruptible = checkCasting(target)
    if name and not notInterruptible then
    local castLength = (endTime - startTime) / 1000
    local secondsLeft = endTime / 1000  - GetTime()
    return ((secondsLeft/castLength)*100)
    end
    return false
end)

ProbablyEngine.condition.register('channeling', function (target, spell)
    return checkChanneling(target)
end)

ProbablyEngine.condition.register("casting", function(target, spell)
    local castName,_,_,_,_,endTime,_,_,notInterruptibleCast = UnitCastingInfo(target)
    local channelName,_,_,_,_,endTime,_,notInterruptibleChannel = UnitChannelInfo(target)
    spell = GetSpellName(spell)
    if (castName == spell or channelName == spell) and not not spell then
    return true
    elseif notInterruptibleCast == false or notInterruptibleChannel == false then
    return true
    end
    return false
end)

ProbablyEngine.condition.register('interruptsAt', function (target, spell)
    if ProbablyEngine.condition['modifier.toggle']('interrupt') then
    if UnitName('player') == UnitName(target) then return false end
    local stopAt = tonumber(spell) or 95
    local secondsLeft, castLength = ProbablyEngine.condition['casting.delta'](target)
    if secondsLeft and 100 - (secondsLeft / castLength * 100) > stopAt then
        StopCast()
        return true
    end
    end
    return false
end)

ProbablyEngine.condition.register('interruptAt', function (target, spell)
    if ProbablyEngine.condition['modifier.toggle']('interrupt') then
    if UnitName('player') == UnitName(target) then return false end
    local stopAt = tonumber(spell) or 95
    local secondsLeft, castLength = ProbablyEngine.condition['casting.delta'](target)
    if secondsLeft and 100 - (secondsLeft / castLength * 100) > stopAt then
        return true
    end
    end
    return false
end)

ProbablyEngine.condition.register("spell.cooldown", function(target, spell)
    local start, duration, enabled = GetSpellCooldown(spell)
    if not start then return false end
    if start ~= 0 then
    return (start + duration - GetTime())
    end
    return 0
end)

ProbablyEngine.condition.register("spell.recharge", function(target, spell)
    local charges, maxCharges, start, duration = GetSpellCharges(spell)
    if not start then return false end
    if start ~= 0 then
    return (start + duration - GetTime())
    end
    return 0
end)

ProbablyEngine.condition.register("spell.usable", function(target, spell)
    return (IsUsableSpell(spell) ~= nil)
end)

ProbablyEngine.condition.register("spell.exists", function(target, spell)
    if GetSpellBookIndex(spell) then
    return true
    end
    return false
end)

ProbablyEngine.condition.register("spell.casted", function(target, spell)
    return ProbablyEngine.module.player.casted(GetSpellName(spell))
end)

ProbablyEngine.condition.register("spell.charges", function(target, spell)
    return select(1, GetSpellCharges(spell))
end)

ProbablyEngine.condition.register("spell.cd", function(target, spell)
    return ProbablyEngine.condition["spell.cooldown"](target, spell)
end)

ProbablyEngine.condition.register("spell.range", function(target, spell)
    local spellIndex, spellBook = GetSpellBookIndex(spell)
    if not spellIndex then return false end
    return spellIndex and IsSpellInRange(spellIndex, spellBook, target)
end)

ProbablyEngine.condition.register("talent", function(args)
    local row, col = strsplit(",", args, 2)
    return hasTalent(tonumber(row), tonumber(col))
end)

ProbablyEngine.condition.register("friend", function(target, spell)
    return ( UnitCanAttack("player", target) ~= 1 )
end)

ProbablyEngine.condition.register("enemy", function(target, spell)
    return ( UnitCanAttack("player", target) )
end)

ProbablyEngine.condition.register("glyph", function(target, spell)
    local spellId = tonumber(spell)
    local glyphName, glyphId

    for i = 1, 6 do
    glyphId = select(4, GetGlyphSocketInfo(i))
    if glyphId then
        if spellId then
        if select(4, GetGlyphSocketInfo(i)) == spellId then
            return true
        end
        else
        glyphName = GetSpellName(glyphId)
        if glyphName:find(spell) then
            return true
        end
        end
    end
    end
    return false
end)

ProbablyEngine.condition.register("range", function(target)
    return ProbablyEngine.condition["distance"](target)
end)

ProbablyEngine.condition.register("distance", function(target)
    if Distance then
        return math.floor(Distance(target, 'player'))
    else -- fall back to libRangeCheck
        local minRange, maxRange = rangeCheck:GetRange(target)
        return maxRange or minRange
    end
end)

ProbablyEngine.condition.register("level", function(target, range)
    return UnitLevel(target)
end)

ProbablyEngine.condition.register("combat", function(target, range)
    return UnitAffectingCombat(target)
end)

ProbablyEngine.condition.register("time", function(target, range)
    if ProbablyEngine.module.player.combatTime then
        return GetTime() - ProbablyEngine.module.player.combatTime
    end
    return false
end)


local deathTrack = { }
ProbablyEngine.condition.register("deathin", function(target, range)
    local guid = UnitGUID(target)
    if deathTrack[target] and deathTrack[target].guid == guid then
        local start = deathTrack[target].time
        local currentHP = UnitHealth(target)
        local maxHP = deathTrack[target].start
        local diff = maxHP - currentHP
        local dura = GetTime() - start
        local hpps = diff / dura
        local death = currentHP / hpps
        if death == math.huge then
            return 8675309
        elseif death < 0 then
            return 0
        else
            return death
        end
    elseif deathTrack[target] then
        table.empty(deathTrack[target])
    else
        deathTrack[target] = { }
    end
    deathTrack[target].guid = guid
    deathTrack[target].time = GetTime()
    deathTrack[target].start = UnitHealth(target)
    return 8675309
end)

ProbablyEngine.condition.register("ttd", function(target, range)
    return ProbablyEngine.condition["deathin"](target)
end)

ProbablyEngine.condition.register("role", function(target, role)
    role = role:upper()

    local damageAliases = { "DAMAGE", "DPS", "DEEPS" }

    local targetRole = UnitGroupRolesAssigned(target)
    if targetRole == role then return true
    elseif role:find("HEAL") and targetRole == "HEALER" then return true
    else
    for i = 1, #damageAliases do
        if role == damageAliases[i] then return true end
    end
    end

    return false
end)

ProbablyEngine.condition.register("name", function (target, expectedName)
    return UnitExists(target) and UnitName(target):lower():find(expectedName:lower()) ~= nil
end)

ProbablyEngine.condition.register("modifier.party", function()
    return IsInGroup()
end)

ProbablyEngine.condition.register("modifier.raid", function()
    return IsInRaid()
end)

ProbablyEngine.condition.register("party", function(target)
    return UnitInParty(target)
end)

ProbablyEngine.condition.register("raid", function(target)
    return UnitInRaid(target)
end)

ProbablyEngine.condition.register("modifier.members", function()
    return (GetNumGroupMembers() or 0)
end)

ProbablyEngine.condition.register("creatureType", function (target, expectedType)
    return UnitCreatureType(target) == expectedType
end)

ProbablyEngine.condition.register("class", function (target, expectedClass)
    local class, _, classID = UnitClass(target)

    if tonumber(expectedClass) then
    return tonumber(expectedClass) == classID
    else
    return expectedClass == class
    end
end)

ProbablyEngine.condition.register("falling", function()
    return IsFalling()
end)

ProbablyEngine.condition.register("timeout", function(args)
    local name, time = strsplit(",", args, 2)
    if tonumber(time) then
        if ProbablyEngine.timeout.check(name) then
            return false
        end
        ProbablyEngine.timeout.set(name, tonumber(time))
        return true
    end
    return false
end)

local heroismBuffs = { 32182, 90355, 80353, 2825, 146555 }

ProbablyEngine.condition.register("hashero", function(unit, spell)
    for i = 1, #heroismBuffs do
    if UnitBuff('player', GetSpellName(heroismBuffs[i])) then
        return true
    end
    end
    return false
end)

ProbablyEngine.condition.register("buffs.stats", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(1) ~= nil)
end)

ProbablyEngine.condition.register("buffs.stamina", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(2) ~= nil)
end)

ProbablyEngine.condition.register("buffs.attackpower", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(3) ~= nil)
end)

ProbablyEngine.condition.register("buffs.attackspeed", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(4) ~= nil)
end)

ProbablyEngine.condition.register("buffs.haste", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(4) ~= nil)
end)

ProbablyEngine.condition.register("buffs.spellpower", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(5) ~= nil)
end)

ProbablyEngine.condition.register("buffs.crit", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(6) ~= nil)
end)
ProbablyEngine.condition.register("buffs.critical", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(6) ~= nil)
end)
ProbablyEngine.condition.register("buffs.criticalstrike", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(6) ~= nil)
end)

ProbablyEngine.condition.register("buffs.mastery", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(7) ~= nil)
end)

ProbablyEngine.condition.register("buffs.multistrike", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(8) ~= nil)
end)
ProbablyEngine.condition.register("buffs.multi", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(8) ~= nil)
end)

ProbablyEngine.condition.register("buffs.vers", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(9) ~= nil)
end)
ProbablyEngine.condition.register("buffs.versatility", function(unit, _)
    return (GetRaidBuffTrayAuraInfo(9) ~= nil)
end)

ProbablyEngine.condition.register("charmed", function(unit, _)
    return (UnitIsCharmed(unit) == true)
end)

ProbablyEngine.condition.register("vengeance", function(unit, spell)
    local vengeance = select(15, _G['UnitBuff']("player", GetSpellName(132365)))
    if not vengeance then
        return 0
    end
    if spell then
        return vengeance
    end
    return vengeance / UnitHealthMax("player") * 100
end)

ProbablyEngine.condition.register("area.enemies", function(unit, distance)
    if UnitsAroundUnit then
        local total = UnitsAroundUnit(unit, tonumber(distance))
        return total
    end
    return 0
end)

ProbablyEngine.condition.register("area.friendly", function(unit, distance)
    if FriendlyUnitsAroundUnit then
        local total = FriendlyUnitsAroundUnit(unit, tonumber(distance))
        return total
    end
    return 0
end)

ProbablyEngine.condition.register("ilevel", function(unit, _)
    return math.floor(select(1,GetAverageItemLevel()))
end)

ProbablyEngine.condition.register("firehack", function(unit, _)
    return FireHack or false
end)

ProbablyEngine.condition.register("offspring", function(unit, _)
    return type(opos) == 'function' or false
end)