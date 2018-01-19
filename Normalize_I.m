function OutImg = Normalize_I(InImg) 
[sm ss sb sp]=size(InImg);
ymax=128; ymin=-127;  
for  i=1:1:sm
    for j=1:1:ss
        for k=1:1:sb
            pixel_v=squeeze(InImg(i,j,k,:));
            xmax = max(max(pixel_v)); %���InImg�е����ֵ  
            xmin = min(min(pixel_v)); %���InImg�е���Сֵ  
            OutImg = round((ymax-ymin)*(pixel_v-xmin)/(xmax-xmin) + ymin); %��һ����ȡ��  
        end

    end
end
end 