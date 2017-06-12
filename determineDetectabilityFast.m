function [threshThickness, errFlags] = determineDetectabilityFast(imgInfo,imgPatch, ...
    binDisk, thickness, diameter, IDicomAvg,IDicomStdev, analysisChoice,...
    errFlags, radius, attenuation,regionnRow,regionNCol, beta)
errFlags.DetectError = 0;
[nRowPatch,nColPatch] = size(binDisk(:,:,1));

%vectorizes and arranges the virtual lesions of all diameters as a matrix. 
%Each column is a different diameter disk that is vectorized
%First column is the largest disk, each subsequent column is smaller Diam
binDiskFlat = reshape(binDisk, 1, nRowPatch*nColPatch, length(diameter));
% figure  %To View
% scatter(1:nRowPatch*nColPatch,squeeze(binDiskFlat(1,:,1)))

%Stacks that previous matrix on top of each other so that I can make each
%stack of disk diameters have different attenuations
%First stack - largest attenuation, last stack - smallest attenuation
binDiskMatrix = repmat(binDiskFlat, [length(thickness) 1 1]);

%Makes similar sized matrix so that I can make it vary by attenuation
transparency = 1 - attenuation';
transparencyMatrix = repmat(transparency, [1,nRowPatch*nColPatch, length(diameter)]);
%Multiplies attenuation matrix through the disk size matrix
finalDiskMatToMult = (1 - (transparencyMatrix.*binDiskMatrix));
finalDiskMatIDicomAvgAllDiams = ((IDicomAvg-50)*finalDiskMatToMult) - (IDicomAvg-50);


%% Experimental Section that make the search region all the max diam size
finalDiskMatIDicomAvg = repmat(finalDiskMatIDicomAvgAllDiams(:,:,1), [1,1,12]);
% size(finalDiskMatIDicomAvg)
%%
%(a,b,c)  a-vary by attenuation  b-goes through a disk image c-changes
%diameter
% figure
% scatter(1:nRowPatch*nColPatch, finalDiskMatIDicomAvg(5,:,4))
% figure
% scatter(1:nRowPatch*nColPatch, finalDiskMatIDicomAvg(5,:,1))
% pause

%Clears to reduce RAM
clear transparencyMatrix
clear binDiskMatrix

%Calculates NPW Lambda Value if no disk inserted in the image
[~ , nPatches] = size(imgPatch);
lambdaNoDisk = zeros(length(thickness), nPatches, length(diameter));
for p = 1:length(diameter)
    lambdaNoDisk(:,:,p) = squeeze(finalDiskMatIDicomAvg(:,:,p)*imgPatch);
end

