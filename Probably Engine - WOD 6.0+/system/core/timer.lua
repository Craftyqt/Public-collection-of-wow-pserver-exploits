-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local debug = ProbablyEngine.debug

ProbablyEngine.timer = {}
local timer = ProbablyEngine.timer

local timers = {}

local function onUpdate(self, elapsed)
  for timer, struct in pairs(timers) do
    struct.last = struct.last + elapsed
    if (struct.last > struct.period) then
      debug.print('Timer Fire: ' .. timer , 'timer')
      struct.event(elapsed)
      struct.last = 0
    end
  end
end

local frame = CreateFrame('Frame')
frame:SetScript('OnUpdate', onUpdate);

function timer.register(module, _event, _period)
  debug.print('Timer Registered: ' .. module, 'timer')
  if not tonumber(_period) then
    ProbablyEngine.print('Timer Error: ' .. module .. ' has no time period.')
    return
  end

  timers[module] = {
    event = _event,
    period = (_period / 1000),
    last = 0
  }
end

function timer.unregister(module)
  debug.print('Timer Unregistered: ' .. module, 'timer')
  timers[module] = nil
end

function timer.updatePeriod(module, period)
  timers[module].period = (period / 1000)
end
