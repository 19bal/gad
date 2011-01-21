function bg = bgmodel(dbnm, dbg)
% function bg = bgmodel(dbnm, dbg)
%   frame akisindan bg modelini olusturur.
% bg modeli
%   bg.(R|G|B).(M|D|[H|V.M|D])
% ornek:
%   bg.R.M
%   bg.R.H.M

mkdir(pathos('_bkp/'));

if ~exist(pathos('_bkp/BGMODEL.mat'), 'file')
    DIR = dir(strcat(dbnm, '*.bmp'));
    Nbg = 1:11;       % bg frame indisleri

    [bg_mn, bg_dev] = bg_color(Nbg, DIR, dbnm, dbg);
    [bg_H_mn, bg_V_mn, bg_H_dev, bg_V_dev] = bg_edge(Nbg, DIR, dbnm);
    
    bg_mn = uint8(bg_mn);   bg_dev = uint8(bg_dev);
    
    bg.R = 0;   bg.G = 0;   bg.B = 0;
    bg.R.M = bg_mn(:,:,1);  bg.R.D = bg_dev(:,:,1);
    bg.G.M = bg_mn(:,:,2);  bg.G.D = bg_dev(:,:,2);
    bg.B.M = bg_mn(:,:,3);  bg.B.D = bg_dev(:,:,3);
    
    bg.R.H = 0;   bg.G.H = 0;   bg.B.H = 0;
    bg.R.H.M = bg_H_mn(:,:,1);  bg.R.H.D = bg_H_dev(:,:,1);
    bg.G.H.M = bg_H_mn(:,:,2);  bg.G.H.D = bg_H_dev(:,:,2);
    bg.B.H.M = bg_H_mn(:,:,3);  bg.B.H.D = bg_H_dev(:,:,3);
    
    bg.R.V = 0;   bg.G.V = 0;   bg.B.V = 0;
    bg.R.V.M = bg_V_mn(:,:,1);  bg.R.V.D = bg_H_dev(:,:,1);
    bg.G.V.M = bg_V_mn(:,:,1);  bg.G.V.D = bg_H_dev(:,:,1);
    bg.B.V.M = bg_V_mn(:,:,1);  bg.B.V.D = bg_H_dev(:,:,1);
    
    sk = pwd;
        cd(pathos('_bkp/'));
        save BGMODEL bg
    cd(sk);     
else
    load(pathos('_bkp/BGMODEL.mat'));
end
