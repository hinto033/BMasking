function [beta, errFlags] = deriveBeta(iDicomEroded, pixelSpacing, patchSize, errFlags)
[nRow,nCol] = size(iDicomEroded);
verticesX = 129:128:nCol-128; verticesY = 129:128:nRow-128; count = 0;
for rowInd = verticesX
    for colInd = verticesY
        imgRegion = iDicomEroded(colInd-128:colInd+127 , rowInd-128:rowInd+127);
        if  all(imgRegion(:))==1
            count = count+1;
            [regionnRow, regionNCol] = size(imgRegion);
            %% Compute power spectrum
            imgFFT = fftshift(fft2(imgRegion)); 
            imgfp = (abs(imgFFT)/(regionnRow*regionNCol)).^2; % Normalize
            %% Adjust PSD size % Make square
            dimDiff = abs(regionnRow-regionNCol);
            dimMax = max(regionnRow,regionNCol);
            if regionnRow > regionNCol                                                                    % More rows than columns
                if ~mod(dimDiff,2); imgfp = [NaN(regionnRow,dimDiff/2) imgfp NaN(regionnRow,dimDiff/2)];   % Even difference   % Pad columns to match dimensions
                else imgfp = [NaN(regionnRow,floor(dimDiff/2)) imgfp NaN(regionnRow,floor(dimDiff/2)+1)];   % Odd difference
                end
            elseif regionnRow < regionNCol                                                                % More columns than rows
                if ~mod(dimDiff,2); imgfp = [NaN(dimDiff/2,regionNCol); imgfp; NaN(dimDiff/2,regionNCol)];                % Pad rows to match dimensions
                else imgfp = [NaN(floor(dimDiff/2),regionNCol); imgfp; NaN(floor(dimDiff/2)+1,regionNCol)];% Pad rows to match dimensions
                end
            end
%             halfDim = floor(dimMax/2) + 1;                                              % Only consider one half of spectrum (due to symmetry)
            %% Compute radially average power spectrum
            [X, Y] = meshgrid(-dimMax/2:dimMax/2-1, -dimMax/2:dimMax/2-1);               % Make Cartesian grid
            [theta, rho] = cart2pol(X, Y); rho = round(rho);                             % Convert to polar coordinate axes
            i = cell(floor(dimMax/2) + 1, 1);
            for nRow = 0:floor(dimMax/2)
                i{nRow + 1} = find(rho == nRow);
            end
            Pf = zeros(1, floor(dimMax/2)+1);
            for nRow = 0:floor(dimMax/2)
                Pf(1, nRow + 1) = nanmean( imgfp( i{nRow+1} ) );
            end
            %Adjust the xs             %Do linear fit
            cyclePerMmPerPixel = 1/(patchSize*pixelSpacing);
            freqMin = 0.15; freqMax = 0.9;  %Have seen fMax of 0.7 and 1
            LoPixels = round(freqMin/cyclePerMmPerPixel);
            HiPixels = round(freqMax/cyclePerMmPerPixel);
            ys = Pf(LoPixels:HiPixels); y_fit = log(ys);
            xs = 0:cyclePerMmPerPixel:1.5;
            xs = xs(LoPixels:HiPixels); x_fit = log(xs); 
            linFitCoeffs = polyfit(x_fit,y_fit,1); betas(count) = -linFitCoeffs(1);
        else
        end
    end
end
if count ==0
    errFlags.Beta = 'No region large enough to calculate Beta - Do not Trust';
    errFlags.stop = 1;
    beta = 3;
else
    beta = sum(betas)/count;
end
if beta >4 || beta<2
    beta = 3;
    disp('Error in Beta derivation. Value of 3 was assumed')
    errFlags.Beta = 'Error in Beta derivation. Value of 3 was assumed';
else errFlags.Beta = 'No Error';
end