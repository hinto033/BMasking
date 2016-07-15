function [attenDisk, errFlags] = createLesionShape(radius, shape, SigmaPixels, errFlags)
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
    PSF = fspecial('gaussian',6,SigmaPixels); 
    attenDisk(:,:,:) = imfilter(smallDisk(:,:,:),PSF,'symmetric','conv');
    errFlags.Lesions = 'No Error';
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
    PSF = fspecial('gaussian',6, SigmaPixels); 
    attenDisk(:,:,:) = imfilter(smallDisk(:,:,:),PSF,'symmetric','conv');
    errFlags.Lesions = 'No Error';
else
    disp('The shape you selected is not currently supported...');
    disp('Calculating as gaussian disks instead...');
    errFlags.Lesions = 'No Shape Selected. Gaussian was assumed';
end
end

