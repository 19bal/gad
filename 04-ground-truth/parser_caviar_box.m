function box_caviar = parser_caviar_box(fnm, dbg);
% function box_caviar = parser_caviar_box(fnm, dbg);
% 
% CAVIAR DB'nin xml dosyasindan box'i parse eder

[pstr, nm, ext] = fileparts(fnm);
fnm_mat = pathos(strcat(pstr, '/', nm, '.mat'));

if exist(fnm_mat)
    load(fnm_mat);
    return
end

str = fileread(fnm);  %xml'i okur

v = xml_parseany( str );  %toolbox'?n bir ?zelli?i, okunan xml'in
%i?indeki de?erleri v'ye atar

sz = length(v.frame);

for f=1:sz
    if dbg, fprintf('%04d. frame isleniyor...\n', f);   end

    if isfield(v.frame{f}.objectlist{1}, 'object')

        bs = v.frame{f}.objectlist{1}.object{1}.box{1}.ATTRIBUTE;

        cbox = [str2num(bs.xc), str2num(bs.yc), ...
                str2num(bs.w),  str2num(bs.h)  ];
    else
        cbox = [-1 -1 0 0];
    end

    box_caviar(f, :) = cbox;
end

save(fnm_mat, 'box_caviar');
