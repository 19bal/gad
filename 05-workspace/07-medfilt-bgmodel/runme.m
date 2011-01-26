%%%%%%%%%%%%%%%% D O   N O T   E D I T   M E %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LIB_PATH = sprintf('..%slib%s', filesep,filesep);                         %
addpath(LIB_PATH,'-end');                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dbg = true;

mkdir(pathos('_db/'));
dbnm = pathos('_db/orj/');              % resimler buraya
dbnm_bw = pathos('_db/bw/');            mkdir(dbnm_bw);
dbnm_siluet = pathos('_db/siluet/');    mkdir(dbnm_siluet);
dbnm_64x64  = pathos('_db/64x64/');     mkdir(dbnm_64x64);
dbnm_bkp = pathos('_bkp/');             mkdir(dbnm_bkp);

iscreate_bg     = ~exist((pathos(strcat(dbnm_bkp, 'bg_model.png'))));
iscreate_bw     = length(dir(strcat(dbnm_bw, '*.png'))) < 1;
iscreate_siluet = length(dir(strcat(dbnm_siluet, '*.png'))) < 1;
iscreate_64x64  = length(dir(strcat(dbnm_64x64, '*.png'))) < 1;

if iscreate_bg
    bg = bg_model(dbnm, dbnm_bkp, 200, dbg);
else
    bg = imread(pathos(strcat(dbnm_bkp, 'bg_model.png')));
end

if iscreate_bw
    dbnm_bw = frm2bw_db(dbnm, dbnm_bw, bg, dbg);
end

DIR = dir(strcat(dbnm, '*.png'));
DIR_bw = dir(strcat(dbnm_bw, '*.png'));
sz = length(DIR_bw);

for f = 100%1:135,
    fprintf('kare %04d/%04d isleniyor ...\n', f, sz);

    imgnm = DIR(f).name;
    fr = imread(strcat(dbnm, imgnm));

    imgnm_bw = DIR_bw(f).name;
    bw = double(imread(strcat(dbnm_bw, imgnm_bw)));

    if iscreate_siluet
        bwr = insanlar(bw, dbg);
        imwrite(bwr, strcat(dbnm_siluet, imgnm));
    else
        bwr = imread(strcat(dbnm_siluet, imgnm));
    end

    frh = fr .* uint8(cat(3, bwr,bwr,bwr));

    if iscreate_64x64
        bw64x64 = bwsresize(bwscrop(bw2silh(bwr)));
        imwrite(bw64x64, strcat(dbnm_64x64, imgnm));
    else
        bw64x64 = imread(strcat(dbnm_64x64, imgnm));
    end

    if dbg
        figure(1);
            subplot(221),   imshow(bwr),        title('bwr');
            subplot(222),   imshow(frh),        title('insanlar');
            subplot(223),   imshow(bw64x64),    title('64x64');
        drawnow;
    end
end
