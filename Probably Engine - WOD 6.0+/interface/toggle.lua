-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.
local L = ProbablyEngine.locale.get

ProbablyEngine.toggle = {}

ProbablyEngine.toggle.create = function(toggle_name, icon, tooltipl1, tooltipl2, callback)
  local toggleCallback = function(self)
    self.checked = not self.checked
    if self.checked then
      ProbablyEngine.buttons.setActive(toggle_name)
    else
      ProbablyEngine.buttons.setInactive(toggle_name)
    end
    ProbablyEngine.config.write('button_states', toggle_name, self.checked)
    if callback then callback(self, mouseButton) end
  end
  ProbablyEngine.buttons.create(toggle_name, icon, toggleCallback, tooltipl1, tooltipl2)
  ProbablyEngine.buttons.loadStates()
end
