function [Done] = saveIQFData(aMat, bMat, aMatc, bMatc, IQF, IQFc, DICOMData,...
    SigmaPixels,attenuation,part1, part2, FileName_Naming, beta, j, errFlags, savedir)
% mean, stdev, sum, entropy, kurtosis, skewness, 5th percentile, 25th
% percentile, 75th percentile, 95th percentile, GLCM Contrast, GLCM
% correlation, GLCM Energy, (All for full, small, med, large)
% GLCM Homogeneity, BIRADS, VBD
disp('Calculating the statistics of the IQF levels...'); tic
% A1 = char(part1{j});
% A2 = char(part2{j});
A1 = '';
A2 = '';
A3 = char(FileName_Naming{j});
aMatVector = aMat(:); aMatVectorNoZeros = aMatVector(aMatVector~=0);
aVals = aMatVectorNoZeros;
bMatVector = bMat(:); bMatVectorNoZeros = bMatVector(bMatVector~=0);
bVals = bMatVectorNoZeros;

stats.imgA.Mean = mean(aVals);
stats.imgA.Median = median(aVals); 
stats.imgA.Sum = sum(aVals); 
stats.imgA.Pctile10 = prctile(aVals,10);
stats.imgA.Pctile25 = prctile(aVals,25); 
stats.imgA.Pctile75 = prctile(aVals,75);
stats.imgA.Pctile90 = prctile(aVals,90);
stats.imgB.Mean = mean(bVals);
stats.imgB.Median = median(bVals); 
stats.imgB.Sum = sum(bVals); 
stats.imgB.Pctile10 = prctile(bVals,10); 
stats.imgB.Pctile25 = prctile(bVals,25);
stats.imgB.Pctile75 = prctile(bVals,75); 
stats.imgB.Pctile90 = prctile(bVals,90); 

%1 = full, 2=small, 3=medium, 4=large
names = {'Full', 'Small', 'Medium','Large'};
for y = 1:4
    if y==1; img = IQF.Full;
    elseif y==2; img = IQF.Small;
    elseif y==3; img = IQF.Medium;
    elseif y==4; img = IQF.Large;
    end
    imgVector = img(:);
    imgVectorNoZeros = imgVector(imgVector~=0);
    IQFvals = imgVectorNoZeros;
    totPx = length(IQFvals);
    pctPxBelow05 = length(IQFvals(IQFvals<.5))/totPx;stats.(names{y}).pctBelowPnt5 = pctPxBelow05;
    pctPxBelow1 = length(IQFvals(IQFvals<1))/totPx;stats.(names{y}).pctBelow1 = pctPxBelow1;
    pctPxBelow125 = length(IQFvals(IQFvals<1.25))/totPx;stats.(names{y}).pctBelow1Pnt25 = pctPxBelow125;
    pctPxBelow15 = length(IQFvals(IQFvals<1.5))/totPx;stats.(names{y}).pctBelow1Pnt5 = pctPxBelow15;
    pctPxBelow2 = length(IQFvals(IQFvals<2))/totPx;stats.(names{y}).pctBelow2 = pctPxBelow2;
    pctPxBelow3 = length(IQFvals(IQFvals<3))/totPx;stats.(names{y}).pctBelow3 = pctPxBelow3;
    pctPxBelow4 = length(IQFvals(IQFvals<4))/totPx;stats.(names{y}).pctBelow4 = pctPxBelow4;
    pctPxBelow5 = length(IQFvals(IQFvals<5))/totPx;stats.(names{y}).pctBelow5 = pctPxBelow5;
    pctPxBelow7 = length(IQFvals(IQFvals<7))/totPx;stats.(names{y}).pctBelow7 = pctPxBelow7;
    pctPxBelow10 = length(IQFvals(IQFvals<10))/totPx;stats.(names{y}).pctBelow10 = pctPxBelow10;
    pctPxBelow12 = length(IQFvals(IQFvals<12))/totPx;stats.(names{y}).pctBelow12 = pctPxBelow12;
    pctPxBelow14 = length(IQFvals(IQFvals<14))/totPx;stats.(names{y}).pctBelow14 = pctPxBelow14;
    pctPxBelow16 = length(IQFvals(IQFvals<16))/totPx;stats.(names{y}).pctBelow16 = pctPxBelow16;
    pctPxBelow18 = length(IQFvals(IQFvals<18))/totPx;stats.(names{y}).pctBelow18 = pctPxBelow18;
    pctPxBelow20 = length(IQFvals(IQFvals<20))/totPx;stats.(names{y}).pctBelow20 = pctPxBelow20;
    imgMean = mean(IQFvals); stats.(names{y}).Mean = imgMean;
    imgMedian = median(IQFvals); stats.(names{y}).Median = imgMedian;
    imgStDev = std(IQFvals); stats.(names{y}).StDev = imgStDev;
    imgSum = sum(IQFvals); stats.(names{y}).Sum = imgSum;
    imgEntropy = entropy(IQFvals); stats.(names{y}).Entropy = imgEntropy;
    imgKurtosis = kurtosis(IQFvals); stats.(names{y}).Kurtosis = imgKurtosis;
    imgSkewness = skewness(IQFvals); stats.(names{y}).Skewness = imgSkewness;
    img10thPercentile = prctile(IQFvals,10); stats.(names{y}).Pctile10 = img10thPercentile;
    img25thPercentile = prctile(IQFvals,25); stats.(names{y}).Pctile25 = img25thPercentile;
    img75thPercentile = prctile(IQFvals,75); stats.(names{y}).Pctile75 = img75thPercentile;
    img90thPercentile = prctile(IQFvals,90); stats.(names{y}).Pctile90 = img90thPercentile;
    %Calculate GLCM
    numBins = 64;
    glcm = graycomatrix(img, 'NumLevels',numBins, 'GrayLimits', []);
    statsGLCM = graycoprops(glcm);
    imgGLCMContrast = statsGLCM.Contrast; stats.(names{y}).GLCMContrast = imgGLCMContrast;
    imgGLCMCorrelation = statsGLCM.Correlation; stats.(names{y}).GLCMCorr = imgGLCMCorrelation;
    imgGLCMEnergy = statsGLCM.Energy; stats.(names{y}).GLCMEnergy = imgGLCMEnergy;
    imgGLCMHomogeneity = statsGLCM.Homogeneity; stats.(names{y}).GLCMHomog = imgGLCMHomogeneity;
