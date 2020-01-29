-- SPEC ID 261
ProbablyEngine.rotation.register(261, {

  --------------------
  -- Start Rotation --
  --------------------
  
  -- Interrupts
  { "Kick", "modifier.interrupts" },
  
  -- Buffs
  { "Deadly Poison", { 
    "!player.buff(Deadly Poison)", 
    "!player.moving",
  }},
  
  { "Leeching Poison", "!player.buff(Leeching Poison)" },
  
  -- Cooldowns
  { "Shadow Blades", "modifier.cooldowns" },
  
  { "Slice and Dice", { 
    "!player.buff(Slice and Dice)", 
    "player.combopoints = 5",
  }},
  
  { "Vanish", { 
    "!player.buff(Shadow Dance)", 
    "modifier.cooldowns",
  }},
  
  -- Rotation
  { "Eviscerate", "player.combopoints = 5" },
  { "Hemorrhage", "target.debuff(Hemorrhage).duration <= 4" },
  {{ -- Greater than 5 CP
  { "Fan of Knives", "modifier.multitarget" },
  { "Backstab", "player.behind" },
  { "Hemorrhage", "!player.behind" },
  
  { "Hemorrhage", { 
    "!player.spell(Backstab).exists", 
    "player.behind",
  }},
  }, "player.combopoints < 5" },
  
  ------------------
  -- End Rotation --
  ------------------

},{

  ---------------
  -- OOC Begin --
  ---------------
  
  { "Deadly Poison", { 
    "!player.buff(Deadly Poison)", 
    "!player.moving",
  }},
  
  { "Ambush", { 
    "player.buff(Stealth)", 
    "target.spell(Ambush).range" 
  }, "target" },
  
  -------------
  -- OOC End --
  -------------
  
})
