-- Class ID 5 - Two Button Masher
ProbablyEngine.rotation.register(5, {

  --------------------
  -- Start Rotation --
  --------------------
  
  -- Mouseover
  { "Shadow Word: Pain", {
    "modifier.shift", 
    "!mouseover.debuff(Shadow Word: Pain)"
  }, "mouseover" },
  
  -- Survival
  { "Power Word: Shield", "player.health <= 95" },
  { "Flash Heal", "player.health <= 60" },

  -- Rotation
  { "Shadow Word: Pain", "!target.debuff(Shadow Word: Pain)" },
  { "Smite" },
  
  ------------------
  -- End Rotation --
  ------------------
  
  }
)
