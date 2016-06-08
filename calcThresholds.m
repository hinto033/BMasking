function [cutoffs] = calcThresholds(IDicomOrig, attenDisks,...
    diameter, attenuation)
[r,c] = size(attenDisks(:,:,1));

%% Test Region
maskingMap = IDicomOrig;
maskingMap= maskingMap./max(maskingMap(:));
maskingMap1 = im2bw(maskingMap,0.20);
maskingMap2 = im2bw(maskingMap,0.05);

avgtest1 = mean2(IDicomOrig(700:2500,1:1200))
stdevtest1 = std2(IDicomOrig(700:2500,1:1200))
% 
% figure
% imshow(IDicomOrig,[])
% figure
% imshow(maskingMap1,[])
% figure
% imshow(maskingMap2,[])


maskingMap = im2bw(maskingMap,0.06);
maskingMap = imcomplement(maskingMap);
IDicomOrig = IDicomOrig .* maskingMap;

IDicomVector = IDicomOrig(:);
IDicomVectorNoZeros =IDicomVector(IDicomVector~=0);

IDicomAvg = mean(IDicomVectorNoZeros)
IDicomStdev = std(IDicomVectorNoZeros)


IDicomAvg = avgtest1
IDicomStdev = stdevtest1
% pause
%% Determine Statistics
% %Create Mask & Threshold 
% maskingMap = IDicomOrig;
% maskingMap= maskingMap./max(maskingMap(:));
% maskingMap = im2bw(maskingMap,0.10);
% maskingMap = imcomplement(maskingMap);
% IDicomOrig = IDicomOrig .* maskingMap;
% [a,b] = size(IDicomOrig)
% %**************************DO THIS******************
% %Remove the Phantom
% %**************************DO THIS******************
% %Calculate mean and stdev
% IDicomVector = IDicomOrig(:);
% IDicomVectorNoZeros =IDicomVector(IDicomVector~=0);
% 



% %% Test Region
% %May need to adjust thresholding so I just get the main part of the breast
% IDicomAvg = mean(IDicomVectorNoZeros)
% IDicomStdev = std(IDicomVectorNoZeros)
% 
% avgtest1 = mean2(IDicomOrig(1200:2000,400:1200))
% stdevtest1 = std2(IDicomOrig(1200:2000,400:1200))
% [B,L,N,A] = bwboundaries(maskingMap);
% N;
% maxSize = 0;
% for u = 1:N
%     sizePatch = length(B{u});
%     if sizePatch >= maxSize
%         segmentNum = u;
%         maxSize = sizePatch;
%     end
% end
% length(B{segmentNum});
% maxSize;
% 
% 
% testTemplate = zeros(a,b);
% pixelsWOnes = B{segmentNum};
% 
% for u = 1:maxSize
%     ind = pixelsWOnes(u,:);
%     testTemplate(ind(1),ind(2)) = 1;
% end
% testTemplate2 = imfill(testTemplate);
% figure
% imshow(testTemplate)
% figure
% imshow(testTemplate2)
% 
% 
% IDicomOrig = IDicomOrig .* testTemplate2;
% %Calculate mean and stdev
% IDicomVector = IDicomOrig(:);
% IDicomVectorNoZeros =IDicomVector(IDicomVector~=0);
% %May need to adjust thresholding so I just get the main part of the breast
% IDicomAvg = mean(IDicomVectorNoZeros)
% IDicomStdev = std(IDicomVectorNoZeros)
% 
% avgtest1 = mean2(IDicomOrig(1200:2000,400:1200))
% stdevtest1 = std2(IDicomOrig(1200:2000,400:1200))
% 
% figure
% imshow(IDicomOrig,[])
% 
% 
% % length(B)
% % length(B{1})
% % length(B{2})
% % B{2}
% % figure
% % imshow(IDicomOrig, [])
% pause
%%

