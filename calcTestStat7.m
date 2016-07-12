function [IQF, aMat, bMat, RSquare] = calcTestStat7(IDicomOrig,...
    attenuation, radius, attenDisk, thickness, diameter, cutoffs, spacing)
%% Setting Parms
pMax = length(radius); kMax = length(attenuation);
[nRows,nCols] = size(IDicomOrig); [r,c] = size(attenDisk(:,:,1));
padAmnt = ceil(r/2); spread = padAmnt-1;
IDicomOrig = padarray(IDicomOrig, [padAmnt,padAmnt], 'symmetric');
oneMm = ceil(1/spacing); fiveMm = ceil(oneMm*5);

IQF.Full = zeros(nRows,nCols); IQF.Large= zeros(nRows,nCols);
IQF.Medium= zeros(nRows,nCols); IQF.Small= zeros(nRows,nCols);
for i = fiveMm+1:2*fiveMm:nCols
    for j = fiveMm+1:2*fiveMm:nRows
        lx = j+padAmnt; ly = i+padAmnt;
        %Define Region
        region = IDicomOrig(lx-spread:lx+spread, ...
            ly-spread:ly+spread);
        if IDicomOrig(lx,ly) > 7000
            IQFFull = 0; IQFLarge = 0;
            IQFMed = 0; IQFSmall = 0;
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
            x = diameter; y = threshThickness;
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
end