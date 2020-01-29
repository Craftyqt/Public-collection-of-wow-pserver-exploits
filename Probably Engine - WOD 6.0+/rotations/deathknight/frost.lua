ProbablyEngine.condition.register('twohand', function(target)
  return IsEquippedItemType("Two-Hand")
end)

ProbablyEngine.condition.register('onehand', function(target)
  return IsEquippedItemType("One-Hand")
end)

-- SPEC ID 251
ProbablyEngine.rotation.register(251, {

  -- Blood Tap
  {{
    { "Blood Tap", "player.runes(unholy).count = 0" },
    { "Blood Tap", "player.runes(frost).count = 0" },
    { "Blood Tap", "player.runes(death).count = 0" },
  } , {
    "player.buff(Blood Charge).count >= 5",
    "player.runes(death).count = 0"
  }},

  -- Survival
  { "Icebound Fortitude", "player.health <= 45" },
  { "Anti-Magic Shell", "player.health <= 45" },

  -- Interrupts
  { "Mind Freeze", "modifier.interrupts" },
  { "Strangualte", {  "modifier.interrupts", "!modifier.last(Mind Freeze)" } },

  { "Defile", "modifier.shift", "ground" },
  { "Chains of Ice", "modifier.control" },

  -- Cooldowns
  { "Pillar of Frost", "modifier.cooldowns" },
  { "Raise Dead", {
    "modifier.cooldowns",
    "player.buff(Pillar of Frost)"
  }},
  { "Empower Rune Weapon", {
    "modifier.cooldowns", 
    "player.runicpower <= 70", 
    "player.runes(unholy).count = 0", 
    "player.runes(frost).count = 0", 
    "player.runes(death).count = 0",
  }},

  -- Disease Control
  { "Unholy Blight", "player.enemies(10) > 3" },
  {{
    {{
      { "Plague Leech", "player.runes(unholy).count = 0" },
      { "Plague Leech", "player.runes(frost).count = 0" },
      { "Plague Leech", "player.runes(death).count = 0" },
    }, "player.spell(Outbreak).cooldown = 0" },
    {{
      { "Plague Leech", "player.runes(unholy).count = 0" },
      { "Plague Leech", "player.runes(frost).count = 0" },
      { "Plague Leech", "player.runes(death).count = 0" },
    }, "target.debuff(Blood Plague).duration < 6" },
  } , {
    "target.debuff(Blood Plague)",
    "target.debuff(Frost Fever)"
  }},
  { "Outbreak", {
    "target.debuff(Frost Fever).duration < 3", 
    "target.debuff(Blood Plague).duration < 3", 
  }, "target" },
  { "Howling Blast", "target.debuff(Frost Fever).duration < 3" },
  { "Plague Strike", { "target.debuff(Blood Plague).duration < 3", "player.runes(unholy).count >= 1" } },
  --{ "Unholy Blight", (function() return UnitsAroundUnit('target', 10) >= 4 end) },
  { "Death and Decay", "modifier.shift", "target.ground" },

  -- DW Rotation
  {{

    -- AoE
    {{
      { "Pestilence", "modifier.last(Outbreak)" },
      { "Pestilence", "modifier.last(Plague Strike)" },
      { "Howling Blast" },
      { "Frost Strike", "player.runicpower >= 75" },
      { "Death and Decay", "target.ground" },
      { "Plague Strike", {
        "player.runes(unholy).count = 2",
        "player.spell(Death and Decay).cooldown",
      }},
      { "Frost Strike" },
    }, "modifier.multitarget" },

    -- Single Target
    {{
      { "Frost Strike", "player.buff(Killing Machine)" },
      { "Frost Strike", "player.runicpower > 88" },
      { "Howling Blast", "player.runes(death).count > 1" },
      { "Howling Blast", "player.runes(frost).count > 1" },
      --{ "Unholy Blight", "target.debuff(Frost Fever).duration < 3" },
      --{ "Unholy Blight", "target.debuff(Blood Plague).duration < 3" },
      { "Soul Reaper", "target.health < 35" },
      { "Howling Blast", "player.buff(Freezing Fog)" },
      { "Frost Strike", "player.runicpower > 76" },
      { "Death Strike", "player.buff(Dark Succor)" },
      { "Death Strike", "player.health <= 65" },
      { "Obliterate", {
        "player.runes(unholy).count > 0",
        "!player.buff(Killing Machine)"
      }},
      { "Howling Blast" },
      -- actions.single_target+=/frost_strike,if=talent.runic_empowerment.enabled&unholy=1
      -- actions.single_target+=/blood_tap,if=talent.blood_tap.enabled&(target.health.pct-3*(target.health.pct%target.time_to_die)>35|buff.blood_charge.stack>=8)
      { "Frost Strike", "player.runicpower >= 40" },

    }, "!modifier.multitarget" },

  }, "player.onehand" },


  -- 2H Rotation
  {{

    -- AoE
    {{
      { "Blood Tap", {
        "player.buff(Blood Charge).count >= 5",
        "!player.runes(blood).count == 2",
        "!player.runes(frost).count == 2",
        "!player.runes(unholy).count == 2",
      }},
      { "Pestilence", {
        "target.debuff(Blood Plague) >= 28",
        "!modifier.last"
      }},
      { "Howling Blast" },
      { "Frost Strike", "player.runicpower >= 75" },
      { "Defile", "modifier.shift", "ground" },
      { "Plague Strike", {
        "player.runes(unholy).count = 2",
        "player.spell(Death and Decay).cooldown",
      }},
      { "Frost Strike" },
    }, "modifier.multitarget" },

    -- Single Target
    {{
      { "Soul Reaper", "target.health < 35" },
      { "Howling Blast", "player.buff(Freezing Fog)" },
      {{
        { "Death Strike", "player.buff(Killing Machine)" },
        { "Seath Strike", "player.runicpower <= 75" },
      }, "player.health <= 65"},
      {{
        { "Obliterate", "player.buff(Killing Machine)" },
        { "Obliterate", "player.runicpower <= 75" },
      }, "player.health > 65"},
      { "Blood Tap", "player.buff(Blood Charge).count >= 5" },
      { "Frost Strike", "!player.buff(Killing Machine)" },
      { "Frost Strike", "player.spell(Obliterate).cooldown >= 4" },
    }, "!modifier.multitarget" },

  }, "player.twohand" },

},{
  { "Horn of Winter", "!player.buff(Horn of Winter)" },
})