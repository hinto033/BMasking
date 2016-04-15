function [levels, IQF, IQFLarge, IQFMed,IQFSmall] = calcTestStat5(I_dicom_orig, attenuation, radius, atten_disks, thickness, diameter, cutoff, padamnt)
%% Setting Parms
pmax = length(radius);
kmax = length(attenuation);
[l,w] = size(I_dicom_orig);
conv_image2 = ones(l,w, pmax)*2; 
%% Performing Calculation of Lambdas
for p = 1:pmax %All diameters
    for k = 1:kmax %All attenuations
        neg_disk = atten_disks(:,:,p);
        pos_disk = -neg_disk;
        atten_img = ((I_dicom_orig-50)'*(attenuation(k) - 1))';
        atten_img_squared = atten_img.*atten_img;    
        if diameter(p)>=2 %If diameter of disk is greater or equal to 2 mm ->Do FFT
            tic
            origpad = padarray(I_dicom_orig,[padamnt padamnt],'symmetric','both');
            [a,b] = size(origpad);
            D1 = fft2(origpad, a, b);
            D2 = fft2(pos_disk, a, b); D2(find(D2 == 0)) = 1e-6; %If it goes wrong, comment out this section
            D3 = D1.*D2; D4 = ifft2(D3);
            imageunpad = D4(2*padamnt+1:2*padamnt+l, 2*padamnt+1:2*padamnt+w);
            tissue_img2a = atten_img.*imageunpad;

            attenimgsquaredpad = padarray(atten_img_squared,[padamnt padamnt],'symmetric','both');
            [a,b] = size(attenimgsquaredpad);
            D1 = fft2(attenimgsquaredpad, a, b);
            D2 = fft2(neg_disk, a, b); D2(find(D2 == 0)) = 1e-6;
            D3 = D1.*D2; D4 = ifft2(D3);
            tissue_img2b = D4(2*padamnt+1:2*padamnt+l, 2*padamnt+1:2*padamnt+w);

            teststatimg = tissue_img2a + tissue_img2b;
            toc
        elseif diameter(p)<2 %Do Conv if diameter less than 2 mm 
            %(Because faster than fft for small signals)
            tic
            conv_tissue = conv2(I_dicom_orig,pos_disk, 'same' ); %Maybe Valid
            tissue_img = atten_img.*conv_tissue;
            disk_img = conv2(atten_img_squared,neg_disk, 'same' ); %Maybe Valid
            toc
            teststatimg = tissue_img + disk_img;
        end
        j = conv_image2(:,:, p);
        j(teststatimg>=cutoff)=thickness(k);
        conv_image2(:,:, p) = j;
    end
end
%% Calculate Full IQF
[l,w,v] = size(conv_image2);
aBase = ones(l,w);
A = zeros(l,w,pmax);
for m = 1:pmax
   A(:,:,m) = aBase*diameter(m);
end
n = pmax;
IQFdenom = dot(A,conv_image2, 3);
IQF = sum(diameter(:))./IQFdenom;  %originally n./IQFdenom;, but this way normalizes for different ranges
%% Calculate Subset IQFs
IQFLargeDenom = dot(A(:,:,1:6),conv_image2(:,:,1:6), 3);
IQFMedDenom = dot(A(:,:,7:12),conv_image2(:,:,7:12), 3);
IQFSmallDenom = dot(A(:,:,13:20),conv_image2(:,:,13:20), 3);
IQFLarge = sum(diameter(1:6))./IQFLargeDenom;
IQFMed = sum(diameter(7:12))./IQFMedDenom;
IQFSmall = sum(diameter(13:20))./IQFSmallDenom;
%% Set areas where i'll do calculations
maskingmap = I_dicom_orig;
% threshold 
maskingmap= maskingmap./max(maskingmap(:));
maskingmap = im2bw(maskingmap,0.2);
maskingmap = imcomplement(maskingmap);
IQF = IQF .* maskingmap;
IQFLarge = IQFLarge .* maskingmap;
IQFMed = IQFMed .* maskingmap;
IQFSmall = IQFSmall .* maskingmap;
%% Undo the padding
levels = conv_image2;
levels = levels(padamnt:l-padamnt, padamnt:w-padamnt,:);
IQF = IQF(padamnt:l-padamnt, padamnt:w-padamnt);
IQFLarge = IQFLarge(padamnt:l-padamnt, padamnt:w-padamnt);
IQFMed = IQFMed(padamnt:l-padamnt, padamnt:w-padamnt);
IQFSmall = IQFSmall(padamnt:l-padamnt, padamnt:w-padamnt);
figure
imshow(IQF, [])
figure
imshow(IQFLarge, [])
figure
imshow(IQFMed, [])
figure
imshow(IQFSmall, [])