end
stats.DICOMData.KVP = DICOMData.KVP;
stats.DICOMData.AnodeTargetMat = DICOMData.AnodeTargetMaterial;
stats.DICOMData.Spacing = DICOMData.PixelSpacing(1);
stats.DICOMData.ExposureuAs = DICOMData.ExposureInuAs;
stats.DICOMData.Position = DICOMData.ViewPosition;
stats.DICOMData.XRayCurrent = DICOMData.XrayTubeCurrent;
stats.DICOMData.ImageOrientation = DICOMData.SeriesDescription;
stats.DICOMData.FilterMaterial = DICOMData.FilterMaterial;
stats.DICOMData.FilterThickness = (DICOMData.FilterThicknessMinimum + DICOMData.FilterThicknessMaximum) / 2; 
% stats.Data.Thresholds = cutoffs;
stats.Data.MTFSigmaPixels = SigmaPixels;
stats.Data.Attenuations = attenuation;
stats.Data.Beta = beta;
%% Do calculations for compressed images
disp('Calculating the statistics of the IQF levels...'); tic
% A1 = char(part1{j});
% A2 = char(part2{j});
A1 = '';
A2 = '';
A3 = char(FileName_Naming{j});
aMatVector = aMatc(:); aMatVectorNoZeros = aMatVector(aMatVector~=0);
aVals = aMatVectorNoZeros;
bMatVector = bMatc(:); bMatVectorNoZeros = bMatVector(bMatVector~=0);
bVals = bMatVectorNoZeros;

statsc.imgA.Mean = mean(aVals);
statsc.imgA.Median = median(aVals); 
statsc.imgA.Sum = sum(aVals); 
statsc.imgA.Pctile10 = prctile(aVals,10);
statsc.imgA.Pctile25 = prctile(aVals,25); 
statsc.imgA.Pctile75 = prctile(aVals,75);
statsc.imgA.Pctile90 = prctile(aVals,90);
statsc.imgB.Mean = mean(bVals);
statsc.imgB.Median = median(bVals); 
statsc.imgB.Sum = sum(bVals); 
statsc.imgB.Pctile10 = prctile(bVals,10); 
statsc.imgB.Pctile25 = prctile(bVals,25);
statsc.imgB.Pctile75 = prctile(bVals,75); 
statsc.imgB.Pctile90 = prctile(bVals,90); 

