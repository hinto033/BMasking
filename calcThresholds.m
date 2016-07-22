function [cutoffs] = calcThresholds(IDicomAvg,IDicomStdev,attenDisks,...
    diameter, attenuation,beta)
%% Create Frequency Map based on beta
[r,c] = size(attenDisks(:,:,1));
endingPercentages = zeros(length(diameter),length(attenuation));
frequencyMap = ones(r,c);
center = [round((r/2)+1), round((c/2)+1)];
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
nPatches = 20;
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

tic
for p = 1:length(diameter) %For each Diam
    negDisk = attenDisks(:,:,p);
    kk = sprintf('Calculating threshold at diameter = %0.2f mm', diameter(p));
    disp(kk)
    for k = 1:length(attenuation) %For each Thickness
        
        attenDisk = negDisk.*((IDicomAvg-50)'*(attenuation(k) - 1));
        wnpw = attenDisk(:);
        %Calculate the 50 lambdas without the disk
        lambdasNoDisk = patches*wnpw;
        %Calculate the 50 lambdas with the disk
        patchesWDisk = patches2 + repmat(wnpw, 1, nPatches)';
        lambdasWDisk = patchesWDisk*wnpw;
        nGuesses = 50;
        percentCorrect = doGuesses(lambdasNoDisk, lambdasWDisk, nGuesses, nPatches);
        if percentCorrect >= .7%.65%If guessed correctly enough .625?
            if k == length(attenuation); %Set threshold if at last atten
                thresh1 = mean(lambdasWDisk); thresh2 = mean(lambdasNoDisk);
                thresh3 = (thresh1+thresh2) / 2; cutoffs(p) = thresh3;
                break
            end
        elseif percentCorrect < .7%.65%If was too inaccurate .625?
                thresh1 = mean(lambdasWDisk); thresh2 = mean(lambdasNoDisk);
                thresh3 = (thresh1+thresh2) / 2; cutoffs(p) = thresh3;
                break
        end
    end
end
toc
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


% %% Create Frequency Map based on beta
% [r,c] = size(attenDisks(:,:,1));
% endingPercentages = zeros(length(diameter),length(attenuation));
% frequencyMap = ones(r,c);
% center = [round((r/2)+1), round((c/2)+1)];
% for j = 1:r
%     for h = 1:c
%         if j==center(2) && h == center(1)
%         else
%             frequencyMap(j,h) = frequencyMap(j,h)/ ...
%                 (sqrt((j-center(2))^2+(h-center(1))^2))^(beta/2);
%         end
%     end
% end
% %% Create several patches to use for the thresholding
% nPatches = 50;
% patches = zeros(r,c,nPatches);
% 
% for j = 1:nPatches
%     % Create patch
%     imNoise = randn(r,c); imFFT = fftshift(fft2(imNoise));
%     imFFTf3Noise = frequencyMap.*imFFT;
%     imf3Noise = ifft2(ifftshift(imFFTf3Noise));
%     Avg = mean(imf3Noise(:)); stDev = std(imf3Noise(:));
%     %Adjust this noise to have same mean/stdev as mammogram
%     im1StdevAdj = (imf3Noise-Avg)*(IDicomStdev/stDev);
%     im1Final = real(im1StdevAdj + IDicomAvg);
%     patches(:,:,j) = im1Final;
% end
% %% Perform 2AFC Method
% for p = 1:length(diameter) %For each Diam
%     negDisk = attenDisks(:,:,p);
%     kk = sprintf('Calculating threshold at diameter = %0.2f mm', diameter(p));
%     disp(kk)
%     for k = 1:length(attenuation) %For each Thickness
%         numAttempts = 10;
%         [percentCorrect, lambSignal, lambNoSignal] = doGuesses(numAttempts,...
%             patches, nPatches, negDisk, attenuation, k);
%         endingPercentages(p,k) = percentCorrect;
%         if percentCorrect > .8%.65%If guessed correctly enough .625?
%             if k == length(attenuation); %Set threshold if at last atten
%                 thresh1 = mean(lambSignal); thresh2 = mean(lambNoSignal);
%                 thresh3 = (thresh1+thresh2) / 2; cutoffs(p) = thresh3;
%                 break
%             end
%         elseif percentCorrect <= .8%.65%If was too inaccurate .625?
%             numCorrect = 0;  numAttempts = 40;
%             [percentCorrect, lambSignal, lambNoSignal] = doGuesses(numAttempts,...
%                 patches, nPatches, negDisk, attenuation, k);
%             endingPercentages(p,k) = percentCorrect;
%             if percentCorrect <=0.7 %set the thresholdvalue
%                 thresh1 = mean(lambSignal); thresh2 = mean(lambNoSignal);
%                 thresh3 = (thresh1+thresh2) / 2; cutoffs(p) = thresh3;
%                 break
%             else
%                 if k == length(attenuation); %Set threshold if at last atten
%                     thresh1 = mean(lambSignal); thresh2 = mean(lambNoSignal);
%                     thresh3 = (thresh1+thresh2) / 2; cutoffs(p) = thresh3;
%                     break
%                 end
%             end
%         end
%     end
% end
% end
% %%The function that does the 2AFC procedure
% function [percentCorrect, lambSignal, lambNoSignal] = doGuesses(numAttempts,...
%     patches, nPatches, negDisk, attenuation, k)
%     numCorrect = 0;
%     for numTries = 1:numAttempts% Number of times to do
%         p1 = randi([1,nPatches]); p2 = randi([1,nPatches]);
%         img1 = patches(:,:,p1); img2 = patches(:,:,p2);
%         %Insert Disk into one image
%         attenDisk = negDisk.*((img1-50)'*(attenuation(k) - 1));
%         imgWDisk = attenDisk+img1; imgWoDisk = img2;
%         %Perform NPWMF for the signal-present image
%         wnpw = attenDisk(:);
%         gTest = imgWDisk(:);  lambda_1 = wnpw'*gTest;
%         gTest = imgWoDisk(:); lambda_2 = wnpw'*gTest;
%         %Make choice of larger lambda value as my guess
%         if lambda_1 > lambda_2 %if the Correct guess
%             numCorrect = numCorrect + 1;
%             percentCorrect = numCorrect/numTries;
%         else  %If the Incorrect guess
%         end
%         lambSignal(numTries) = lambda_1; lambNoSignal(numTries) = lambda_2;
%     end
%     percentCorrect = numCorrect/numTries;
% end