% CAVIAR DB'nin xml dosyasindan box'i parse eder
clear all; close all;   clc;
warning off all;

dbg = true;

fnm = pathos('_db/fosmne1gt.xml');
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

[pstr, nm, ext] = fileparts(fnm);

save(strcat(pstr, nm, '.mat'), 'box_caviar');
