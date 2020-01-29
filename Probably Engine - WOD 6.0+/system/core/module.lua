-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.module = {}
local module = ProbablyEngine.module

function module.register(name, struct)
  module[name] = struct
end

function module.unregister(name)
  module[name] = nil
end
