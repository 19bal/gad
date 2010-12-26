function [mn, st, N] = artimsal(mn, st, N, bw, fr, dbg)
% function [mn, st, N] = artimsal(mn, st, N, bw, fr, dbg)

[H, W, C] = size(fr);

tic
for x=1:W
    for y=1:H
        for c=1:C
            if bw(y,x,c)
                m = double(mn(y,x,c));
                s = double(st(y,x,c));
                n = N(y,x,c);
                g = double(fr(y,x,c));
                
                
                m = (m * n + g) / (n + 1);
                
                Sx = m * n;
                SSx = (n-1) * s^2 + Sx^2 / n;
                
                Sx = Sx + g;
                SSx = SSx + g^2;
                
                s = sqrt( ((n+1) * SSx - Sx) / ((n+1)*n));
                n = n + 1;
                
                mn(y,x,c) = m;
                st(y,x,c) = s;                
                N(y,x,c) = n;
            end
        end
    end
end
toc