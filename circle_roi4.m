function [attenDisk] = circle_roi4(radius)
diam = round(radius.*2) + 1;
rt = diam./2;
searchArea = ceil(max(diam.*sqrt(2)))+1;
centerX = round(searchArea+1)/2;
centerY = round(searchArea+1)/2;
smallDisk = zeros(searchArea, searchArea, length(radius));
size(smallDisk(:,:,1))
cx=centerX;cy=centerY;ix=searchArea;iy=searchArea;

for j = 1:length(radius)
r=rt(j);
[x,y]=meshgrid(-(cx-1):(ix-cx),-(cy-1):(iy-cy));
smallDisk(:,:,j)=((x.^2+y.^2)<=r^2);
end
attenDisk = zeros(searchArea,searchArea,length(radius));
PSF = fspecial('gaussian',6,2); 
attenDisk(:,:,:) = imfilter(smallDisk(:,:,:),PSF,'symmetric','conv');

