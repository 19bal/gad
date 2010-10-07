clear all

mov=aviread('output.avi');   % output.avi dosyasindan video görüntüsü alınır ve framelere bölünür.

for i=1:150
    
    flag1(:,:,:,i)=frame2im(mov(i));  % frameler image olarak düzenlenir.

    frames(:,:,:,i) = imcrop(flag1(:,:,:,i), [38 73 252 157]);  % Gerekli olan yerler kalacak sekilde resimler kirpilir.
    
    flag1(:,:,:,i)=frame2im(mov(i));

    frames(:,:,:,i) = imcrop(flag1(:,:,:,i), [38 73 252 157]);

    p1(:,:,i)=frames(:,:,1,i);    % kirmizi 
        
    p2(:,:,i)=frames(:,:,2,i);    %yesil
   
    p3(:,:,i)=frames(:,:,3,i);    %mavi
       
    %%%MASKELEME İSLEMİ %%%%  
    
    rmask1(:,:,i)=(p1(:,:,i)>30);    %kirmizi maske 1 
        
    rmask2(:,:,i)=(p1(:,:,i)<94);    
        
    rmask(:,:,i)=rmask2(:,:,i).*rmask1(:,:,i);
        
    gmask(:,:,i)=(p2(:,:,i)>115);
        
    bmask(:,:,i)=(p3(:,:,i)>69);
        
    mask(:,:,i)=bmask(:,:,i).*rmask(:,:,i).*gmask(:,:,i);
        
    %%%%%%

    mask(:,:,i) = medfilt2(mask(:,:,i),[4 4]);  %Maske 4x4'lük median filtreden gecirilir.
      
    mask(:,:,i) = imfill(mask(:,:,i),'holes');  %Bosluk doldurma islemi yapilir
        
    end
    
    