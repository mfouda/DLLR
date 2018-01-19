clc
clear
close all;
addpath(genpath('E:\Yilong DATA\code\DLLR'));
addpath(genpath('E:\Yilong DATA\ESPIRiT'));
addpath(genpath('E:\Yilong DATA\raw\2016_Nov_brain'));

load mask_all
load GreData
[sx,sy,Sn,Nc]=size(gre_kxkyzc);
ncalib = 48;
ksize = [6,6]; % ESPIRiT kernel-window-size
calibc_batch_input=zeros(20,4,400,841); %[slicenumber masknumber pixel  batchnumber]
tic
for slice_n=1:1:20
            gre_kxkyzc=double(gre_kxkyzc);
            [sx,sy,Sn,Nc]=size(gre_kxkyzc);
            DATA = gre_kxkyzc(:,:,slice_n,:);
            DATA = squeeze(DATA);
            DATA = DATA/max(max(max(abs(ifft2c(DATA))))) + eps;
            
     for mask_n =1:1:4   
            mask=mask_all(:,:,mask_n);
            mask=squeeze(mask);
            mask_i = (size(mask,1)-size(DATA,1))./2 ;
            mask = imcrop(mask,[mask_i,mask_i,size(DATA,1)-1,size(DATA,1)-1]);
            DATAc = DATA.* repmat(mask,[1,1,Nc]);
            calibc = crop(DATAc,[ncalib,ncalib,Nc]);
          %% DATA augmentation add 
           batch_size = 20;
           calibc_batch = Data_Augmentation(calibc, batch_size);
           % calibc_batch_input(slice_n,mask_n,:,:) = reshape(calibc_batch,[12800 841]);
           k_all= sos(calibc_batch,3);
           calibc_batch_input(slice_n,mask_n,:,:) = reshape( k_all,[400 841]);
       
     end
      slice_n
end
toc

calibc_batch_input = permute(calibc_batch_input,[2 1 4 3]); % 4 20 841 12800
size(calibc_batch_input)
input_matrix = reshape(calibc_batch_input,[67280 400]);
save('E:\Yilong DATA\code\DLLR\DATA\input_matrix','input_matrix');
%%
% input_real = real(input_matrx);
% save('F:\code\DLLR\DATA\input_matrx_real.mat','input_real','-v7.3');
% input_imag = imag(input_matrx);
% save('F:\code\DLLR\DATA\input_matrx_imag.mat','input_imag','-v7.3');
 % 
%input_imag=reshape(input_matrx,[80 lkcc]);
%% 
% k=input_matrx(9,:);
% k=reshape(k,[48,48,32]);
% I=sos(ifft2c(k));
% imshow(I)
% %%
% 
% input_matrx_r=permute(input_matrx_r,[2 1 3]);
% input_matrx_i=permute(input_matrx_i,[2 1 3]);
% input_imag=reshape(input_matrx,[80 lkcc]);
% save('F:\code\DLLR\DATA\input_imag.mat','input_imag')
