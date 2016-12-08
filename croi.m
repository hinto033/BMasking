function [roiH] = croi(img, bdrind,coeff)
%  Choose Region of Interest for Hough Transform
%  roih returns the region of interest for Hough transformation

[dimX, ~] = size(img);
rub = round(bdrind(find(bdrind>=3,1))*coeff);
lb = min(find(bdrind==max(bdrind(round(dimX*0.25):end)), 1, 'last'),round(dimX*0.50)); %skip the first few rows just in case 
roiH = img(1:lb,1:rub);
clear lb rub dimx dimy
