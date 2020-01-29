-- Class ID 4 - 1337 P14Y3R
ProbablyEngine.rotation.register(4, {

  --------------------
  -- Start Rotation --
  --------------------

  -- Keybinds
  { "Throw", "modifier.shift" },

  -- Survival
  { "Evasion", "player.health <= 75" },

  -- Opener
  { "Stealth", {
    "target.enemy",
    "!player.buff(Stealth)",
  }},

  { "Ambush", "player.buff(Stealth)" },

  -- Rotation
  { "Eviscerate", "player.combopoints >= 4" },
  { "Sinister Strike" },

  ------------------
  -- End Rotation --
  ------------------

  },{
  -- Opener
  { "Stealth", {
    "target.enemy",
    "!player.buff(Stealth)",
  }},

  { "Ambush", "player.buff(Stealth)" },
})
