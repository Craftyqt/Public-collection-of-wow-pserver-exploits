-- ProbablyEngine Rotations
-- Released under modified BSD, see attached LICENSE.

ProbablyEngine.listener.register("LFG_PROPOSAL_SHOW", function()
  if ProbablyEngine.config.read('autolfg', false) then
    AcceptProposal()
  end
end)