% Determine the noise amount or just assume it is 1/f3
% For now I am doing 1/f3
endingPercentages = zeros(length(diameter),length(attenuation));
frequencyMap = ones(r,c);
center = [round((r/2)+1), round((c/2)+1)];
for j = 1:r
    for h = 1:c
        if j==center(2) && h == center(1)
        else
            frequencyMap(j,h) = frequencyMap(j,h)/ ...
                (sqrt((j-center(2))^2+(h-center(1))^2))^(3/2);
        end
    end
end
for p = 1:length(diameter) %For each Diam
    negDisk = attenDisks(:,:,p);
    for k = 1:length(attenuation) %For each Thickness
        numCorrect = 0;
        for numTries = 1:40% Number of times to do
            %% Create 1st patch
            imNoise1 = randn(r,c); imFFT1 = fftshift(fft2(imNoise1));
            %Multiply IFFT by 1/f3 map
            imFFTf3Noise1 = frequencyMap.*imFFT1;
            %IFFT to make 1/f3 noise image
            imf3Noise1 = ifft2(ifftshift(imFFTf3Noise1)); 
%             figure; imshow(imf3Noise1,[])
            Avg1 = mean(imf3Noise1(:)); stDev1 = std(imf3Noise1(:));
            %Adjust this noise to have same mean/stdev as mammogram
            im1StdevAdj = (imf3Noise1-Avg1)*(IDicomStdev/stDev1);
            im1Final = real(im1StdevAdj + IDicomAvg);
            %Calculate the disk (which is my signal to detect)
            img1Avg = mean2(im1Final);
            attenDisk = negDisk.*((img1Avg-50)'*(attenuation(k) - 1));
%             figure; imshow(attenDisk,[])
            attenDisk = negDisk.*((im1Final-50)'*(attenuation(k) - 1));
%             figure; imshow(attenDisk,[])
%             pause
            %Insert Disk into that image
            imgWDisk = attenDisk+im1Final;
            %Perform NPWMF for the signal-present image
            wnpw = attenDisk(:); gTest = imgWDisk(:);
            lambda_1 = wnpw'*gTest;
%             figure; imshow(imgWDisk,[])
            %% Create 2nd patch
            imNoise2 = randn(r,c); imFFT2 = fftshift(fft2(imNoise2));
            %Multiply IFFT by 1/f3 map
            imFFTf3Noise2 = frequencyMap.*imFFT2;
            %IFFT to make 1/f3 noise image
            imf3Noise2 = ifft2(ifftshift(imFFTf3Noise2));
            Avg2 = mean(imf3Noise2(:));stDev2 = std(imf3Noise2(:));
            %Adjust this noise to have same mean/stdev as mammogram
            im2StdevAdj = (imf3Noise2-Avg2)* (IDicomStdev/stDev2);
            im2Final = real(im2StdevAdj + IDicomAvg);
            %Perform NPWMF for the signal-Absent image
            wnpw = attenDisk(:); gTest = im2Final(:);
            lambda_2 = wnpw'*gTest;
%             figure; imshow(im2Final,[])
%             pause
            %Make choice of larger lambda value as my guess
            if lambda_1 > lambda_2 %if the Correct guess
                numCorrect = numCorrect + 1;
                percentCorrect = numCorrect/numTries;
            else  %If the Incorrect guess
            end
            %Store lambda values
            lambSignal(numTries) = lambda_1;
            lambNoSignal(numTries) = lambda_2;

        end
        percentCorrect = numCorrect/numTries;
        endingPercentages(p,k) = percentCorrect
        fprintf('%1.2f percent correct at column %1.1f\n', percentCorrect, k)
        if percentCorrect >= .65%If guessed correctly enough .625?
        elseif percentCorrect < .65%If was too inaccurate .625?
            disp('set the thresholdvalue')
            thresh1 = mean(lambSignal); thresh2 = mean(lambNoSignal);
            thresh3 = (thresh1+thresh2) / 2;
            format long
            cutoffs(p) = thresh3
            break
        end
    end
end
format short

format long
