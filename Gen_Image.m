clc;clear
% codepath = 'E:\Yilong DATA\code\DLLR';
% toolpath = 'E:\Yilong DATA\ESPIRiT';
% imagesavepath = 'E:\Yilong DATA\GenImage\';
codepath = 'F:\code\DLLR';
toolpath = 'F:\code\ESPIRiT';
imagesavepath = 'F:\Yilong DATA\1Drandn mask 2016_Nov_brain T2\GenImage\';

addpath(genpath(codepath)); addpath(genpath(toolpath));
kx=360;
ky=kx;
slice_n=18;
%% image initilize
I_all=zeros(kx*4,ky*6);
load('mask_all_randn1D360.mat'); mask_all=mask_all_randn1D; I_mask=permute(mask_all,[2 3 1]);
I_all(:,1:ky)=reshape(I_mask,[kx*4 ky]); % mask colum

  for slice_n=12
 %% groud truth image
load('F:\Yilong DATA\raw\ref_009_T2.mat')
gre_kxkyzc=fft2c(ref);
DATA = gre_kxkyzc(:,:,slice_n,:);
DATA = squeeze(DATA);
DATA = DATA/max(max(max(abs(ifft2c(DATA))))) + eps;
DATA=double(DATA);  
slice_I=sos(ifft2c(DATA));
%slice_I = permute(slice_I,[2 1]);
I_all(:,ky+1:2*ky)=repmat(slice_I,[4 1]);
% fixed rank number image and error map
    %% calculate SAKE image     
%      for mask_n = 1:1:4
%                 mask=mask_all(:,:,mask_n);
%                 mask=squeeze(mask);
%     %             mask_i = (size(mask,1)-size(DATA,1))./2 ;
%     %             mask = imcrop(mask,[mask_i,mask_i,size(DATA,1)-1,size(DATA,1)-1]);
%                 DATAc = DATA.* repmat(mask,[1,1,32]);
%                 Res_64 = SAKE_RES_Calculator(64,DATA,DATAc,slice_n,mask_n,imagesavepath);
%      end
     
         %% shouw SAKE iamge
    addpath(genpath(imagesavepath));
    for i=1:1:4
        load(['slice_' num2str(slice_n) '_mask_' num2str(i) '_rank_64']);
%         I_A=I(:,1:size(I,1));I_B=I(:,size(I,1)+1:end);
%           I_A=permute(I_A,[2 1]);I_B=permute(I_B,[2 1]);
%           I=[I_A I_B];
          I_all((i-1)*kx+1:1:i*kx,2*ky+1:1:4*ky)=I;   
    end
    
 %% adptive setting rank image and error map
    addpath(genpath(imagesavepath));
    for i=1:1:4
        load(['slice_' num2str(slice_n) '_mask_' num2str(i) '_opt']);
%           I_A=I(:,1:size(I,1));I_B=I(:,size(I,1)+1:end);
%           I_A=permute(I_A,[2 1]);I_B=permute(I_B,[2 1]);
%           I=[I_A I_B];
        I_all((i-1)*kx+1:1:i*kx,4*ky+1:1:6*ky)=I;   
    end
% 

%% Iamge show
figure; imshow(I_all);
    end


 
