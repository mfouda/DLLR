InImg=sos(calibc);
ymax=512;ymin=-512;  
xmax = max(max(InImg)); %���InImg�е����ֵ  
xmin = min(min(InImg)); %���InImg�е���Сֵ  
OutImg = round((ymax-ymin)*(InImg-xmin)/(xmax-xmin) + ymin); %��һ����ȡ�� 
imshow(OutImg)