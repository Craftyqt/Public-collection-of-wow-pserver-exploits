-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local LibDispellable = LibStub("LibDispellable-1.0")

-- unit states for PvP
-- fuckin awesome amirite?

--[[
  state.purge
  state.charm
  state.disarm
  state.disorient
  state.dot
  state.fear
  state.incapacitate
  state.misc
  state.root
  state.silence
  state.sleep
  state.snare
  state.stun
  immune.all
  immune.charm
  immune.disorient
  immune.fear
  immune.incapacitate
  immune.melee
  immune.misc
  immune.silence
  immune.polly
  immune.sleep
  immune.snare
  immune.spell
  immune.stun
]]--

ProbablyEngine.states = { }
ProbablyEngine.states.status = {}
ProbablyEngine.states.status.charm = {
    "^charmed"
}
ProbablyEngine.states.status.disarm = {
    "disarmed"
}
ProbablyEngine.states.status.disorient = {
    "^disoriented"
}
ProbablyEngine.states.status.dot = {
    "damage every.*sec", "damage per.*sec"
}
ProbablyEngine.states.status.fear = {
    "^horrified", "^fleeing", "^feared", "^intimidated", "^cowering in fear",
    "^running in fear", "^compelled to flee"
}
ProbablyEngine.states.status.incapacitate = {
    "^incapacitated", "^sapped"
}
ProbablyEngine.states.status.misc = {
    "unable to act", "^bound", "^frozen.$", "^cannot attack or cast spells",
    "^shackled.$"
}
ProbablyEngine.states.status.root = {
    "^rooted", "^immobil", "^webbed", "frozen in place", "^paralyzed",
    "^locked in place", "^pinned in place"
}
ProbablyEngine.states.status.silence = {
    "^silenced"
}
ProbablyEngine.states.status.sleep = {
    "^asleep"
}
ProbablyEngine.states.status.snare = {
    "^movement.*slowed", "movement speed reduced", "^slowed by", "^dazed",
    "^reduces movement speed"
}
ProbablyEngine.states.status.stun = {
    "^stunned", "^webbed"
}
ProbablyEngine.states.immune = {}
ProbablyEngine.states.immune.all = {
    "dematerialize", "deterrence", "divine shield", "ice block"
}
ProbablyEngine.states.immune.charm = {
    "bladestorm", "desecrated ground", "grounding totem effect", "lichborne"
}
ProbablyEngine.states.immune.disorient = {
    "bladestorm", "desecrated ground"
}
ProbablyEngine.states.immune.fear = {
    "berserker rage", "bladestorm", "desecrated ground", "grounding totem",
    "lichborne", "nimble brew"
}
ProbablyEngine.states.immune.incapacitate = {
    "bladestorm", "desecrated ground"
}
ProbablyEngine.states.immune.melee = {
    "dispersion", "evasion", "hand of protection", "ring of peace", "touch of karma"
}
ProbablyEngine.states.immune.misc = {
    "bladestorm", "desecrated ground"
}
ProbablyEngine.states.immune.silence = {
    "devotion aura", "inner focus", "unending resolve"
}
ProbablyEngine.states.immune.polly = {
    "immune to polymorph"
}
ProbablyEngine.states.immune.sleep = {
    "bladestorm", "desecrated ground", "lichborne"
}
ProbablyEngine.states.immune.snare = {
    "bestial wrath", "bladestorm", "death's advance", "desecrated ground",
    "dispersion", "hand of freedom", "master's call", "windwalk totem"
}
ProbablyEngine.states.immune.spell = {
    "anti-magic shell", "cloak of shadows", "diffuse magic", "dispersion",
    "massspell reflection", "ring of peace", "spell reflection", "touch of karma"
}
ProbablyEngine.states.immune.stun = {
    "bestial wrath", "bladestorm", "desecrated ground", "icebound fortitude",
    "grounding totem", "nimble brew"
}

ProbablyEngine.condition.register("state.purge", function(target, spell)
  if LibDispellable:CanDispelWith(target, GetSpellID(GetSpellName(spell))) then
    return true
  end
  return false
end)

ProbablyEngine.condition.register("state.charm", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.status.charm, 'debuff')
end)

ProbablyEngine.condition.register("state.disarm", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.status.disarm, 'debuff')
end)

ProbablyEngine.condition.register("state.disorient", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.status.disorient, 'debuff')
end)

ProbablyEngine.condition.register("state.dot", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.status.dot, 'debuff')
end)

ProbablyEngine.condition.register("state.fear", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.status.fear, 'debuff')
end)

ProbablyEngine.condition.register("state.incapacitate", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.status.incapacitate, 'debuff')
end)

ProbablyEngine.condition.register("state.misc", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.status.misc, 'debuff')
end)

ProbablyEngine.condition.register("state.root", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.status.root, 'debuff')
end)

ProbablyEngine.condition.register("state.silence", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.status.silence, 'debuff')
end)

ProbablyEngine.condition.register("state.sleep", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.status.sleep, 'debuff')
end)

ProbablyEngine.condition.register("state.snare", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.status.snare, 'debuff')
end)

ProbablyEngine.condition.register("state.stun", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.status.stun, 'debuff')
end)

ProbablyEngine.condition.register("immune.all", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.all)
end)

ProbablyEngine.condition.register("immune.charm", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.immune.charm)
end)

ProbablyEngine.condition.register("immune.disorient", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.immune.disorient)
end)

ProbablyEngine.condition.register("immune.fear", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.immune.fear)
end)

ProbablyEngine.condition.register("immune.incapacitate", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.immune.incapacitate)
end)

ProbablyEngine.condition.register("immune.melee", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.immune.melee)
end)

ProbablyEngine.condition.register("immune.misc", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.immune.misc)
end)

ProbablyEngine.condition.register("immune.silence", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.immune.silence)
end)

ProbablyEngine.condition.register("immune.poly", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.immune.polly)
end)

ProbablyEngine.condition.register("immune.sleep", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.immune.sleep)
end)

ProbablyEngine.condition.register("immune.snare", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.immune.snare)
end)

ProbablyEngine.condition.register("immune.spell", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.immune.spell)
end)

ProbablyEngine.condition.register("immune.stun", function(target, spell)
  return ProbablyEngine.tooltip.scan(target, ProbablyEngine.states.immune.stun)
end)
