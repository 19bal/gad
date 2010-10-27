function [eH, eV] = myedge(I)
% function [eH, eV] = myedge(I)
%  soble edge hesaplar, eH+eV: gercel degerli

I = double(I);

H = fspecial('sobel')/8;  % horizontal
tH = transpose(H);      % vertical

eH = imfilter(I, H,  'replicate');
eV = imfilter(I, tH, 'replicate');