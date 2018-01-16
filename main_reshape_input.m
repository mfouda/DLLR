addpath(genpath('E:\Yilong DATA\ESPIRiT'));
addpath(genpath('E:\Yilong DATA\raw\2016_Nov_brain'));
clc
clear
close all;

load brain_8ch
load GreData
[sx,sy,Sn,Nc]=size(gre_kxkyzc);
for slice_n=1
      for mask_n =1     
            gre_kxkyzc=double(gre_kxkyzc);
            DATA = gre_kxkyzc(:,:,slice_n,:);
            DATA = squeeze(DATA);
            DATA = DATA/max(max(max(abs(ifft2c(DATA))))) + eps;
            % DATA = permute(DATA,[2 1 3]);
            switch mask_n
               case 1
                   mask = mask_nocalib_x2half;
               case 2
                   mask = mask_nocalib_x3;
               case 3
                   mask = mask_randm_x3;
               case 4
                   mask = mask_randm_x4;
           end
                 mask_i = (size(mask,1)-size(DATA,1))./2 ;
                 mask = imcrop(mask,[mask_i,mask_i,size(DATA,1)-1,size(DATA,1)-1]);
                 figure; imshow(mask);
                 DATAc = DATA.* repmat(mask,[1,1,Nc]);
      end
end