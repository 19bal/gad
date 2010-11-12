% demo gait analysis
clear all; close all;  clc;
dbg = true;
isCreateBW = false;

% % dbnm = strcat(DB_ROOT(), 'gait/soton/');
dbnm = '../../../db/gait/';
bw_dbnm = strcat(dbnm, 'bw/');

if isCreateBW
    bg = bgmodel(dbnm, dbg);
    bw_dbnm = frm2bw_db(dbnm, bg, dbg);
end

DIR = dir(strcat(bw_dbnm, '*.png'));
sz = length(DIR);

for f=1:sz,
    if dbg,
        fprintf('%2d. frame isleniyor\n', f);
    end
    
    imgnm = DIR(f).name;    
    bw = imread(strcat(bw_dbnm, imgnm));
    
    frm(:,:,f) = bw;         

    s = fextract(bw, dbg);    
    moments(f, :) = cat(1, s.moments);
    W(:, f) = cat(1, s.W);
    H(:, f) = cat(1, s.H);
    angles(:, f) = cat(1, s.angle);
    areas(:, f)  = cat(1, s.area);
    w(:, f) = cat(1, s.w); % gaTech
    R(:,:, f) = cat(1, s.R); % MIT
    
    if ~dbg,
        figure(11);
        imshow(bw);        

        figure(12);  
        subplot(411);   plot(moments(:,1)); title('Hu1');
        subplot(412);   plot(moments(:,2)); title('Hu2');
        subplot(413);   plot(moments(:,3)); title('Hu8');
        subplot(414);   plot(W);        
        drawnow;
    end

    if ~dbg,
        drawnow
        ffrm = getframe();
        [X, map] = rgb2ind(frame2im(ffrm), 256);
        gifIMG(:,:,1,f) = X;
    end
end
if ~dbg
    imwrite(gifIMG, map, 'anim_mit.gif', 'DelayTime',0,'LoopCount',inf);
end

% Gait Energy Image
cfrm = cycle_crop(frm, W, false);

gei = mean(double(cfrm), 3);
gei = uint8(gei * 255); % normalization: 0-255

if dbg,
    figure(13);
    imshow(gei);    title('Gait Energy Image');
end

% crop feature
[cfrm, cS, cE] = cycle_crop(frm, W, false);
cw = w(:, cS:cE);
cR = R(:,:, cS:cE);

