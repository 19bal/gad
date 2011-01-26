function bwr = insanlar(bw, dbg)
dip_initialise('silent');

bw = logical(bw);

a = dip_image(bw);
b = bskeleton(a,0,'natural');

bw2 = logical(b);
L = bwlabel(bw2,8);
Lv = L(:);

% L icerisindekileri frekansina gore sirala
sz = max(Lv);
for i=1:sz
    N(i) = length(find(Lv == i));
end

if dbg
    figure(11),
    imshow(L);            title('iskeletler');
    
    figure(12), 
    ind = 1:length(N);
    plot(ind, N, '*');      title('iskelet uzunluk histogrami');
    xlabel('indis');    ylabel('Frekans');
    grid on
end

[v, iv] = sort(N, 'descend');

T = 10;
indk = iv(v > T);

% skeleton
bws = zeros(size(bw));
for i=1:length(indk),
    t = bw;
    k = indk(i);
    t(L ~= k) = 0;
    t(L == k) = 1;
    
    bws = bws + t;
end

% maske
a = dip_image(logical(bw));
b = dip_image(logical(bws));
c = bdilation(b, 8,-1,0);
bwr = logical(a * c);

if dbg
    figure(13)
    subplot(221),   imshow(bw);             title('bw');
    subplot(222),   imshow(logical(bws));   title('bws');
    subplot(223),   imshow(logical(c));     title('dilation');
    subplot(224),   imshow(bwr);            title('bwr');
end


