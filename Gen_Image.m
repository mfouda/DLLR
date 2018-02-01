clc;clear
codepath = 'E:\Yilong DATA\code\DLLR';
toolpath = 'E:\Yilong DATA\ESPIRiT';
addpath(genpath(codepath)); addpath(genpath(toolpath));
kx=128;
ky=kx;
slice_n=16;
%% mask image
I_all=zeros(kx*4,ky*6);
load('mask_all_2d.mat');mask_all_2d=permute(mask_all_2d,[2 3 1]);
I_all(:,1:ky)=reshape(mask_all_2d,[kx*4 ky]); % mask colum
%% groud truth image
load('E:\Yilong DATA\raw\2016_Nov_brain\GreData.mat')
DATA = gre_kxkyzc(:,:,slice_n,:);
DATA = squeeze(DATA);
DATA = DATA/max(max(max(abs(ifft2c(DATA))))) + eps;
slice_I=sos(ifft2c(DATA));
I_all(:,ky+1:2*ky)=repmat(slice_I,[4 1]);
%% fixed rank number image and error map

imshow(I_all);
