function Normalized_input_matrix= Normalize_P(input_matrix) 
[sn sp]=size(input_matrix);
ymax=128; ymin=-127;  
        for i=1:1:sn
            pixel_v=input_matrix(i,:);
            xmax = max(max(pixel_v)); %求得InImg中的最大值  
            xmin = min(min(pixel_v)); %求得InImg中的最小值  
            Normalized_input_matrix(i,:) = round((ymax-ymin)*(pixel_v-xmin)/(xmax-xmin) + ymin); %归一化并取整  
            i
        end

end