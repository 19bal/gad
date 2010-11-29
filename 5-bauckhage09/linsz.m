function [sz, k] = linsz(S, n, sp);
% function [sz, k] = linsz(S, n, sp);
% 
% 'S' boyutunu 'n' parcaya dogrusal bir sekilde boler. Her bir alt bolum
% boyutlari 'sz' de, ofset olarak 'sp' kullanildiginda baslangic
% koordinatlari ise 'k' dadir.
% 
% Ornek
%   [sz, k] = linsz(10, 4, 1)

m = n;
for i=1:m
    sz(i) = round(S/n);
    S = S - sz(i);
    n = n - 1;
end

k(1) = sp;
for i=2:m
    k(i) = k(i-1) + sz(i-1);
end
