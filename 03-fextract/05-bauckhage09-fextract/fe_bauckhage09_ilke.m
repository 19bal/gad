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

%[BWcrop,ebp,wbp]=crop(BW);
i=1;
flag1=0;
while flag1==0;
    
    if sum(BW(i,:))~=0
        
        flag1=1;
        nbp=i;    % north bounding point
    
    end
    i=i+1;
end

flag1=0;

while flag1==0;
    
    if sum(BW(i,:)) == 0
        
        flag1=1;
        sbp=i;   % south bounding point
    
    end
    
    i=i+1;

end

flag1=0;
i=1;

while flag1==0;
    
    if sum(BW(:,i))~=0
        
        flag1=1;
        wbp=i;   %west bounding point
    end
    
    i=i+1;
    
    
end

flag1=0;

while flag1==0;
    
    if sum(BW(:,i))==0
        
        flag1=1;
        ebp=i;   %east bounding point
    
    end
    
    i=i+1;
    
    
end

BWcrop = imcrop(BW,[wbp nbp (ebp-wbp-1) (sbp-nbp-1)]);
i=1;
flag1=0;
size(1)=length(BWcrop);
size(2)=ebp-wbp;

col_w=round(size(2)/n)-1;   % column width
                             

for i=1:n
    
    if i ==(n)
        
        croped{i} =[(i+(i-1)*col_w)   1  (size(2)-( croped{i-1}(1)+ col_w )) size(1)];
        
    else
        
        croped{i} = [(i+(i-1)*col_w )  1  col_w+1  size(1) ]  ;
        
    end
    
end

%% Yatay eksenin noktalarının belirlenmesi


for i = 1:n
    
    flag2=0;
    cur_crop=croped{i};                  % current bounded image
    j=1;
    
    
    
    if i==n                              % Son sütünda hata oluşmaması için 
           
       flaglastcrop=cur_crop(3);     
       cur_crop(3)=size(2)-cur_crop(1);
        
    end
    
    
    
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
            cur_crop(4)=j-cur_crop(2);
            

            
            croped{i}=cur_crop;
            

            
        end
        j=j+1;
    
    end
    
    if i==n
            
        croped{i}(3)=flaglastcrop;
            
    end

end

c=0;  % counter

for k=1:n
    
    line_w = round( ( croped{k}(4)+1 ) /m )-1  ;  % her sütün için gereken satır aralığı
    
    for i=1:m
        
        c=c+1;
        
        if i == m
        
            lastcrop{c} =[croped{k}(1)  croped{k}(2)+line_w*(i-1)    croped{k}(3) ( croped{k}(4)+croped{k}(2) -   ( lastcrop{c-1}(2) + line_w ) )  ];
        
        else 
        
            lastcrop{c} = [croped{k}(1) (croped{k}(2)+line_w*(i-1))  croped{k}(3)  line_w ]  ;
        
        end
        
    end
    
end



    % Düşey eksenin noktalarının belirlenmesi

for i = 1:n*m
    
    flag2=0;
    cur_crop=lastcrop{i};                  % current bounded image
    j=cur_crop(1);
    counter3=1;   
    
    
%     if i==n                              % Son sütünda hata oluşmaması için 
%            
%        flaglastcrop=cur_crop(3);     
%        cur_crop(3)=size(2)-cur_crop(1);
%         
%     end
    

    
   while flag2==0  &&  j ~= ( cur_crop(1)+cur_crop(3) ) 

        
        
        if sum( BWcrop ( ( cur_crop (2):  cur_crop(2)+cur_crop (4)-1 ) , j ) )~=0
            
            
            flag2=1;
            cur_crop(1)=j;
            cur_crop(3)=cur_crop(3)-counter3+1;
            F{i}=cur_crop;
            j=j-1;

        end
        
        counter3=counter3+1;
        j=j+1;
    
   end

   
    if j~=( cur_crop(1)+cur_crop(3) )
    
        j=cur_crop(1)+cur_crop(3)-1;
    
        flag2=0;
   
        counter2=1;
    
   
        while flag2==0 &&  j ~= cur_crop(1)+1 && j ~=0
        
        
            if sum( BWcrop ( ( cur_crop (2) :  cur_crop(2)+cur_crop (4)-1 ) , j ) )==0
            
            flag2=1;
            cur_crop(3)=cur_crop(3)-counter2;
            F{i}=cur_crop;
            
        
            end
        
        j=j-1;
        counter2=counter2+1;
    
    
        end
    
%     if i==n
%             
%         croped{i}(3)=flaglastcrop;
%             
%     end
    
    end
    
end