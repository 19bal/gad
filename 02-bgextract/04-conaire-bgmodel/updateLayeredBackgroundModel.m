function [bgmodel, foreground, bridif, coldif, shadows] = updateLayeredBackgroundModel(bgmodel, im, doupdate, pixelweight)

if (nargin < 4)
    pixelweight = ones(size(im,1), size(im,2));
end
if (nargin < 3)
    doupdate = 1;
end

layers = bgmodel{1};
counts = bgmodel{2};
numbglayers = bgmodel{3};
T = bgmodel{4};
U = bgmodel{5};
A = bgmodel{6};

xs = size(layers,2);
ys = size(layers,1);
zs = size(layers,3);
N = size(layers,4);

difim = sqrt(sum((layers - repmat(im,[1 1 1 N])).^2, 3));

% for each layer, see if it matches
isok = zeros(ys,xs);
match = (N+1) * ones(ys,xs);
for i = 1:N
    isgood = (difim(:,:,1,i)<T);
    isok = isok + isgood;
    match = min(match, i*isgood + (N+1)*(1-isgood));
end


%[dist,match] = min(difim,[],4);
replace = 0+(match > N);
match = match + replace.*(N-match);
replace = replace .* (pixelweight > 0); % do not replace if pixel is not used

foreground = 0+(match > numbglayers);



% determine colour and brightness change (for RGB image)
if (zs == 3)
    bgbri = max(1,sum(layers(:,:,:,1),3));
    bgg = layers(:,:,2,1)./bgbri;
    bgb = layers(:,:,3,1)./bgbri;
    imbri = max(1,sum(im(:,:,:),3));
    img = im(:,:,2)./imbri;
    imb = im(:,:,3)./imbri;
    bridif = abs(log(imbri./bgbri));
    coldif = sqrt((bgb-imb).^2 + (bgg-img).^2);
    
    tmpdif = bridif + 18*coldif;
    shadows = foreground .* (bridif + 18*coldif <= 0.5);
    foreground = foreground .* (1-shadows);
else
    bridif=[];
    coldif=[];
    shadows=[];
end


if (doupdate==0)
    return;
end



% set count to zero if layer is being replaced
counts(:,:,N) = counts(:,:,N) .* (1-replace);

% update layer counts
matchv = (match-1) * (xs*ys);
[xp,yp] = meshgrid(1:xs,1:ys);
val = makelinear(matchv + yp + (xp-1)*ys);
val2 = makelinear(yp + (xp-1)*ys);
%counts(val) = counts(val) + 1;
counts(val) = counts(val) + pixelweight(val2);

% add new layers
replace2 = repmat(replace,[1 1 zs]);
layers(:,:,:,N) = (1-replace2).*layers(:,:,:,N) + replace2.*im;

% Sort layers
for i = N:-1:2
    % see if the counts of the layer above are lower
    doswap = counts(:,:,i-1) < counts(:,:,i);
    % Do swapping!
    doswap2 = repmat(doswap, [1 1 zs]);
    
    % swap counts
    old = counts(:,:,i);
    counts(:,:,i) = (1-doswap).*counts(:,:,i) + doswap.*(counts(:,:,i-1));
    counts(:,:,i-1) = (1-doswap).*counts(:,:,i-1) + doswap.*old;
    % swap layers
    old = layers(:,:,:,i);
    layers(:,:,:,i) = (1-doswap2).*layers(:,:,:,i) + doswap2.*(layers(:,:,:,i-1));
    layers(:,:,:,i-1) = (1-doswap2).*layers(:,:,:,i-1) + doswap2.*old;
end

counts = counts * U;

% Update 'numbglayers'
csum = zeros(ys,xs);
numbglayers = N*ones(ys,xs);
lim = A * sum(counts,3);

for i = 1:N
    csum = csum+counts(:,:,i);
    numbglayers = min(numbglayers, i*(csum>=lim) + N*(csum<lim));
end


bgmodel = {layers, counts, numbglayers, T, U, A};








