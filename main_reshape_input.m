clc
clear
close all;
path_title='F:\Yilong DATA\';
codepath = 'F:\code\DLLR';
% SUSTC-computer
% path_title='E:\Yilong DATA\';
% codepath = 'E:\Yilong DATA\code\DLLR';

addpath(genpath(codepath));
addpath(genpath([path_title 'ESPIRiT']));
addpath(genpath([path_title 'raw\2016_Nov_brain']));


load mask_all
load GreData
[sx,sy,Sn,Nc]=size(gre_kxkyzc);
ncalib = 48;
ksize = [6,6]; % ESPIRiT kernel-window-size
%calibc_batch_input=zeros(20,4,400,841); %[slicenumber masknumber pixel  batchnumber]
batch_size = 44;
batch_pixels =Nc *batch_size^2 ;

batch_n = (ncalib-batch_size+1)^2;
calibc_batch_input=zeros(15,4,batch_pixels,batch_n); %[slicenumber masknumber pixel  batchnumber]

tic
for slice_n=1:1:17
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
          
           calibc_batch = Data_Augmentation(calibc, batch_size);
           calibc_batch_input(slice_n,mask_n,:,:) = reshape(calibc_batch,[batch_pixels,batch_n]);
           
%            k_all= sos(calibc_batch,3);
%            calibc_batch_input(slice_n,mask_n,:,:) = reshape(k_all,[400 841]);
       
     end
      slice_n
end
toc

calibc_batch_input = permute(calibc_batch_input,[2 1 4 3]); % 4 20 841 12800
size(calibc_batch_input)
%save('F:\code\DLLR\input_matrix.mat','input_matrix');

% %%
input_matrix_t=reshape(calibc_batch_input,[batch_n*68   batch_pixels]);
load([codepath '\DATA\label.mat'])
%label=label-min(label)+1;
tr_label=repmat(label(1:68),[batch_n,1]);
% tr=[tr_label real(input_matrix);
%     tr_label imag(input_matrix)];
%% Normal
input_matrix=[real(input_matrix_t) imag(input_matrix_t)];
% % AA=randperm(67280,10000);
% % input_matrix=input_matrix(AA,:);
% % tr_label=tr_label(AA,:);
Normalized_input_matrix= Normalize_P(input_matrix);
tr=[tr_label Normalized_input_matrix];
%%
tr_input=tr;
save([codepath '\DATA\tr_input.mat'],'tr_input');
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
