clc
clear
close all;
%% path
addpath(genpath('F:\Yilong DATA\code\DLLR'));
addpath(genpath('F:\Yilong DATA\ESPIRiT'));
addpath(genpath('F:\Yilong DATA\raw'));
imagesavepath = 'F:\Yilong DATA\Results Image\'; 
ranksavepath = 'F:\Yilong DATA\Results Res\';

load mask_all_randn1D360.mat;
mask_all = mask_all_randn1D;
load('ref_009_T2')
gre_kxkyzc=fft2c(ref);


%% load GreData
% DATA

for slice_n=17
            gre_kxkyzc=double(gre_kxkyzc);
            [sx,sy,Sn,Nc]=size(gre_kxkyzc);
            DATA = gre_kxkyzc(:,:,slice_n,:);
            DATA = squeeze(DATA);
            DATA = DATA/max(max(max(abs(ifft2c(DATA))))) + eps;
            
     for mask_n = 2  
         
            mask=mask_all(:,:,mask_n);
%           mask=squeeze(mask);
%           mask_i = (size(mask,1)-size(DATA,1))./2 ;
%           mask = imcrop(mask,[mask_i,mask_i,size(DATA,1)-1,size(DATA,1)-1]);
            DATAc = DATA.* repmat(mask,[1,1,Nc]);
          %% Calculate the up bound and lower bound
            lb=2;
            ub=288;
            %%
            RES_rank=zeros(1,ub);
            
            for rank_n =15:1:55
            [mid_area] = SAKE_RES_Calculator(rank_n,DATA,DATAc,slice_n,mask_n,imagesavepath);
            RES_rank(rank_n) = mid_area;
            end
            
         optimal_rank = find(RES_rank==min(RES_rank(find(RES_rank~=0))));      
         save([ranksavepath 'slice_' num2str(slice_n) '_mask_' num2str(mask_n) '_optimal rank_' num2str(optimal_rank) '.mat'],'RES_rank');
     
     end
 
end
