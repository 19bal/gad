function bgp = aday_bgp(fr, bw, bgp, dbg);

[H, W, C] = size(fr);

%
% % % % tic
% % % % ind = find(bw);
% % % % [yy,xx,cc] = ind2sub(size(bw), ind);
% % % % 
% % % % for i=1:length(yy)
% % % %     bgp{yy(i), xx(i), cc(i), :} = [bgp{yy(i), xx(i), cc(i), :} fr(yy(i), xx(i), cc(i))];
% % % % end
% % % % toc

tic
for x=1:W
    for y=1:H
        for c=1:C
            if bw(y,x,c)
                bgp{y,x,c,:} = [bgp{y,x,c,:} fr(y,x,c)];
            end
        end
    end
end
toc