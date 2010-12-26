function im2 = removesmallregions3(im, minsize, conn)

if (nargin <= 2)
    conn = 8;
end

%
% uses 8-connectedness
%

[imc, nregions] = bwlabel(im,conn);

h=hist(makelinear(imc),nregions+1);
h2 = h>=minsize;

im2 = (h2(imc+1)) .* (imc>0);
