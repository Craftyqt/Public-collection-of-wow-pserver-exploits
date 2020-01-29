-- Class ID 8 - Table / Portal Machine
ProbablyEngine.rotation.register(8, {

  --------------------
  -- Start Rotation --
  --------------------
  
  -- Blink
  { "Blink", "modifier.shift" },

  -- Interrupt
  { "Counterspell", "target.casting" },
  
  -- Survival
  { "Frost Nova", "target.range < 8" },
  
  -- Rotation, If You Can Call It That
  { "Fire Blast" },
  { "Frostfire Bolt" },
  
  ------------------
  -- End Rotation --
  ------------------
  }
)
