function [lambdaNPW, lambdaFFT,lambdaConv] = confirmCalcs(IDicomOrig, attenuation, radius,...
    attenDisk, thickness, diameter, cutoffs, spacing)
%% Setting Parms
pMax = length(radius);
kMax = length(attenuation);
[l,w] = size(IDicomOrig);
%% Performing Calculation of Lambdas
for p = 6:6%pMax %All diameters
    diam = diameter(p)/10;
    s = sprintf('Now calculating detectability at %1.3f cm', diam);
    disp(s)
    binDisk = attenDisk(:,:,p);
    [r,c] = size(binDisk);
    padAmnt = (r+1)/2;
    for k = 1:1%kMax %All attenuations
        %Actual NPWMF
        centerImage = IDicomOrig;
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
        attenImg = ((IDicomOrig-50)'*(attenuation(k) - 1))';
        attenImgSquared = attenImg.*attenImg;    
        lambdaNPW = lambda;
        
        %FFT Image
        origPad = padarray(IDicomOrig,[padAmnt padAmnt],'symmetric','both');
        [a,b] = size(origPad);
        %Tissue Image
        D1 = fft2(binDisk, a, b);% D1(find(D1 == 0)) = 1e-8;
        attenAndTiss = attenImg.*IDicomOrig;
        D2 = fft2(attenAndTiss, a, b);
        D4 = D1.*D2;
        D5 = ifft2(D4);
        imageUnpad = D5(padAmnt+1:padAmnt+l, padAmnt+1:padAmnt+w);
        tissueImg2a = imageUnpad;
        %Bias Image
        [a,b] = size(origPad);
        D2 = fft2(binDisk, a, b); %D2(find(D2 == 0)) = 1e-8;          
        D1 = fft2(attenImgSquared, a, b);
        D3 = D1.*D2; 
        D4 = ifft2(D3);
        tissueImg2b = D4(padAmnt+1:padAmnt+l, padAmnt+1:padAmnt+w);
        testStatImg = tissueImg2a + tissueImg2b;

        center = size(testStatImg)/2 + .5;
        biasfft = tissueImg2b(center(1), center(2));
        tissftt = tissueImg2a(center(1), center(2));
        fftlambda = testStatImg(center(1), center(2));
        lambdaFFT = fftlambda;
        %Conv Section           
        convTissue = attenImg.*IDicomOrig;
        tissue_img = conv2(convTissue,binDisk, 'valid' );
        diskImg = conv2(attenImgSquared,binDisk, 'valid' ); %Maybe Valid
        testStatImg = tissue_img + diskImg;  
        biasconv = diskImg;
        tissconv = tissue_img;   
        convlambda = testStatImg;
        lambdaConv = convlambda;
    end
end