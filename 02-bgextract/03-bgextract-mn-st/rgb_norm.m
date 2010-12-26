img = imread('008a013s00L_0078o.png');

P = rgb2gray(img);

xyz = img;
X = xyz(:,:,1); Y = xyz(:,:,2); Z = xyz(:,:,3);


figure(1);

subplot(221),   imshow(img);
subplot(222),   imshow(abs(X-Y));    title('X-Y');
subplot(223),   imshow(abs(Y-Z));    title('Y-Z');
subplot(224),   imshow(abs(Z-X));    title('Z-X');

figure(2);

subplot(221),   imshow(img);
subplot(222),   imshow(abs(X-P));    title('X-P');
subplot(223),   imshow(abs(Y-P));    title('Y-P');
subplot(224),   imshow(abs(Z-P));    title('Z-P');
