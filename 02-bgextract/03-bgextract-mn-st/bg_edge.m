function [bg_H_mn, bg_V_mn, bg_H_dev, bg_V_dev] = bg_edge(Nbg, DIR, dbnm)
% [bg_H_mn, bg_V_mn, bg_H_dev, bg_V_dev] = bg_edge(Nbg, DIR, dbnm)
% arkaplan framelerinin edge (sobel) H ve V yonelim ortalamasi ve sapmasi

dbg = false;

for f=Nbg,
    imgnm = DIR(f).name;    
    img = imread(strcat(dbnm, imgnm));
    
    for i=1:3,
        [edgeH(:,:,i,f), edgeV(:,:,i,f)] = myedge(img(:,:,i));
    end
end

%% a) mean
%   frame indisince ortalama
%   tum framelerin ortalamasi: resim (RGB)
bg_H_mn = mean(double(edgeH), 4);
bg_V_mn = mean(double(edgeV), 4);

%% b) deviation (~standart deviation?)
bg_H_dev = std(double(edgeH), 0, 4);
bg_V_dev = std(double(edgeV), 0, 4);

