function [SigmaPixels] = determineMTF(IDicomOrig)
IDicomOrig(all(IDicomOrig>10000,2),:)=[];
[r,c] = size(IDicomOrig)
deriv = zeros(1,c);
maxDiff = 0;
Slope = 0;
for p = 1:r
    for m = 2:c-1
    deriv(m) = abs(IDicomOrig(p,m) -IDicomOrig(p,m+1));
    end
    %Finds peak derivative (Max slope)
    maxDeriv = max(deriv);
    peakInd = find(deriv==maxDeriv);
    thresh = 15;   %This is arbitrary and I might need to change it.
    %Finds locations where the derivative is small
    arrayZeros = find(deriv<thresh);
    f = arrayZeros;
    %Finds 'zero' locations to left and right of the peak derivative
    valToFind = peakInd(1);
    tmp = (f-valToFind);
    tmpAbove = tmp(tmp>0);
    [idxAbove] = min(tmpAbove); 
    closestAbove = f(idxAbove); %closest value
    TruIDXAbove = peakInd+closestAbove;
    derivAtVal = deriv(TruIDXAbove);
    
    tmpBelow = abs(tmp(tmp<0));
    [idxBelow] = min(tmpBelow);
    TruIDXBelow = peakInd-idxBelow;
    derivAtValBelow = deriv(TruIDXBelow);
    
    eee = (TruIDXAbove-TruIDXBelow)+1;

    
    %Calculate Slope and maximum
    maxDiffTest = abs(IDicomOrig(p,TruIDXAbove) - IDicomOrig(p,TruIDXBelow));
    SlopeTest = maxDiffTest/(TruIDXAbove - TruIDXBelow);
    %Saves this row and relevant data if the slope in this row is larger
    %than any other row I've seen.
    if SlopeTest >=Slope
        p %Displays the row if I find a new peak slope
        maxDiff = maxDiffTest;
        Signal = IDicomOrig(p,TruIDXBelow:TruIDXAbove);
        SignalLength = eee;
        DerivSignal = deriv(TruIDXBelow:TruIDXAbove);
        rowNumber = p;
        colIndices = [TruIDXAbove, TruIDXBelow];
        Slope = maxDiff / (TruIDXAbove - TruIDXBelow);
    end
end
%Plots to check that the function worked well
figure(1)
plot(1:c, IDicomOrig(rowNumber,:))
figure(3)
plot(1:SignalLength, Signal)
%This is my lineSpreadFunction (The derivative)
figure(4)
plot(1:SignalLength, DerivSignal)
%Do gaussian fit to determine the proper amoutn of blur
%Assumes LSF = PSF
yData = DerivSignal' / max(DerivSignal);
xData = linspace(1,SignalLength, SignalLength)';
[f, gof] = fit(xData,yData,'gauss1')
figure(5)
plot(f,xData,yData)
%Calculates gaussian fit so I can find my sigma
r2 = gof.rsquare; coeffs = coeffvalues(f);
Scaling = coeffs(1); OffSet = coeffs(2); SigmaPixels = coeffs(3);
Sigmamm = SigmaPixels* .07;
%MTF = FFT of LineSpreadFunction
xMTF = linspace(-10, 10, 100);
LSF = Scaling*exp(-((xMTF-OffSet)./SigmaPixels).^2);
MTF = fft(LSF);
figure(9)
plot(abs(MTF))
pause