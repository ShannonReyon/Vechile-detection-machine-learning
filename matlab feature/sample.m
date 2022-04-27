clc
clear all
close all
warning off
x=imread('car.png');
imshow(x);
x=rgb2gray(x);
w = edge(x,'canny',0.2);
figure;
imshow(w);
sum_value=0;
[r c]=size(w);
for i=1:r
    for j=1:c
        sum_value=sum_value+w(i,j);
    end
end
ls=sum_value/(r*c)