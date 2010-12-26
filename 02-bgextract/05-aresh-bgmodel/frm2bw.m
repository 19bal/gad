% sadece KARE FARK
% http://areshmatlab.blogspot.com/2010/05/low-complexity-background-subtrac
% tion.html

clear all;close all;clc;
dbnm = '../../db/surveillance/';
DIR = dir(strcat(dbnm, '*.png'));

sz = length(DIR);

thresh = 40;

imgnm = DIR(1).name; % read in 1st frame as background frame
bg = imread(strcat(dbnm, imgnm)); 
bg_bw = rgb2gray(bg); % convert background to greyscale

% ----------------------- set frame size variables -----------------------
fr_size = size(bg);
width = fr_size(2);
height = fr_size(1);
fg = zeros(height, width);

alfa = 0.6;

% --------------------- process frames -----------------------------------
for f=[2:140 155:250]%sz
    imgnm = DIR(f).name;
    fr = imread(strcat(dbnm, imgnm)); 

    fr_bw = rgb2gray(fr); % convert frame to grayscale
    fr_diff = abs(double(fr_bw) - double(bg_bw));

    for j=1:width
        for k=1:height
            if ((fr_diff(k,j) > thresh))
                fg(k,j) = fr_bw(k,j);
            else
                fg(k,j) = 0;
            end
        end
    end
    
    bg_bw = uint8(alfa * double(bg_bw) + (1 - alfa) * double(fr_bw));
    
    figure(1),
    subplot(3,1,1),     imshow(uint8(fr))
    subplot(3,1,2),     imagesc(uint8(fr_bw)); axis image
    subplot(3,1,3),     imshow(uint8(fg))
end