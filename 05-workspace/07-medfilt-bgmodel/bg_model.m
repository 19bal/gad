function bg = bg_model(dbnm, dbnm_bkp, N, dbg);
% function bg = bg_model(dbnm, dbnm_bkp, N, dbg);

DIR = dir(strcat(dbnm, '*.png'));
DIR = DIR(1:N);
bg = bg_color(DIR, dbnm, dbg);

mkdir(dbnm_bkp);
imwrite(bg, pathos(strcat(dbnm_bkp, 'bg_model.png')));