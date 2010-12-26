% demo gait analysis
clear all; close all;  clc;
dbg = true;

mkdir(pathos('_db/'));
mkdir(pathos('_bkp/'));

% resimleri buraya koy
dbnm = pathos('_db/orj/');
imgnm_bg = pathos('_bkp/bg_model.png');

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
            subplot(222),   imshow(bg);                 title('median bgmodel');
            subplot(223),   imshow(uint8(255*bwr));     title('bw');
            subplot(224),   imshow(bw(:,:,1));          title('bw:R');
        drawnow;
    end
end

% % if dbg
% %     figure(2),
% %     subplot(121), imshow(uint8(bg_mn));                     title('mean')
% %     subplot(122), imshow(uint8(255*bg_st / min(bg_st(:)))); title('std')
% %     drawnow;
% %     
% %     figure(3); 
% %     imshow( uint8(10*abs(double(bg) - double(bg_mn) )));    title('fark: median - mean')
% % end
% % 
% % imwrite(uint8(bg_mn), imgnm_bg_mn);
% % 
% % save(fnm_bg_st, 'bg_st');
