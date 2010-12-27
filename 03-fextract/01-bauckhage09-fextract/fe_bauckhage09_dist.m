function Dist = fe_bauckhage09_dist(bw, nr, nc, dbg);
% function Dist = fe_bauckhage09_dist(bw, nr, nc, dbg);

BB = fe_bauckhage09(bw, nr, nc, dbg, false);

[R, C, t] = size(BB);
[H, W] = size(bw);

s = regionprops(bwlabel(bw), 'centroid');
centroid = cat(1, s.Centroid);

Dist = zeros(2*C + 2*(R - 2) + 1, 1);

% 1
i = 1;
r = 1;  
for c = 1:C
    X = BB(r, c, 1);
    Y = BB(r, c, 2);    
    Dist(i) = euclid_distance([X Y], centroid) / H;
    i = i + 1;
end

% 2
c = C;  
for r = 2:R
    X = BB(r, c, 1);
    Y = BB(r, c, 2);    
    Dist(i) = euclid_distance([X Y], centroid) / H;
    i = i + 1;
end

% 3
r = R;  
for c = (C-1):-1:1
    X = BB(r, c, 1);
    Y = BB(r, c, 2);    
    Dist(i) = euclid_distance([X Y], centroid) / H;
    i = i + 1;
end

% 4
c = 1;  
for r = (R-1):-1:2
    X = BB(r, c, 1);
    Y = BB(r, c, 2);    
    Dist(i) = euclid_distance([X Y], centroid) / H;
    i = i + 1;
end

% global normalizasyon faktoru-centroid:y/H
Dist(i) = centroid(2)/H;
