function [cdData, IQF] = calcIQF2(results, cutoff, thickness, diameter)

handles.thickness = thickness;
handles.diameter = diameter;
numberDiams = length(handles.diameter);
cdData = zeros(1,2);
% results
% pause
% cutoff
% pause
iqfDenom = 0;
    for j = 1:numberDiams%6 %Scroll through diameters 1:16
        minThickness = find(results(j,:) < cutoff);
%         pause
        if isempty(minThickness)
            minThickness = 16; %(the minimum thickness) I might need to change this to maximum thickness
            thresholdThickness = 2;
        elseif max(minThickness) == 16
            thresholdThickness = 0.03;
        else
            pn = results(j, max(minThickness));
            pnMinusOne = results(j, max(minThickness)+1);
            tn = thickness(max(minThickness));
            tnMinusOne = thickness(max(minThickness)+1);
            thresholdThickness = (((cutoff - pnMinusOne)/(pn - pnMinusOne)) * (tn - tnMinusOne)) + tnMinusOne;
            
%                         pause
            if thresholdThickness < 0 
                thresholdThickness = 0;
            elseif thresholdThickness > 2
                thresholdThickness = 2;
            end
        end
        cdData(j,:) = [diameter(j) , thresholdThickness];
        iqfDenom = iqfDenom + (cdData(j,1)*cdData(j,2));
    end
    IQF = numberDiams/iqfDenom;  %All diameters
%     IQF(2) = (numberDiams/2)/((cdData((numberDiams/2)+1:numberDiams,1)'*cdData((numberDiams/2)+1:numberDiams,2)));  %Diameters .06-0.5 mm
%     IQF(3) = (numberDiams/2)/((cdData(1:(numberDiams/2),1)'*cdData(1:(numberDiams/2),2)));% Diameters .63-10 mm
end
