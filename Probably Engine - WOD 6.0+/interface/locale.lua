-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

local GetLocale = GetLocale

ProbablyEngine.locale = {}
local locale = ProbablyEngine.locale

local locales = {}
local playerLocale = GetLocale()
local writeTo = playerLocale
local fallback = true
local warn = false

function locale.new(id)
  writeTo = id
  if id ~= playerLocale and id ~= 'enUS' then return end
  if not locales[id] then locales[id] = {} end
end

function locale.get(key)
  if locales[playerLocale] and locales[playerLocale][key] then
    return locales[playerLocale][key]
  elseif fallback and locales['enUS'][key] then
    if warn then print('Warning, locale not found for key:' .. key) end
    return locales['enUS'][key]
  end
  return 'nolocale:' .. key
end

function locale.set(key, text)
  if writeTo ~= playerLocale and writeTo ~= 'enUS' then return end

  if not locales[writeTo] then
    print('Error must create the following locale first:', writeTo)
  end

  locales[writeTo][key] = text
end
