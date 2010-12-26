function a = myfitellipse(bw, dbg)
% function a = myfitellipse(bw, dbg)

L = bwlabel(bw);
s = regionprops(L, {'area','centroid', 'majoraxislength', 'minoraxislength', 'orientation'});

areas     = cat(1, s.Area);
centroids = cat(1, s.Centroid);
majorAL   = cat(1, s.MajorAxisLength);
minorAL   = cat(1, s.MinorAxisLength);
orient    = cat(1, s.Orientation);

[t, i] = max(areas);
centroids = centroids(i, :);
majorAL = 0.5*majorAL(i);
minorAL = 0.5*minorAL(i);
orient  = orient(i);

a(1:2) = centroids;
a(3)   = majorAL;
a(4)   = minorAL;
a(5)   = -deg2rad(orient);