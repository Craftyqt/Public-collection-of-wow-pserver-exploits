-- SPEC ID 104
ProbablyEngine.rotation.register(104, {

  --------------------
  -- Start Rotation --
  --------------------

  -- Bear Form
  { "/cancelform\n/run CastShapeshiftForm(1)", { 
    "!player.buff(5487)", 
    "!player.buff(40120)", 
    "!player.buff(33943)",    --Bear Form
  }},

  -- Interrupts
  {{
  { "80964", { 
    "target.interruptAt(35)", 
    "!modifier.last(5211)",
  }}, --Skull Bash --Mighty Bash
  { "5211" , { 
    "target.interruptAt(35)", 
    "!modifier.last(80964)",
  }}, --Mighty Bash / Skull Bash

  -- Ress target-Instantly
  { "20484", { 
    "target.dead", 
    "player.buff(108373)",
  }, "target" }, --Rebirth / Dream of Cenarius
  
  { "20484", { 
    "mouseover.dead", 
    "player.buff(108373)",
  }, "mouseover" }, --Rebirth / Dream of Cenarius`
  
  --Taunt
  { "6795", { 
    "target.range <= 30", 
    "target.threat < 100", 
    "!modifier.last(Growl)", 
    "modifier.shift",
  }},

  -- Survival
  {{
    { "108238", { "player.health <= 30" }}, --Renewal
    { "108238", { "player.health <= 50", "player.buff(106922)" }}, --Renewal / Might of Ursoc
    { "61336", { "player.health <= 40" }}, --Survival Instincts
    { "106922", { "player.health <= 50" }}, --Might of Ursoc
    { "22812", { "player.health <= 90" }}, --Barkskin
    { "122285", }, --Bone Shield
    { "126453", { "player.health <= 90" }}, --Elusive Brew
    { "#5512", { "player.health <= 50" }}, --Healthstone
  }, { "toggle.Survival" }},
  
  { "22842", { 
    "player.health <= 80", 
    "!player.glyph(40896)", 
    "!modifier.last(22842)", 
  }}, --Frenzied Regeneration
  
  { "22842", { 
    "target.threat >= 100", 
    "!player.buff", 
    "player.glyph(40896)", 
    "!modifier.last(22842)" 
  }}, --Frenzied Regeneration
  
  { "62606", { 
    "target.threat >= 100", 
    "target.range <= 5", 
    "!player.buff", 
    "!modifier.last(62606)",
  }}, --Savage Defense
  
  { "5185", { 
    "player.health <= 85", 
    "player.buff(145162)",
  }}, --Healing Touch / Dream of Cenarius
  
  { "5185", { 
    "targettarget.health <= 85", 
    "player.buff(145162)",
  }, "targettarget" }, --Healing Touch / Dream of Cenarius
  
  { "5185", { 
    "lowest.health <= 65", 
    "player.buff(145162)" 
  }, "lowest" }, --Healing Touch / Dream of Cenariu

  --AOE
  { "779", { 
    "modifier.multitarget", 
    "target.range <= 5",
  }}, --Swipe

  -- Cooldowns
  {{
      { "124974", { "player.spell(50334).cooldown = 0" }}, --Nature's Vigil / Berserk
      { "124974", { "player.spell(102558).cooldown = 0" }}, --Nature's Vigil / Incarnation: Son of Ursoc
      { "102558", { "player.buff(124974)" }}, --Incarnation: Son of Ursoc / Nature's Vigil
      { "50334", { 
        "player.time > 10",
        "!player.buff(102558)", 
        "player.buff(124974).duration > 10",
      }}, --Berserk / Incarnation: Son of Ursoc / Nature's Vigil
    }, { 
      "!target.dead", 
      "target.range <= 5", 
      "target.ttd > 45", 
      "player.spell(124974).exists", 
      "modifier.cooldowns" }}, --Nature's Vigil
    
    {{
      { "102558" }, --Incarnation: Son of Ursoc
      { "50334", { "player.time >= 90", "!player.buff(102558)" }}, --Berserk / Incarnation: Son of Ursoc
    }, { 
      "!target.dead", 
      "target.range <= 5", 
      "target.ttd > 45", 
      "!player.spell(124974).exists", 
      "modifier.cooldowns",
  }}, --Nature's Vigil

  -- Mob Control
    { "5229", { "player.rage < 70" }}, --Enrage
    { "770", { "target.debuff(113746).duration < 3" }},  --Faerie Fire
  
    { "77758", { 
      "target.range <= 5", 
      "target.debuff.duration < 3",
    }}, --Thrash
  
    { "33917" }, --Mangle
  
    { "6807", { 
      "player.buff(135288)", 
      "!modifier.last(6807)",
    }}, --Maul / Tooth and Claw
  
    { "6807", { 
      "player.rage >= 80", 
      "!modifier.last(6807)",
    }}, --Maul
  
    { "6807", { 
      "target.threat < 100", 
      "!modifier.last(6807)",
    }}, --Maul
  
    { "33745", { "target.debuff.duration < 3" }}, --Lacerate
    { "33745", { "!modifier.last(33745)" }}, --Lacerate
  
    { "779", { 
      "target.range <= 5", 
        "modifier.enemies > 3", 
    }}, --Swipe
  
    { "77758", { "target.range <= 5" }}, --Thrash
    { "779", { "target.range <= 5" }}, --Swipe
    { "770" }, --Faerie Fire
  
  }, { 
    "player.buff(5487)",
  }},

  ------------------
  -- End Rotation --
  ------------------

},{

  ---------------
  -- OOC Begin --
  ---------------

  { "1126", { 
    "!lowest.buff(1126).any", 
    "!lowest.buff(20217).any",
    "!lowest.buff(115921).any", 
    "lowest.range <= 30", 
    "player.form = 0",
  }, "lowest" } -- Mark of the Wild / Blessing of Kings / Legacy of the Emperor

 -------------
  -- OOC End --
  -------------

},
function()
ProbablyEngine.toggle.create('Survival', 'Interface\\Icons\\Ability_druid_tigersroar','Survivability','Enable or Disable the usage of Survivability Cooldowns')
end)
