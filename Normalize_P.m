function Normalized_input_matrix= Normalize_P(input_matrix) 
[sn sp]=size(input_matrix);
ymax=128; ymin=-127;  
        for i=1:1:sn
            pixel_v = input_matrix(i,:);
            xmax = max(pixel_v) ; %���InImg�е����ֵ  
            xmin = min(pixel_v) ;%���InImg�е���Сֵ  
            Normalized_input_matrix(i,:) = round((ymax-ymin)*(pixel_v-xmin)/(xmax-xmin) + ymin); %��һ����ȡ��  
            
        end

end