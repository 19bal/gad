% Test Layered Background Model

dbnm = '../../db/surveillance/';
DIR = dir(strcat(dbnm, '*.png'));

sz = length(DIR);

N = 5; % number of layers
T = 20; % RGB Euclidian threshold
U = 0.999; % update rate
A = 0.85; % fraction of observed colour to account for in the background

for f=[1:140 155:250]%sz
    imgnm = DIR(f).name;
    cfrm = double(imread(strcat(dbnm, imgnm))); 
    
    if f == 1
        bgmodel = initLayeredBackgroundModel(cfrm, N, T, U, A);
    else        
        [bgmodel, foreground, bridif, coldif, shadows] = updateLayeredBackgroundModel(bgmodel, cfrm);
        
        if f > 50
            subplot(2,3,1);     shownormimage2(cfrm);                       title('Image');
            subplot(2,3,2);     shownormimage2(foreground);                 title('Detected Foreground');
            subplot(2,3,4);     shownormimage2(shadows);                    title('Shadows');
            subplot(2,3,5);     imfg = removesmallregions3(foreground,100);
                                shownormimage2(imfg);                       title('Cleaned up foreground');
            subplot(2,3,6);     shownormimage2(bluescreen(imfg, cfrm));     title('Detected Object');        
            drawnow;
        end
    end
end

