function [ROI, ROIAvg, ROIStDev] = separateROI(IDicomOrig, yxCoords, pixelSpacing)

[nPnts, ~] = size(yxCoords); %Derives number of points
[nRow,nCol] = size(IDicomOrig); %makes blank template
ROIMask = zeros(nRow,nCol);
for f = 1:nPnts
ROIMask(yxCoords(f,1),yxCoords(f,2)) = 1; %Makes outline of the mask
end
% ROIMask1 = bwconvhull(ROIMask);   %May not be necessary, but more correct

%Calculates rectangular dimensions of the region
xmax = max(yxCoords(:,2)); xmin = min(yxCoords(:,2)); xrange = xmax-xmin;
ymax = max(yxCoords(:,1)); ymin = min(yxCoords(:,1)); yrange = ymax-ymin;
% Makes mask rectangular and annotation is inscribed within
ROIMask(ymin:ymax, xmin:xmax) = 1;

% Makes mask square (Chooses Max dimension)
% and dilates by 0.5 cm (5mm)
buff = round(5/pixelSpacing); %0.5 cm buffer to add to all sides
diff = (xrange-yrange)/2; %Difference in order to make square ROI
%This creates a square ROI that is 0.5 cm bigger than the largest dimension
if xrange>yrange %Wider than tall-> adds difference to make square mask
    ROIMask(ymin-diff-buff:ymax+diff +buff, xmin-buff:xmax+buff) = 1;
elseif xrange<yrange %Taller than wide-> adds difference to make square
    ROIMask(ymin-buff:ymax+buff, xmin-diff-buff:xmax+diff+buff) = 1;
else %only add the dilation because it's already square
    ROIMask(ymin-buff:ymax+buff, xmin-buff:xmax+buff) = 1;
end

ROINotCropped = ROIMask.*IDicomOrig; %Multiplies the mask by the image vals
%This crops so only the square ROI exists.
if xrange>yrange %Wider than tall
    ROI = ROINotCropped(ymin-diff-buff:ymax+diff +buff, xmin-buff:xmax+buff);
elseif xrange<yrange %Taller than wide
    ROI = ROINotCropped(ymin-buff:ymax+buff, xmin-diff-buff:xmax+diff+buff);
else
    ROI = ROINotCropped(ymin-buff:ymax +buff, xmin-buff:xmax+buff);
end
%Calculate statistics for simulated patches in future functions
ROINoZeros =ROI(ROI~=0);
ROIAvg = mean(ROINoZeros);
ROIStDev = std(ROINoZeros);
end
