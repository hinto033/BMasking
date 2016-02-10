function [cdData, IQF] = calcIQF(results, cutoff, thickness, diameter)
handles.results = results;
handles.thickness = thickness;
handles.diameter = diameter;
numberDiams = length(handles.diameter);
cdData = zeros(1,2);
iqfDenom = 0;
    for j = 1:numberDiams%6 %Scroll through diameters 1:16
        handles.results(:,j);  %Shows all the p values at that diameter
%         minThickness = find(handles.results(:,j) > cutoff); for t test
        minThickness = find(handles.results(:,j) < cutoff);
        if isempty(minThickness)
            minThickness = 14; %(the minimum thickness) I might need to change this to maximum thickness
        end
        if minThickness(1) == 1
            thresholdThickness = 2;
        else
            pn = handles.results(minThickness(1), j);
            %pn = handles.lambda(minThickness(1), j);
            pnMinusOne = handles.results(minThickness(1) - 1, j);
            %pnMinusOne = handles.lambda(minThickness(1) - 1, j);
            tn = handles.thickness(minThickness(1));
            tnMinusOne = handles.thickness(minThickness(1) - 1);
            thresholdThickness = (((cutoff - pnMinusOne)/(pn - pnMinusOne)) * (tn - tnMinusOne)) + tnMinusOne;
            if thresholdThickness < 0 
                thresholdThickness = 0;
            elseif thresholdThickness > 2
                thresholdThickness = 2;
            end
        end
        cdData(j,:) = [handles.diameter(j) , thresholdThickness];
        iqfDenom = iqfDenom + (cdData(j,1)*cdData(j,2));
    end
    IQF = numberDiams/iqfDenom;
end