%1 = full, 2=small, 3=medium, 4=large
names = {'Full', 'Small', 'Medium','Large'};
for y = 1:4
    if y==1; img = IQFc.Full;
    elseif y==2; img = IQFc.Small;
    elseif y==3; img = IQFc.Medium;
    elseif y==4; img = IQFc.Large;
    end
    imgVector = img(:);
    imgVectorNoZeros = imgVector(imgVector~=0);
    IQFvals = imgVectorNoZeros;
    totPx = length(IQFvals);
    pctPxBelow05 = length(IQFvals(IQFvals<.5))/totPx;statsc.(names{y}).pctBelowPnt5 = pctPxBelow05;
    pctPxBelow1 = length(IQFvals(IQFvals<1))/totPx;statsc.(names{y}).pctBelow1 = pctPxBelow1;
    pctPxBelow125 = length(IQFvals(IQFvals<1.25))/totPx;statsc.(names{y}).pctBelow1Pnt25 = pctPxBelow125;
    pctPxBelow15 = length(IQFvals(IQFvals<1.5))/totPx;statsc.(names{y}).pctBelow1Pnt5 = pctPxBelow15;
    pctPxBelow2 = length(IQFvals(IQFvals<2))/totPx;statsc.(names{y}).pctBelow2 = pctPxBelow2;
    pctPxBelow3 = length(IQFvals(IQFvals<3))/totPx;statsc.(names{y}).pctBelow3 = pctPxBelow3;
    pctPxBelow4 = length(IQFvals(IQFvals<4))/totPx;statsc.(names{y}).pctBelow4 = pctPxBelow4;
    pctPxBelow5 = length(IQFvals(IQFvals<5))/totPx;statsc.(names{y}).pctBelow5 = pctPxBelow5;
    pctPxBelow7 = length(IQFvals(IQFvals<7))/totPx;statsc.(names{y}).pctBelow7 = pctPxBelow7;
    pctPxBelow10 = length(IQFvals(IQFvals<10))/totPx;statsc.(names{y}).pctBelow10 = pctPxBelow10;
    pctPxBelow12 = length(IQFvals(IQFvals<12))/totPx;statsc.(names{y}).pctBelow12 = pctPxBelow12;
    pctPxBelow14 = length(IQFvals(IQFvals<14))/totPx;statsc.(names{y}).pctBelow14 = pctPxBelow14;
    pctPxBelow16 = length(IQFvals(IQFvals<16))/totPx;statsc.(names{y}).pctBelow16 = pctPxBelow16;
    pctPxBelow18 = length(IQFvals(IQFvals<18))/totPx;statsc.(names{y}).pctBelow18 = pctPxBelow18;
    pctPxBelow20 = length(IQFvals(IQFvals<20))/totPx;statsc.(names{y}).pctBelow20 = pctPxBelow20;
    imgMean = mean(IQFvals); statsc.(names{y}).Mean = imgMean;
    imgMedian = median(IQFvals); statsc.(names{y}).Median = imgMedian;
    imgStDev = std(IQFvals); statsc.(names{y}).StDev = imgStDev;
    imgSum = sum(IQFvals); statsc.(names{y}).Sum = imgSum;
    imgEntropy = entropy(IQFvals); statsc.(names{y}).Entropy = imgEntropy;
    imgKurtosis = kurtosis(IQFvals); statsc.(names{y}).Kurtosis = imgKurtosis;
    imgSkewness = skewness(IQFvals); statsc.(names{y}).Skewness = imgSkewness;
    img10thPercentile = prctile(IQFvals,10); statsc.(names{y}).Pctile10 = img10thPercentile;
    img25thPercentile = prctile(IQFvals,25); statsc.(names{y}).Pctile25 = img25thPercentile;
    img75thPercentile = prctile(IQFvals,75); statsc.(names{y}).Pctile75 = img75thPercentile;
    img90thPercentile = prctile(IQFvals,90); statsc.(names{y}).Pctile90 = img90thPercentile;
    %Calculate GLCM
    numBins = 64;
    glcm = graycomatrix(img, 'NumLevels',numBins, 'GrayLimits', []);
    statsGLCM = graycoprops(glcm);
    imgGLCMContrast = statsGLCM.Contrast; statsc.(names{y}).GLCMContrast = imgGLCMContrast;
    imgGLCMCorrelation = statsGLCM.Correlation; statsc.(names{y}).GLCMCorr = imgGLCMCorrelation;
    imgGLCMEnergy = statsGLCM.Energy; statsc.(names{y}).GLCMEnergy = imgGLCMEnergy;
    imgGLCMHomogeneity = statsGLCM.Homogeneity; statsc.(names{y}).GLCMHomog = imgGLCMHomogeneity;
