function bgmodel = initLayeredBackgroundModel(im, N, T, U, A)

if (nargin < 2)
    N = 5; % number of layers
end
if (nargin < 3)
    T = 30; % threshold for matching
end
if (nargin < 4)
    U = 0.99; % update control  (e.g. 0.6 = very fast, 0.99 = slow)
end
if (nargin < 5)
    A = 0.75; % fraction of prior pixels in background layers
end

xs = size(im,2);
ys = size(im,1);
zs = size(im,3);

layers = zeros(ys,xs,zs,N);
counts = zeros(ys,xs,N);

layers(:,:,:,1) = im;
counts(:,:,1) = 1;

numbglayers = ones(ys,xs);

bgmodel = {layers, counts, numbglayers, T, U, A};








