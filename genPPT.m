clc;clear
imagepath='E:\Yilong DATA\Results Image\';
addpath(genpath(imagepath)); % image path
addpath(genpath('E:\Yilong DATA\code\DLLR\stefslon-exportToPPTX')); % exportToPPTX tool path

fileFolder=fullfile(imagepath);
dirOutput=dir(fullfile(fileFolder,'*mat'));
fileNames={dirOutput.name}';
for i=1
    imagename_i = fileNames(i);
    I_path=char(strcat(imagepath,imagename_i));
    load(I_path);
    imshow(I);
    
end
