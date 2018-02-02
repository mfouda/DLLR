clc;clear
codepath = 'E:\Yilong DATA\code\DLLR';
toolpath = 'E:\Yilong DATA\ESPIRiT';
imagesavepath = 'E:\Yilong DATA\GenImage\';
addpath(genpath(codepath)); addpath(genpath(toolpath));
kx=128;
ky=kx;
slice_n=16;
%% mask image
I_all=zeros(kx*4,ky*6);
load('mask_all_2d.mat');I_mask=permute(mask_all_2d,[2 3 1]);
I_all(:,1:ky)=reshape(I_mask,[kx*4 ky]); % mask colum
%% groud truth image
load('E:\Yilong DATA\raw\2016_Nov_brain\GreData.mat')
DATA = gre_kxkyzc(:,:,slice_n,:);
DATA = squeeze(DATA);
DATA = DATA/max(max(max(abs(ifft2c(DATA))))) + eps;
DATA=double(DATA);
slice_I=sos(ifft2c(DATA));
%slice_I = permute(slice_I,[2 1]);
I_all(:,ky+1:2*ky)=repmat(slice_I,[4 1]);
% %% fixed rank number image and error map
%     %% calculate SAKE image 
%      for mask_n =1:1:4   
%                 mask=mask_all_2d(:,:,mask_n);
%                 mask=squeeze(mask);
%     %             mask_i = (size(mask,1)-size(DATA,1))./2 ;
%     %             mask = imcrop(mask,[mask_i,mask_i,size(DATA,1)-1,size(DATA,1)-1]);
%                 DATAc = DATA.* repmat(mask,[1,1,32]);
%                 Res_64 = SAKE_RES_Calculator(64,DATA,DATAc,slice_n,mask_n,imagesavepath);
%      end

    %% shouw SAKE iamge
    addpath(genpath(imagesavepath));
    for i=1:1:4
        load(['slice_' num2str(slice_n) '_mask_' num2str(i)]);
        I_all((i-1)*kx+1:1:i*kx,2*ky+1:1:4*ky)=I;   
    end
%     
%  %% adptive setting rank image and error map
%  for i =1:1:4
%     load('');
%     I_all()
%  end
%  

%% Iamge show
    imshow(I_all);
 
