function conf = frm2confE(frm, bg, me, Me, dbg);
% conf = frm2confE(frm, bg, me, Me, dbg);
% 
% video daki frame'in on/arka-plan olarak bw halini uret

% struct2matrix
bg_H_mn(:,:,1) = bg.R.H.M;    bg_V_mn(:,:,1) = bg.R.V.M;
bg_H_mn(:,:,2) = bg.G.H.M;    bg_V_mn(:,:,2) = bg.G.V.M;
bg_H_mn(:,:,3) = bg.B.H.M;    bg_V_mn(:,:,3) = bg.B.V.M;

for i=1:3,
    [Ht(:,:,i), Vt(:,:,i)] = myedge(frm(:,:,i));
end

deltaH = abs(double(Ht) - double(bg_H_mn));
deltaV = abs(double(Vt) - double(bg_V_mn));

deltaG = deltaH + deltaV;

  G = abs(bg_H_mn) + abs(bg_V_mn);
 Gt = double(abs(Ht) + abs(Vt));
Gty = max(G, Gt);                   Gty(Gty == 0) = 0.1;

mx = max(max(G(:)), max(Gty(:)));

%RdeltaG = compute_RdeltaG(deltaG, mx);

if dbg
    figure(88);
    % subplot(221);   imagesc(deltaG); title('deltaG');
    subplot(222);   imagesc(G/mx);      title('G');
    subplot(223);   imagesc(Gt/mx);     title('Gt');
    % subplot(224);   imagesc(RdeltaG);    title('RdeltaG');
end

if dbg,
    figure(99);
    subplot(221);   imshow(deltaH);    
    subplot(223);   imshow(deltaV);    
end

% jabri'den confidence
confH = fark2conf(deltaH, me, Me);
confV = fark2conf(deltaV, me, Me);

confH = max(confH(:,:,1), max(confH(:,:,2), confH(:,:,3)));
confV = max(confV(:,:,1), max(confV(:,:,2), confV(:,:,3)));
conf  = max(confH, confV);

if dbg,
    figure(1);  
    subplot(221);   imshow(confH);
    subplot(222);   imshow(confV);
    subplot(223);   imshow(conf);
    title('Confidence image');
end




%bwH = (farkH < bg_H_dev);           bwV = (farkV < bg_V_dev);
%figure(99), 
%subplot(211);  imshow(uint8(255*bwH))
%subplot(212);  imshow(uint8(255*bwV))

% % % % frm = double(frm);
% % % % confR = frm2conf(frm(:,:,1), bg_H_mn(:,:,1), bg_V_mn(:,:,1), bg_H_dev(:,:,1), bg_V_dev(:,:,1), me, Me);
% % % % confG = frm2conf(frm(:,:,2), bg_H_mn(:,:,2), bg_V_mn(:,:,2), bg_H_dev(:,:,2), bg_V_dev(:,:,2), me, Me);
% % % % confB = frm2conf(frm(:,:,3), bg_H_mn(:,:,3), bg_V_mn(:,:,3), bg_H_dev(:,:,3), bg_V_dev(:,:,3), me, Me);
% % % % 
% % % % conf = max(confR, max(confG, confB));
% % % % 
% % % % if ~dbg,    
% % % %     figure(1);  imshow(conf); %uint8( double(conf)*(255/max(double(conf(:)))) ));
% % % %     title('Edge Confidence image');
% % % %     drawnow
% % % % end
% % % % 
% % % % function conf = frm2conf(X, bg_H_mn, bg_V_mn, bg_H_dev, bg_V_dev, me, Me);
% % % % dbg = true;
% % % % M = fspecial('sobel');
% % % % 
% % % % H = imfilter(X, M, 'replicate'); %edge(X, 'sobel', [], 'horizontal');
% % % % V = imfilter(X, M', 'replicate'); %edge(X, 'sobel', [], 'vertical');
% % % % 
% % % % if dbg
% % % %     whos bg_H_mn
% % % %     figure(88); 
% % % %     subplot(221),   imshow(uint8(H))
% % % %     subplot(222),   imshow(uint8(V))
% % % %     subplot(223),   imshow(uint8(bg_H_mn))
% % % %     subplot(224),   imshow(uint8(bg_V_mn))
% % % % end
% % % % farkH = abs(double(H) - double(bg_H_mn));    
% % % % farkV = abs(double(V) - double(bg_V_mn));    
% % % % deltaG = farkH + farkV;
% % % % 
% % % % G = abs(H) + abs(V);
% % % % Gt= abs(bg_H_mn) + abs(bg_V_mn);
% % % % Gty = max(G, Gt);
% % % % 
% % % % % RdeltaG = deltaG * deltaG ./ Gty;
% % % % RdeltaG = deltaG .^2 / Gty;
% % % % 
% % % % % jabri'den confidence
% % % % conf = (RdeltaG - me) / (Me - me) * 100;    
% % % % conf(RdeltaG < me) = 0;
% % % % conf(RdeltaG > Me) = 100;
% % % % conf = uint8(conf * (255/100));
% % % % 
