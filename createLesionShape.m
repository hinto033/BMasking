function [binaryDiskBlurred, errFlags] = createLesionShape(radius, shape, SigmaPixels, errFlags)
diamVector = round(radius.*2) + 1;
radiusVector = diamVector./2;
diskRegionSize = ceil(max(diamVector.*sqrt(2)))+1;
if isequal(shape, 'Round')  %shape == 'Round'
    centerX = round(diskRegionSize+1)/2;
    centerY = round(diskRegionSize+1)/2;
    diskBinaryMask = zeros(diskRegionSize, diskRegionSize, length(radius));
    for j = 1:length(radius)
        radCurrent = radiusVector(j);
        [x,y]=meshgrid(-(centerX-1):(diskRegionSize-centerX),-(centerY-1):(diskRegionSize-centerY));
        diskBinaryMask(:,:,j)=((x.^2+y.^2)<=radCurrent^2);
    end
    PSF = fspecial('gaussian',6,SigmaPixels); 
    binaryDiskBlurred = zeros(diskRegionSize,diskRegionSize,length(radius));
    binaryDiskBlurred(:,:,:) = imfilter(diskBinaryMask(:,:,:),PSF,'symmetric','conv');
    errFlags.Lesions = 'No Error';
elseif isequal(shape, 'Gaussian')  %shape == 'Gaussian'
    %Creates Gaussian that is centered and 3*sigma = radius
    diskBinaryMask = zeros(diskRegionSize, diskRegionSize, length(radius));
    size(diskBinaryMask(:,:,1))
    for j = 1:length(radius)
    radCurrent = radiusVector(j);
    gaussianMask = fspecial('gaussian',diskRegionSize, radCurrent/3);
    maxGaussian = max(max(gaussianMask));
    gaussianMask = gaussianMask./maxGaussian;
    diskBinaryMask(:,:,j) = gaussianMask;
    end
    binaryDiskBlurred = zeros(diskRegionSize,diskRegionSize,length(radius));
    PSF = fspecial('gaussian',6, SigmaPixels); 
    binaryDiskBlurred(:,:,:) = imfilter(diskBinaryMask(:,:,:),PSF,'symmetric','conv');
    errFlags.Lesions = 'No Error';
else
    disp('The shape you selected is not currently supported...');
    disp('Calculating as gaussian disks instead...');
    errFlags.Lesions = 'No Shape Selected. Gaussian was assumed';
end
end

