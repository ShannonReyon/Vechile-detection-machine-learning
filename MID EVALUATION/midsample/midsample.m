%clear all;
%clc;
%% Prepare the dataset

x = feature(:, 1:10);
y = feature(:,11);

rand = randperm(2000);

xtr = x(rand(1:1600), :);
ytr = y(rand(1:1600), :);

xt = x(rand(1601:end), :);
yt = y(rand(1601:end), :);

%% Training the model
model = fitcsvm(xtr, ytr, 'KernelFunction', 'rbf', ...
    'OptimizeHyperparameters', 'auto', ...
    'HyperparameterOptimizationOptions', struct('AcquisitionFunctionName', ...
    'expected-improvement-plus', 'ShowPlots', true));

save model

%% Test accuracy of the model
result = predict(model, xt);
accuracy = sum(result == yt)/length(yt)*100;
sp = sprintf("Test Accuracy = %.2f", accuracy);
disp(sp);
%% Test
cd ..
%%%%%%%%%%%%get test image %%%%%%%%%%
    [f,p]=uigetfile('*.*');
    test=imread(strcat(p,f));
   %%%%%%%texture features test image%%%%%%%%
   B = imresize(test,[64 64]);
   y=rgb2gray(B);
   lbpB1 = extractLBPFeatures(y,'Upright',false);
   lb1=sum(lbpB1);
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

   Testftr=horzcat([lb1,f1,f2,f3,f4,ls]);
   TestSet=Testftr;
   
   result2 = predict(model, TestSet);
   imshow(test)
   if result2 == 1
       msgbox('Vehicle')
   elseif result2 == 0
       msgbox('no Vehicle')
   else
       msgbox('None')
   end    