%Calculates Offset Vector and Matrix
% Of same size and dimensions as Other matrices
%(this allows easy conversion from NPW Lambda
%without lesion to NPW Lambda with lesion
%Essentially adds a dot product of the disc lesion with itself.
offsetVector = zeros(length(thickness), 1, length(diameter));
for p = 1:length(diameter)
    A = squeeze(finalDiskMatIDicomAvgAllDiams(:,:,p));
    offsetVector(:,1,p)= sum(A.*A,2);
end
offsetMatrix = repmat(offsetVector, [1, nPatches, 1]);

%Calculates the Lambda Values with the disk lesion
lambdaWDisk = lambdaNoDisk+offsetMatrix;

% analysisChoice

%Calculates CD Curves/IQF Values  Based on whatever criteria you set.
if strcmp(analysisChoice, 'Similar by Statistics') ==1
    %Normalizes the mean/stdev
%     imgInfo(:,5)
    imgInfo(:,5) = imgInfo(:,5) / max(imgInfo(:,5));
    imgInfo(:,6) = imgInfo(:,6) / max(imgInfo(:,6));
    pMax = length(radius); kMax = length(attenuation);

    paddedLocations = imgInfo(:,1:2);
    paddedStats = imgInfo(:,5:6);
    [nValidPatches,~] = size(paddedLocations);
    thresholdFinal = zeros(nValidPatches,length(diameter));
    nPatches = 11;
    threshThickness = zeros(nValidPatches, pMax);
    counttt = 0;
    for kk = 1:nValidPatches
        patchStat = imgInfo(kk,5:6);
        statOffset = repmat(patchStat, nValidPatches, 1);
        statOffset = paddedStats - statOffset;
        medWeight = .8;
        stdWeight = .2;
        diffInStats = ((medWeight*(statOffset(:,1).^2)) + (stdWeight*(statOffset(:,2).^2)))/2;
        [n,idx] = sort(diffInStats);
        for dd = 1:length(diameter)
            testMat = horzcat(lambdaWDisk(:,kk,dd),lambdaNoDisk(:,idx(2:nPatches),dd));
            [testmatSort, idxSort] = sort(testMat, 2);
            
%             if dd == 7 %|| dd ==1 %If we're looking at a smaller virt. lesion
%             testMat
%             testmatSort
%             idxSort
%             
%             pause
%             end
            
            colNumThresh = ceil(0.7*((nPatches-1)));
            bestRow = min(find(idxSort(:,colNumThresh)==1));
            if isempty(bestRow)
                errFlags.DetectError = errFlags.DetectError + 1;
                threshThickness(kk,dd) = 4;
            elseif bestRow == 1
                errFlags.DetectError = errFlags.DetectError + 1;
                threshThickness(kk,dd) = 4;
            else
                counttt=counttt+1;
                threshThickness(kk,dd) = thickness(bestRow);
            end
        end
    end
    counttt;
elseif strcmp(analysisChoice, 'Similar by Location') ==1
    %Normalizes the mean/stdev
    imgInfo(:,5) = imgInfo(:,5) / max(imgInfo(:,5));
    imgInfo(:,6) = imgInfo(:,6) / max(imgInfo(:,6));
    pMax = length(radius); kMax = length(attenuation);

    paddedLocations = imgInfo(:,1:2);
    paddedStats = imgInfo(:,5:6);
    [nValidPatches,~] = size(paddedLocations);
    thresholdFinal = zeros(nValidPatches,length(diameter));
    nPatches = 11;
    threshThickness = zeros(nValidPatches, pMax);

    counttt = 0;
    for kk = 1:nValidPatches
        patchLoc = paddedLocations(kk,1:2);
        LocOffset = repmat(patchLoc, nValidPatches, 1);
        LocOffset = paddedStats - LocOffset;
        diffInStats = LocOffset(:,1).^2 + LocOffset(:,2).^2;
        [n,idx] = sort(diffInStats);
        for dd = 1:length(diameter)
            testMat = horzcat(lambdaWDisk(:,kk,dd),lambdaNoDisk(:,idx(2:nPatches),dd));
            [testmatSort, idxSort] = sort(testMat, 2);
%             if dd == 7 %|| dd ==1 %If we're looking at a smaller virt. lesion
%             testMat
%             testmatSort
%             idxSort
%             
%             pause
%             end
            colNumThresh = ceil(0.7*((nPatches-1)));
            
%             pause
            bestRow = min(find(idxSort(:,colNumThresh)==1));
            if isempty(bestRow)
                errFlags.DetectError = errFlags.DetectError + 1;
                threshThickness(kk,dd) = 4;
            elseif bestRow == 1
                errFlags.DetectError = errFlags.DetectError + 1;
                threshThickness(kk,dd) = 4;
            else
                counttt=counttt+1;
                threshThickness(kk,dd) = thickness(bestRow);
            end
        end
    end
    counttt;
elseif strcmp(analysisChoice, 'Simulate') ==1
    [nValidPatches,~] = size(imgInfo);
    [cutoffs] = calcThresholds(IDicomAvg,IDicomStdev,binDisk,...
       diameter, attenuation,beta);
    t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
    clear IDicomOrig 
    %Calculate the lambda for every disk/diameter
    disp('Calculating Lambda Values...');tic
    pMax = length(radius); kMax = length(attenuation);
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
end
errFlags=errFlags;
