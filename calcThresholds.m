function [thresholdFinal] = calcThresholds(IDicomAvg,IDicomStdev,binDisk,...
    diameter, attenuation,beta)
%% Create Frequency Map based on beta
[nRows,nCols] = size(binDisk(:,:,1));
frequencyMap = ones(nRows,nCols);
center = [round((nRows/2)+1), round((nCols/2)+1)];
%Creates 1/f^beta fourier space map
for j = 1:nRows
    for h = 1:nCols
        if j==center(2) && h == center(1)
        else
            frequencyMap(j,h) = frequencyMap(j,h)/ ...
                (sqrt((j-center(2))^2+(h-center(1))^2))^(beta/2);
        end
    end
end
%% Perform the thresholding multiple times (2-3)
for nTimes = 1:3
str = sprintf('Performing Round %0.0f of Threshold Detection...', nTimes);
disp(str)
%% Create several patches to use for the thresholding
nPatches = 15;
noisePatches = zeros(nPatches,nRows*nCols);
for j = 1:nPatches
    % Create patch
    imNoise = randn(nRows,nCols); imFFT = fftshift(fft2(imNoise));
    imFFTf3Noise = frequencyMap.*imFFT;
    imf3Noise = ifft2(ifftshift(imFFTf3Noise));
    imAvg = mean(imf3Noise(:)); imStDev = std(imf3Noise(:));
    %Adjust this noise to have same mean/stdev as mammogram
    imAdjusted = (imf3Noise-imAvg)*(IDicomStdev/imStDev);
    imNoiseFinal = real(imAdjusted + IDicomAvg);
    noisePatches(j,:) = imNoiseFinal(:)';
end
clear imFFTf3Noise imNoise imFFT imf3Noise im1Final im1StdevAdj
%% Determine threshold at each Diameter
filterNPW = zeros(nRows*nCols,length(attenuation));
for p = 1:length(diameter) %For each Diam
    negDisk = binDisk(:,:,p);
    for k = 1:length(attenuation)
        attenDisk = negDisk*((IDicomAvg-50)*(attenuation(k) - 1));
        filterNPW(:,k) = attenDisk(:);
    end
    %Computes lambdas without disk for all attenuations and all patches
    lambdasNoDisk = noisePatches*filterNPW; 
    offsetWDisk = diag(filterNPW'*filterNPW)';
    offsetMatrix = repmat(offsetWDisk,nPatches,1);
    %Computes lambdas with disk for all attenuations and all patches
    lambdasWDisk = lambdasNoDisk + offsetMatrix; 
    for k = 1:length(attenuation)
        lambdasAtAttenNoDisk = lambdasNoDisk(:,k); %Separates lambdas of single attenuation
        lambdasAtAttenWDisk = lambdasWDisk(:,k); %Separates lambdas of single attenuation
        nGuesses = 100;
        percentCorrect = doGuesses(lambdasAtAttenNoDisk, lambdasAtAttenWDisk, nGuesses, nPatches);
        if percentCorrect >= .7 %If guessed correctly enough ->don't set threshold
            if k == length(attenuation); %Set threshold if at last atten
                threshWDisk = mean(lambdasAtAttenWDisk);
                threshNoDisk = mean(lambdasAtAttenNoDisk);
                threshAvg = (threshWDisk+threshNoDisk) / 2;
                thresholdDetection(nTimes,p) = threshAvg;
                break
            end
        elseif percentCorrect < .7 %If was too inaccurate -> Set threshold
                threshWDisk = mean(lambdasAtAttenWDisk);
                threshNoDisk = mean(lambdasAtAttenNoDisk);
                threshAvg = (threshWDisk+threshNoDisk) / 2;
                thresholdDetection(nTimes,p) = threshAvg;
                break
        end
    end
end
end
thresholdFinal = mean(thresholdDetection);
clear lambdasWDisk patchesWDisk lambdasNoDisk wnpw attenDisk negDisk
end
function [percentCorrect] = doGuesses(lambdasAtAttenNoDisk, lambdasAtAttenWDisk,...
    nGuesses, nPatches)
    numCorrect = 0;
    for numTries = 1:nGuesses% Number of times to do
        patchSelection = randperm(nPatches, 2);
        p1 = patchSelection(1);
        p2 = patchSelection(2);
        if lambdasAtAttenNoDisk(p1)<lambdasAtAttenWDisk(p2)
            numCorrect = numCorrect + 1;
            percentCorrect = numCorrect/numTries;
        elseif lambdasAtAttenNoDisk(p1)>lambdasAtAttenWDisk(p2)
        end
    end
    percentCorrect = numCorrect/numTries;
end
