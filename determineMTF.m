function [sigmaPixels, errFlags] = determineMTF(IDicomOrig,DICOMData)

sigmaPixels = 0.13/DICOMData.PixelSpacing(1);
errFlags.MTF = 'no Error';
% 
% [nRow,nCol] = size(IDicomOrig); 
% deriv = zeros(1,nCol);
% absoluteMaxSlope = 0;
% for row = 1:nRow %Every Row
%     for col = 2:nCol-1 %Finds derivative (Max slope) along a row
%         deriv(col) = abs(IDicomOrig(row,col) - IDicomOrig(row,col+1));
%     end
%     maxDeriv = max(deriv);  DerivInd = find(deriv==maxDeriv);
%     
%     %Finds region to left and right of the peak slope where it levels off
%     threshold = 15;
%     arrayFlatRegions = find(deriv<threshold);
%     flatRegionIdx = arrayFlatRegions;
%     
%     %Finds 'zero' locations to left and right of the peak derivative
%     slopeRegionToFind = DerivInd(1);
%     maxSlopeIdx = (flatRegionIdx-slopeRegionToFind);
%     indicesAboveMaxSlope = maxSlopeIdx(maxSlopeIdx>0); %Finds zero region to right of max slope
%     indicesBelowMaxSlope = abs(maxSlopeIdx(maxSlopeIdx<0)); %Finds zero region to left of max slope
%     [indexAbove] = min(indicesAboveMaxSlope);
%     [indexBelow] = min(indicesBelowMaxSlope);
%     closestAbove = flatRegionIdx(indexAbove);
%     truIDXAbove = DerivInd+closestAbove;
%     truIDXBelow = DerivInd-indexBelow;
%     truIDXAbove = truIDXAbove(1); %First flat point to right of max slope
%     truIDXBelow = truIDXBelow(1); %First flat point to left of max slope
%     %Prevents from triggering at leftmost/rightmost part
%     if truIDXBelow<1 || truIDXAbove>nCol
%         continue
%     end
%     maxDiffRow = abs(IDicomOrig(row,truIDXAbove) - IDicomOrig(row,truIDXBelow));
%     slopeRow = maxDiffRow/(truIDXAbove - truIDXBelow);
%     slopeLength = (truIDXAbove-truIDXBelow)+1;
%     %Saves this row and relevant data if the slope in this row is larger
%     %than any other row I've seen.
%     if slopeRow >= absoluteMaxSlope
%         maxDiffAbsolute = maxDiffRow; SignalLength = slopeLength;
%         signal = IDicomOrig(row,truIDXBelow:truIDXAbove);
%         derivSignal = deriv(truIDXBelow:truIDXAbove);
%         absoluteMaxSlope = maxDiffAbsolute / (truIDXAbove - truIDXBelow);
%     end
% end
% %Do gaussian fit to determine the proper amount of blur
% %Assumes LSF = PSF
% yData = derivSignal' / max(derivSignal);
% xData = linspace(1,SignalLength, SignalLength)';
% [flatRegionIdx, gof] = fit(xData,yData,'gauss1');
% %Calculates gaussian fit so I can find my sigma (which is my MTF)
% coeffs = coeffvalues(flatRegionIdx);
% sigmaPixels = coeffs(3);
% sigmamm = sigmaPixels* .07;
% %If the MTF finding function didn't work...
% if sigmaPixels >=5 || sigmaPixels <=.25
%     sigmaPixels = 1;
%     errFlags.MTF = 'MTF Function Unsuccessful. Approximated as 1 Pixel Sigma';
% else errFlags.MTF = 'No Error;';
end