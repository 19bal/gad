function dbnm_bw = frm2bw_db(dbnm, dbnm_bw, bg, dbg);
% function dbnm_bw = frm2bw_db(dbnm, dbnm_bw, bg, dbg);
alpha = 0.00;   % devreye almak icin 0.05 degerini kullanabilirsin 
T = 30;
mc = 25;    Mc = 45;

mkdir(dbnm_bw);

DIR = dir(strcat(dbnm, '*.png'));
sz = length(DIR);
bg = double(bg);

for f = 1:sz,
    fprintf('kare %04d/%04d isleniyor ...\n', f, sz);
    
    imgnm = DIR(f).name;    
    cfrm = double(imread(strcat(dbnm, imgnm)));
    
    fark = abs(cfrm - bg);
    
    % bg update with running average    
    bg = alpha * cfrm + (1 - alpha) * bg;
    
    bw = (fark > T);    
    confC = frm2confC(cfrm, bg, mc, Mc, T, false);
     
    if dbg
        figure(1);
            subplot(121),   imshow(uint8(cfrm))
            subplot(122),   imshow(confC)
        drawnow;
    end    
    
    imwrite(confC, strcat(dbnm_bw, imgnm));
end
