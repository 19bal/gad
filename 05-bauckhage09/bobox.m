function b = bobox(bw)
% function b = bobox(bw)
% bbox ismi dusunuldu fakat dipimage:bbox ile cakistigindan bobox olarak
% guncellendi.

[yy, xx, t] = find(bw == 1);
mnX = min(xx(:)); mnY = min(yy(:));
mxX = max(xx(:)); mxY = max(yy(:));

b = [mnX, mnY, (mxX - mnX + 1), (mxY - mnY + 1)];

if size(b, 1) == 0
    b = [1 1 1 1];
end

% % v1
% % TODO: resim icerisinde sadece bir nesnenin oldugu kabul edildi. Genel
% % durumlari idare et
% 
% L = bwlabel(bw);
% s = regionprops(L, 'boundingbox');
% b = cat(1, s.BoundingBox);