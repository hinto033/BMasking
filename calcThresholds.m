function [cutoffs] = calcThresholds(IDicomAvg,IDicomStdev,binDisk,...
    diameter, attenuation,beta)
%% Create Frequency Map based on beta
[r,c] = size(binDisk(:,:,1));
frequencyMap = ones(r,c);
center = [round((r/2)+1), round((c/2)+1)];
%Creates 1/f^beta fourier space map
for j = 1:r
    for h = 1:c
        if j==center(2) && h == center(1)
        else
            frequencyMap(j,h) = frequencyMap(j,h)/ ...
                (sqrt((j-center(2))^2+(h-center(1))^2))^(beta/2);
        end
    end
end
%% Create several patches to use for the thresholding
nPatches = 30;
patches = zeros(nPatches,r*c);
patches2 = zeros(nPatches,r*c);
tic
for j = 1:nPatches
    % Create patch
    imNoise = randn(r,c); imFFT = fftshift(fft2(imNoise));
    imFFTf3Noise = frequencyMap.*imFFT;
    imf3Noise = ifft2(ifftshift(imFFTf3Noise));
    Avg = mean(imf3Noise(:)); stDev = std(imf3Noise(:));
    %Adjust this noise to have same mean/stdev as mammogram
    im1StdevAdj = (imf3Noise-Avg)*(IDicomStdev/stDev);
    im1Final = real(im1StdevAdj + IDicomAvg);
    patches(j,:) = im1Final(:)';
    %Create 2nd patch
    imNoise = randn(r,c); imFFT = fftshift(fft2(imNoise));
    imFFTf3Noise = frequencyMap.*imFFT;
    imf3Noise = ifft2(ifftshift(imFFTf3Noise));
    Avg = mean(imf3Noise(:)); stDev = std(imf3Noise(:));
    %Adjust this noise to have same mean/stdev as mammogram
    im1StdevAdj = (imf3Noise-Avg)*(IDicomStdev/stDev);
    im1Final = real(im1StdevAdj + IDicomAvg);
    patches2(j,:) = im1Final(:)';
end
toc
clear imFFTf3Noise imNoise imFFT imf3Noise im1Final im1StdevAdj frequencyMap

%% Determine threshold at each Diameter
wnpw = zeros(r*c,length(attenuation));
for p = 1:length(diameter) %For each Diam
    negDisk = binDisk(:,:,p);
    str = sprintf('Calculating threshold at diameter = %0.2f mm', diameter(p));
    disp(str)
    for k = 1:length(attenuation)
        attenDisk = negDisk.*((IDicomAvg-50)'*(attenuation(k) - 1));
        wnpw(:,k) = attenDisk(:);
    end
    lambdasNoDisk = patches*wnpw;
    offsets = diag(wnpw'*wnpw)';
    offsetMatrix = repmat(offsets,nPatches,1);
    lambdasWDisk = patches2*wnpw + offsetMatrix;
    for k = 1:length(attenuation)
        noDisk = lambdasNoDisk(:,k);
        wDisk = lambdasWDisk(:,k);
        nGuesses = 200;
        percentCorrect = doGuesses(noDisk, wDisk, nGuesses, nPatches);
        if percentCorrect >= .7%.65%If guessed correctly enough .625?
            if k == length(attenuation); %Set threshold if at last atten
                thresh1 = mean(wDisk); thresh2 = mean(noDisk);
                thresh3 = (thresh1+thresh2) / 2; cutoffs(p) = thresh3;
                break
            end
        elseif percentCorrect < .7%.65%If was too inaccurate .625?
                thresh1 = mean(wDisk); thresh2 = mean(noDisk);
                thresh3 = (thresh1+thresh2) / 2; cutoffs(p) = thresh3;
                break
        end
    end
end
clear lambdasWDisk patchesWDisk lambdasNoDisk wnpw attenDisk negDisk
end

function [percentCorrect] = doGuesses(lambdasNoDisk, lambdasWDisk, nGuesses, nPatches)
    numCorrect = 0;
    for numTries = 1:nGuesses% Number of times to do
        p1 = randi([1,nPatches]); p2 = randi([1,nPatches]);
        
        if lambdasNoDisk(p1)<lambdasWDisk(p2)
            numCorrect = numCorrect + 1;
            percentCorrect = numCorrect/numTries;
        elseif lambdasNoDisk(p1)>lambdasWDisk(p2)
        end
    end
    percentCorrect = numCorrect/numTries;
end
