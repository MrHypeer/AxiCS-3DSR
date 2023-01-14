%deconUsingRL   deconvolution using MATLAB built-in function

%% params: image name, CR
clear all; close all
addpath('.\utili\')
dataPath = '.\data\';
imgName = 'beads_sparse01.tif';
psfName = 'beadPSF.tif';
CR = [4, 4, 4];

%% load image stack and psf, subsample data data
img = readMultiTiff([dataPath, imgName], 0);
psf = readMultiTiff([dataPath, psfName], 0);
img_conv = otf2psf(psf2otf(img,size(img)).*psf2otf(psf,size(img)));

img_CR = img_conv(1:CR(1):end,1:CR(2):end,1:CR(3):end);


%% upsampling and deconvolution
% img_upsamp = zeros(size(img_CR).*CR);
% [x_pxl_CR, y_pxl_CR, z_pxl_CR] = size(img_CR);
[x_pxl_ups, y_pxl_ups, z_pxl_ups] = size(img);
[Y_CR, X_CR, Z_CR] = meshgrid(CR(2):CR(2):y_pxl_ups, ...
    CR(1):CR(1):x_pxl_ups, CR(3):CR(3):z_pxl_ups);
[Y_ups, X_ups, Z_ups] = meshgrid(1:y_pxl_ups, ...
    1:x_pxl_ups, 1:z_pxl_ups);
img_upsamp = interpn(X_CR, Y_CR, Z_CR, img_CR,X_ups, Y_ups, Z_ups,...
    'cubic',0);
img_deconv = deconvlucy(img_upsamp,psf,10); 

%% display result
f1 = figure('Name','original image display');
figure(f1)
subplot(131)
imagesc(img(:,:,50)); title('ori img')
subplot(132)
imagesc(img_conv(:,:,50)); title('conv img')
subplot(133)
imagesc(img_CR(:,:,25)); title('sub-samp conv img')
sgtitle('iamge display of original img')

figure(2)
idx = randi(112);
subplot(131)
imagesc(squeeze(img(:,:,idx))); title('ori')
subplot(132)
imagesc(squeeze(img_conv(:,:,idx))); title('con')
subplot(133)
imagesc(squeeze(img_deconv(:,:,idx))); title('de-conv')
sgtitle([num2str(idx), ' layer'])



