function [calibc_batch] = Data_Augmentation(calibc, batch_size)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
% batch_size is a number

[scx,scy,Nc]=size(calibc);
slide_x = scx-batch_size+1;
slide_y = scy-batch_size+1;
calibc_batch=zeros(batch_size,batch_size,Nc,slide_x*slide_y);

    for i=1:1:slide_x
        for j=1:1:slide_y     
                batch_index=(i-1)*slide_y+j;
                calibc_batch(:,:,:,batch_index)=calibc(i:1:i+batch_size-1,j:1:j+batch_size-1,:);   
        end
    end
    
end

