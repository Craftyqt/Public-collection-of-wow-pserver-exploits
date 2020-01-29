-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local L = ProbablyEngine.locale.get

ProbablyEngine.command.help = {

}

ProbablyEngine.command.register_help = function(key, help)
  ProbablyEngine.command.help[key] = help
end

ProbablyEngine.command.register_handler({'version', 'ver', 'v'}, function()
  ProbablyEngine.command.print('|cff' .. ProbablyEngine.addonColor .. 'ProbablyEngine |r' .. ProbablyEngine.version)
end)
ProbablyEngine.command.register_help('version', L('help_version'))

ProbablyEngine.command.register_handler({'toggleui', 'ui'}, function()
  ProbablyEngine.config.write('uishown', not ProbablyEngine.config.read('uishown'))
  if ProbablyEngine.config.read('uishown') then
    ProbablyEngine.buttons.buttonFrame:Show()
  else
    ProbablyEngine.buttons.buttonFrame:Hide()
  end
end)
ProbablyEngine.command.register_help('toggleui', L('help_toggleui'))

ProbablyEngine.command.register_handler({'help', '?', 'wat'}, function()
  ProbablyEngine.command.print('|cff' .. ProbablyEngine.addonColor .. 'ProbablyEngine |r' .. ProbablyEngine.version)
  for command, help in pairs(ProbablyEngine.command.help) do
    ProbablyEngine.command.print('|cff' .. ProbablyEngine.addonColor .. '/pe ' ..command .. '|r ' .. help)
  end
end)
ProbablyEngine.command.register_help('help', L('help_help'))

ProbablyEngine.command.register_handler({'cycle', 'pew', 'run'}, function()
  ProbablyEngine.cycle(true)
end)
ProbablyEngine.command.register_help('cycle', L('help_cycle'))

ProbablyEngine.command.register_handler({'toggle'}, function()
  ProbablyEngine.buttons.toggle('MasterToggle')
end)
ProbablyEngine.command.register_handler({'enable'}, function()
  ProbablyEngine.buttons.setActive('MasterToggle')
end)
ProbablyEngine.command.register_handler({'disable'}, function()
  ProbablyEngine.buttons.setInactive('MasterToggle')
end)

ProbablyEngine.command.register_help('toggle', L('help_toggle'))

ProbablyEngine.command.register_handler({'cd', 'cooldown', 'cooldowns'}, function()
  ProbablyEngine.buttons.toggle('cooldowns')
end)
ProbablyEngine.command.register_help('cd', L('cooldowns_tooltip'))

ProbablyEngine.command.register_handler({'kick', 'interrupts', 'interrupt', 'silence'}, function()
  ProbablyEngine.buttons.toggle('interrupt')
end)
ProbablyEngine.command.register_help('kick', L('interrupt_tooltip'))


ProbablyEngine.command.register_handler({'aoe', 'multitarget'}, function()
  ProbablyEngine.buttons.toggle('multitarget')
end)
ProbablyEngine.command.register_help('aoe', L('multitarget_tooltip'))


ProbablyEngine.command.register_handler({'al', 'log', 'actionlog'}, function()
  PE_ActionLog:Show()
end)
ProbablyEngine.command.register_help('al', L('help_al'))

ProbablyEngine.command.register_handler({'lag', 'cycletime'}, function()
  PE_CycleLag:Show()
end)

ProbablyEngine.command.register_handler({'turbo', 'godmode'}, function()
  local state = ProbablyEngine.config.toggle('pe_turbo')
  if state then
    ProbablyEngine.print(L('turbo_enable'))
    SetCVar('maxSpellStartRecoveryOffset', 1)
    SetCVar('reducedLagTolerance', 10)
    ProbablyEngine.cycleTime = 10
  else
    ProbablyEngine.print(L('turbo_disable'))
    SetCVar('maxSpellStartRecoveryOffset', 1)
    SetCVar('reducedLagTolerance', 100)
    ProbablyEngine.cycleTime = 100
  end
end)
ProbablyEngine.command.register_help('turbo', L('help_turbo'))

ProbablyEngine.command.register_handler({'bvt'}, function()
  local state = ProbablyEngine.config.toggle('buttonVisualText')
  ProbablyEngine.buttons.resetButtons()
  ProbablyEngine.rotation.add_buttons()
end)

