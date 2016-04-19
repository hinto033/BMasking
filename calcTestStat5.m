function [levels, IQF, IQFLarge, IQFMed,IQFSmall] = calcTestStat5(IDicomOrig, attenuation, radius, attenDisk, thickness, diameter, cutoff, padAmnt)
%% Setting Parms
pMax = length(radius);
kMax = length(attenuation);
[l,w] = size(IDicomOrig);
convImage2 = ones(l,w, pMax)*2; 
%% Performing Calculation of Lambdas
for p = 1:pMax %All diameters
    for k = 1:kMax %All attenuations
        negDisk = attenDisk(:,:,p);
        posDisk = -negDisk;
        attenImg = ((IDicomOrig-50)'*(attenuation(k) - 1))';
        attenImgSquared = attenImg.*attenImg;    
        if diameter(p)>=2 %If diameter of disk is greater or equal to 2 mm ->Do FFT
            tic
            origPad = padarray(IDicomOrig,[padAmnt padAmnt],'symmetric','both');
            [a,b] = size(origPad);
            D1 = fft2(origPad, a, b);
            D2 = fft2(posDisk, a, b); D2(find(D2 == 0)) = 1e-6; %If it goes wrong, comment out this section
            D3 = D1.*D2; D4 = ifft2(D3);
            imageUnpad = D4(2*padAmnt+1:2*padAmnt+l, 2*padAmnt+1:2*padAmnt+w);
            tissueImg2a = attenImg.*imageUnpad;

            attenImgSquaredPad = padarray(attenImgSquared,[padAmnt padAmnt],'symmetric','both');
            [a,b] = size(attenImgSquaredPad);
            D1 = fft2(attenImgSquaredPad, a, b);
            D2 = fft2(negDisk, a, b); D2(find(D2 == 0)) = 1e-6;
            D3 = D1.*D2; D4 = ifft2(D3);
            tissueImg2b = D4(2*padAmnt+1:2*padAmnt+l, 2*padAmnt+1:2*padAmnt+w);

            testStatImg = tissueImg2a + tissueImg2b;
            toc
        elseif diameter(p)<2 %Do Conv if diameter less than 2 mm 
            %(Because faster than fft for small signals)
            tic
            convTissue = conv2(IDicomOrig,posDisk, 'same' ); %Maybe Valid
            tissue_img = attenImg.*convTissue;
            diskImg = conv2(attenImgSquared,negDisk, 'same' ); %Maybe Valid
            toc
            testStatImg = tissue_img + diskImg;
        end
        j = convImage2(:,:, p);
        j(testStatImg>=cutoff)=thickness(k);
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
figure
imshow(IQF, [])
figure
imshow(IQFLarge, [])
figure
imshow(IQFMed, [])
figure
imshow(IQFSmall, [])

