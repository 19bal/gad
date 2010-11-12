function [bg_mn, bg_dev] = bg_color(Nbg, DIR, dbnm, dbg)
% function [bg_mn, bg_dev] = bg_color(Nbg, DIR, dbnm, dbg)
% arkaplan framelerinin ortalamasi ve sapmasi

for f=Nbg,
    imgnm = DIR(f).name;    
    img = imread(strcat(dbnm, imgnm));
    
    frm(:,:,:,f) = img;
end

%% a) mean
%   frame indisince ortalama
%   tum framelerin ortalamasi: resim (RGB)
bg_mn = mean(double(frm), 4);

if dbg,
    figure(2);              imshow(uint8(bg_mn));
    title('Mean image');    drawnow;
end

%% b) deviation (~standart deviation?)
bg_dev = std(double(frm), 0, 4);

if dbg,
    figure(3);  imshow(uint8(bg_dev * (255/max(bg_dev(:)))));   
    title('Deviation image');   drawnow;
end
