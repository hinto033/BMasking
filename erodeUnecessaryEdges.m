function [maskingMap1] = erodeUnecessaryEdges(maskingMap1, maxArea)
se = strel('disk',10,6); trigger = 0;
while trigger == 0
    %Erodes
    maskingMap1 = imerode(maskingMap1,se);
    IDicomVector = maskingMap1(:);
    IDicomVectorNoZeros =IDicomVector(IDicomVector~=0);
    reducedArea = length(IDicomVectorNoZeros);
    %Stop eroding if area is 1/2 the original area
    if reducedArea/maxArea <=0.5
        trigger=1;
    end
end