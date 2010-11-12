function features = fextract(bw, dbg)
% function features = fextract(bw)

features.moments(1) = immoment_hu(bw, 1);
features.moments(2) = immoment_hu(bw, 2);
features.moments(3) = immoment_hu(bw, 8);

% Bundle rectangle
L = bwlabel(bw);
s  = regionprops(L, {'boundingbox', 'area'});

bbox = cat(1, s.BoundingBox);
features.W = bbox(3);
features.H = bbox(4);

features.angle = rad2deg(atan2(features.H, features.W));

features.area = cat(1, s.Area);

features.w = fe_gatech(bw, dbg);
features.R = fe_mit(bw, dbg);