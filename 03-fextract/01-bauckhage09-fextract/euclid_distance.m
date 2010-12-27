function h = euclid_distance(A, B)
%function h = euclid_distance(A, B)
%   A ve B noktalarinin euclid mesafesi
% 
% Input:
%   A, B: structure turunde, elemanlari (X,Y,Z)
% Output:
%   h: hesaplanan hipotenus degeri
% 
% Example 1:
%   A.X = 0; A.Y = 0;   A.Z = 0
%   B.X = 5; B.Y = 0;   B.Z = 0
%   euclid_distance(A, B)
% 
% Example 2:
%   euclid_distance([1 2], [3 4])
% 
% Example 3:
%   x = [1 2; 3 4; 5 6]
%   mn = mean(x)
%   euclid_distance(x, mn)

if isstruct(A)
    deltaX = abs(A.X - B.X);
    deltaY = abs(A.Y - B.Y);

    if isfield(A, 'Z')
        deltaZ = abs(A.Z - B.Z);
        h = sqrt(deltaX.^2 + deltaY.^2 + deltaZ.^2);
    else
        h = sqrt(deltaX.^2 + deltaY.^2);
    end
else % array
    if size(A, 1) > 1 && size(B, 1) == 1
        B = repmat(B, [size(A,1) 1]);
    end
        
    h = sqrt(sum((A' - B').^2));
end