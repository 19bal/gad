% demo gait analysis
clear all; close all;  clc;
dbg = true;

mkdir(pathos('_db/'));
mkdir(pathos('_bkp/'));

% resimleri buraya koy
dbnm = pathos('_db/orj/');				% surveillance:RGB resimler
imgnm_bg = pathos('_bkp/bg_model.png');	% 19bal/shadow:07-medfilt-bgmodel in urettigi

imgnm_mn = pathos('_bkp/bg_model_mean.png');
fnm_st = pathos('_bkp/bg_model_std.mat');

bg = imread(imgnm_bg);

T = 10;

mn = zeros(size(bg));
st = zeros(size(bg));
N = zeros(size(bg));

DIR = dir(strcat(dbnm, '*.png'));
sz = length(DIR);

for f=1:200 %sz,
    if dbg,
        fprintf('%2d. frame isleniyor\n', f);
    end

    imgnm = DIR(f).name;
    fr = imread(strcat(dbnm, imgnm));

    bw = abs(double(fr) - double(bg)) < T;

    bwi = true - bw;
    bwr = bwareaopen(bwi, 1000);
    bw = true - bwr;

    [mn, st, N] = artimsal(mn, st, N, bw, fr, dbg);

    if dbg,
        figure(1);
            subplot(221),   imshow(fr);                 title('su anki kare');
            subplot(222),   imshow(uint8(255*bw));      title('bw');
            subplot(223),   imshow(uint8(mn));          title('mn');
            subplot(224),   imshow(uint8(10*abs(st)));  title('st');
        drawnow;
    end
end

imwrite(uint8(mn), imgnm_mn);
save(fnm_st, 'st');

