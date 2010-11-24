%function F = fe_bauckage09( I , m, n )
clear all
I=imread('R1.jpg');
%% Initial values
flag1=0; n=6; m=8;
i=1;
%% Image filtering and Aranging 
G=rgb2gray(I);
level=graythresh(G);
BW = im2bw(G,level);
BW=BW<1; %inverse BW
size=size(BW);
%% Cropping Image to the First Bounding Box

[BWcrop,ebp,wbp]=crop(BW);

size(1)=length(BWcrop);
size(2)=ebp-wbp;

col_w=round(size(2)/n)-1;   % column width
line_w=round(size(1)/m)-1;  %line width

for i=1:n
    
    if i ==(n)
        
        croped{i} =[(i+(i-1)*col_w)   1  (size(2)-(i+(i-1)*col_w)+1) size(1)];
        
    else
        
        croped{i} = [(i+(i-1)*col_w )  1  col_w+1  size(1) ]  ;
        
    end
end


for i = 1:n
    
    flag2=0;
    cur_crop=croped{i};                  % current bounded image
    j=1;
    
    %% Son sütünda hata oluşmaması için yazılır bura
    
    if i==n
           
       flaglastcrop=cur_crop(3);     
       cur_crop(3)=size(2)-cur_crop(1);
        
    end
    
    %% Yatay eksenin noktalarının belirlenmesi
    
   while flag2==0   
    

        
        if sum(BWcrop(j,(cur_crop(1): i*cur_crop(3) ) ) )~=0
            
            
            flag2=1;
            cur_crop(2)=j;
            

        
            croped{i}=cur_crop;

        end
        
        j=j+1;
    
    end
    
    flag2=0;
    
    while flag2==0 && j<cur_crop(4)+1
        
        if sum(BWcrop( j,(cur_crop(1):i*cur_crop(3) ) ) ) ==0
            
            flag2=1;
            cur_crop(4)=j-cur_crop(2)-1;
            

            
            croped{i}=cur_crop;
            

            
        end
        j=j+1;
    
    end
    
    if i==n
            
        croped{i}(3)=flaglastcrop;
            
    end

end

for i=1:m
    
    if i ==(m)
        
        son2=imcrop(BWcrop, [1 (i+(i-1)*line_w)   size(2)  (size(1)-(i+(i-1)*line_w)+1) ]);
        
    else
        
        croped2(:,:,i)=imcrop(BWcrop, [ 1 (i+(i-1)*line_w )  size(2)  line_w   ] ) ;
        
    end
end