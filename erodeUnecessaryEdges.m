function [erodedMap] = erodeUnecessaryEdges(binaryBreast, maxArea)
se = strel('disk',40,8); trigger = 0;
while trigger == 0
    %Erodes
    binaryBreast = imerode(binaryBreast,se);
    IDicomVector = binaryBreast(:);
    IDicomVectorNoZeros =IDicomVector(IDicomVector~=0);
    reducedArea = length(IDicomVectorNoZeros);
    %Stop eroding if area is 1/2 the original area
    if reducedArea/maxArea <=0.5
        trigger=1;
    end
end
erodedMap = binaryBreast;