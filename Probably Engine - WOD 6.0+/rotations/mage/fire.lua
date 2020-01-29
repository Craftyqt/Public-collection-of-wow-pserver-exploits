-- SPEC ID 63
ProbablyEngine.rotation.register(63, {

  --------------------
  -- Start Rotation --
  --------------------
  
  -- Cooldowns
  { "45438", {
    "modifier.cooldowns", 
    "player.health <= 30" } }, -- Ice Block
  { "11958", {
    "modifier.cooldowns", 
    "player.health <= 25", 
    "player.spell(45438).cooldown",
  }},-- Cold Snap
  
  { "55342", "modifier.cooldowns" }, -- Mirror Image
  { "108978", "modifier.cooldowns" }, -- Alter Time
  { "12043", "modifier.cooldowns" }, -- Presence of Mind
  { "115610", { 
    "modifier.cooldowns", 
    "player.health <= 80",
  }},-- Temporal Shield
  
    -- Interrupts
  { "2139", "modifier.interrupts" }, -- Counterspell
  { "102051", "modifier.interrupts" }, -- Frostjaw
  
  -- AoE
  --{ "10", "modifier.ctrl", "ground" }, -- Blizzard -- Unimplemented 
  { "2120", "modifier.control", "ground" }, -- Flamestrike
  { "113724", "modifier.alt", "ground" }, -- Ring of Frost
	
  -- Mage Bombs
  { "114923", "!target.debuff(114923)", "target" }, -- Nether Tempest
  { "114923", "target.debuff(114923).duration <= 2", "target" }, -- Nether Tempest
  { "44457", "!target.debuff(44457)", "target" }, -- Living Bomb
  { "112948", "player.spell(112948).cooldown = 0", "target" }, -- Frost Bomb
  
  -- Survivability
  { "122", "target.range <= 9" }, -- Frost Nova
  { "1953", "target.range <= 3" }, -- Blink
  { "31661", "target.range <= 5" }, -- Dragon's Breath
  { "116011", "modifier.shift", "ground" }, -- Rune of Power
  { "11426", "player.health <= 80" }, -- Ice Barrier
  
  -- Rotation
  { "11129",  "target.debuff(12654)" }, -- Combustion
  { "11366", "player.buff(48108)" }, -- Pyroblast
  { "108853", "player.buff(48107)" }, -- Inferno Blast
  { "44457", "target.debuff(44457).duration <= 3" }, -- Living Bomb
  { "2948", "player.moving" }, -- Scorch
  { "133" } -- Fireball

  ------------------
  -- End Rotation --
  ------------------
  
  },{
  
  ---------------
  -- OOC Begin --
  ---------------
  
  { "1459", "!player.buff(1459).any" }, -- Arcane Brilliance
  { "30482", "!player.buff(30482)" }
  
  -------------
  -- OOC End --
  -------------
  
  }) -- Molten Armor
