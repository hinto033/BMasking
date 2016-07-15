function [beta, errFlags] = deriveBeta(IDicomEroded, pixelSpacing, patchSize, errFlags)
[r,c] = size(IDicomEroded);
verticesx = 129:128:c-128; verticesy = 129:128:r-128; count = 0;
for j = verticesx
    for k = verticesy
        patch = IDicomEroded(k-128:k+127 , j-128:j+127);
        if  all(patch(:))==1
            count = count+1;
            img = patch; [N M] = size(img); %Take fft
            %% Compute power spectrum
            imgf = fftshift(fft2(img)); imgfp = (abs(imgf)/(N*M)).^2;                    % Normalize
            %% Adjust PSD size % Make square
            dimDiff = abs(N-M);  dimMax = max(N,M);
            if N > M                                                                    % More rows than columns
                if ~mod(dimDiff,2); imgfp = [NaN(N,dimDiff/2) imgfp NaN(N,dimDiff/2)];   % Even difference   % Pad columns to match dimensions
                else; imgfp = [NaN(N,floor(dimDiff/2)) imgfp NaN(N,floor(dimDiff/2)+1)];   % Odd difference
                end
            elseif N < M                                                                % More columns than rows
                if ~mod(dimDiff,2); imgfp = [NaN(dimDiff/2,M); imgfp; NaN(dimDiff/2,M)];                % Pad rows to match dimensions
                else; imgfp = [NaN(floor(dimDiff/2),M); imgfp; NaN(floor(dimDiff/2)+1,M)];% Pad rows to match dimensions
                end
            end
            halfDim = floor(dimMax/2) + 1;                                              % Only consider one half of spectrum (due to symmetry)
            %% Compute radially average power spectrum
            [X Y] = meshgrid(-dimMax/2:dimMax/2-1, -dimMax/2:dimMax/2-1);               % Make Cartesian grid
            [theta rho] = cart2pol(X, Y); rho = round(rho);                             % Convert to polar coordinate axes
            i = cell(floor(dimMax/2) + 1, 1);
            for r = 0:floor(dimMax/2)
                i{r + 1} = find(rho == r);
            end
            Pf = zeros(1, floor(dimMax/2)+1);
            for r = 0:floor(dimMax/2)
                Pf(1, r + 1) = nanmean( imgfp( i{r+1} ) );
            end
            %Adjust the xs             %Do linear fit
            cyclePerMmPerPixel = 1/(patchSize*pixelSpacing);
            fmin = 0.15; fmax = 0.9;  %Have seen fMax of 0.7 and 1
            LoPixels = round(fmin/cyclePerMmPerPixel);
            HiPixels = round(fmax/cyclePerMmPerPixel);
            ys = Pf(LoPixels:HiPixels); y_fit = log(ys);
            xs = 0:cyclePerMmPerPixel:1.5;
            xs = xs(LoPixels:HiPixels); x_fit = log(xs); 
            P = polyfit(x_fit,y_fit,1); betas(count) = -P(1);
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