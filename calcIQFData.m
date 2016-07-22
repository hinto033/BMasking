function [IQF, aMat, bMat, RSquare, errFlags] = calcIQFData(IDicomOrig,attenuation, ...
    radius, binDisk, thickness, diameter, cutoffs, spacing,binaryOutline,IDicomAvg,IDicomStdev, errFlags)
%% Setting Parms
pMax = length(radius); kMax = length(attenuation);
[nRows,nCols] = size(IDicomOrig); [r,c] = size(binDisk(:,:,1));
padAmnt = ceil(r/2); spread = padAmnt-1;
IDicomOrig = padarray(IDicomOrig, [padAmnt,padAmnt], 'symmetric');
oneMm = ceil(1/spacing); fiveMm = ceil(oneMm*5);

IQF.Full = zeros(nRows,nCols); IQF.Large= zeros(nRows,nCols);
IQF.Medium= zeros(nRows,nCols); IQF.Small= zeros(nRows,nCols);
errCount=0;
timerMultiplier = 1;
count = 0;
tic
for j = 1:pMax
    negDisk = binDisk(:,:,j);
for k = 1:kMax
    attenDisk = negDisk.*((IDicomAvg-50)'*(attenuation(k) - 1));
    attenMatrix(:,k,j) = attenDisk(:);
end
end
toc
tic
for i = fiveMm+1:2*fiveMm:nCols
    for j = fiveMm+1:2*fiveMm:nRows
        if binaryOutline(j,i) == 0
        else
            count = count+1;
        end
    end
end
toc
imgPatch = zeros(count, (spread*2+1)^2);
count = 0;
tic
for i = fiveMm+1:2*fiveMm:nCols
    for j = fiveMm+1:2*fiveMm:nRows
        lx = j+padAmnt; ly = i+padAmnt;
        %Define Region
        region = IDicomOrig(lx-spread:lx+spread, ...
            ly-spread:ly+spread);
        if binaryOutline(j,i) == 0 %Do not store the location
        else
            %Do store the locaiton
            count = count+1;
            imgInfo(count,1) = lx;
            imgInfo(count,2) = ly;
            imgInfo(count,3) = j;
            imgInfo(count,4) = i;
            imgPatch(count,:) = region(:)';
        end
    end
end
%Calculate the lambda for every disk/diameter
tic
lambdaAll= zeros(count,kMax,pMax);
for h = 1:pMax
    lambdaAll(:,:,h) = imgPatch*attenMatrix(:,:,h);
end
toc
tic %CAN IMPROVE ON THIS IF CAN GET ALL INDICES IN ONE SWOOP
for h = 1:pMax %For each diamter, find the cutoff thickness at each point
    lambdaDiam = lambdaAll(:,:,h);
    cutoffDiam = cutoffs(h);
    for y = 1:count
        lambdaPatch = lambdaDiam(y,:);
        idx = find(lambdaPatch>cutoffDiam, 1);
        if idx == 1 %Not detectable at thickest attenuation level
            threshThickness(y, h) = 2;
        elseif isempty(idx)
            threshThickness = thickness(kMax);
        else
            distLambdas = lambdaPatch(idx-1) - lambdaPatch(idx);
            distCutoffLambda = cutoffs(h) - lambdaPatch(idx);
            fractionUp = distCutoffLambda/distLambdas;
            distThickness = thickness(idx-1) - thickness(idx);
            threshThickness(y, h) = thickness(idx)+(fractionUp*distThickness);
        end
    end

end
toc
tic
%Now Calculate the IQF, EXP Fit, etc.
x = diameter;
for m = 1:count
    y = threshThickness(m,:);
    IQFdenom = x*y';
    IQFFull(m) = sum(diameter(:))./IQFdenom;
    IQFLarge(m) = sum(diameter(1:8))./(x(1:8)*y(1:8)');
    IQFMedium(m) = sum(diameter(9:16))./(x(9:16)*y(9:16)');
    IQFSmall(m) = sum(diameter(17:24))./(x(17:24)*y(17:24)');
    
    [f, gof] = fit(x',y','power1');
    RSquareVector(m) = gof.rsquare;
    coeffs = coeffvalues(f);
    aVector(m) = coeffs(1);
    bVector(m) = coeffs(2);
end
toc
tic
for m = 1:count
    j = imgInfo(m,3);
    i = imgInfo(m,4);
    IQF.Full(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = IQFFull(m);
    IQF.Large(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFLarge(m);
    IQF.Medium(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFMedium(m);
    IQF.Small(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFSmall(m);

    RSquare(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = RSquareVector(m);
    coeffs = coeffvalues(f);
    aMat(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = aVector(m);
    bMat(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = bVector(m);
end
toc
figure
imshow(IQF.Full,[])
pause

end

%             x = diameter; y = threshThickness;
%             %Calc IQF
%             IQFdenom = x*y';
%             IQFFull = sum(diameter(:))./IQFdenom;
%             IQFLarge = sum(diameter(1:8))./(x(1:8)*y(1:8)');
%             IQFMed = sum(diameter(9:16))./(x(9:16)*y(9:16)');
%             IQFSmall = sum(diameter(17:24))./(x(17:24)*y(17:24)'); 
%             %Calc power law fit, etc.
%             [f, gof] = fit(x',y','power1');
%             RSquare(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = gof.rsquare;
%             coeffs = coeffvalues(f);
%             aMat(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = coeffs(1);
%             bMat(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = coeffs(2);
%         end
%         IQF.Full(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFFull;
%         IQF.Large(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFLarge;
%         IQF.Medium(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFMed;
%         IQF.Small(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFSmall;


% end
%             lambdas = zeros(pMax, kMax);
%             for p = 1:pMax %All Diams
%                 negDisk = attenDisk(:,:,p);
%                 for k = 1:kMax %All Attens
%                     %Do Calculations
%                     scaledDisk = negDisk.*((region-50)*(attenuation(k) - 1));
%                     regionWDisk = region + scaledDisk;
%                     wnpw = scaledDisk(:);
%                     gTest = regionWDisk(:);
%                     lambda = wnpw'*gTest;
%                     lambdas(p,k) = lambda;
%                     if k == 1 && lambda > cutoffs(p) %Hits cutoff at 1st iteration ; never detectable
%                         threshThickness(p) = thickness(k);
%                         break
%                     elseif k == kMax && lambda < cutoffs(p) %never hits cutoff ; detectable at all thicknesses
%                         threshThickness(p) = thickness(k);
%                         errCount = errCount+1;
%                         str = sprintf('%0.0f discs where it was detectable at all thicknesses', errCount);
%                         errFlags.noCutoffHit = str;
%                         break
%                     elseif lambda > cutoffs(p) && k~=1 %&& k~=kMax
%                         distLambdas = lambdas(p,k-1) - lambdas(p,k);
%                         distCutoffLambda = cutoffs(p) - lambdas(p,k);
%                         fractionUp = distCutoffLambda/distLambdas;
%                         distThickness = thickness(k-1) - thickness(k);
%                         threshThickness(p) = thickness(k)+(fractionUp*distThickness);
%                         break
%                     end
%                 end
%             end
%             x = diameter; y = threshThickness;
%             %Calc IQF
%             IQFdenom = x*y';
%             IQFFull = sum(diameter(:))./IQFdenom;
%             IQFLarge = sum(diameter(1:8))./(x(1:8)*y(1:8)');
%             IQFMed = sum(diameter(9:16))./(x(9:16)*y(9:16)');
%             IQFSmall = sum(diameter(17:24))./(x(17:24)*y(17:24)'); 
%             %Calc power law fit, etc.
%             [f, gof] = fit(x',y','power1');
%             RSquare(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = gof.rsquare;
%             coeffs = coeffvalues(f);
%             aMat(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = coeffs(1);
%             bMat(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = coeffs(2);
%         end
%         IQF.Full(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFFull;
%         IQF.Large(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFLarge;
%         IQF.Medium(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFMed;
%         IQF.Small(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFSmall;
%     end
% end
% if errCount == 0; errFlags.noCutoffHit = 'No Error';
% end
% end








% %% Setting Parms
% pMax = length(radius); kMax = length(attenuation);
% [nRows,nCols] = size(IDicomOrig); [r,c] = size(attenDisk(:,:,1));
% padAmnt = ceil(r/2); spread = padAmnt-1;
% IDicomOrig = padarray(IDicomOrig, [padAmnt,padAmnt], 'symmetric');
% oneMm = ceil(1/spacing); fiveMm = ceil(oneMm*5);
% 
% IQF.Full = zeros(nRows,nCols); IQF.Large= zeros(nRows,nCols);
% IQF.Medium= zeros(nRows,nCols); IQF.Small= zeros(nRows,nCols);
% errCount=0;
% timerMultiplier = 1;
% tic
% for i = fiveMm+1:2*fiveMm:nCols
%     for j = fiveMm+1:2*fiveMm:nRows
%         if toc - (30*timerMultiplier) >0
%             timerMultiplier = timerMultiplier+1;
%             str = sprintf('30 seconds has elapsed. Still Calculating...');
%             disp(str)
%         end
%         lx = j+padAmnt; ly = i+padAmnt;
%         %Define Region
%         region = IDicomOrig(lx-spread:lx+spread, ...
%             ly-spread:ly+spread);
%         if binaryOutline(j,i) == 0
%             IQFFull = 0; IQFLarge = 0;
%             IQFMed = 0; IQFSmall = 0;
%         else
%             lambdas = zeros(pMax, kMax);
%             for p = 1:pMax %All Diams
%                 negDisk = attenDisk(:,:,p);
%                 for k = 1:kMax %All Attens
%                     %Do Calculations
%                     scaledDisk = negDisk.*((region-50)*(attenuation(k) - 1));
%                     regionWDisk = region + scaledDisk;
%                     wnpw = scaledDisk(:);
%                     gTest = regionWDisk(:);
%                     lambda = wnpw'*gTest;
%                     lambdas(p,k) = lambda;
%                     if k == 1 && lambda > cutoffs(p) %Hits cutoff at 1st iteration ; never detectable
%                         threshThickness(p) = thickness(k);
%                         break
%                     elseif k == kMax && lambda < cutoffs(p) %never hits cutoff ; detectable at all thicknesses
%                         threshThickness(p) = thickness(k);
%                         errCount = errCount+1;
%                         str = sprintf('%0.0f discs where it was detectable at all thicknesses', errCount);
%                         errFlags.noCutoffHit = str;
%                         break
%                     elseif lambda > cutoffs(p) && k~=1 %&& k~=kMax
%                         distLambdas = lambdas(p,k-1) - lambdas(p,k);
%                         distCutoffLambda = cutoffs(p) - lambdas(p,k);
%                         fractionUp = distCutoffLambda/distLambdas;
%                         distThickness = thickness(k-1) - thickness(k);
%                         threshThickness(p) = thickness(k)+(fractionUp*distThickness);
%                         break
%                     end
%                 end
%             end
%             x = diameter; y = threshThickness;
%             %Calc IQF
%             IQFdenom = x*y';
%             IQFFull = sum(diameter(:))./IQFdenom;
%             IQFLarge = sum(diameter(1:8))./(x(1:8)*y(1:8)');
%             IQFMed = sum(diameter(9:16))./(x(9:16)*y(9:16)');
%             IQFSmall = sum(diameter(17:24))./(x(17:24)*y(17:24)'); 
%             %Calc power law fit, etc.
%             [f, gof] = fit(x',y','power1');
%             RSquare(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = gof.rsquare;
%             coeffs = coeffvalues(f);
%             aMat(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = coeffs(1);
%             bMat(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm) = coeffs(2);
%         end
%         IQF.Full(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFFull;
%         IQF.Large(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFLarge;
%         IQF.Medium(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFMed;
%         IQF.Small(j-fiveMm:j+fiveMm,i-fiveMm:i+fiveMm)= IQFSmall;
%     end
% end
% if errCount == 0; errFlags.noCutoffHit = 'No Error';
% end
% end