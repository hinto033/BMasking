function [IQF, aMat, bMat, errFlags] = calcIQFData(IDicomOrig,attenuation, ...
    radius, binDisk, thickness, diameter, cutoffs, spacing,binaryOutline,IDicomAvg,IDicomStdev, errFlags)
%% Setting Parms

pMax = length(radius); kMax = length(attenuation);
[nRows,nCols] = size(IDicomOrig); [nRowPatch,nColPatch] = size(binDisk(:,:,1));
padAmnt = ceil((nRowPatch+1)/2); patchRadius = padAmnt-1;
IDicomOrig = padarray(IDicomOrig, [padAmnt,padAmnt], 'symmetric');


oneMmPixels = ceil(1/spacing); pixelRadInIQFImg = ceil(oneMmPixels*2.5);
rowIndices = pixelRadInIQFImg+1:2*pixelRadInIQFImg:nCols;
colIndices = pixelRadInIQFImg+1:2*pixelRadInIQFImg:nRows;
nValidPatches = 0;
disp('Determining Locations to calculate...');tic
for rowIdx = rowIndices
    for colIdx = colIndices
        if binaryOutline(colIdx,rowIdx) == 0
        else
            nValidPatches = nValidPatches+1;
        end
    end
end
t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
 %VERY GREEDY RAM
if mod(nRowPatch,2) == 0
    imgPatch = zeros((patchRadius*2)^2,nValidPatches);
else
    imgPatch = zeros((patchRadius*2+1)^2,nValidPatches);
end
imgInfo = zeros(nValidPatches,4);
nValidPatches = 0;
disp('Storing Image Patches...');tic
for rowIdx = rowIndices
    for colIdx = colIndices
        paddedColIdx = colIdx+padAmnt;
        paddedRowIdx = rowIdx+padAmnt;
        %Define Region
        if mod(nRowPatch,2) == 0
            region = IDicomOrig(paddedColIdx-patchRadius:paddedColIdx+patchRadius-1, ...
            paddedRowIdx-patchRadius:paddedRowIdx+patchRadius-1);
        else
            region = IDicomOrig(paddedColIdx-patchRadius:paddedColIdx+patchRadius, ...
            paddedRowIdx-patchRadius:paddedRowIdx+patchRadius);
        end
        
        if binaryOutline(colIdx,rowIdx) == 0 %Do not store the location
        else  %Do store the location
            nValidPatches = nValidPatches+1;
            imgInfo(nValidPatches,1) = paddedColIdx;
            imgInfo(nValidPatches,2) = paddedRowIdx;
            imgInfo(nValidPatches,3) = colIdx;
            imgInfo(nValidPatches,4) = rowIdx;
            imgPatch(:,nValidPatches) = region(:);
        end
    end
end

t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
clear IDicomOrig binaryOutline
%Calculate the lambda for every disk/diameter
disp('Calculating Lambda Values...');tic
lambdaAll= zeros(kMax,nValidPatches,pMax);
% attenMatrix = zeros(kMax,r*c);
attenMatrix = zeros(nRowPatch*nColPatch,kMax);
for colIdx = 1:pMax
    negDisk = binDisk(:,:,colIdx);
    for k = 1:kMax
        attenDisk = negDisk.*((IDicomAvg-50)*(attenuation(k) - 1));
        attenMatrix(:,k) = attenDisk(:);
    end
    attenMatrixFlipped = attenMatrix.';
    lambdaAll(:,:,colIdx) = attenMatrixFlipped*imgPatch;
end
clear imgPatch attenMatrix binDisk
t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
threshThickness = zeros(nValidPatches, pMax);
disp('Calculating threshold Thicknesses...');tic %CAN IMPROVE ON THIS IF CAN GET ALL INDICES IN ONE SWOOP
for currentDiam = 1:pMax %For each diamter, find the cutoff thickness at each point
    lambdaDiam = lambdaAll(:,:,currentDiam);
    cutoffDiam = cutoffs(currentDiam);
    for m = 1:nValidPatches
        lambdaPatch = lambdaDiam(:,m);
        idx = find(lambdaPatch>cutoffDiam, 1);
        if idx == 1 %Not detectable at thickest attenuation level
            threshThickness(m,currentDiam) = 2;
        elseif isempty(idx)
            threshThickness(m,currentDiam) = thickness(kMax);
        else
            distLambdas = lambdaPatch(idx-1) - lambdaPatch(idx);
            distCutoffLambda = cutoffs(currentDiam) - lambdaPatch(idx);
            fractionAbove = distCutoffLambda/distLambdas;
            distThickness = thickness(idx-1) - thickness(idx);
            threshThickness(m, currentDiam) = thickness(idx)+(fractionAbove*distThickness);
        end
    end

end

t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
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

figure
imshow(IQF.Full,[])
figure
imshow(IQF.Medium,[])
figure
imshow(IQF.Small,[])

str = 'pausing'
pause
end
