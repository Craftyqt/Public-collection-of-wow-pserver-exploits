-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.debug = {
  enabled = false
}
local debug = ProbablyEngine.debug

local level = 0
local flags = {
  index = 0,
}

local function addFlag(name)
  local bitValue = bit.lshift(1, flags.index)
  flags[name] = bitValue
  flags.index = flags.index + 1
end

local function getFlag(name)
  return flags[name]
end

addFlag('no_flag')
addFlag('config')
addFlag('listener')
addFlag('timer')
addFlag('library')
addFlag('dsl_no_exist')
addFlag('dsl_call')
addFlag('dsl_debug')
addFlag('rotation')
addFlag('action_block')
addFlag('queue')
addFlag('dynamic')
addFlag('spell_cast')

function debug.add(flag)
  level = bit.bor(level, getFlag(flag))
end

function debug.remove(flag)
  level = bit.bxor(level, getFlag(flag))
end

function debug.toggle()
  debug.enabled = not debug.enabled
end

function debug.print(message, flag)
  if not debug.enabled then return end
  if flag == nil then flag = 'no_flag' end
  if bit.band(getFlag(flag), level) ~= 0 then
    print("|cFFff8000[Debug]|r " .. message)
  end
end

function debug.dump(obj)
  return DevTools_Dump(obj)
end
