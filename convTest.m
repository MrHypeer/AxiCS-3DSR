%%% test convolution using 2D and 3D psf

clear all; close all
addpath('.\utili\')
dataPath = '.\data\';
%% load image stack and psf
imgName = 'PollenStack.tif';
psfName = 'pollenPSF.tif';
img = readMultiTiff([dataPath, imgName], 0);
psf = readMultiTiff([dataPath, psfName], 0);
% crop psf and stack layer into 20 layers
img = img(:,:,50:69);
psf = psf(:,:,22:41);
stack_layer = zeros(size(img));
stack_3d = stack_layer;
%% obtain 3d stack using layerwise convolution
for ii = 1: size(img,3)
    for jj = 1:size(psf,3)
        stack_layer(:,:,ii) = stack_layer(:,:,ii) + conv2(img(:,:,jj),psf(:,:,11),'same');
    end
end
%% obtain 3d stack using 3d convolution
stack_3d = convn(img, psf, 'same');

%%
aaa = sum(stack_layer,3);
bbb = sum(stack_3d,3);
original = sum(img,3);
%% show rec result and compare
f1 = figure('Name', 'Sum, origianl');
movegui(f1, 'west');
figure(f1)
subplot(121)
imagesc(sum(img,3))
title('original')
subplot(122)
imagesc(transpose(squeeze(psf(32,:,:))))
title('psf')

f2 = figure('Name', 'Sum, two method');
movegui(f2, 'east');
figure(f2)
subplot(121)
imagesc(aaa)
title('layer-wise, middle psf')
subplot(122)
imagesc(bbb)
title('3d')


