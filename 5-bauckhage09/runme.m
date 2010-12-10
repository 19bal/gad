close all;  clear all;  clc;

%%%%%%%%%%%%%%%% D O   N O T   E D I T   M E %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LIB_PATH = sprintf('..%slib%s', filesep,filesep);                         %
addpath(LIB_PATH,'-end');                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dbg = true;
nr = 8;
nc = 6;

dbnm = pathos('_db/');
DIR = dir(strcat(dbnm, '*.png'));
sz = length(DIR);

for f = 1:sz,
    fprintf('kare %04d/%04d isleniyor ...\n', f, sz);

    imgnm = DIR(f).name;    
    bw = imread(strcat(dbnm, imgnm));
    
    BB = fe_bauckhage09(bw, nr, nc, true, true);
    
    if dbg
        figure(1);
        imshow(bw),        title('bw');
        hold on
        for c=1:nc
            for r=1:nr
                rectangle('Position', BB(r,c,:),'EdgeColor', 'g', 'LineWidth', 1);            
            end
        end        
        hold off       
    end    
end
