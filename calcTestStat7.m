function [levels, IQF] = calcTestStat7(IDicomOrig, attenuation, radius,...
    attenDisk, thickness, diameter, cutoffs, spacing)
%% Setting Parms
pMax = length(radius);
kMax = length(attenuation);
[nRows,nCols] = size(IDicomOrig);
figure
imshow(IDicomOrig,[])
[r,c] = size(attenDisk(:,:,1));
padAmnt = ceil(r/2)
IDicomOrig = padarray(IDicomOrig, [padAmnt,padAmnt], 'symmetric');
figure
imshow(IDicomOrig,[])

oneMm = ceil(1/spacing);
fiveMm = ceil(oneMm*5);


spread = padAmnt-1

IQF.Full = zeros(nRows,nCols);
IQF.Large= zeros(nRows,nCols);
IQF.Medium= zeros(nRows,nCols);
IQF.Small= zeros(nRows,nCols);

tic
% figure
for i = fiveMm+1:2*fiveMm:nCols
    for j = fiveMm+1:2*fiveMm:nRows
        lx = j+padAmnt;
        ly = i+padAmnt;
        %Define Region
%         5mmregion = IDicomOrig(lx-twopointfiveMm:lx+twopointfiveMm, ...
%             ly-twopointfiveMm:ly+twopointfiveMm);
        region = IDicomOrig(lx-spread:lx+spread, ...
            ly-spread:ly+spread);
