function RdeltaG = compute_RdeltaG(deltaG, mx)
% function RdeltaG = compute_RdeltaG(deltaG, Gty)

RdeltaG = deltaG.^2 / mx;