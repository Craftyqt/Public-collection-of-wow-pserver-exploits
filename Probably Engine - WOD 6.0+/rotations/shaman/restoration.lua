-- SPEC ID 264
ProbablyEngine.rotation.register(264, {

  --------------------
  -- Start Rotation --
  --------------------
  
  -- Buffs
  { "Earthliving Weapon", "!player.enchant.mainhand" },
  { "Water Shield", "!player.buff(Water Shield)" },

  -- Tank
  { "Earth Shield", { 
    "!tank.buff(Earth Shield)", 
    "!tank.player",
  }, "tank" },
  
  { "Riptide", "!tank.buff", "tank" },

  -- Healing totem
  { "Healing Stream Totem" },
  { "Mana Tide Totem", "player.mana < 40" },
  { "Healing Tide Totem", "@coreHealing.needsHealing(60, 4)", "lowest" },

  -- Dispell
  { "Purify Spirit", "@coreHealing.needsDispelled('Aqua Bomb')" },

  -- AoE
  { "Healing Rain", "modifier.shift", "ground" },

  -- Unleash Life
  { "Greater Healing Wave", { 
    "lowest.health < 50", 
    "player.buff(Unleash Life)",
  }, "lowest" },
  
  { "Unleash Elements", "lowest.health < 50" },
  
  { "Healing Wave", { 
    "lowest.health < 91", 
    "lowest.debuff(Chomp)",
  }, "lowest" },

  -- regular healing
  { "Healing Surge", "lowest.health < 40", "lowest" },
  
  { "Greater Healing Wave", { 
    "lowest.health < 55", 
    "player.buff(Tidal Waves).count = 2",
  }, "lowest" },
  
  { "Chain Heal", "@coreHealing.needsHealing(80, 4)", "lowest" },
  { "Healing Wave", "lowest.health < 75", "lowest" },
  
  { "Riptide", { 
    "!lowest.buff", "lowest.health < 80",
  }, "lowest" },

  -- caus we dps too right ?!?
  { "Searing Totem", {
    "toggle.totems", 
    "!player.totem(Fire Elemental Totem)", 
    "!player.totem(Searing Totem)",
  }},
  
  { "Lightning Bolt", { "focustarget.exists" }, "focustarget" },
  
  ------------------
  -- End Rotation --
  ------------------

},{

  ---------------
  -- OOC Begin --
  ---------------
  
  { "Earthliving Weapon", "!player.enchant.mainhand" },
  { "Water Shield", "!player.buff" },
  { "Healing Wave", "@coreHealing.needsHealing(80, 1)", "lowest" },
  { "Healing Wave", "lowest.health < 85", "lowest" },
  
  -------------
  -- OOC End --
  -------------
  
})
