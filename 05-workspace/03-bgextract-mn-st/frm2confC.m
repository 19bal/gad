function conf = frm2confC(frm, bg, mc, Mc, dbg);
% function conf = frm2confC(frm, bg, mc, Mc, dbg);
% 
% video daki frame den conf matrisini/resmini uret

% struct2matrix
bg_mn(:,:,1) = bg.R.M;
bg_mn(:,:,2) = bg.G.M;
bg_mn(:,:,3) = bg.B.M;

fark = abs(double(frm) - double(bg_mn));    

if false,
    % struct2matrix
    bg_dev(:,:,1) = bg.R.D;
    bg_dev(:,:,2) = bg.G.D;
    bg_dev(:,:,3) = bg.B.D;
    
    bw = (fark < bg_dev);
    figure(99), imshow(uint8(255*bw))
    conf=1;
    return
end

% jabri'den confidence
conf = fark2conf(fark, mc, Mc);

conf = max(conf(:,:,1), max(conf(:,:,2), conf(:,:,3)));

if dbg,
    figure(1);  imshow(conf);
    title('Confidence image');
end


