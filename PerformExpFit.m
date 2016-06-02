function [aMat, bMat, RSquare] = PerformExpFit(levels, spacing,diameter)
%Do exponential fit of the data and produce a and b values
cdDiam = diameter;
x = cdDiam(8:20)';
halfmm = ceil(.5/spacing);
mm = halfmm*2;
[nRows,nCols,p] = size(levels);
aMat = zeros(nRows,nCols);
bMat = zeros(nRows,nCols);
RSquare = zeros(nRows,nCols);
disp('Now calculating Exponential Fits of Threshold Thickness vs Diameter')
tic
for i = mm+1:2*mm:nRows
    for j = mm+1:2*mm:nCols
        cdThickness = reshape(levels(i,j,:), [1,p]);
        y = cdThickness(8:20)';
        [f, gof] = fit(x,y,'power1');
        RSquare(i-mm:i+mm,j-mm:j+mm) = gof.rsquare;
        coeffs = coeffvalues(f);
        aMat(i-mm:i+mm,j-mm:j+mm) = coeffs(1);
        bMat(i-mm:i+mm,j-mm:j+mm) = coeffs(2);
        %Add in the map for the different a b, and rsquared
    end
end
toc
% pause
