% dbnm = strcat(DB_ROOT(), 'facerec/ef/train/');
dbnm = '_db/';
DIR = dir(strcat(dbnm, '*.png'));

sz = length(DIR);

for i=1:sz,
    rgb = imread(strcat(dbnm, DIR(i).name));
    rgb = imresize(rgb, [150 NaN]);

    fimage = msseg(rgb);

    % [fimage labels modes regSize grad conf] = edison_wrapper(rgb, @rgb2lab);

    figure(1);  imshow(rgb);
    figure(2),  imshow(fimage)

    pause
end
