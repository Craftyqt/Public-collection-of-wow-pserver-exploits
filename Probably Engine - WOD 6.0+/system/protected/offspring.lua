-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

-- Functions that require OffSpring

local L = ProbablyEngine.locale.get

function ProbablyEngine.protected.OffSpring()

    if oexecute then

        ProbablyEngine.faceroll.rolling = false

        ProbablyEngine.pmethod = "OffSpring"

        function Cast(spell, target)
            if type(spell) == "number" then
                if target then
                    oexecute("CastSpellByID(".. spell ..", \""..target.."\")")
                else
                    oexecute("CastSpellByID(".. spell ..")")
                end
            else
                if target then
                    oexecute("CastSpellByName(\"".. spell .."\", \""..target.."\")")
                else
                    oexecute("CastSpellByName(\"".. spell .."\")")
                end
            end
        end

        local CastGroundOld = CastGround
        function CastGround(spell, target)
            if UnitExists(target) then
                Cast(spell, target)
                UnitWorldClick(target)
                return
            end
            CastGroundOld(spell, target) -- try the old one ?
        end

        function LineOfSight(a, b)
            if a ~= 'player' then
                ProbablyEngine.print(L('offspring_los_warn'))
            end
            return UnitInLos(b)
        end

        function Macro(text)
            oexecute("RunMacroText(\""..text.."\")")
        end

        function Distance(a, b)
            if UnitExists(a) and UnitIsVisible(a) and UnitExists(b) and UnitIsVisible(b) then
                local ax, ay, az, ar = UnitPosition(a)
                local bx, by, bz, br = UnitPosition(b)
                return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2))
            end
            return 0
        end

        function FaceUnit(unit)
            if UnitExists(unit) and UnitIsVisible(unit) then
                FaceToUnit(unit)
            end
        end

        function UseItem(name, target)
            if type(spell) == "number" then
                if target then
                    oexecute("UseItemByName(".. spell ..", \""..target.."\")")
                else
                    oexecute("UseItemByName(".. spell ..")")
                end
            else
                if target then
                    oexecute("UseItemByName(\"".. spell .."\", \""..target.."\")")
                else
                    oexecute("UseItemByName(\"".. spell .."\")")
                end
            end
        end

        function UseInvItem(slot)
            return oexecute("UseInventoryItem(\""..slot.."\")")
        end

        function UnitInfront(unit1, unit2)
            if unit1 == 'player' then
                return not BehindUnit(unit2)
            else
                return not BehindUnit(unit1)
            end
        end

        local uau_cache_time = { }
        local uau_cache_count = { }
        local uau_cache_dura = 0.1
        function UnitsAroundUnit(unit, distance, ignoreCombat)
            local uau_cache_time_c = uau_cache_time[unit..distance..tostring(ignoreCombat)]
            if uau_cache_time_c and ((uau_cache_time_c + uau_cache_dura) > GetTime()) then
                return uau_cache_count[unit..distance..tostring(ignoreCombat)]
            end
            if UnitExists(unit) then
                local total = 0
                local totalObjects = ObjectsCount(unit, distance)
                for i = 1, totalObjects do
                    local pointer, id, name, bounding, x, y, z, facing, summonedbyme, createdbyme, combat, target = ObjectByIndex(i)
                    local _, oType = pcall(ObjectType, pointer)
                    local reaction = UnitReaction("player", pointer)
                    if reaction then
                        local combat = UnitAffectingCombat(pointer)
                        if reaction and reaction <= 4 and (ignoreCombat or combat) then
                            total = total + 1
                        end
                    end
                end
                uau_cache_count[unit..distance..tostring(ignoreCombat)] = total
                uau_cache_time[unit..distance..tostring(ignoreCombat)] = GetTime()
                return total - 1
            else
                return 0
            end
        end

        function FriendlyUnitsAroundUnit(unit, distance, ignoreCombat)
            local uau_cache_time_c = uau_cache_time[unit..distance..tostring(ignoreCombat)..'f']
            if uau_cache_time_c and ((uau_cache_time_c + uau_cache_dura) > GetTime()) then
                return uau_cache_count[unit..distance..tostring(ignoreCombat)..'f']
            end
            if UnitExists(unit) then
                local total = 0
                local totalObjects = ObjectsCount(unit, distance)
                for i = 1, totalObjects do
                    local pointer, id, name, bounding, x, y, z, facing, summonedbyme, createdbyme, combat, target = ObjectByIndex(i)
                    local reaction = UnitReaction("player", pointer)
                    if reaction then
                        local combat = UnitAffectingCombat(pointer)
                        if reaction and reaction >= 5 and (ignoreCombat or combat) then
                            total = total + 1
                        end
                    end
                end
                uau_cache_count[unit..distance..tostring(ignoreCombat)..'f'] = total
                uau_cache_time[unit..distance..tostring(ignoreCombat)..'f'] = GetTime()
                return total - 1
            else
                return 0
            end
        end

        function StopCast()
            oexecute("SpellStopCasting()")
        end

        ProbablyEngine.protected.unlocked = true
        ProbablyEngine.protected.method = "offspring"
        ProbablyEngine.timer.unregister('detectUnlock')
        ProbablyEngine.print(L('unlock_offspring'))

    end

end