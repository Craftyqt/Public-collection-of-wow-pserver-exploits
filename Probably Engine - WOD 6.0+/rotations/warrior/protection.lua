-- SPEC ID 73
ProbablyEngine.rotation.register(73, {

  --------------------
  -- Start Rotation --
  --------------------
  
  -- Buffs
  { "Berserker Rage" },

  -- Survival
  { "Rallying Cry", { 
    "player.health < 10", 
    "modifier.cooldowns", 
  }},
    
  { "Last Stand", { 
    "player.health < 20", 
    "modifier.cooldowns",
  }},
  
  { "Shield Wall", { 
    "player.health < 30", 
    "modifier.cooldowns", 
  }},
  
  { "Impending Victory", "player.health <= 85" },
  { "Victory Rush", "player.health <= 85" },

  -- Survival Buffs
  { "Shield Block", "!player.buff(Shield Block)" },
  
  { "Shield Barrier", { 
    "!player.buff(Shield Barrier)", 
    "player.rage > 80", 
  }},

  -- Threat Control w/ Toggle
  { "Taunt", "toggle.tc", "target.threat < 100" },
  { "Taun", "toggle.tc", "mouseover.threat < 100", "mouseover" },

  -- Kicks
  { "Pummel", "modifier.interrupts" },
  { "Disrupting Shout", "modifier.interrupts", "target.range <= 8" },

  -- Ranged
  { "Heroic Throw", "target.range >= 10" },
  
  { "Throw", { 
    "target.range >= 10", 
    "!player.moving",
  }},

  -- Cooldowns
  { "Bloodbath", "modifier.cooldowns"  },
  { "Avatar", "modifier.cooldowns"  },
  { "Recklessness", "target.range <= 8", "modifier.cooldowns"  },
  { "Skull Banner", "modifier.cooldowns"  },
  { "Bladestorm", "target.range <= 8", "modifier.cooldowns"  },

  -- AoE
  { "Sweeping Strikes", "modifier.multitarget", "target.range <= 5" },
  { "Thunder Clap", "modifier.multitarget", "target.range <= 5" },
  { "Whirlwind", "modifier.multitarget", "target.range <= 5" },
  { "Dragon Roar", "modifier.multitarget", "target.range <= 5" },
  { "Cleave", "player.rage > 60", "modifier.multitarget" },
  { "modifier.multitarget" }, 

  -- Rotation
  { "Shield Slam" },
  { "Revenge", { "player.rage <= 80", }},
  
  -- Bleed
  { "Devastate", "!target.debuff(Deep Wounds)" },
  
  -- Weakened Armor
  { "Devastate", { "target.debuff(Weakened Armor).count < 3" }},
  
  { "Sunder Armor", { 
    "player.level < 26", 
    "target.debuff(Weakened Armor).count < 3", 
  }},
  
  -- Weakened Blows
  { "Thunder Clap", { 
    "!target.debuff(Weakened Blows).any", 
    "target.range <= 8", 
  }},
  
  -- Filler lol
  { "Devastate" },

  ------------------
  -- End Rotation --
  ------------------
  
}, 
 function ()
  ProbablyEngine.toggle.create('tc', 'Interface\\Icons\\ability_deathwing_bloodcorruption_death', 'Threat Control', '')
  end)