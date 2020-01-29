-- SPEC ID 72
ProbablyEngine.rotation.register(72, {

  --------------------
  -- Start Rotation --
  --------------------
  
  -- Buffs
  { "Berserker Rage" },

  -- Survival
  { "Rallying Cry", { 
    "player.health < 15", 
    "modifier.cooldowns",
  }},
  
  { "Die by the Sword", "player.health < 25" },
  { "Impending Victory", "player.health <= 85" },
  { "Victory Rush", "player.health <= 85" },

  -- Kicks
  { "Pummel", "modifier.interrupts" },
  { "Disrupting Shout", "modifier.interrupts" },

  -- Cooldowns
  { "Bloodbath", "modifier.cooldowns" },
  { "Avatar", "modifier.cooldowns" },
  { "Recklessness", "modifier.cooldowns" },
  { "Skull Banner", "modifier.cooldowns" },
  { "Bladestorm", "modifier.cooldowns" },

  -- AoE
  { "Thunder Clap", "modifier.multitarget", "target.range <= 5" },
  { "Whirlwind", "modifier.multitarget", "target.range <= 5" },
  { "Dragon Roar", "modifier.multitarget", "target.range <= 5" },

  -- Rotation
  { "Colossus Smash" },
  { "Bloodthirst" },
  { "Execute", "player.rage > 80" },
  { "Heroic Strike", "player.rage > 80" },
  { "Raging Blow" },
  { "Wild Strike", "player.buff(Bloodsurge)" },
  { "Impending Victory" },
  { "Heroic Throw" }
  
  ------------------
  -- End Rotation --
  ------------------

})
