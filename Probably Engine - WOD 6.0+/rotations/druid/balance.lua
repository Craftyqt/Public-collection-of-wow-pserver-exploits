-- SPEC ID 102 (Balance)
ProbablyEngine.rotation.register(102, {

  --------------------
  -- Start Rotation --
  --------------------
  
  --Screw bear form
  { "/cancelform", "player.buff(Bear Form)" },
  
  -- Mouseover Debuffing
  { "Moonfire", "!mouseover.debuff(Moonfire)", "mouseover" },
  { "Sunfire", "!mouseover.debuff(Sunfire)", "mouseover" },
  
  -- Mouseover Brez
  { "Rebirth", "!mouseover.alive", "mouseover" },
  
  -- Survival on Self
  { "Renewal", "player.health <= 30" },
  { "Might of Ursoc", "player.health <= 50" },
  { "Cenarion Ward", "player.health < 85", "player" },
  { "Barkskin", "player.health <= 80", "player" },
  { "Innervate", "player.mana <= 75", "player" },
  
  -- Cooldowns
  { "Incarnation: Chosen of Elune", { 
    "modifier.cooldowns", 
    "player.balance.sun",
  }},
  
  { "Nature's Vigil", "modifier.cooldowns" },
  
  -- AoE and Keybinds
  { "Moonfire", { 
    "modifier.multitarget", 
    "target.debuff(Moonfire).duration < 2",
  }},
  
  { "Sunfire", {
    "modifier.multitarget", 
    "target.debuff(Sunfire).duration < 2",
  }},
  
  { "Starfall", "modifier.multitarget" },
  
  { "Wild Mushroom", { 
    "modifer.multitarget", 
    "modifier.control",
  }},
  
  { "Wild Mushroom: Detonate", { 
    "modifer.multitarget", 
    "modifier.alt",
  }},
  
  { "Hurricane", { 
    "modifier.multitarget", 
    "modifier.shift",
  }},
  
  { "Astral Storm", { 
    "modifier.multitarget", 
    "modifier.shift",
  }},
  
  -- Walking
  { "Moonfire", { 
    "player.balance.moon", 
    "player.moving" 
  }},
  
  { "Sunfire", { 
    "player.balance.sun", 
    "player.moving",
  }},
  
  { "Starsurge", { 
    "player.buff(Shooting Stars)", 
    "player.moving"
  }},
  
  -- Dots
  { "Moonfire", "target.debuff(Moonfire).duration < 2" },
  { "Sunfire", "target.debuff(Sunfire).duration < 2" },
  
  -- Balance
  { "Starsurge" },
  { "Starfire", "player.balance.sun" },
  { "Wrath", "player.balance.moon" },
  { "Starfall" },

  ------------------
  -- End Rotation --
  ------------------
  
  }
)
