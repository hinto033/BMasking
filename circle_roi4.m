function [attenDisk] = circle_roi4(radius, shape)
diam = round(radius.*2) + 1;
rt = diam./2;
searchArea = ceil(max(diam.*sqrt(2)))+1;
attenDisk = 0;
if isequal(shape, 'Round')%shape == 'Round'
    centerX = round(searchArea+1)/2;
    centerY = round(searchArea+1)/2;
    smallDisk = zeros(searchArea, searchArea, length(radius));
    cx=centerX;cy=centerY;ix=searchArea;iy=searchArea;
    for j = 1:length(radius)
    r=rt(j);
    [x,y]=meshgrid(-(cx-1):(ix-cx),-(cy-1):(iy-cy));
    smallDisk(:,:,j)=((x.^2+y.^2)<=r^2);
    end
    attenDisk = zeros(searchArea,searchArea,length(radius));
    PSF = fspecial('gaussian',6,2); 
    attenDisk(:,:,:) = imfilter(smallDisk(:,:,:),PSF,'symmetric','conv');
elseif isequal(shape, 'Gaussian')%shape == 'Gaussian'
        %Creates Gaussian that is centered and 3*sigma = radius
    smallDisk = zeros(searchArea, searchArea, length(radius));
    size(smallDisk(:,:,1))
    for j = 1:length(radius)
    r=rt(j);
    g = fspecial('gaussian',searchArea, r/3);
    gmax = max(max(g));
    g = g./gmax;
    smallDisk(:,:,j) = g;
    end
    attenDisk = zeros(searchArea,searchArea,length(radius));
    PSF = fspecial('gaussian',6,2); 
    attenDisk(:,:,:) = imfilter(smallDisk(:,:,:),PSF,'symmetric','conv');
else
    error('No currently made shape selected')
end
end

