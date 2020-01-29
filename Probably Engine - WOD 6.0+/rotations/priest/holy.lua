ProbablyEngine.rotation.register(257, {

  -- Instants
  { "Fade", "player.agro" },
  { "Angelic Feather", {"player.movingfor > 2", "!player.buff" }, "player.ground" },
  { "Angelic Feather", {"focus.movingfor > 2", "!focus.buff" }, "focus.ground" },
  { "Purify", "@coreHealing.canDispell(Purify)" },

  {{ -- 95 % AoE
    { "Circle of Healing" },
  }, "@coreHealing.needsHealing(95, 3)", "lowest" },

  {{ -- 95 % Instants
    { "Renew", "!focus.buff" },
    { "Power Word: Shield", { "!focus.debuff(Weakened Soul)", "!focus.buff" } },
  }, "focus.exists", "focus" },

  {{ -- 95 % Instants
    { "Renew", "!lowest.buff" },
    { "Power Word: Shield", { "!lowest.debuff(Weakened Soul)", "!lowest.buff" } },
  }, "lowest.health < 95", "lowest" },

  {{ -- 50% Player
    { "Desperate Prayer" }
  }, "player.health < 50", "player" },

  {{ -- 85 % Casted
    { "Flash Heal" },
  }, "lowest.health < 85", "lowest" },

  {{ -- 90 % Casted
    { "Heal" }
  }, "lowest.health < 90", "lowest" },

}, {

  { "Power Word: Fortitude", "!player.buff" },
  { "Angelic Feather", {"player.movingfor > 2", "!player.buff" }, "player.ground" },
  { "Angelic Feather", {"focus.movingfor > 2", "!focus.buff" }, "focus.ground" },

  {{ -- 95 % Instants
    { "Power Word: Shield", { "!focus.debuff(Weakened Soul)", "!focus.buff" } },
  }, "focus.exists", "focus" },

  {{ -- 95 % Instants
    { "Renew", "!lowest.buff" },
    { "Power Word: Shield", { "!lowest.debuff(Weakened Soul)", "!lowest.buff" } },
  }, "lowest.health < 95", "lowest" },

})
