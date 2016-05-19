function [cdThickness, cdDiam] = calcTestStatPoint(IDicomOrig, attenuation, radius,...
    attenDisk, thickness, diameter, cutoffs, spacing)
%% Setting Parms
pMax = length(radius);
kMax = length(attenuation);
%% Performing Calculation of Lambdas
for p = 1:pMax %All diameters
    diam = diameter(p)/10;
    s = sprintf('Now calculating detectability at %1.3f cm', diam);
    disp(s)
    binDisk = attenDisk(:,:,p);
    [r,c] = size(binDisk);
    padAmnt = (r+1)/2;
    for k = 1:kMax %All attenuations
        %To reconfirm getting same values as actual NPW, just enter the commented code
        %below into this section
        attenImg = ((IDicomOrig-50)'*(attenuation(k) - 1))';
        attenImgSquared = attenImg.*attenImg;
        
        center = size(IDicomOrig)/2+.5;
        rowSel = center(1);
        colSel = center(2);
        padA = padAmnt - 1;
        centerImage = IDicomOrig(rowSel-padA:rowSel+padA, colSel-padA:colSel+padA);
        negDisk = attenDisk(:,:,p);
        avgROI = mean2(centerImage);
        attenDisks = negDisk*((avgROI-50)'*(attenuation(k) - 1)); %Is my w=gs-gn
        attenDisks = negDisk.*((centerImage-50)'*(attenuation(k) - 1));
        imgWDisk = attenDisks+centerImage;%Is my gtest
        wnpw = attenDisks(:);
        gTest = imgWDisk(:);
        lambda = wnpw'*gTest;
        biasterm = attenDisks(:)'*attenDisks(:);
        tissueterm = attenDisks(:)'*centerImage(:);
        shouldbeLambda = biasterm+tissueterm;

        testStatImg(p,k) = lambda;

    end
end

cdDiam = diameter;
for i = 1:length(diameter)
    thicks = testStatImg(i,:);
    cutoff = cutoffs(i);
    inds = find(thicks>=cutoff);
    minInds = min(inds);
    if isempty(inds)
        cdThickness(i) = .03;
    elseif minInds ==1
        cdThickness(i) = 2;
    else
        diffA = cutoff - thicks(minInds);
        diffTot = thicks(minInds-1)-thicks(minInds);
        ratio = diffA/diffTot;
        diffThick = thickness(minInds-1)-thickness(minInds);
        testCuttoffVal = thicks(minInds) + (ratio*diffTot);
        testThickVal = thickness(minInds) + (ratio*diffThick);
        cdThickness(i) = testThickVal;
    end
end