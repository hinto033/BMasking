function [aMat, bMat, RSquare] = PerformExpFit(levels, spacing,diameter)
%Do exponential fit of the data and produce a and b values
cdDiam = diameter;
x = cdDiam(:);
oneMm = ceil(1/spacing);
twopointfiveMm = ceil(oneMm*2.5);
[nRows,nCols,p] = size(levels);
aMat = zeros(nRows,nCols);
bMat = zeros(nRows,nCols);
RSquare = zeros(nRows,nCols);
disp('Now calculating Exponential Fits of Threshold Thickness vs Diameter')
tic
for i = twopointfiveMm+1:2*twopointfiveMm:nRows
    for j = twopointfiveMm+1:2*twopointfiveMm:nCols
        %NED to take an average ofa region most likely.
        cdThickness = reshape(levels(i,j,:), [1,p]);
        y = cdThickness(:);
        [f, gof] = fit(x,y,'power1');
        RSquare(i-twopointfiveMm:i+twopointfiveMm,j-twopointfiveMm:j+twopointfiveMm) = gof.rsquare;
        coeffs = coeffvalues(f);
        aMat(i-twopointfiveMm:i+twopointfiveMm,j-twopointfiveMm:j+twopointfiveMm) = coeffs(1);
        bMat(i-twopointfiveMm:i+twopointfiveMm,j-twopointfiveMm:j+twopointfiveMm) = coeffs(2);
        %Add in the map for the different a b, and rsquared
    end
end
toc
pause
% pause
