function bg_med = bg_color(DIR, dbnm, dbg) 
for f=1:length(DIR),
    imgnm = DIR(f).name;    
    img = imread(strcat(dbnm, imgnm));
    
    frm(:,:,:,f) = img;
end

%% a) median
%   frame indisince ortanca
%   tum framelerin ortancasi: resim (RGB)
bg_med = uint8(median(double(frm), 4));

if dbg,
    figure(11);              imshow(uint8(bg_med));
    title('Median image');    drawnow;
end
