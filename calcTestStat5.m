function [levels, IQF] = calcTestStat5(IDicomOrig, attenuation, radius,...
    attenDisk, thickness, diameter, cutoffs, spacing)
%% Setting Parms
pMax = length(radius);
kMax = length(attenuation);
[l,w] = size(IDicomOrig);
convImage2 = ones(l,w, pMax)*2; 
%% Performing Calculation of Lambdas
for p = 1:pMax %All diameters
    diam = diameter(p)/10;
    s = sprintf('Now calculating detectability at %1.3f cm', diam);
    disp(s)
    binDisk = attenDisk(:,:,p);
    centerDisk=size(binDisk)/2+.5;
    radDiskExt = ceil(radius(p)*1.4);
    binDisk = binDisk(centerDisk(1)-radDiskExt:centerDisk(1)+radDiskExt,centerDisk(2)-radDiskExt:centerDisk(2)+radDiskExt);
    [r,c] = size(binDisk);
    padAmnt = (r+1)/2;
    for k = 1:kMax %All attenuations
        attenImg = ((IDicomOrig-50)'*(attenuation(k) - 1))';
        attenImgSquared = attenImg.*attenImg;    
        %If diameter of disk is greater or equal to 2 mm ->Do FFT
        if diameter(p)>=2
            tic
            origPad = padarray(IDicomOrig,[padAmnt padAmnt],'symmetric','both');
            [a,b] = size(origPad);
            %Tissue Image
            D1 = fft2(binDisk, a, b);% D1(find(D1 == 0)) = 1e-8;
            attenAndTiss = attenImg.*IDicomOrig;
            D2 = fft2(attenAndTiss, a, b);
            D4 = D1.*D2;
            D5 = ifft2(D4);
            imageUnpad = D5(padAmnt+1:padAmnt+l, padAmnt+1:padAmnt+w);
            tissueImg2a = imageUnpad;
            %Bias Image
            [a,b] = size(origPad);
            D2 = fft2(binDisk, a, b); %D2(find(D2 == 0)) = 1e-8;          
            D1 = fft2(attenImgSquared, a, b);
            D3 = D1.*D2; 
            D4 = ifft2(D3);%.^2;
            tissueImg2b = D4(padAmnt+1:padAmnt+l, padAmnt+1:padAmnt+w);
            testStatImg = tissueImg2a + tissueImg2b;
            toc
        %Do Conv if diameter less than 2 mm 
        elseif diameter(p)<2
            %(Because faster than fft for small signals)
            tic            
            convTissue = attenImg.*IDicomOrig;
            tissue_img = conv2(convTissue,binDisk, 'same' );
            diskImg = conv2(attenImgSquared,binDisk, 'same' ); %Maybe Valid
            testStatImg = tissue_img + diskImg;  
            toc

        end
        j = convImage2(:,:, p);
        j(testStatImg<=cutoffs(p))=thickness(k);
        convImage2(:,:, p) = j;
    end
end
%% Calculate Full IQF
disp('Now Organizing Data into IQF and IQF of small, medium, and large disks')
[l,w,v] = size(convImage2);
aBase = ones(l,w);
A = zeros(l,w,pMax);
for m = 1:pMax
   A(:,:,m) = aBase*diameter(m);
end
IQFdenom = dot(A,convImage2, 3);
IQF = sum(diameter(:))./IQFdenom;  %originally pMax./IQFdenom;, but this way normalizes for different ranges
%% Calculate Subset IQFs
IQFLargeDenom = dot(A(:,:,1:6),convImage2(:,:,1:6), 3);
IQFMedDenom = dot(A(:,:,7:12),convImage2(:,:,7:12), 3);
IQFSmallDenom = dot(A(:,:,13:20),convImage2(:,:,13:20), 3);
IQFLarge = sum(diameter(1:6))./IQFLargeDenom;
IQFMed = sum(diameter(7:12))./IQFMedDenom;
IQFSmall = sum(diameter(13:20))./IQFSmallDenom;
%% Set areas where i'll do calculations
maskingMap = IDicomOrig;
% threshold 
maskingMap= maskingMap./max(maskingMap(:));
maskingMap = im2bw(maskingMap,0.2);
maskingMap = imcomplement(maskingMap);
IQF.IQF = IQF .* maskingMap;
IQF.Large = IQFLarge .* maskingMap;
IQF.Med = IQFMed .* maskingMap;
IQF.Small = IQFSmall .* maskingMap;
levels = convImage2;
%% Calculate IQFAverage
%Flawed because it doesnt account for the muscle tissue
IQFVector = IQF.IQF(:);
IQFVectorNoZeros = IQFVector(IQFVector~=0);
IQF.avgIQF = mean(IQFVectorNoZeros);
IQF.stdevIQF = std(IQFVectorNoZeros);
%%
%Calculate the percent of the IQF above a certain value (Look at John
%notes0
%Area that has the top 10% of IQF Values
num = length(IQFVectorNoZeros);
tenPercentCutoff = num*0.9;
IQFVectorNoZerosSorted = sort(IQFVectorNoZeros);
IQF10Area = IQFVectorNoZerosSorted(num*0.9:end);
avgIQF10 = mean(IQF10Area);
stdIQF10 = std(IQF10Area);
%Area that has the top 25% of IQF Values
IQF25Area = IQFVectorNoZerosSorted(num*0.75:end);
avgIQF25 = mean(IQF25Area);
stdIQF25 = std(IQF25Area);
% %%
% %Do exponential fit of the data and produce a and b values
% cdDiam = diameter;
% x = cdDiam(8:20)';
% halfmm = ceil(.5/spacing);
% mm = halfmm*2;
% [nRows,nCols,p] = size(levels);
% aMat = zeros(nRows,nCols);
% bMat = zeros(nRows,nCols);
% RSquare = zeros(nRows,nCols);
% disp('Now calculating Exponential Fits of Threshold Thickness vs Diameter')
% tic
% for i = mm+1:2*mm:nRows
%     for j = mm+1:2*mm:nCols
%         cdThickness = reshape(levels(i,j,:), [1,p]);
%         y = cdThickness(8:20)';
%         [f, gof] = fit(x,y,'power1');
%         RSquare(i-mm:i+mm,j-mm:j+mm) = gof.rsquare;
%         coeffs = coeffvalues(f);
%         aMat(i-mm:i+mm,j-mm:j+mm) = coeffs(1);
%         bMat(i-mm:i+mm,j-mm:j+mm) = coeffs(2);
%         %Add in the map for the different a b, and rsquared
%     end
% end
% toc



%To reconfirm getting real values.
        %Calc Actual Lambda here
%         rowSel = 1500;
%         colSel = 400;
%         padA = padAmnt - 1;
%         centerImage = IDicomOrig(rowSel-padA:rowSel+padA, colSel-padA:colSel+padA);
%         negDisk = attenDisk(:,:,p);
%         avgROI = mean2(centerImage);
%         attenDisks = negDisk*((avgROI-50)'*(attenuation(k) - 1)); %Is my w=gs-gn
%         attenDisks = negDisk.*((centerImage-50)'*(attenuation(k) - 1));
%         imgWDisk = attenDisks+centerImage;%Is my gtest
%         wnpw = attenDisks(:);
%         gTest = imgWDisk(:);
%         lambda = wnpw'*gTest
%         biasterm = attenDisks(:)'*attenDisks(:)
%         tissueterm = attenDisks(:)'*centerImage(:)
%         shouldbeLambda = biasterm+tissueterm

%Insert htis into the fft section to test.
            % tissftt = tissueImg2a(1500,400)
            % biasfft = tissueImg2b(1500,400)
            % fftlambda = testStatImg(1500,400)


%Insert this into the convolution section to test
            % tissconv = tissue_img(1500,400)       
            % biasconv = diskImg(1500,400)            
            % convlambda = testStatImg(1500,400)