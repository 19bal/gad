function data = makelinear(im)

% converts a 2D array (image)
% into a 1D vector
%

data = zeros(numel(im),1);
data(:) = im(:);

% old code
%data = zeros(prod(size(im)),1);
%i = 1:length(data);
%data(i)=im(i);
