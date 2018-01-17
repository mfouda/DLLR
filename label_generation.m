clc
clear
close all;
%% path
% point to the double-digit before .mat
tic;
addpath(genpath('F:\code\DLLR'));
fileFolder=fullfile('F:\Yilong DATA\First batch results\Results Res');
dirOutput=dir(fullfile(fileFolder,'*mat'));
fileNames={dirOutput.name}';
for i=1:1:size(fileNames,1)  
   str = char(fileNames(i));
   %%
   pat_slice='(?<=slice_).*?(?=_mask_)';
   slice_n_cell=regexpi(str,pat_slice,'match');
   slice_n=str2num(char(slice_n_cell));
    
    %%
    pat_mask='(?<=_mask_).*?(?=_optimal rank_)';
    mask_n_cell=regexpi(str,pat_mask,'match');
    mask_n=str2num(char(mask_n_cell));
    
    %%
    pat_rank ='\d\d.mat';
    location_rank=regexp(str,pat_rank);

   %%
    ranknumber(slice_n,mask_n)= str2num(str(location_rank:location_rank+1));    
end
ranknumber=ranknumber';
label=reshape(ranknumber,[80 1]);
save('F:\code\DLLR\DATA\label.mat','label')

toc
