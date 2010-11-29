function BB = fe_bauckhage09(bw, nr, nc, dbg, dbg_deep)
% function BB = fe_bauckhage09(bw, nr, nc, dbg, dbg_deep)

% % Asama 1:
% b = bobox(bw);
% bw = imcrop(bw, b);

% Asama 2:
[H, W] = size(bw);
[sz, xk] = linsz(W, nc, 1);

for c=1:nc
    BB1(c, :) = [xk(c), 1, sz(c), H];
end

% Asama 3:
for c=1:nc
    sbw = imcrop(bw, BB1(c, :));
    
    [yy, tx, tt] = find(sbw == 1);
    mnY = min(yy(:));   mxY = max(yy(:));
    
    BB1(c, :) = [BB1(c, 1), mnY, BB1(c, 3), (mxY - mnY + 1)];
    
    if dbg_deep
        figure(13),
        imshow(bw);     title('orj');
        hold on
        rectangle('Position', BB1(c,:),'EdgeColor', 'g', 'LineWidth', 1);
        hold off        
        pause
    end
end

if dbg
    figure(13)
    imshow(bw)
    hold on
    for c=1:nc
        rectangle('Position', BB1(c,:),'EdgeColor', 'g', 'LineWidth', 1);
    end    
    hold off
end

% Asama 4
for c=1:nc
    [sz, yk] = linsz(BB1(c, 4), nr, BB1(c, 2));
    
    for r=1:nr
        BB(r, c, :) = [BB1(c, 1), ...
                       yk(r), ...
                       BB1(c, 3), ...
                       sz(r)];
        
        if dbg_deep
            figure(14),
            imshow(bw)
            hold on
            rectangle('Position', BB(r,c,:),'EdgeColor', 'g', 'LineWidth', 1);
            hold off
            pause
        end
    end
end

if dbg
    figure(14)
    
    imshow(bw)
    hold on
    for c=1:nc
        for r=1:nr
            rectangle('Position', BB(r,c,:),'EdgeColor', 'g', 'LineWidth', 1);
        end
    end    
    hold off
end

% Asama 5:
for c=1:nc
    for r=1:nr
        sbw = imcrop(bw, BB(r, c, :));
        b = bobox(sbw);
        
        BB(r, c, :) = [BB(r, c, 1) + b(1), ...
                       BB(r, c, 2) + b(2), ...
                                     b(3), ...
                                     b(4)];
                                 
        if dbg_deep
            figure(15),
            imshow(bw);     title('orj');
            hold on
            rectangle('Position', BB(r,c,:),'EdgeColor', 'g', 'LineWidth', 1);            
            pause
        end                                 
    end
end

if dbg
    figure(15)
    
    imshow(bw)
    hold on
    for c=1:nc
        for r=1:nr
            rectangle('Position', BB(r,c,:),'EdgeColor', 'g', 'LineWidth', 1);
        end
    end    
    hold off
end