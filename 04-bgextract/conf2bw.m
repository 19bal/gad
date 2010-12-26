function bw = conf2bw(conf, dbg)
% TODO: color segmentation
gri = conf; %rgb2gray(conf);
lvl = graythresh(gri);
bw = im2bw(gri, lvl);

if dbg,
    figure(2);  imagesc(bw);    
    axis image;
end