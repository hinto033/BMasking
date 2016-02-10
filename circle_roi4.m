function [atten_disks] = circle_roi4(radius)
im_size = [2.*ceil(radius)+1;2.*ceil(radius)+1];
d = ceil((radius.*2.*sqrt(2)));
dCenter = ceil(((2.*d)+1)./2 +0.5);
imageSizeX = im_size(2,:);
imageSizeY = im_size(1,:);
% Next create the circle in the image.
centerX = max(d)+1;
centerY = max(d)+1;
max(radius)
rads=radius.^2;
smalldisk = zeros(2*max(d)+1, 2*max(d)+1, length(radius));

for j = 1:length(imageSizeX)
    [columnsInImage, rowsInImage] = meshgrid(1:2*max(d)+1, 1:2*max(d)+1);
    smalldisk(:,:,j) = (rowsInImage - centerY).^2 + (columnsInImage - centerX).^2 <= rads(j);%radius.^2;
%     [boxSize(j),~] = size(smalldisk(:,:,j));
end

atten_disks = zeros(2*max(d)+1,2*max(d)+1,length(radius));
PSF = fspecial('gaussian',18,18);
        
atten_disks(:,:,:) = imfilter(smalldisk(:,:,:),PSF,'symmetric','conv');