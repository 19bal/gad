function conf = fark2conf(fark, mc, Mc)
% function conf = fark2conf(fark, mc, Mc)

conf = (fark - mc) / (Mc - mc) * 100;    
conf(fark < mc) = 0;
conf(fark > Mc) = 100;
conf = uint8(conf * (255/100));