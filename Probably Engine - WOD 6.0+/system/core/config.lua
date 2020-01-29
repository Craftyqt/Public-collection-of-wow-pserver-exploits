-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local debug = ProbablyEngine.debug

ProbablyEngine.config = {}
local config = ProbablyEngine.config
local data = {}

function config.load(tbl)
  debug.print('Config Data Loaded', 'config')
  if tbl == nil then
    ProbablyEngine_ConfigData = {}
    data = ProbablyEngine_ConfigData
  else
    data = tbl
  end
end

function config.read(key, ...)
  debug.print('Reading Config Key: ' .. key, 'config')
  key = tostring(key)
  local length = select('#', ...)
  local default
  if length > 0 then
    default = select(length, ...)
  end

  if length <= 1 then
    if data[key] ~= nil then
      return data[key]
    elseif default ~= nil then
      data[key] = default
      return data[key]
    else
      return nil
    end
  end

  local _key = data[key]
  if not _key then
    data[key] = {}
    _key = data[key]
  end
  local __key
  for i = 1, length - 2 do
    __key = tostring(select(i, ...))
    if _key[__key] then
      _key = _key[__key]
    else
      _key[__key] = {}
      _key = _key[__key]
    end
  end
  __key = tostring(select(length - 1, ...))

  if _key[__key] then
    return _key[__key]
  elseif default ~= nil then
    _key[__key] = default
    return default
  end

  return nil
end

function config.write(key, ...)
  debug.print('Writing Config Key: ' .. key, 'config')
  key = tostring(key)
  local length = select('#', ...)
  local value = select(length, ...)

  if length == 1 then
    data[key] = value
    return
  end

  local _key = data[key]
  if not _key then
    data[key] = {}
    _key = data[key]
  end
  local __key
  for i = 1, length - 2 do
    __key = tostring(select(i, ...))
    if _key[__key] then
      _key = _key[__key]
    else
      _key[__key] = {}
      _key = _key[__key]
    end
  end

  __key = tostring(select(length - 1, ...))
  _key[__key] = value
end

function config.toggle(key)
  debug.print('Toggling Config Key: ' .. key, 'config')
  key = tostring(key)
  data[key] = not data[key]
  return data[key]
end
