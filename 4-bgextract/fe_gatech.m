function w = fe_gatech(bw, dbg)
% function w = fe_gatech(bw)

%% pelvis
pPelvis = fe_ppelvis(bw);

%% head
% morph:dilation/erosion ile incelt
bw1 = imerode(bw, strel('disk', 3));

L = bwlabel(bw1);
s = regionprops(L, 'centroid');
centroids = cat(1, s.Centroid);
[y, i] = min(centroids(:, 2));
pHead = round(centroids(i, :));

%% lfoot - rfoot
[H, W] = size(bw);
bw_lfoot = bw(pPelvis(2):H, 1:pPelvis(1));
bw_rfoot = bw(pPelvis(2):H, pPelvis(1):W);

% lfoot
[r,c,v] = find(bw_lfoot);
i = min(c);
r = find(bw_lfoot(:, i));
pLfoot = [i (min(r) + pPelvis(2) - 1)];

% rfoot
[r,c,v] = find(bw_rfoot);
i = max(r);
c = find(bw_rfoot(i, :));
pRfoot = [(max(c) + pPelvis(1) - 1) (i + pPelvis(2) - 1)];

% di'ler
d1 = abs(pHead(2) - pRfoot(2));
d2 = dist_euclid(pHead, pPelvis);
d3 = dist_euclid(pPelvis, pLfoot);
d4 = dist_euclid(pLfoot, pRfoot);

w = [d1 d2 d3 d4];

if dbg,
    figure(44),
    if ~true,   subplot(221),   end
    
    imshow(bw); title('FE-gaTECH');    
    hold on
    plot(pPelvis(1), pPelvis(2), 'b*', ...
         pHead(1),   pHead(2),   'r*', ...
         pLfoot(1),  pLfoot(2),  'g*', ...
         pRfoot(1),  pRfoot(2),  'm*');
    hold off
    
    hold on
    tmp = [pHead; pPelvis; pLfoot; pPelvis; pRfoot];
    plot(tmp(:,1), tmp(:,2), 'k')
    hold off
    
    if ~true,
        subplot(222),   imshow(bw1)
        subplot(223),   imshow(bw_lfoot)
        subplot(224),   imshow(bw_rfoot)
    end
end
