-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local pels = ProbablyEngine.locale.set

ProbablyEngine.locale.new('enUS')

-- Buttons
pels('toggle', 'Toggle')
pels('toggle_tooltip', 'Temporarily enable or disable the rotation.')
pels('cooldowns', 'Cooldowns')
pels('cooldowns_tooltip', 'Toggle the usage of long duration cooldowns.')
pels('multitarget', 'Multi-Target')
pels('multitarget_tooltip', 'Toggle the usage of multi-target abilities.')
pels('interrupt', 'Interrupts')
pels('interrupt_tooltip', 'Toggle the usage of spell interrupts.')
pels('drag_to_position', 'Drag to Position')
pels('current_spell', 'Current Spell')
pels('previous_spell', 'Previous Spell')
pels('none', 'None')
pels('enable', 'Enable')
pels('enabled', 'Enabled')
pels('disable', 'Disable')
pels('disabled', 'Disabled')
pels('status', 'Status:')

-- Buttons Menu
pels('rtn_default', 'Default Rotations')
pels('rtn_custom', 'Custom Rotations')
pels('rtn_switch', 'Switched active rotation to: ')
pels('rtn_nocustom', 'No Custom Rotations Loaded')

-- General
pels('left_click', 'Left-Click')
pels('right_click', 'Right-Click')
pels('mod_click', 'Shift/Ctrl/Alt-Click')
pels('drag', 'Drag')
pels('rotation_loaded', 'rotation loaded!')
pels('casting', 'Casting')
pels('on', 'on')
pels('on the ground', 'on the ground!')

-- Minimap
pels('open_config', 'to open configuration')
pels('unlock_buttons', 'to unlock buttons')
pels('move_minimap', 'to move minimap button')

-- Combat Tracker
pels('est', 'Est.') -- Estimated
pels('na', 'n/a') -- not/available
pels('k', 'k') -- Thousands postfix
pels('all_units', 'All Units')
pels('combat_tracker', 'Combat Tracker')
pels('ttd', 'TTD') -- Time To Death shorthand
pels('hpr', 'HPR') -- Health Points Remaining shorthand

-- commands
pels('running_version', 'You are running build')
pels('build', 'build')
pels('help_cycle', 'Manually cycle the rotation.')
pels('help_toggle', 'Enable/Disable the addon.')
pels('help_ct', 'Toggle the Combat Tracker.')
pels('help_al', 'Toggle the Action Log.')
pels('help_version', 'Show the current version.')
pels('help_help', 'Show this message.')
pels('help_turbo', 'Toggle turbo mode.')
pels('help_toggleui', 'Toggles the visibility of the user interface.')
pels('unknown_type', 'Unknown Command Type')

pels('turbo_enable', 'Turbo Mode Enabled!')
pels('turbo_disable', 'Turbo Mode Disabled!')

-- Protected
pels('unlock_generic', 'Detected a generic Lua unlock!  Some advanced features will not work.')
pels('unlock_none', 'No unlock found, now in FaceRoll mode. Checking for unlock...')
pels('unlock_firehack', 'Detected FireHack!')
pels('unlock_offspring', 'Detected OffSpring!')
pels('offspring_los_warn', 'OffSpring does not support LoS from an arbitrary unit, only player.')
pels('unlock_wowsx', 'Detected WoWSX!')


-- classes
pels('arcane_mage', 'Arcane Mage')
pels('fire_mage', 'Fire Mage')
pels('frost_mage', 'Frost Mage')
pels('holy_paladin', 'Holy Paladin')
pels('protection_paladin', 'Protection Paladin')
pels('retribution_paladin', 'Retribution Paladin')
pels('arms_warrior', 'Arms Warrior')
pels('furry_warrior', 'Furry Warrior')
pels('protection_warrior', 'Protection Warrior')
pels('balance_druid', 'Balance Druid')
pels('feral_combat_druid', 'Feral Combat Druid')
pels('guardian_druid', 'Guardian Druid')
pels('restoration_druid', 'Restoration Druid')
pels('blood_death_knight', 'Blood Death Knight')
pels('frost_death_knight', 'Frost Death Knight')
pels('unholy_death_knight', 'Unholy Death Knight')
pels('beast_mastery_hunter', 'Beast Mastery Hunter')
pels('marksmanship_hunter', 'Marksmanship Hunter')
pels('survival_hunter', 'Survival Hunter')
pels('discipline_priest', 'Discipline Priest')
pels('holy_priest', 'Holy Priest')
pels('shadow_priest', 'Shadow Priest')
pels('assassination_rogue', 'Assassination Rogue')
pels('combat_rogue', 'Combat Rogue')
pels('subtlety_rogue', 'Subtlety Rogue')
pels('elemental_shaman', 'Elemental Shaman')
pels('enhancement_shaman', 'Enhancement Shaman')
pels('restoration_shaman', 'Restoration Shaman')
pels('affliction_warlock', 'Affliction Warlock')
pels('demonology_warlock', 'Demonology Warlock')
pels('destruction_warlock', 'Destruction Warlock')
pels('brewmaster_monk', 'Brewmaster Monk')
pels('windwalker_monk', 'Windwalker Monk')
pels('mistweaver_monk', 'Mistweaver Monk')