%         figure
%         imshow(region,[])
%         pause
        if IDicomOrig(lx,ly) > 7000
        IQFFull = 0;
        IQFLarge = 0;
        IQFMed = 0;
        IQFSmall = 0;
        else
            lambdas = zeros(pMax, kMax);
            for p = 1:pMax %All Diams
            negDisk = attenDisk(:,:,p);
            for k = 1:kMax %All Attens
                %Do Calculations
                scaledDisk = negDisk.*((region-50)*(attenuation(k) - 1));
                regionWDisk = region + scaledDisk;
                wnpw = scaledDisk(:);
                gTest = regionWDisk(:);
                lambda = wnpw'*gTest;
                lambdas(p,k) = lambda;
                if k == 1 && lambda > cutoffs(p)
                    threshThickness(p) = thickness(k);
                end
                if k == kMax && lambda < cutoffs(p)
                    threshThickness(p) = thickness(k);
                end
                if lambda > cutoffs(p)
                    %Need to do the in between value here
                    threshThickness(p) = thickness(k);
                    break
                end


            end
            end
        x = diameter;
        y = threshThickness;

        %Calc IQF
        IQFdenom = x*y';
        IQFFull = sum(diameter(:))./IQFdenom;
        IQFLarge = sum(diameter(1:8))./(x(1:8)*y(1:8)');
        IQFMed = sum(diameter(9:16))./(x(9:16)*y(9:16)');
        IQFSmall = sum(diameter(17:24))./(x(17:24)*y(17:24)');
            
        
        %Calc power law fit, etc.
        [f, gof] = fit(x',y','power1');
        RSquare(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = gof.rsquare;
        coeffs = coeffvalues(f);
        aMat(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = coeffs(1);
        bMat(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = coeffs(2);
        
        end


        IQF.Full(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFFull;
        IQF.Large(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFLarge;
        IQF.Medium(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFMed;
        IQF.Small(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFSmall;
        
    end
end
toc
figure
imshow(IQF.Full,[])   
pause
end







% 
% 
% 
% 
% 
% %% Performing Calculation of Lambdas
% for p = 1:pMax %All diameters
%     diam = diameter(p)/10;
%     s = sprintf('Now calculating detectability at %1.3f cm', diam);
%     disp(s)
%     binDisk = attenDisk(:,:,p);
%     centerDisk=size(binDisk)/2+.5;
%     radDiskExt = ceil(radius(p)*1.4);
%     binDisk = binDisk(centerDisk(1)-radDiskExt:centerDisk(1)+radDiskExt,centerDisk(2)-radDiskExt:centerDisk(2)+radDiskExt);
%     [r,c] = size(binDisk);
%     padAmnt = (r+1)/2;
%     for k = 1:kMax %All attenuations
%         attenImg = ((IDicomOrig-50)'*(attenuation(k) - 1))';
%         attenImgSquared = attenImg.*attenImg;    
%         %If diameter of disk is greater than 2 mm ->Do FFT
%         if diameter(p)>2
%             tic
%             origPad = padarray(IDicomOrig,[padAmnt padAmnt],'symmetric','both');
%             [a,b] = size(origPad);
%             %Tissue Image
%             D1 = fft2(binDisk, a, b);% D1(find(D1 == 0)) = 1e-8;
%             attenAndTiss = attenImg.*IDicomOrig;
%             D2 = fft2(attenAndTiss, a, b);
%             D4 = D1.*D2;
%             D5 = ifft2(D4);
%             imageUnpad = D5(padAmnt+1:padAmnt+l, padAmnt+1:padAmnt+w);
%             tissueImg2a = imageUnpad;
%             %Bias Image
%             [a,b] = size(origPad);
%             D2 = fft2(binDisk, a, b); %D2(find(D2 == 0)) = 1e-8;          
%             D1 = fft2(attenImgSquared, a, b);
%             D3 = D1.*D2; 
%             D4 = ifft2(D3);%.^2;
%             tissueImg2b = D4(padAmnt+1:padAmnt+l, padAmnt+1:padAmnt+w);
%             testStatImg = tissueImg2a + tissueImg2b;
%             toc
%         %Do Conv if diameter less or equal to 2 mm 
%         elseif diameter(p)<=2
%             %(Because faster than fft for small signals)
%             tic            
%             convTissue = attenImg.*IDicomOrig;
%             tissue_img = conv2(convTissue,binDisk, 'same' );
%             diskImg = conv2(attenImgSquared,binDisk, 'same' ); %Maybe Valid
%             testStatImg = tissue_img + diskImg;  
%             toc
%         end
%         j = convImage2(:,:, p);
%         j(testStatImg<=cutoffs(p))=thickness(k);
%         convImage2(:,:, p) = j;
%     end
% end
% %% Calculate Full IQF
% disp('Now Organizing Data into IQF and IQF of small, medium, and large disks')
% [l,w,v] = size(convImage2);
% aBase = ones(l,w);
% A = zeros(l,w,pMax);
% for m = 1:pMax
%    A(:,:,m) = aBase*diameter(m);
% end
% IQFdenom = dot(A,convImage2, 3);
% IQFFull = sum(diameter(:))./IQFdenom;  %originally pMax./IQFdenom;, but this way normalizes for different ranges
% %% Calculate Subset IQFs
% IQFLargeDenom = dot(A(:,:,1:8),convImage2(:,:,1:8), 3);
% IQFMedDenom = dot(A(:,:,9:16),convImage2(:,:,9:16), 3);
% IQFSmallDenom = dot(A(:,:,17:24),convImage2(:,:,17:24), 3);
% IQFLarge = sum(diameter(1:8))./IQFLargeDenom;
% IQFMed = sum(diameter(9:16))./IQFMedDenom;
% IQFSmall = sum(diameter(17:24))./IQFSmallDenom;
% %% Set areas where i'll do calculations
% maskingMap = IDicomOrig;
% % threshold 
% maskingMap= maskingMap./max(maskingMap(:));
% maskingMap = im2bw(maskingMap,0.2);
% maskingMap = imcomplement(maskingMap);
% IQF.Full = IQFFull .* maskingMap;
% IQF.Large = IQFLarge .* maskingMap;
% IQF.Med = IQFMed .* maskingMap;
% IQF.Small = IQFSmall .* maskingMap;
% levels = convImage2;