function [results] = seeTestStat5(IDicomOrig, attenuation, radius,...
    attenDisk, thickness, diameter, cutoffs, spacing)
%% Setting Parms
pMax = length(radius);
kMax = length(attenuation);
[l,w] = size(IDicomOrig);
results = zeros(pMax, kMax)
%% Performing Calculation of Lambdas
for p = 1:pMax %All diameters
    diam = diameter(p)/10;
    s = sprintf('Now calculating detectability at %1.3f cm', diam);
    disp(s)
    binDisk = attenDisk(:,:,p);
    [r,c] = size(binDisk);
    padAmnt = (r+1)/2;
    for k = 1:kMax %All attenuations
        %Actual NPWMF
        centerImage = IDicomOrig;
        negDisk = attenDisk(:,:,p);
        avgROI = mean2(centerImage);
%         size(centerImage)
%         size(negDisk)
        attenDisks = negDisk*((avgROI-50)'*(attenuation(k) - 1)); %Is my w=gs-gn
        attenDisks = negDisk.*((centerImage-50)'*(attenuation(k) - 1));
        imgWDisk = attenDisks+centerImage;%Is my gtest
        figure; imshow(attenDisks,[])
        wnpw = attenDisks(:);
        gTest = imgWDisk(:);
        lambda = wnpw'*gTest;
        biasterm = attenDisks(:)'*attenDisks(:);
        tissueterm = attenDisks(:)'*centerImage(:);
        shouldbeLambda = biasterm+tissueterm;
        attenImg = ((IDicomOrig-50)'*(attenuation(k) - 1))';
        attenImgSquared = attenImg.*attenImg;    
        lambdaNPW(p,k) = lambda;
        
%         figure(1)
%         imshow(centerImage, [])
        figure(2)
        imshow(imgWDisk, [])
        [xSel,ySel] = ginput(1);
        if xSel <=500 & ySel <=500
            results(p,k) = 1
        elseif xSel >=500 & ySel >=500
           results(p,k) = 0
        else
            results(p,k) = -1
        end
        
%         results(p,k) = 
        
    end
end


lambdaNPW