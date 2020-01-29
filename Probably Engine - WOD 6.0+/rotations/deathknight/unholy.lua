-- SPEC ID 252
ProbablyEngine.rotation.register(252, {

  { "Raise Dead", "!pet.exists" },

  { "Mind Freeze", "modifier.interrupts" },
  { "Strangualte", {  "modifier.interrupts", "!modifier.last(Mind Freeze)" } },
  { "Chains of Ice", "modifier.control" },

  { "Icebound Fortitude", "player.health <= 45" },
  { "Anti-Magic Shell", "player.health <= 45" },
  { "Death Pact", "player.health <= 45" },

  -- start simcraft
  --actions.single_target+=/blood_tap,if=talent.blood_tap.enabled&(buff.blood_charge.stack>10&runic_power>=32)
  { "Blood Tap", { "player.buff(Blood Charge).count >= 5", "player.runicpower >= 32" } },
  --actions.single_target+=/outbreak,if=dot.frost_fever.remains<3|dot.blood_plague.remains<3
  { "Outbreak", "target.debuff(Blood Plague).duration < 3" },
  { "Outbreak", "target.debuff(Frost Fever).duration < 3" },
  --actions.single_target+=/soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35
  { "Soul Reaper", { "!target.debuff", "target.health < 35" } },
  --actions.single_target+=/blood_tap,if=talent.blood_tap.enabled&((target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains=0))
  { "Blood Tap", { "!target.debuff(Soul Reaper)", "target.health < 35" } },
  --actions.single_target+=/plague_strike,if=!dot.blood_plague.ticking|!dot.frost_fever.ticking
  { "Plague Strike", "!target.debuff(Blood Plague)" },
  { "Plague Strike", "!target.debuff(Frost Fever)" },
  --actions.single_target+=/summon_gargoyle
  { "Summon Gargoyle", "modifier.cooldowns" },
  --actions.single_target+=/dark_transformation
  { "Dark Transformation" },
  --actions.single_target+=/death_coil,if=runic_power>90
  { "Death Couil", "player.runicpower > 90" },
  --actions.single_target+=/death_and_decay,if=unholy=2
  { "Death and Decay", "player.runes(unholy) = 2", "ground" },
  --actions.single_target+=/blood_tap,if=talent.blood_tap.enabled&(unholy=2&cooldown.death_and_decay.remains=0)
  { "Blood Tap", { "player.runes(unholy) = 2", "spell.cooldown(Death and Decay) = 0" } },
  --actions.single_target+=/scourge_strike,if=unholy=2
  { "Scourge Strike", "player.runes(unholy) = 2" },
  --actions.single_target+=/festering_strike,if=blood=2&frost=2
  { "Fastering Strike", { "player.runes(unholy) = 2", "player.runes(blood) = 2" } },
  --actions.single_target+=/death_and_decay
  { "Death and Decay", nil, "ground" },
  --actions.single_target+=/blood_tap,if=talent.blood_tap.enabled&cooldown.death_and_decay.remains=0
  { "Blood Tap", "spell.cooldown(Death and Decay) = 0" },
  --actions.single_target+=/death_coil,if=buff.sudden_doom.react|(buff.dark_transformation.down&rune.unholy<=1)
  { "Death Coil", "player.buff(Sudden Doom)" },
  --actions.single_target+=/scourge_strike
  { "Scourge Strike" },
  --actions.single_target+=/festering_strike
  { "Festering Strike" },
  --actions.single_target+=/death_coil
  { "Death Coil" },
  --actions.single_target+=/blood_tap,if=talent.blood_tap.enabled&buff.blood_charge.stack>=8
  { "Blood Tap", "player.buff(Blood Charge).count >= 8" },
  --actions.single_target+=/empower_rune_weapon
  { "Empower Rune Weapon", {
    "modifier.cooldowns", 
    "player.runicpower <= 70", 
    "player.runes(blood).count = 0", 
    "player.runes(unholy).count = 0", 
    "player.runes(frost).count = 0", 
    "player.runes(death).count = 0",
  }},

},{

  ---------------
  -- OOC Begin --
  ---------------
  
  -- Buffs
  { "Horn of Winter", "!player.buff(Horn of Winter)" },
  
  -- Keybinds
  { "Army of the Dead", "modifier.alt" },
  { "Death Grip", "modifier.control" },
  
  -- Pet
  { "Raise Dead", "!pet.exists" },
  
  -------------
  -- OOC End --
  -------------
  }
)
