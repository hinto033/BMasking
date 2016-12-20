function [threshThickness, errFlags] = determineDetectability(imgInfo,imgPatch, ...
    binDisk, thickness, diameter, IDicomAvg,IDicomStdev, analysisChoice,...
    errFlags, radius, attenuation,regionnRow,regionNCol, beta)

pMax = length(radius); kMax = length(attenuation);
[nRowPatch,nColPatch] = size(binDisk(:,:,1));
if strcmp(analysisChoice, 'Similar') ==1
    %% Calculate the thresholds by using nearby patches
    paddedLocations = imgInfo(:,1:2);
    [nValidPatches,~] = size(paddedLocations);
    thresholdFinal = zeros(nValidPatches,length(diameter));
    nPatches = 5;
    threshThickness = zeros(nValidPatches, pMax);
    for kk = 1:nValidPatches
        kk
        %**** NEED to adjust to choose image patches that are of similar mean,
        %stdev, NPS, etc.
        %**** That will involve altering findImagePatches as well.
        patchLocation = imgInfo(kk,1:2);
        patchOffset = repmat(patchLocation, nValidPatches,1);
        patchOffset = paddedLocations-patchOffset;
        distToPatch = patchOffset(:,1).^2 + patchOffset(:,2).^2; %This is what will chagne.
        [n,idx] = sort(distToPatch);
        noisePatches(1,:) = imgPatch(:,idx(1))';
        noisePatches(2,:) = imgPatch(:,idx(2))';
        noisePatches(3,:) = imgPatch(:,idx(3))';
        noisePatches(4,:) = imgPatch(:,idx(4))';
        noisePatches(5,:) = imgPatch(:,idx(5))';

        filterNPW = zeros(regionnRow*regionNCol,length(attenuation));
        for p = 1:length(diameter) %For each Diam
            negDisk = binDisk(:,:,p);
            for k = 1:length(attenuation)
                attenDisk = negDisk*((IDicomAvg-50)*(attenuation(k) - 1));
                filterNPW(:,k) = attenDisk(:);
            end
            %Computes lambdas without disk for all attenuations and all patches
            lambdasNoDisk = noisePatches*filterNPW; %Costly TimeWise
            offsetWDisk = diag(filterNPW'*filterNPW)'; %Costly timewise
            offsetMatrix = repmat(offsetWDisk,nPatches,1); %Fine
            %Computes lambdas with disk for all attenuations and all patches
            lambdasWDisk = lambdasNoDisk + offsetMatrix; 
            for k = 1:length(attenuation)
                lambdasAtAttenNoDisk = lambdasNoDisk(:,k); %Separates lambdas of single attenuation
                lambdasAtAttenWDisk = lambdasWDisk(:,k); %Separates lambdas of single attenuation
                numCorrect = 0;
                for numTries = 1:((nPatches-1)*2)% Number of times to do
                    patchSelection = [ones(1,nPatches-1), 2:nPatches; 2:nPatches,ones(1,nPatches-1)];
                    p1 = patchSelection(1,numTries);
                    p2 = patchSelection(2,numTries);
                    if lambdasAtAttenNoDisk(p1)<lambdasAtAttenWDisk(p2)
                        numCorrect = numCorrect + 1;
                        percentCorrect = numCorrect/numTries;
                    elseif lambdasAtAttenNoDisk(p1)>lambdasAtAttenWDisk(p2)
                    end
                end
                percentCorrect = numCorrect/numTries;
                if percentCorrect >= .7 %If guessed correctly enough ->don't set threshold
                    if k == length(attenuation); %Set threshold if at last atten
                        threshThickness(kk,p) = thickness(k);
                        break
                    end
                elseif percentCorrect < .7 %If was too inaccurate -> Set threshold 
                    threshThickness(kk,p) = thickness(k);
                        break
                end
            end
        end
    end
elseif strcmp(analysisChoice, 'Simulate') ==1
    [nValidPatches,~] = size(imgInfo);
    [cutoffs] = calcThresholds(IDicomAvg,IDicomStdev,binDisk,...
       diameter, attenuation,beta);
    t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
    clear IDicomOrig 
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
end
errFlags=errFlags;
