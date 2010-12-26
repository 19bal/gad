function conf = frm2confC(frm, bg, mc, Mc, T, dbg);
% function conf = frm2confC(frm, bg, mc, Mc, T, dbg);
% 
% video daki frame den conf matrisini/resmini uret

fark = abs(double(frm) - double(bg));    

% jabri'den confidence
conf = fark2conf(fark, mc, Mc);

conf = max(conf(:,:,1), max(conf(:,:,2), conf(:,:,3)));

if dbg,
    figure(1);  imshow(conf);
    title('Confidence image');
end


