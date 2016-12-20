function [IQF, aMat, bMat, errFlags] = calcIQFData(IDicomOrig,attenuation, ...
    radius, binDisk, thickness, diameter,  spacing,binaryOutline,IDicomAvg,IDicomStdev, threshThickness,errFlags, imgInfo)
%% Setting Parms

[nRows,nCols] = size(IDicomOrig); [nRowPatch,nColPatch] = size(binDisk(:,:,1));
oneMmPixels = ceil(1/spacing); pixelRadInIQFImg = ceil(oneMmPixels*2.5);
rowIndices = pixelRadInIQFImg+1:2*pixelRadInIQFImg:nCols;
colIndices = pixelRadInIQFImg+1:2*pixelRadInIQFImg:nRows;
[nValidPatches,~] = size(threshThickness)

disp('Calculating IQF Values...');tic
%Now Calculate the IQF, EXP Fit, etc.
x = diameter;
IQFFull = zeros(1,nValidPatches);IQFLarge = zeros(1,nValidPatches);IQFMedium = zeros(1,nValidPatches);
IQFSmall = zeros(1,nValidPatches);aVector = zeros(1,nValidPatches);bVector = zeros(1,nValidPatches);
%NEED TO INSERT AN ERROR FLAG HERE
threshThickness(isnan(threshThickness)) = 0.03; %Replaces any nan values with 0.03
threshThickness(isinf(threshThickness)) = 0.03; %Replaces any nan values with 0.03

nDiam = length(diameter);
split1 = round(nDiam/3);
split2 = 2*split1;
for m = 1:nValidPatches
    y = threshThickness(m,:);
    
    IQFdenom = x*y';
    IQFFull(m) = sum(diameter(:))./IQFdenom;
    IQFLarge(m) = sum(diameter(1:split1))./(x(1:split1)*y(1:split1)');
    IQFMedium(m) = sum(diameter(split1+1:split2))./(x(split1+1:split2)*y(split1+1:split2)');
    IQFSmall(m) = sum(diameter(split2+1:end))./(x(split2+1:end)*y(split2+1:end)');
    A = ones(length(diameter),2); B = zeros(length(diameter),1);
    
%     figure
%     scatter(diameter,y)
%     set(gca,'xscale','log','yscale','log')
%     title('Contrast Detail plot')
%     xlabel('Diameter of Lesion (mm)')
%     ylabel('Threshold Thickness for Detection (um Gold)')
%     pause
    
    B(:,1) = log(y)'; A(:,2) = log(diameter');
    test = A\B;
    alpha = exp(test(1)); beta = test(2);
    aVector(m) = alpha;
    bVector(m) = beta;
end
t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
disp('Plotting IQF Values...');tic
IQF.Full = zeros(nRows,nCols); IQF.Large= zeros(nRows,nCols);
IQF.Medium= zeros(nRows,nCols); IQF.Small= zeros(nRows,nCols);
for m = 1:nValidPatches
    colIdx = imgInfo(m,3);
    rowIdx = imgInfo(m,4);
    
    IQF.Full(colIdx-pixelRadInIQFImg:colIdx+pixelRadInIQFImg,rowIdx-pixelRadInIQFImg:rowIdx+pixelRadInIQFImg) = IQFFull(m);
    IQF.Large(colIdx-pixelRadInIQFImg:colIdx+pixelRadInIQFImg,rowIdx-pixelRadInIQFImg:rowIdx+pixelRadInIQFImg)= IQFLarge(m);
    IQF.Medium(colIdx-pixelRadInIQFImg:colIdx+pixelRadInIQFImg,rowIdx-pixelRadInIQFImg:rowIdx+pixelRadInIQFImg)= IQFMedium(m);
    IQF.Small(colIdx-pixelRadInIQFImg:colIdx+pixelRadInIQFImg,rowIdx-pixelRadInIQFImg:rowIdx+pixelRadInIQFImg)= IQFSmall(m);

    aMat(colIdx-pixelRadInIQFImg:colIdx+pixelRadInIQFImg,rowIdx-pixelRadInIQFImg:rowIdx+pixelRadInIQFImg) = aVector(m);
    bMat(colIdx-pixelRadInIQFImg:colIdx+pixelRadInIQFImg,rowIdx-pixelRadInIQFImg:rowIdx+pixelRadInIQFImg) = bVector(m);
end
t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)

IQF.Full = IQF.Full(1:nRows,1:nCols) .* binaryOutline;
IQF.Large = IQF.Large(1:nRows,1:nCols) .* binaryOutline;
IQF.Medium = IQF.Medium(1:nRows,1:nCols) .* binaryOutline;
IQF.Small = IQF.Small(1:nRows,1:nCols) .* binaryOutline;

errFlags=errFlags;
end
