function bwSilh = bw2silh(bw)
% function silh = bw2silh(bw)
% 
% bw goruntuden en buyuk alana sahip olan insana ait
% silhouette'i cikarir

L = bwlabel(bw);
s = regionprops(L, 'area');
areas = cat(1, s.Area);

[mx, ind] = max(areas);

bwSilh = bw; %?
bwSilh(L ~= ind) = false;
bwSilh(L == ind) = true;