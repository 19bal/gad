function frm2bw_db(dbnm, dbnm_bw, bg, dbg);
% function frm2bw_db(dbnm, dbnm_bw, bg, dbg)

mkdir(dbnm_bw);
DIR = dir(strcat(dbnm, '*.png'));

Nf = 55:108;    %max(Nbg)+1:length(DIR);    % diger frameler

ind = 1;
mc = 25;    Mc = 45;
me = 15;     Me = 25;

for f=Nf,
    if dbg,
        fprintf('%2d. frame isleniyor\n', f);
    end
    
    imgnm = DIR(f).name;    
    frm = imread(strcat(dbnm, imgnm));
        
    confC = frm2confC(frm, bg, mc, Mc, false);
    
    %%<-- edge modeli aksiyor!
    % confE = frm2confE(frm, bg, me, Me, false);        
    % conf = max(confC, confE);
    %%-->
    conf = confC;
    
    bw = conf2bw(conf, false);
    
    %% shadow removal
    bw1 = bw; %bw1 = imfill(bw, 'holes');
    bw2 = imerode(bw1, ones(10));
    bw3 = imdilate(bw2, ones(30));%strel('line', 55, 90));
    bw4 = bw1 & bw3;
       
    bwSilh = bw2silh(bw4);
    cimg = bwscrop(bwSilh);
    rimg = bwsresize(cimg);
    
    if dbg,
        figure(55);
        subplot(221);   imshow(frm);
        subplot(222);   imshow(bwSilh);
        subplot(223);   imshow(cimg);
        subplot(224);   imshow(rimg);
    end
    
    gifIMG(:,:,1,ind) = rimg;    
    ind = ind + 1;
    imwrite(rimg, strcat(dbnm_bw, imgnm));
end
imwrite(gifIMG, strcat(dbnm_bw, 'anim.gif'), 'DelayTime',0,'LoopCount',inf);

