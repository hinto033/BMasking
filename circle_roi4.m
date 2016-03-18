function [atten_disks] = circle_roi4(radius)

dt = round(radius.*2) + 1;
rt = dt./2;

d = ceil((dt.*sqrt(2)));
dCenter = ceil(((2.*d)+1)./2 +0.5);
centerX = max(d)+1;
centerY = max(d)+1;
max(radius)
rads=radius.^2;
smalldisk = zeros(2*max(d)+1, 2*max(d)+1, length(radius));

cx=centerX;cy=centerY;ix=2*max(d)+1;iy=2*max(d)+1;
for j = 1:length(radius)
r=rt(j);
dt(j);
rt(j);
[x,y]=meshgrid(-(cx-1):(ix-cx),-(cy-1):(iy-cy));
smalldisk(:,:,j)=((x.^2+y.^2)<=r^2);
end
atten_disks = zeros(2*max(d)+1,2*max(d)+1,length(radius));
PSF = fspecial('gaussian',6,2); 
atten_disks(:,:,:) = imfilter(smalldisk(:,:,:),PSF,'symmetric','conv');


