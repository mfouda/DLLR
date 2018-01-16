function [SNR] = SNR_Calculator(DATA,batchsize)
%UNTITLED2 ¼ÆËã image µÄSNR£¬ mean(S)/std(N)
% batchsize = 20;
I = sos(ifft2c(DATA));
length_1 = size(DATA,1)-batchsize-1;
length_2 = size(DATA,2)-batchsize-1;
N_1 = imcrop(I,[1 1 batchsize batchsize]);
N_2 = imcrop(I,[1 length_2 batchsize batchsize]);
N_3 = imcrop(I,[length_1 1 batchsize batchsize]);
N_4 = imcrop(I,[length_1 length_2 batchsize batchsize]);
N = [N_1(:);N_2(:);N_3(:);N_4(:)];
location_x = size(DATA,1)./2 - batchsize;
location_y = size(DATA,2)./2 - batchsize;
S = imcrop(I,[location_x,location_y,batchsize*2+1,batchsize*2+1]);
S = S(:);
SNR = mean(S)./std(N)

%%
% IF=sos(image_full);
% RV_all=sum(abs(IF(:)));
% plot(RV);
% min(find(RV-RV_all./SNR <0))

end