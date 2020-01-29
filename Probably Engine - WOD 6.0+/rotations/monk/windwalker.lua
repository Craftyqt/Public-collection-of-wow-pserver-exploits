-- SPEC ID 269
ProbablyEngine.rotation.register(269, {

  --------------------
  -- Start Rotation --
  --------------------
  
  -- Get Fucked Button
  { "Touch of Death", "player.buff(Death Note)" },

  -- Interrupts
  { "Spear Hand Strike", "modifier.interrupts" },
  { "Grapple Weapon", "modifier.interrupts" },
  
  { "Leg Sweep", {
    "modifier.interrupts", 
    "target.range <= 5",
  }},

  -- Survival
  { "Expel Harm", "player.health < 80" },
  { "Fortifying Brew", "player.health <= 30" },
  { "Touch of Karma", "player.health <= 50" },
  { "Nimble Brew", "player.state.fear" },
  { "Nimble Brew", "player.state.stun" },
  { "Nimble Brew", "player.state.root" },
  { "Nimble Brew", "player.state.horror" },
  { "Dampen Harm", "player.health <= 45" },
  { "Diffuse Magic", "player.health <= 45" },
  
  -- Keybinds
  { "Paralysis", "modifier.shift", "mouseover" },
  { "Healing Sphere", "modifier.alt", "ground" }, 
  { "Crackling Jade Lightning", "modifier.control", "target" },
  
  -- Cooldowns
  { "Invoke Xuen: The White Tiger", "modifier.cooldowns" },
  
  -- PvP
  { "Disable", {
    "toggle.disable", 
    "!target.debuff(Disable)",
  }},
  
  -- Talents
  { "Chi Wave" },
  { "Zen Sphere", "!player.buff(Zen Sphere)", "player" },
  { "Chi Burst" },
  { "Invoke Xuen, the White Tiger" },
  { "Tiger's Lust", "target.range >= 15" },
  
  -- Multi-Target
  { "Fists of Fury", { 
    "modifer.multitarget", 
    "player.energy < 30", 
    "target.range <= 8", 
    "player.chi >= 3",
  }},
  
  { "Rushing Jade Wind", "modifier.multitarget" },
  { "Spinning Crane Kick", "modifier.multitarget" },
  
  --Brews
  { "Energizing Brew", "player.energy <= 45" },
  { "Tigereye Brew", "player.buff(Tigereye Brew).count >= 10" },
  { "Chi Brew", "player.chi <= 1" },
  
  -- Rotation
  { "Rising Sun Kick" },
  { "Fists of Fury", {"player.energy < 30", "target.range <= 8"} },
  { "Tiger Palm", "player.buff(Tiger Power).duration <= 2" },
  { "Tiger Palm", "player.buff(Combo Breaker: Tiger Palm)" },
  { "Blackout Kick", "player.buff(Combo Breaker: Blackout Kick)" },
  
  { "Blackout Kick", { 
    "player.chi >= 2", 
    "target.debuff(Rising Sun Kick)", 
    "player.buff(Tiger Power)",
  }},
  
  { "Fists of Fury", {
    "player.energy < 30", 
    "target.range <= 8",
  }},
  { "Jab" },
  
  ------------------
  -- End Rotation --
  ------------------
  
  },{ 
  
  ---------------
  -- OOC Begin --
  ---------------
  
  { "Expel Harm", "player.health < 80" },
  { "Fortifying Brew", "player.health <= 30" },
  { "Touch of Karma", "player.health <= 50" },
  
  -- Keybinds
  { "Paralysis", "modifier.shift", "mouseover" },
  { "Healing Sphere", "modifier.alt", "ground" }, 
  { "Crackling Jade Lightning", "modifier.control", "target" },
  
  -- Buffs
  { "Legacy of the White Tiger", "!player.buff(Legacy of the White Tiger).any" },
  { "116095", "!player.buff(116095).any" },-- Legacy of Emp

  -------------
  -- OOC End --
  -------------
}, function()
ProbablyEngine.toggle.create('disable', 'Interface\\Icons\\ability_shockwave', 'Disable', 'Toggle Disable')
end)
