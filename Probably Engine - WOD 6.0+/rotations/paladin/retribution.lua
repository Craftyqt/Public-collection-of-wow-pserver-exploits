-- SPEC ID 70
ProbablyEngine.rotation.register(70, {

  --------------------
  -- Start Rotation --
  --------------------
  
  --Cooldowns
  { "Avenging Wrath", { 
    "modifier.cooldowns", 
    "player.buff(Inquisition)" }},
  { "Guardian of Ancient Kings", { "modifier.cooldowns", "player.buff(Inquisition)" }},
    
  -- Inquisition
  { "Inquisition", { 
    "!player.buff(Inquisition)", 
    "player.holypower >= 3",
  }},
  
  { "Inquisition", { 
    "player.buff(Inquisition).duration <= 2", 
    "player.holypower >= 3", 
    }},
    
  --DPS
  {{ -- Runs w/ Avenging Wrath
  { "Templar's Verdict", { 
    "player.holypower = 5", 
    "!modifier.multitarget",
  }},
  
  { "Divine Storm", { 
    "player.holypower = 5", 
    "modifier.multitarget" 
  }, "target.range <= 8" },
  
  { "Hammer of Wrath" },
  { "Execution Sentence", "spell.cooldown(Hammer of Wrath) > 0.2" },
  
  { "Hammer of the Righteous", { 
    "modifier.multitarget", 
    "spell.cooldown(Hammer of Wrath) > 0.2",
  }},
  
  { "Exorcism", "spell.cooldown(Hammer of Wrath) > 0.2" },
  { "Crusader Strike", "spell.cooldown(Hammer of Wrath) > 0.2" },
  { "Judgement", "spell.cooldown(Hammer of Wrath) > 0.2" },
  { "Templar's Verdict", "!modifier.multitarget" },
  { "Divine Storm", "modifier.multitarget" }, 
  }, "player.buff(Avenging Wrath)"},
  
  -- Lower Than 20% HP
  {{
  { "Templar's Verdict", { 
    "player.holypower = 5", 
    "!modifier.multitarget",
  }},
  
  { "Divine Storm", { 
    "player.holypower = 5", 
    "modifier.multitarget" 
  }, "target.range <= 8" },
  
  { "Hammer of Wrath" },
  { "Execution Sentence", "spell.cooldown(Hammer of Wrath) > 0.2" },
  
  { "Hammer of the Righteous", { 
    "modifier.multitarget", 
    "spell.cooldown(Hammer of Wrath) > 0.2",
  }},
  
  { "Exorcism", "spell.cooldown(Hammer of Wrath) > 0.2" },
  { "Crusader Strike", "spell.cooldown(Hammer of Wrath) > 0.2" },
  { "Judgement", "spell.cooldown(Hammer of Wrath) > 0.2" },
  { "Templar's Verdict", "!modifier.multitarget" },
  { "Divine Storm", "modifier.multitarget" }, 
  }, "target.health < 20"},
  
  -- Standard DPS
  { "Templar's Verdict", {
    "player.holypower = 5", 
    "!modifier.multitarget",
  }},
  
  { "Divine Storm", { 
    "player.holypower >= 3", 
    "modifier.multitarget" 
  }, "target.range <= 8" },
  
  { "Hammer of the Righteous", "modifier.multitarget" },
  { "Execution Sentence", "player.buff(Inquisition)" },
  { "Exorcism" },
  { "Crusader Strike", "!modifier.multitarget" },
  { "Judgment" },
  { "Templar's Verdict", "!modifier.multitarget" },
  { "Divine Storm", "modifier.multitarget" },
  
  ------------------
  -- End Rotation --
  ------------------
  
  },{
  
  ---------------
  -- OOC Begin --
  ---------------
  
  { "Blessing of Might", "!player.buff(Blessing of Might).any" },
	
  -------------
  -- OOC End --
  -------------
  
})
     
