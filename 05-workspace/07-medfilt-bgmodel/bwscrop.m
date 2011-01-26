function cimg = bwscrop(bws)
% function cimg = bwscrop(bws)
% 
% silhouette resmini (bws) cirp

dbg = false;

L = bwlabel(bws);
s = regionprops(L, 'boundingbox');
bbox = round(cat(1, s.BoundingBox));

cimg = imcrop(bws, bbox);

if dbg
    figure(99);
    imshow(bws);
    
    hold on;
    rectangle('Position', bbox, 'EdgeColor', 'g', 'LineWidth', 1);
    hold off;
end