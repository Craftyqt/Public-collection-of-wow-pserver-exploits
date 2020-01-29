-- SPEC ID 71
ProbablyEngine.rotation.register(71, {


--Rotation according to Icy Veins, with some extra PvP stuff
--I haven't experimented enough with AoE to have sweeping strikes trigger with PE 
--at the optimal time, and whirlwind goes off quite a bit just using the 
--single target rotation.
-- <3 thefrese

  --------------------
  -- Start Rotation --
  --------------------
	--Heroic Leap time!
	--Leap to your mouseover with Control!
	{ "Heroic Leap", "modifier.control", "mouseover.ground"},
	--Leap to your target with Alt!
	{ "Heroic Leap", "modifier.alt", "ground"},
  
	--Interrupts
	{ "Pummel", "modifier.interrupts" },
	
	--Snare if target is a player
	{ "Hamstring", {
		"!target.debuff(Hamstring)",
		"modifier.player"
	}},
	
	--Cooldowns
	{ "Recklessness", "modifier.cooldowns" },
	{ "Bloodbath", "modifier.cooldowns" }, 
	{ "Avatar", "modifier.cooldowns" },
	{ "Rallying Cry", { 
		"coreHealing.needsHealing(30, 4)",
		"modifier.cooldowns"
	}},
	{ "Die by the Sword", "player.health <= 65" },
	
	--Self-healing
	{ "Victory Rush", "player.health <= 85" },
	{ "Impending Victory", "player.health <= 85" },
	
	--Multitarget
	{ "Sweeping Strikes", "modifier.multitarget" },
	{ "Bladestorm", "modifier.multitarget" },
	
	--Rotation
	{ "Colossus Smash" },
	
	--Execute every chance you get!
	{ "Execute" },
	
	--Apply Rend, but don't waste precious Colossus Smash time!
	{ "Rend", {
		"!target.debuff(Rend)",
		"!target.debuff(Colossus Smash)"
	}},
	{ "Rend", {
		"target.debuff.duration(Rend) < 5", 
		"!target.debuff(Colossus Smash)"
	}},
	
	--Build rage and whatnot	
	{ "Mortal Strike" },
	
	--Storm Bolt, but we won't waste our stun randomly on players!
	{ "Storm Bolt", {
		"!target.debuff(Colossus Smash)",
		"!modifier.player"
	}},
	{ "Storm Bolt", {
		"target.debuff(Colossus Smash)",
		"player.rage > 70",
		"!modifier.player"
	}},
	
	--Whirlwind is useful single target now? Yikes!
	--Slam if you took that talent, WW if you didn't.
	{ "Slam", {
		"!target.debuff(Colossus Smash)",
		"player.rage > 40"
	}},
	{ "Whirlwind", {
		"!target.debuff(Colossus Smash)",
		"player.rage > 40"
	}},
	{ "Slam", "target.debuff(Colossus Smash)" }, 
	{ "Whirlwind", "target.debuff(Colossus Smash)" },
	
	},
	{
	
	--Buff yourself
	{ "Battle Shout", "!player.buff(Battle Shout)" },
	
})