end
statsc.DICOMData.KVP = DICOMData.KVP;
statsc.DICOMData.AnodeTargetMat = DICOMData.AnodeTargetMaterial;
statsc.DICOMData.Spacing = DICOMData.PixelSpacing(1);
statsc.DICOMData.ExposureuAs = DICOMData.ExposureInuAs;
statsc.DICOMData.Position = DICOMData.ViewPosition;
statsc.DICOMData.XRayCurrent = DICOMData.XrayTubeCurrent;
statsc.DICOMData.ImageOrientation = DICOMData.SeriesDescription;
statsc.DICOMData.FilterMaterial = DICOMData.FilterMaterial;
statsc.DICOMData.FilterThickness = (DICOMData.FilterThicknessMinimum + DICOMData.FilterThicknessMaximum) / 2; 
% stats.Data.Thresholds = cutoffs;
statsc.Data.MTFSigmaPixels = SigmaPixels;
statsc.Data.Attenuations = attenuation;
statsc.Data.Beta = beta;

%% Set Savepath
t = toc; str = sprintf('time elapsed: %0.2f', t); disp(str)
% savepath = 'W:\Breast Studies\Masking\BJH_MaskingMaps\';
% savepath = 'W:\Breast Studies\Masking\PrelimAnalysis\UCSF\Interval\MaskingMaps\';
%*****
% savepath = [savedir,'\'];
savepath = savedir{1};
%*****
% pause
%% Export images/data as .mats
disp('Saving all Data...'); tic
A4 = 'GeneratedStatistics'; A5 = '.mat';
formatSpec = '%s_%s_%s%s';
A2
A3
A4
A5
fileForSaving = sprintf(formatSpec,A2,A3, A4, A5)
savepath
save([savepath fileForSaving], 'stats');
A4 = 'GeneratedStatisticsCompressed'; A5 = '.mat';
fileForSaving = sprintf(formatSpec,A2,A3, A4, A5);
save([savepath fileForSaving], 'statsc');
A4_2 = 'IQFFullDisks';
IQFFull = IQF.Full;
fileForSaving = sprintf(formatSpec,A2,A3,  A4_2,  A5);
save([savepath fileForSaving], 'IQFFull'); %IQF Image
A4_3 = 'IQFSmallDisks';
IQFSmall = IQF.Small;
fileForSaving = sprintf(formatSpec,A2,A3,A4_3,  A5);
save([savepath fileForSaving], 'IQFSmall'); %IQF Image of small disks
A4_4 = 'IQFMediumDisks';
IQFMedium = IQF.Medium;
fileForSaving = sprintf(formatSpec,A2,A3, A4_4, A5);
save([savepath fileForSaving], 'IQFMedium'); % IQF Image of medium disks
A4_5 = 'IQFLargeDisks';
IQFLarge = IQF.Large;
fileForSaving = sprintf(formatSpec,A2,A3, A4_5, A5);
save([savepath fileForSaving], 'IQFLarge'); % IQF Image of large disks
A4_6 = 'A_ValueOfFit';
fileForSaving = sprintf(formatSpec,A2,A3, A4_6, A5);
save([savepath fileForSaving], 'aMat');% a value from exponential fit at each point
A4_7 = 'B_ValueOfFit';
fileForSaving = sprintf(formatSpec,A2,A3, A4_7, A5);
save([savepath fileForSaving], 'bMat');% b value from exponential fit at each point
% A4_8 = 'RSquareOfFit';
% fileForSaving = sprintf(formatSpec,A2,A3, A4_8, A5)
% save(['W:\Breast Studies\Masking\BJH_MaskingMaps\' fileForSaving], 'RSquare')% r^2 value from exp fit at each point
% t = toc; str = sprintf('time elapsed: %0.2f', t); disp(str)
A4_8 = 'ErrorFlags';
fileForSaving = sprintf(formatSpec,A2,A3, A4_8, A5);
save([savepath fileForSaving], 'errFlags')% r^2 value from exp fit at each point
t = toc; str = sprintf('time elapsed: %0.2f', t); disp(str)
Done = 'Finished this image.';
disp('Finished Saving data to the directory')
end