function [RV,RLB,RUB]= SVT_RES_Calculator(DATA,lb,ub)
%UNTITLED2 计算 image 的SNR， mean(S)/std(N)
% 也用到了SAKE的部分参数，放到了函数体内部，需注意，谨防出错
ksize = [6,6]; % ESPIRiT kernel-window-size
ncalib = 48;
% %% add mask
% mask=mask_nocalib_x2half;     % choose a 3x no calibration mask
%DATAc = DATA.* repmat(mask,[1,1,size(DATA,3)]);
DATAc = DATA;
calibc = crop(DATAc,[ncalib,ncalib,size(DATA,3)]);
%%
[sx,sy,Nc] = size(calibc);
image_full=ifft2c(calibc);
tmp=im2row(calibc,ksize);
[tsx,tsy,tsz] = size(tmp);
A = reshape(tmp,tsx,tsy*tsz); % hankel matrix
[U,S,V] = svd(A); 
kernel = reshape(V,ksize(1),ksize(2),Nc,size(V,2));
S_v = diag(S);
% %  %% using fully SVD resuts to replace reference image as they are difference
% % A_temp=U*S*V'; B_temp=reshape(A_temp,size(A_temp,1),size(A_temp,2)./Nc,Nc); 
% % [res_temp,W] = row2im(B_temp,[ncalib ncalib], ksize);
% % image_full =ifft2c(res_temp);
% % figure;imshow(sos(ifft2c(res_temp)));
% % figure;imshow(sos(ifft2c(calibc)));
% % figure;mesh(sos(ifft2c(res_temp))-sos(ifft2c(calibc)));


%%
for i=lb:1:ub
%     eigThresh_k=i/10;
%     idx = max(find(S_v >= S_v(1)*eigThresh_k));
    idx=i;
    S_truncated = S_v(1:1:idx);
    S_temp = diag(S_truncated);
    A_recon=U(:,1:1:idx)*S_temp*V(:,1:1:idx)';
    %A_recon=A_recon + m;
    B=reshape(A_recon,size(A,1),size(A,2)./Nc,Nc);
    [res,W] = row2im(B,[ncalib ncalib], ksize);
    image_recon=ifft2c(res);
    %figure;imshow(sos(image_recon)./5);
    %saveas(gcf,['E:\code\ESPIRiT\TEST L Curve\r is ' num2str(i) '.png'])
    residual = sos(image_recon)-sos(image_full);
    RV(i)=sum(abs(residual(:)));
end
    
    RV_all = sos(ifft2c(calibc)); 
    RV_all= sum(RV_all(:));
    
%     RLB = min(find(RV -RV_all./(SNR+1) <0)) ;% rank lower bound
   RLB = min(find(RV -RV_all.*0.1 <0));
   RUB = min(find(RV -RV_all.*0.005 <0));
end

