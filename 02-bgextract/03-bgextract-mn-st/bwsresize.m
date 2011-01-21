function rimg = bwsresize(bws)
% function rimg = bwsresize(bws)
% 
% bws resmini 64x64'lik kare resme kucult
% bws'nin yuksekligi 64 olacak sekilde olcekle.
rimg = imresize(bws, [64, NaN]);

L = bwlabel(rimg);
s = regionprops(L,'centroid');
centroids = round(cat(1, s.Centroid));

W = size(rimg, 2);
cn = centroids(1);
sh = round(W/2 - cn);

psz = floor((64 - size(rimg,2))/2);

% FIXME:
if psz < 0,
    rimg = bws;
    return
end

rimg = padarray(rimg, [0 psz], 0, 'both');
rimg = padarray(rimg, [0 (64 - size(rimg,2))], 0, 'post');

rimg = circshift(rimg, [0 sh]);
