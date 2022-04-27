cd 1000 % change directory to access data

df=[] % create a data frame

for i = 1:2000 % loop till end of data
   x=imread(strcat(int2str(i),'.png')); %string concatinate and open images one by one
   
   %%%%%%%Extract texture features%%%%%%%%
   y=rgb2gray(x); % convert image to gray scale
   lbpB1 = extractLBPFeatures(y,'Upright',false); %local binary pattern feature extraction
   lb1=sum(lbpB1);% get the summation
   glcm=graycomatrix(y,'Offset',[2,0;0,2]);   %Gray-Level Co-Occurrence Matrix 
   st1=graycoprops(glcm,{'contrast','homogeneity'});
   st2=graycoprops(glcm,{'correlation','energy'});
   
   f1=st1.Contrast;
   f2=st1.Homogeneity;
   f3=st2.Correlation;
   f4=st2.Energy;
   
   w=edge(y,'canny',0.2);
   sum_value=0;
   [r c]=size(w);
   for a=1:r
        for j=1:c
           sum_value=sum_value+w(a,j); 
        end
   end
    ls=sum_value/(r*c);
    
   
    if i<=1000
        CL = 0;
    end
    
    if i>1000
        CL = 1;
    end    
   Fr=horzcat([lb1,f1,f2,f3,f4,ls,CL]);
   
   df=[df;Fr];
   ex=xlswrite('feature.xlsx',df)
   
     
end