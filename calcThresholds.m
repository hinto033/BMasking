function [cutoffs] = calcThresholds(IDicomOrig, attenDisks,...
    diameter, attenuation)
[r,c] = size(attenDisks(:,:,1));
maskingMap = IDicomOrig;
maskingMap= maskingMap./max(maskingMap(:));
maskingMap1 = im2bw(maskingMap,0.20);
maskingMap1 = imcomplement(maskingMap1);

[labeledImage, numberOfBlobs] = bwlabel(maskingMap1);
blobMeasurements = regionprops(labeledImage, 'area', 'Centroid');
allAreas = [blobMeasurements.Area]; numToExtract = 1;

[sortedAreas, sortIndexes] = sort(allAreas, 'descend');
biggestBlob = ismember(labeledImage, sortIndexes(1:numToExtract));
% Convert from integer labeled image into binary (logical) image.
maskingMap1 = biggestBlob > 0; maxArea = max(sortedAreas);
maskingMap1(1,:) = 0; maskingMap1(:,1) = 0;
maskingMap1(end,:) = 0; maskingMap1(:,end) = 0;

IDicomOrig = IDicomOrig .* maskingMap1;

se = strel('disk',5,6);
count = 1; trigger = 0;
while trigger == 0
maskingMap1 = imerode(maskingMap1,se);
IDicomOrig = IDicomOrig .* maskingMap1;
IDicomVector = IDicomOrig(:);
IDicomVectorNoZeros =IDicomVector(IDicomVector~=0);
reducedArea = length(IDicomVectorNoZeros);
if reducedArea/maxArea <=0.5
    trigger=1;
end
IDicomAvg = mean(IDicomVectorNoZeros);
IDicomStdev = std(IDicomVectorNoZeros);
end
% Determine the noise amount or just assume it is 1/f3
% For now I am doing 1/f3
endingPercentages = zeros(length(diameter),length(attenuation));
frequencyMap = ones(r,c);
center = [round((r/2)+1), round((c/2)+1)];
beta = 3;
for j = 1:r
    for h = 1:c
        if j==center(2) && h == center(1)
        else
            frequencyMap(j,h) = frequencyMap(j,h)/ ...
                (sqrt((j-center(2))^2+(h-center(1))^2))^(beta/2);
        end
    end
end
%Create several patches
tic
nPatches = 50;
patches = zeros(r,c,nPatches);
for j = 1:nPatches
    % Create patch
    imNoise = randn(r,c); imFFT = fftshift(fft2(imNoise));
    imFFTf3Noise = frequencyMap.*imFFT;
    imf3Noise = ifft2(ifftshift(imFFTf3Noise));
    Avg = mean(imf3Noise(:)); stDev = std(imf3Noise(:));
    %Adjust this noise to have same mean/stdev as mammogram
    im1StdevAdj = (imf3Noise-Avg)*(IDicomStdev/stDev);
    im1Final = real(im1StdevAdj + IDicomAvg);
    patches(:,:,j) = im1Final;
end
toc

tic
for p = 1:length(diameter) %For each Diam
    negDisk = attenDisks(:,:,p);
    for k = 1:length(attenuation) %For each Thickness
        numCorrect = 0;
        for numTries = 1:10% Number of times to do
            p1 = randi([1,nPatches]);
            p2 = randi([1,nPatches]);
            img1 = patches(:,:,p1);
            img2 = patches(:,:,p2);
            %Insert Disk into that image
            attenDisk = negDisk.*((img1-50)'*(attenuation(k) - 1));
            imgWDisk = attenDisk+img1;
            imgWoDisk = img2;
            %Perform NPWMF for the signal-present image
            wnpw = attenDisk(:); gTest = imgWDisk(:);
            lambda_1 = wnpw'*gTest;
            gTest = imgWoDisk(:);
            lambda_2 = wnpw'*gTest;
            %Make choice of larger lambda value as my guess
            if lambda_1 > lambda_2 %if the Correct guess
                numCorrect = numCorrect + 1;
                percentCorrect = numCorrect/numTries;
            else  %If the Incorrect guess
            end
            lambSignal(numTries) = lambda_1;
            lambNoSignal(numTries) = lambda_2;
        end
        percentCorrect = numCorrect/numTries;
        endingPercentages(p,k) = percentCorrect;
        fprintf('%1.2f percent correct at column %1.1f\n', percentCorrect, k)
        if percentCorrect > .7%.65%If guessed correctly enough .625?
        elseif percentCorrect <= .7%.65%If was too inaccurate .625?
            numCorrect = 0;
            for numTries = 1:40% Number of times to do
            p1 = randi([1,nPatches]);
            p2 = randi([1,nPatches]);
            img1 = patches(:,:,p1);
            img2 = patches(:,:,p2);
            %Insert Disk into that image
            attenDisk = negDisk.*((img1-50)'*(attenuation(k) - 1));
            imgWDisk = attenDisk+img1;
            imgWoDisk = img2;
            %Perform NPWMF for the signal-present image
            wnpw = attenDisk(:); gTest = imgWDisk(:);
            lambda_1 = wnpw'*gTest;
            gTest = imgWoDisk(:);
            lambda_2 = wnpw'*gTest;
            %Make choice of larger lambda value as my guess
            if lambda_1 > lambda_2 %if the Correct guess
                numCorrect = numCorrect + 1;
                percentCorrect = numCorrect/numTries;
            else  %If the Incorrect guess
            end
            lambSignal(numTries) = lambda_1;
            lambNoSignal(numTries) = lambda_2;
            end
            
            percentCorrect = numCorrect/numTries;
            endingPercentages(p,k) = percentCorrect;
            fprintf('%1.2f percent correct after trying again at column %1.1f\n', percentCorrect, k)
            
            if percentCorrect <=0.65
            disp('set the thresholdvalue')
            thresh1 = mean(lambSignal); thresh2 = mean(lambNoSignal);
            thresh3 = (thresh1+thresh2) / 2;
            format long
            cutoffs(p) = thresh3
            break
            end
        end
    end
end
toc