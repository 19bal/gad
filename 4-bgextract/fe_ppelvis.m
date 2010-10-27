function pPelvis = fe_ppelvis(bw)
% function pPelvis = fe_ppelvis(bw)
% regionprops:centroid
L = bwlabel(bw);
s = regionprops(L, 'centroid');
pPelvis = round(cat(1, s.Centroid));
