function [res] = SAKE_RES_Calculator(ranknumber,DATA,DATAc,slice_n,mask_n)
%UNTITLED2 计算SAKE 的residual,从而可以借助退火算法帮助确定最佳的rank number
%   SAKE本身性质相关的变量，留在函数内部；无关的移走
  %% Prepare DATA
        ncalib = 48;
        ksize = [6,6]; % ESPIRiT kernel-window-size
        sakeIter = 100;
        wnthresh = ranknumber/prod(ksize); % Window-normalized number of singular values to threshold
        eigThresh_im = 0.9; % threshold of eigenvectors in image space   
        [sx sy Nc]=size(DATAc);
        calibc = crop(DATAc,[ncalib,ncalib,Nc]);
        
       %%
        % Display sampling mask and root sos of zero-filled reconstruction
        im = ifft2c(DATAc);

        %% Singular values of the calibration matrix before SAKE
        %  
        % compute Calibration matrix, perform  SVD and convert singular vectors
        % into k-space kernels

        [k,S] = dat2Kernel(calibc,ksize);

        %%
        % Compute ESPIRiT maps to show that the maps are corrupted as well. 
        [M,W] = kernelEig(k(:,:,:,1:floor(wnthresh*prod(ksize))),[sx,sy]);

        %% Perform SAKE reconstruction to recover the calibration area

        disp('Performing SAKE recovery of calibration');
        calib = SAKE(calibc, [ksize], wnthresh,sakeIter, 0);
        disp('Done')
        %% Compute Soft-SENSE ESPIRiT Maps 
        % crop sensitivity maps according to eigenvalues==1. Note that we have to
        % use 2 sets of maps. Here we weight the 2 maps with the eigen-values
        [k,S] = dat2Kernel(calib,ksize);
        [M,W] = kernelEig(k(:,:,:,1:floor(wnthresh*prod(ksize))),[sx,sy]);
        
        maps = M(:,:,:,end-1:end);

        % Weight the eigenvectors with soft-senses eigen-values
        weights = W(:,:,end-1:end) ;
        weights = (weights - eigThresh_im)./(1-eigThresh_im).* (W(:,:,end-1:end) > eigThresh_im);
        weights = -cos(pi*weights)/2 + 1/2;

        % create and ESPIRiT operator
        ESP = ESPIRiT(maps,weights);
        nIterCG = 15; 

        %% Reconsturctions
        % ESPIRiT CG reconstruction with soft-sense and 2 sets of maps
        disp('Performing ESPIRiT reconstruction from 2 maps')
        tic; [reskESPIRiT, resESPIRiT] = cgESPIRiT(DATAc,ESP, nIterCG, 0.01,DATAc*0); toc
        figure, imshow(cat(2,sos(ifft2c(DATA-reskESPIRiT))*10,sos(resESPIRiT.*weights)),[0,1])
        title(['Reconstruction results with rank number threshold = ' num2str(floor(wnthresh*prod(ksize)))])
      %  saveas(gcf,['E:\Yilong DATA\Results Image\slice_' num2str(slice_n) '_mask_' num2str(mask_n) '_rank_' num2str(floor(wnthresh*prod(ksize))) '.png']);     
         res = sum(sum(sos(ifft2c(DATA-reskESPIRiT))));     
         I = cat(2,sos(ifft2c(DATA-reskESPIRiT))*10,sos(resESPIRiT.*weights)) ;
         save(['E:\Yilong DATA\Results Image\slice_' num2str(slice_n) '_mask_' num2str(mask_n) '_rank_' num2str(floor(wnthresh*prod(ksize))) '.mat'],'I');
end

