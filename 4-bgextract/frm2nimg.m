function img = frm2nimg(frm)

img = im2double(frm);

misc = (img(:,:,1) + img(:,:,2) + img(:,:,3));
misc(misc==0) = 0.001;

img(:,:,1) = img(:,:,1) ./ misc;
img(:,:,2) = img(:,:,2) ./ misc;
% img(:,:,3) = img(:,:,3) ./ misc;
