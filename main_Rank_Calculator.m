%% main
addpath(genpath('E:\Yilong DATA\ESPIRiT'));
addpath(genpath('E:\Yilong DATA\raw\2016_Nov_brain'));
clc
clear
close all;

load mask_all
load GreData
% slice_n=1;
% mask_n=1;
for slice_n=1
       gre_kxkyzc=double(gre_kxkyzc);
            [sx,sy,Sn,Nc]=size(gre_kxkyzc);
            DATA = gre_kxkyzc(:,:,slice_n,:);
            DATA = squeeze(DATA);
            DATA = DATA/max(max(max(abs(ifft2c(DATA))))) + eps;
     for mask_n =1   
         
            % DATA = permute(DATA,[2 1 3]);
            mask=mask_all(:,:,mask_n);
            mask=squeeze(mask);
            mask_i = (size(mask,1)-size(DATA,1))./2 ;
            mask = imcrop(mask,[mask_i,mask_i,size(DATA,1)-1,size(DATA,1)-1]);

            DATAc = DATA.* repmat(mask,[1,1,Nc]);
            %%  Calculate the SNR for fully sampled image
    %         I = sos(ifft2c(DATA));
    %         imshow(I)
    %         batchsize=10;
    %         [SNR] = SNR_Calculator(DATA,batchsize)
    %         %SNR=100;
    % 
            %%
            lb=1;
            ub=288;
            [RV,RLB,RUB] = SVT_RES_Calculator(DATA,lb,ub);
            plot(RV);
           Left=RLB ; Right = RUB; EPS=2;
            %%
            RES_rank=zeros(1,RUB);
            while (Left + EPS <Right)
                mid = floor((Left + Right)/2);
                midmid = floor((mid + Right)/2);
                    if RES_rank(mid)==0
                        [mid_area] = SAKE_RES_Calculator(mid,DATA,DATAc,slice_n,mask_n);
                        RES_rank(mid) = mid_area;
                    else
                    end
                    if RES_rank(midmid)==0
                        [midmid_area] = SAKE_RES_Calculator(midmid,DATA,DATAc,slice_n,mask_n);
                        RES_rank(midmid) = midmid_area;
                    else
                    end
                
                if (RES_rank(mid) <= RES_rank(midmid)) 
                    Right = midmid;
                else
                    Left = mid;
                end
            end
          optimal_rank = find(RES_rank==min(RES_rank(find(RES_rank~=0))));
            
        save(['E:\Yilong DATA\Results Res\slice_' num2str(slice_n) '_mask_' num2str(mask_n) '_optimal rank_' num2str(optimal_rank) '.mat'],'RES_rank');
     end
 
end
