% demo gait analysis
clear all; close all;  clc;
dbg = true;

dbnm = pathos('_db/orj/');
imgnm_bg = pathos('_bkp/bg_model.png');

bg = imread(imgnm_bg);

T = 10;

bgp = cell(size(bg));

DIR = dir(strcat(dbnm, '*.png'));
sz = length(DIR);

for f=1:200%sz,
    if dbg,
        fprintf('%2d. frame isleniyor\n', f);
    end
    
    imgnm = DIR(f).name;    
    fr = imread(strcat(dbnm, imgnm));
    
    bw = abs(double(fr) - double(bg)) < T;
    
    bgp = aday_bgp(fr, bw, bgp, dbg);
    
    if dbg,
        figure(1);
            subplot(221),   imshow(fr);             title('su anki kare');
            subplot(222),   imshow(bg);             title('median bgmodel');
            subplot(223),   imshow(uint8(255*bw));  title('bw');
            subplot(224),   imshow(bw(:,:,1));      title('bw:R');
    end
end

