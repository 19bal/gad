function im2 = bluescreen(mask, im1)

blue = 0*im1;
blue(:,:,1) = 50;
blue(:,:,2) = 200;
blue(:,:,3) = 255;

if (size(mask,3)==1)
    mask = repmat(mask,[1 1 3]);
end
if (size(im1,3)==1)
    im1 = repmat(im1,[1 1 3]);
end

im2 = mask.*im1 + (1-mask).*blue;

