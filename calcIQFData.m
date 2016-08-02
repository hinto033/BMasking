function [IQF, aMat, bMat, errFlags] = calcIQFData(IDicomOrig,attenuation, ...
    radius, binDisk, thickness, diameter, cutoffs, spacing,binaryOutline,IDicomAvg,IDicomStdev, errFlags)
%% Setting Parms
pMax = length(radius); kMax = length(attenuation);
[nRows,nCols] = size(IDicomOrig); [r,c] = size(binDisk(:,:,1));
padAmnt = ceil(r/2); spread = padAmnt-1;
IDicomOrig = padarray(IDicomOrig, [padAmnt,padAmnt], 'symmetric');
oneMm = ceil(1/spacing); fiveMm = ceil(oneMm*2.5);
iNums = fiveMm+1:2*fiveMm:nCols; jNums = fiveMm+1:2*fiveMm:nRows;
count = 0;
disp('Determining Locations to calculate...');tic
for i = iNums
    for j = jNums
        if binaryOutline(j,i) == 0
        else
            count = count+1;
        end
    end
end
t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
imgPatch = zeros(count, (spread*2+1)^2); %VERY GREEDY RAM
imgInfo = zeros(count,4);
count = 0;
disp('Storing Image Patches...');tic
for i = iNums
    for j = jNums
        lx = j+padAmnt; ly = i+padAmnt;
        %Define Region
        region = IDicomOrig(lx-spread:lx+spread, ...
            ly-spread:ly+spread);
        if binaryOutline(j,i) == 0 %Do not store the location
        else
            %Do store the locaiton
            count = count+1;
            imgInfo(count,1) = lx;
            imgInfo(count,2) = ly;
            imgInfo(count,3) = j;
            imgInfo(count,4) = i;
            imgPatch(count,:) = region(:)';
        end
    end
end
t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
clear IDicomOrig binaryOutline
%Calculate the lambda for every disk/diameter
disp('Calculating Lambda Values...');tic
lambdaAll= zeros(count,kMax,pMax);
attenMatrix = zeros( r*c,kMax);
for j = 1:pMax
    negDisk = binDisk(:,:,j);
    for k = 1:kMax
        attenDisk = negDisk.*((IDicomAvg-50)'*(attenuation(k) - 1));
        attenMatrix(:,k) = attenDisk(:);
    end
    lambdaAll(:,:,j) = imgPatch*attenMatrix(:,:);
end
clear imgPatch attenMatrix binDisk
t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
threshThickness = zeros(count, pMax);
disp('Calculating threshold Thicknesses...');tic %CAN IMPROVE ON THIS IF CAN GET ALL INDICES IN ONE SWOOP
for h = 1:pMax %For each diamter, find the cutoff thickness at each point
    lambdaDiam = lambdaAll(:,:,h);
    cutoffDiam = cutoffs(h);
    for m = 1:count
        lambdaPatch = lambdaDiam(m,:);
        idx = find(lambdaPatch>cutoffDiam, 1);
        if idx == 1 %Not detectable at thickest attenuation level
            threshThickness(m,h) = 2;
        elseif isempty(idx)
            threshThickness(m,h) = thickness(kMax);
        else
            distLambdas = lambdaPatch(idx-1) - lambdaPatch(idx);
            distCutoffLambda = cutoffs(h) - lambdaPatch(idx);
            fractionUp = distCutoffLambda/distLambdas;
            distThickness = thickness(idx-1) - thickness(idx);
            threshThickness(m, h) = thickness(idx)+(fractionUp*distThickness);
        end
    end

end
t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
disp('Calculating IQF Values...');tic
%Now Calculate the IQF, EXP Fit, etc.
x = diameter;
IQFFull = zeros(1,count);IQFLarge = zeros(1,count);IQFMedium = zeros(1,count);
IQFSmall = zeros(1,count);aVector = zeros(1,count);bVector = zeros(1,count);

%NEED TO INSERT AN ERROR FLAG HERE
threshThickness(isnan(threshThickness)) = 0.03; %Replaces any nan values with 0.03
threshThickness(isinf(threshThickness)) = 0.03; %Replaces any nan values with 0.03

for m = 1:count
    y = threshThickness(m,:);
    IQFdenom = x*y';
    IQFFull(m) = sum(diameter(:))./IQFdenom;
    IQFLarge(m) = sum(diameter(1:8))./(x(1:8)*y(1:8)');
    IQFMedium(m) = sum(diameter(9:16))./(x(9:16)*y(9:16)');
    IQFSmall(m) = sum(diameter(17:24))./(x(17:24)*y(17:24)');
   
    A = ones(length(diameter),2);
    B = zeros(length(diameter),1);
    B(:,1) = log(y)';
    A(:,2) = log(diameter');
    test = A\B;
    alpha = exp(test(1));
    beta = test(2);
    aVector(m) = alpha;
    bVector(m) = beta;
end
t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
disp('Plotting IQF Values...');tic
IQF.Full = zeros(nRows,nCols); IQF.Large= zeros(nRows,nCols);
IQF.Medium= zeros(nRows,nCols); IQF.Small= zeros(nRows,nCols);
for m = 1:count
    j = imgInfo(m,3);
    i = imgInfo(m,4);
    IQF.Full(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = IQFFull(m);
    IQF.Large(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFLarge(m);
    IQF.Medium(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFMedium(m);
    IQF.Small(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFSmall(m);

    aMat(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = aVector(m);
    bMat(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = bVector(m);
end
t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
end
