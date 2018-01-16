clc
clear
close all;
addpath(genpath('F:\code\DLLR'));
addpath(genpath('F:\Yilong DATA\ESPIRiT'));
addpath(genpath('F:\Yilong DATA\raw\2016_Nov_brain'));
imagesavepath = 'F:\Yilong DATA\Results Image\'; 
ranksavepath = 'F:\Yilong DATA\Results Res\';

load mask_all
load GreData
[sx,sy,Sn,Nc]=size(gre_kxkyzc);
ncalib = 48;
ksize = [6,6]; % ESPIRiT kernel-window-size
lkcc=ncalib^2*Nc;
input_matrx=zeros(Sn,4,lkcc);
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
            calibc=reshape(calibc,[lkcc,1]);
            input_matrx(slice_n,mask_n,:)=real(calibc);   
      end
end
toc
%% 
input_matrx=reshape(input_matrx,[80 lkcc]);
k=input_matrx(10,:);
k=reshape(k,[48,48,32]);
I=sos(ifft2c(k));
imshow(I)

