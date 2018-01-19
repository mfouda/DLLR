function OutImg = Normalize_I(InImg) 
[sm ss sb sp]=size(InImg);
ymax=128; ymin=-127;  
for  i=1:1:sm
    for j=1:1:ss
        for k=1:1:sb
            pixel_v=squeeze(InImg(i,j,k,:));
            xmax = max(max(pixel_v)); %求得InImg中的最大值  
            xmin = min(min(pixel_v)); %求得InImg中的最小值  
            OutImg = round((ymax-ymin)*(pixel_v-xmin)/(xmax-xmin) + ymin); %归一化并取整  
        end

    end
end
end 