-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local debug = ProbablyEngine.debug

ProbablyEngine.listener = {}
local listener = ProbablyEngine.listener

local listeners = {}

local function onEvent(self, event, ...)
  if not listeners[event] then return end

  for i = 1, #listeners[event] do
    debug.print('Event Called: ' .. event .. ', ' .. listeners[event][i].name, 'listener')
    listeners[event][i].callback(...)
  end
end

local frame = CreateFrame('Frame', 'PE_Events')
frame:SetScript('OnEvent', onEvent)

function listener.register(name, event, callback)
  if not callback then
    name, event, callback = 'default', name, event
  end

  debug.print('Event Registered: ' .. event .. ', ' .. name, 'listener')

  if not listeners[event] then
    frame:RegisterEvent(event)
    listeners[event] = {}
  end

  table.insert(listeners[event], { name = name, callback = callback })
end

function listener.unregister(event, name, callback)
  if not callback then
    name, callback = 'default', name
  end

  for i = 1, #listeners[event] do
    if listeners[event][i].name == name or listeners[event][i].callback == callback then
      debug.print('Event Unregistered: ' .. event .. ', ' .. name, 'listener')
      table.remove(listeners[event], i)
    end
  end

  if #listeners[event] == 0 then
    listeners[event] = nil
    frame:UnregisterEvent(event)
  end
end

function listener.trigger(event, ...)
  onEvent(nil, event, ...)
end
