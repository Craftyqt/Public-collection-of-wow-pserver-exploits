-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local debug = ProbablyEngine.debug
local time = time

ProbablyEngine.timeout = {}
local timeout = ProbablyEngine.timeout

local timeouts = {}
local frame = CreateFrame('Frame')

frame:SetScript('OnUpdate', function(self, elapsed)
  for name, struct in pairs(timeouts) do
    if GetTime() >= (struct.start + struct.timeout) then
      if struct.callback then
        struct.callback()
      end
      timeouts[name] = nil
    end
  end
end)

function timeout.set(name, timeout, callback)
  timeouts[name] = {
    callback = callback,
    timeout = timeout,
    start = GetTime()
  }
end

function timeout.check(name)
  if timeouts[name] ~= nil then
    return (GetTime() - timeouts[name].start)
  end
  return false
end