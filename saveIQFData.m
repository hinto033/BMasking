function [Done] = saveIQFData(aMat, bMat, IQF,DICOMData,cutoffs,...
    SigmaPixels,attenuation,part1, part2, FileName_Naming, beta,RSquare, j, errFlags)
% mean, stdev, sum, entropy, kurtosis, skewness, 5th percentile, 25th
% percentile, 75th percentile, 95th percentile, GLCM Contrast, GLCM
% correlation, GLCM Energy, (All for full, small, med, large)
% GLCM Homogeneity, BIRADS, VBD
disp('Calculating the statistics of the IQF levels...'); tic
A1 = char(part1{j});
A2 = char(part2{j});
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
stats.Data.Thresholds = cutoffs;
stats.Data.MTFSigmaPixels = SigmaPixels;
stats.Data.Attenuations = attenuation;
stats.Data.Beta = beta;
t = toc; str = sprintf('time elapsed: %0.2f', t); disp(str)
savepath = 'W:\Breast Studies\Masking\BJH_MaskingMaps\';
%% Export images/data as .mats
disp('Saving all Data...'); tic
A4 = 'GeneratedStatistics'; A5 = '.mat';
formatSpec = '%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A2,A3, A4, A5)
save(['W:\Breast Studies\Masking\BJH_MaskingMaps\' fileForSaving], 'stats')
A4_2 = 'IQFFullDisks';
IQFFull = IQF.Full;
fileForSaving = sprintf(formatSpec,A2,A3,  A4_2,  A5)
save(['W:\Breast Studies\Masking\BJH_MaskingMaps\' fileForSaving], 'IQFFull') %IQF Image
A4_3 = 'IQFSmallDisks';
IQFSmall = IQF.Small;
fileForSaving = sprintf(formatSpec,A2,A3,A4_3,  A5)
save(['W:\Breast Studies\Masking\BJH_MaskingMaps\' fileForSaving], 'IQFSmall') %IQF Image of small disks
A4_4 = 'IQFMediumDisks';
IQFMedium = IQF.Medium;
fileForSaving = sprintf(formatSpec,A2,A3, A4_4, A5)
save(['W:\Breast Studies\Masking\BJH_MaskingMaps\' fileForSaving], 'IQFMedium') % IQF Image of medium disks
A4_5 = 'IQFLargeDisks';
IQFLarge = IQF.Large;
fileForSaving = sprintf(formatSpec,A2,A3, A4_5, A5)
save(['W:\Breast Studies\Masking\BJH_MaskingMaps\' fileForSaving], 'IQFLarge') % IQF Image of large disks
A4_6 = 'A_ValueOfFit';
fileForSaving = sprintf(formatSpec,A2,A3, A4_6, A5)
save(['W:\Breast Studies\Masking\BJH_MaskingMaps\' fileForSaving], 'aMat')% a value from exponential fit at each point
A4_7 = 'B_ValueOfFit';
fileForSaving = sprintf(formatSpec,A2,A3, A4_7, A5)
save(['W:\Breast Studies\Masking\BJH_MaskingMaps\' fileForSaving], 'bMat')% b value from exponential fit at each point
A4_8 = 'RSquareOfFit';
fileForSaving = sprintf(formatSpec,A2,A3, A4_8, A5)
save(['W:\Breast Studies\Masking\BJH_MaskingMaps\' fileForSaving], 'RSquare')% r^2 value from exp fit at each point
t = toc; str = sprintf('time elapsed: %0.2f', t); disp(str)
A4_8 = 'ErrorFlags';
fileForSaving = sprintf(formatSpec,A2,A3, A4_8, A5)
save(['W:\Breast Studies\Masking\BJH_MaskingMaps\' fileForSaving], 'errFlags')% r^2 value from exp fit at each point
t = toc; str = sprintf('time elapsed: %0.2f', t); disp(str)
Done = 'Finished this image.';
end