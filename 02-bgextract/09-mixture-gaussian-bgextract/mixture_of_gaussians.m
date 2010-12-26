% This m-file implements the mixture of Gaussians algorithm for background
% subtraction.  It may be used free of charge for any purpose (commercial
% or otherwise), as long as the author (Seth Benton) is acknowledged.

clear all;  close all;  clc;

%%%%%%%%%%%%%%%% D O   N O T   E D I T   M E %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LIB_PATH = sprintf('..%slib%s', filesep,filesep);                         %
addpath(LIB_PATH,'-end');                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dbnm = pathos(strcat(DB_ROOT(LIB_PATH), 'gait/surveillance/'));
% dbnm = pathos('_db/');
DIR = dir(strcat(dbnm, '*.png'));
dbg = true;

% -----------------------  frame size variables -----------------------
imgnm = DIR(1).name;    
fr = imread(strcat(dbnm, imgnm));   % read in 1st frame as background frame
fr_bw = rgb2gray(fr);               % convert background to greyscale
fr_size = size(fr);             
width = fr_size(2);
height = fr_size(1);
fg = zeros(height, width);
bg_bw = zeros(height, width);

% --------------------- mog variables -----------------------------------
C = 3;                                  % number of gaussian components (typically 3-5)
M = 1;                                  % number of background components
D = 2.5;                                % positive deviation threshold
alpha = 0.01;                           % learning rate (between 0 and 1) (from paper 0.01)
thresh = 0.25;                          % foreground threshold (0.25 or 0.75 in paper)
sd_init = 6;                            % initial standard deviation (for new components) var = 36 in paper
w = zeros(height,width,C);              % initialize weights array
mean = zeros(height,width,C);           % pixel means
sd = zeros(height,width,C);             % pixel standard deviations
u_diff = zeros(height,width,C);         % difference of each pixel from mean
p = alpha/(1/C);                        % initial p variable (used to update mean and sd)
rank = zeros(1,C);                      % rank of components (w/sd)


% --------------------- initialize component means and weights -----------
pixel_depth = 8;                        % 8-bit resolution
pixel_range = 2^pixel_depth -1;         % pixel range (# of possible values)

mn = rand([height width C]) * pixel_range;  % means random (0-255)
w  = ones([height width C]) * (1/C);        % weights uniformly dist
sd = ones([height width C]) * sd_init;      % initialize to sd_init 

%--------------------- process frames -----------------------------------
for n = 2:length(DIR)
    imgnm = DIR(n).name;    
    fr = imread(strcat(dbnm, imgnm));
    fr_bw = rgb2gray(fr);               % convert frame to grayscale
    
    % calculate difference of pixel values from mean
    for i=1:C
        fr_bwC(:,:,i) = fr_bw;
    end
    u_diff = abs(double(fr_bwC) - double(mn));
    
    % update gaussian components for each pixel
    for i=1:height
        for j=1:width
            
            match = 0;
            for k=1:C                       
                if (abs(u_diff(i,j,k)) <= D*sd(i,j,k))       % pixel matches component
                    
                    match = 1;                          % variable to signal component match
                    
                    % update weights, mean, sd, p
                    w(i,j,k) = (1-alpha)*w(i,j,k) + alpha;
                    p = alpha/w(i,j,k);                  
                    mn(i,j,k) = (1-p)*mn(i,j,k) + p*double(fr_bw(i,j));
                    sd(i,j,k) =   sqrt((1-p)*(sd(i,j,k)^2) + p*((double(fr_bw(i,j)) - mn(i,j,k)))^2);
                else                                    % pixel doesn't match component
                    w(i,j,k) = (1-alpha)*w(i,j,k);      % weight slighly decreases
                    
                end
            end
            
            w(i,j,:) = w(i,j,:)./sum(w(i,j,:));
            
            bg_bw(i,j)=0;
            for k=1:C
                bg_bw(i,j) = bg_bw(i,j)+ mn(i,j,k)*w(i,j,k);
            end
            
            % if no components match, create new component
            if (match == 0)
                [min_w, min_w_index] = min(w(i,j,:));  
                mn(i,j,min_w_index) = double(fr_bw(i,j));
                sd(i,j,min_w_index) = sd_init;
            end

            rank = w(i,j,:)./sd(i,j,:);             % calculate component rank
            rank_ind = [1:1:C];
            
            % sort rank values
            for k=2:C               
                for m=1:(k-1)
                    
                    if (rank(:,:,k) > rank(:,:,m))                     
                        % swap max values
                        rank_temp = rank(:,:,m);  
                        rank(:,:,m) = rank(:,:,k);
                        rank(:,:,k) = rank_temp;
                        
                        % swap max index values
                        rank_ind_temp = rank_ind(m);  
                        rank_ind(m) = rank_ind(k);
                        rank_ind(k) = rank_ind_temp;    

                    end
                end
            end
            
            % calculate foreground
            match = 0;
            k=1;
            
            fg(i,j) = 0;
            while ((match == 0)&&(k<=M))

                if (w(i,j,rank_ind(k)) >= thresh)
                    if (abs(u_diff(i,j,rank_ind(k))) <= D*sd(i,j,rank_ind(k)))
                        fg(i,j) = 0;
                        match = 1;
                    else
                        fg(i,j) = fr_bw(i,j);     
                    end
                end
                k = k+1;
            end
        end
    end
    
    figure(1),
    subplot(311),   imshow(fr),             title('Frame');
    subplot(312),   imshow(uint8(bg_bw)),   title('bg\_bw');
    subplot(313),   imshow(uint8(fg)),      title('fg');    
    drawnow
end

 