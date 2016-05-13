function [levels, IQF, IQFLarge, IQFMed,IQFSmall] = calcTestStat5(IDicomOrig, attenuation, radius, attenDisk, thickness, diameter, cutoff, padAmnt)
%% Setting Parms
pMax = length(radius);
kMax = length(attenuation);
[l,w] = size(IDicomOrig);
convImage2 = ones(l,w, pMax)*2; 
% cutoff = -1e5
cutoffs = [-4,-4,-4,-4,-4,-4,-4, -4.0331,-2.8546,-2.3610,-1.7207,-1.5966, -1.2005,-1.5624,-1.3016,-1.2426,-1.6839,-1.3971,-1.9411, -1.9411];
% cutoffs = [-4,-4,-4,-4,-4,-4,-4, -4.0331,-2.8546,-2.3610,-1.7207,-1.5966, -1.2005,-1.5624,-1.3016,-1.2426,-1.2426,-1.2426,-1.2426, -1.2426];
cutoffs = cutoffs*1e5;
%% Performing Calculation of Lambdas
for p = 1:pMax %All diameters
    for k = 1:kMax %All attenuations
        
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
        
        binDisk = attenDisk(:,:,p);
        negDisk = -binDisk;
        attenImg = ((IDicomOrig-50)'*(attenuation(k) - 1))';
        attenImgSquared = attenImg.*attenImg;    
if diameter(p)>=2 %If diameter of disk is greater or equal to 2 mm ->Do FFT
            tic
            origPad = padarray(IDicomOrig,[padAmnt padAmnt],'symmetric','both');
            [a,b] = size(origPad);
            d = max(a,b);
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
            % tissftt = tissueImg2a(1500,400)
            % biasfft = tissueImg2b(1500,400)
            % fftlambda = testStatImg(1500,400)
            toc
        elseif diameter(p)<2 %Do Conv if diameter less than 2 mm 
            %(Because faster than fft for small signals)
            tic            
            convTissue = attenImg.*IDicomOrig;
            tissue_img = conv2(convTissue,binDisk, 'same' );
            diskImg = conv2(attenImgSquared,binDisk, 'same' ); %Maybe Valid
            toc
            testStatImg = tissue_img + diskImg;                 
            % tissconv = tissue_img(1500,400)       
            % biasconv = diskImg(1500,400)            
            % convlambda = testStatImg(1500,400)

end
        j = convImage2(:,:, p);
        j(testStatImg<=cutoffs(p))=thickness(k);
        convImage2(:,:, p) = j;
    end
end
%% Calculate Full IQF
[l,w,v] = size(convImage2);
aBase = ones(l,w);
A = zeros(l,w,pMax);
for m = 1:pMax
   A(:,:,m) = aBase*diameter(m);
end
n = pMax;
IQFdenom = dot(A,convImage2, 3);
IQF = sum(diameter(:))./IQFdenom;  %originally n./IQFdenom;, but this way normalizes for different ranges
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
IQF = IQF .* maskingMap;
IQFLarge = IQFLarge .* maskingMap;
IQFMed = IQFMed .* maskingMap;
IQFSmall = IQFSmall .* maskingMap;
%% Undo the padding
levels = convImage2;
levels = levels(padAmnt:l-padAmnt, padAmnt:w-padAmnt,:);
IQF = IQF(padAmnt:l-padAmnt, padAmnt:w-padAmnt);
IQFLarge = IQFLarge(padAmnt:l-padAmnt, padAmnt:w-padAmnt);
IQFMed = IQFMed(padAmnt:l-padAmnt, padAmnt:w-padAmnt);
IQFSmall = IQFSmall(padAmnt:l-padAmnt, padAmnt:w-padAmnt);
% figure
% imshow(IQF, [])
% figure
% imshow(IQFLarge, [])
% figure
% imshow(IQFMed, [])
% figure
% imshow(IQFSmall, [])

