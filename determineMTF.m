function [SigmaPixels, errFlags] = determineMTF(IDicomOrig)
IDicomOrig(all(IDicomOrig>10000,2),:)=[]; %Delete Empty Rows
[r,c] = size(IDicomOrig); 
deriv = zeros(1,c);
maxDiff = 0; %Initializing variables
Slope = 0;
for p = 1:r %Every Row
    for m = 2:c-1 %Finds derivative (Max slope)
        deriv(m) = abs(IDicomOrig(p,m) -IDicomOrig(p,m+1));
    end
    maxDeriv = max(deriv);  DerivInd = find(deriv==maxDeriv);
    thresh = 15;   %This is arbitrary and I might need to change it.
    arrayZeros = find(deriv<thresh);  zeroLocations = arrayZeros;
    %Finds 'zero' locations to left and right of the peak derivative
    slopeRegionToFind = DerivInd(1);
    tmp = (zeroLocations-slopeRegionToFind);
    tmpAbove = tmp(tmp>0); %Finds zero region to right of max slope
    tmpBelow = abs(tmp(tmp<0)); %Finds zero region to left of max slope
    [indexAbove] = min(tmpAbove);   [idxBelow] = min(tmpBelow);
    closestAbove = zeroLocations(indexAbove);
    TruIDXAbove = DerivInd+closestAbove; TruIDXBelow = DerivInd-idxBelow;
    %derivAtVal = deriv(TruIDXAbove);
    %derivAtValBelow = deriv(TruIDXBelow);
    TruIDXAbove = TruIDXAbove(1);
    TruIDXBelow = TruIDXBelow(1);
    if TruIDXBelow<1 | TruIDXAbove>c
        continue
    end
    maxDiffTest = abs(IDicomOrig(p,TruIDXAbove) - IDicomOrig(p,TruIDXBelow));
    SlopeTest = maxDiffTest/(TruIDXAbove - TruIDXBelow);
    slopeLength = (TruIDXAbove-TruIDXBelow)+1;
    %Saves this row and relevant data if the slope in this row is larger
    %than any other row I've seen.
    if SlopeTest >=Slope
        rowNumber = p;
        maxDiff = maxDiffTest; SignalLength = slopeLength;
        Signal = IDicomOrig(p,TruIDXBelow:TruIDXAbove);
        DerivSignal = deriv(TruIDXBelow:TruIDXAbove);
        colIndices = [TruIDXAbove, TruIDXBelow];
        Slope = maxDiff / (TruIDXAbove - TruIDXBelow);
    end
end
%Do gaussian fit to determine the proper amoutn of blur
%Assumes LSF = PSF
yData = DerivSignal' / max(DerivSignal);
xData = linspace(1,SignalLength, SignalLength)';
[zeroLocations, gof] = fit(xData,yData,'gauss1');

%Calculates gaussian fit so I can find my sigma (which is my MTF)
rSquared = gof.rsquare; coeffs = coeffvalues(zeroLocations);
Scaling = coeffs(1); OffSet = coeffs(2); SigmaPixels = coeffs(3);
Sigmamm = SigmaPixels* .07;
if SigmaPixels >=5 || SigmaPixels <=.25%If the MTF finding function didn't work...
    SigmaPixels = 1;
    errFlags.MTF = 'MTF Function Unsuccessful. Approximated as 1 Pixel Sigma';
else errFlags.MTF = 'No Error;';
end