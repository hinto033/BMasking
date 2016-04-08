function [atten_disks] = circle_roi4(radius)
diam = round(radius.*2) + 1;
rt = diam./2;
searchArea = ceil(max(diam.*sqrt(2)))+1;
centerX = round(searchArea+1)/2;
centerY = round(searchArea+1)/2;
smalldisk = zeros(searchArea, searchArea, length(radius));
size(smalldisk(:,:,1))
cx=centerX;cy=centerY;ix=searchArea;iy=searchArea;

for j = 1:length(radius)
r=rt(j);
[x,y]=meshgrid(-(cx-1):(ix-cx),-(cy-1):(iy-cy));
smalldisk(:,:,j)=((x.^2+y.^2)<=r^2);
end
atten_disks = zeros(searchArea,searchArea,length(radius));
PSF = fspecial('gaussian',6,2); 
atten_disks(:,:,:) = imfilter(smalldisk(:,:,:),PSF,'symmetric','conv');

