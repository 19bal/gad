function frm2bw_db(dbnm, dbnm_bw, bg, dbg);
% function frm2bw_db(dbnm, dbnm_bw, bg, dbg)

mkdir(dbnm_bw);
DIR = dir(strcat(dbnm, '*.png'));

Nf = 300:500;%length(DIR);    % diger frameler

mc = 5;    Mc = 45;

for f=Nf,
    if dbg,
        fprintf('%2d. frame isleniyor\n', f);
    end
    
    imgnm = DIR(f).name;    
    frm = imread(strcat(dbnm, imgnm));
        
    conf = frm2confC(frm, bg, mc, Mc, false);
    bw = conf2bw(conf, false);
             
    bwSilh = bw2silh(bw);
    cimg = bwscrop(bwSilh);
    rimg = bwsresize(cimg);
    
    if dbg,
        figure(11);
        subplot(221);   imshow(frm);
        subplot(222);   imshow(bwSilh);
        subplot(223);   imshow(cimg);
        subplot(224);   imshow(rimg);
    end
    
    imwrite(rimg, strcat(dbnm_bw, imgnm));
end

