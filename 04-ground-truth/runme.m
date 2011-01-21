% CAVIAR db den parse edilen box'lari png uzerine cizdir
clear all;  close all;  clc;

dbg = true;
dbnm = pathos('_db/orj/');
fnm_mat = pathos('_db/fosmne1gt.xml');

box_caviar = parser_caviar_box(fnm_mat, dbg);

% caviar notasyonundan Matlab:RECT notasyonuna donustur
rect(:, 1) = box_caviar(:, 1) - round(box_caviar(:,3)/2);
rect(:, 2) = box_caviar(:, 2) - round(box_caviar(:,4)/2);
rect(:, 3) = box_caviar(:, 3);
rect(:, 4) = box_caviar(:, 4);

DIR = dir(strcat(dbnm, '*.png'));

sz = length(DIR);

for f=1:10:sz%1:sz
    if dbg, fprintf('%04d. fram isleniyor...\n', f);    end
    
    frm = imread(strcat(dbnm, DIR(f).name));
    
    if dbg,
        figure(1),  
        imshow(frm),    
        if rect(f, 1) > 0
            hold on
            rectangle('Position', rect(f, :), 'EdgeColor', 'g', 'LineWidth', 1);  
            hold off
        end
        drawnow;
    end
end
