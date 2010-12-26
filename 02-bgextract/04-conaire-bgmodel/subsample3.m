function im2 = subsample3(im, nw, nh)

w = size(im,2);
h = size(im,1);
d = size(im,3);

im2 = zeros(nh,nw,d);

if (nw==1)
    allx = round((w+1)/2);
else
    allx = round(1+(((1:nw)-1)/(nw-1)*(w-1)));
end

if (nh==1)
    ally = round((h+1)/2);
else
    ally = round(1+(((1:nh)-1)/(nh-1)*(h-1)));
end


%ally = floor(((nh/2/h):(nh-1))*h/nh)+1;

im2 = im(ally,allx,:);


% for j = 1:nh
%     pj = floor((j-1)*h/nh)+1;
%     im2(j,:,:) = im(pj,allx,:);
% end



