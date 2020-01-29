-- Class ID 9 - The OP
ProbablyEngine.rotation.register(9, {

  --------------------
  -- Start Rotation --
  --------------------

  -- Mouseover
  { "Corruption", {
    "modifier.shift", 
    "!mouseover.debuff(Corruption)"
  }, "mouseover" },
  
  -- Survival
  { "Drain Life", "player.health <= 85" },

  -- Rotation
  { "Corruption", "!target.debuff(Corruption)" },
  { "Shadow Bolt" },
  
  ------------------
  -- End Rotation --
  ------------------
  }
)
