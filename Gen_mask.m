 clc;clear;
 %% 
load('mask_all.mat');
mx=200;kx=128;
mask_i = (mx-kx)./2 ;
for i=1:1:4
    mask_all_2d(:,:,i)=imcrop(mask_all(:,:,i),[mask_i,mask_i,kx-1,kx-1]);
end
  save('E:\Yilong DATA\code\DLLR\mask_all_2d.mat','mask_all_2d');
 %%
 % mask_all_1d=zeros(232,232,4);
% length_k=232;
% mask_all_1d(1:2:length_k,:,1)=ones(length_k./2,length_k);
% mask_all_1d(1:4:length_k,:,2)=ones(length_k./4,length_k);
% mask_all_1d(1:6:length_k,:,3)=ones(floor(length_k./6)+1,length_k);
% mask_all_1d(1:8:length_k,:,4)=ones(length_k./8,length_k);
% %%
% imshow(mask_all_1d(:,:,4));
% save('F:\code\DLLR\mask_all_1d.mat','mask_all_1d');
% 
%%
% %% 
% lk=200;
% csize=20;
% central = (lk-csize)./2:(lk+csize)./2 -1 ;central=central';
% mask_all_randn1D=zeros(lk,lk,4);
% U2_index = randperm(lk,lk./2);
% U3_index = randperm(lk,floor(lk./3));
% mask_all_randn1D(U2_index,:,1)=ones(lk./2,lk);
% mask_all_randn1D(U3_index,:,2)=ones(floor(lk./3),lk);
% mask_all_randn1D(U2_index,:,3)=ones(lk./2,lk); mask_all_randn1D(central,central,3)=ones(csize,csize);
% mask_all_randn1D(U3_index,:,4)=ones(floor(lk./3),lk); mask_all_randn1D(central,central,4)=ones(csize,csize);
% %%
% imshow(mask_all_randn1D(:,:,4));
% save('F:\code\DLLR\mask_all_randn1D.mat','mask_all_randn1D');
  
%%