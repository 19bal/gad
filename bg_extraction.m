clear all
mov=aviread('output.avi');


f(:,:,:,1)=frame2im(mov(1));




for i=1:150
    
    flag1(:,:,:,i)=frame2im(mov(i));

    frames(:,:,:,i) = imcrop(flag1(:,:,:,i), [38 73 252 157]);


    
    flag1(:,:,:,i)=frame2im(mov(i));

    frames(:,:,:,i) = imcrop(flag1(:,:,:,i), [38 73 252 157]);



  
    
        

        
        p1(:,:,i)=frames(:,:,1,i);    % kırmızı 
        
        
        p2(:,:,i)=frames(:,:,2,i);    %yeşil
   
         
        p3(:,:,i)=frames(:,:,3,i);    %mavi
         
    
        rmask1(:,:,i)=(p1(:,:,i)>30);    %kırmızı maske 1 
        
        rmask2(:,:,i)=(p1(:,:,i)<94);    
        
      
        rmask(:,:,i)=rmask2(:,:,i).*rmask1(:,:,i);
        
        gmask(:,:,i)=(p2(:,:,i)>115);
        
       
        
      
        
        bmask(:,:,i)=(p3(:,:,i)>69);
        
        
        
       
         
        mask(:,:,i)=bmask(:,:,i).*rmask(:,:,i).*gmask(:,:,i);
        mask(:,:,i) = medfilt2(mask(:,:,i),[4 4]);
      
        mask(:,:,i) = imfill(mask(:,:,i),'holes');
        
    end
    
    