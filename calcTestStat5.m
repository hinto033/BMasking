function [levels, IQF] = calcTestStat5(I_dicom_orig, attenuation, radius, atten_disks, thickness, diameter, cutoff, padamnt)
handles.attenuation = attenuation;
dt = round(radius.*2) + 1;
d = ceil((dt.*sqrt(2)));
%% Setting Parms

%% New Section fixed bias term...THIS SHOULD BE MOST ACCURATE< CUrrently, wrong
pmax = length(radius);
kmax = length(attenuation);
cutoff = cutoff;
[l,w] = size(I_dicom_orig)
% pause
b=2*max(d);
conv_image2 = ones(l,w, pmax)*2; 
padnum = padamnt
for p = 1:pmax %All diameters
    for k = 1:kmax %All attenuations
        neg_disk = atten_disks(:,:,p);
        pos_disk = -neg_disk;
        atten_img = ((I_dicom_orig-50)'*(handles.attenuation(k) - 1))';
        atten_img_squared = atten_img.*atten_img;
        
        
        
%         tic
%         conv_tissue = conv2(I_dicom_orig,pos_disk, 'same' ); %Maybe Valid
%         tissue_img = atten_img.*conv_tissue;
%         toc
%         tic
%         disk_img = conv2(atten_img_squared,neg_disk, 'same' ); %Maybe Valid
%         toc
%         
%         k
%         teststatimg = tissue_img + disk_img;

tic
        origpad = padarray(I_dicom_orig,[padnum padnum],'symmetric','both');
        [a,b] = size(origpad);
        D1 = fft2(origpad, a, b);
        D2 = fft2(pos_disk, a, b);
        D3 = D1.*D2;
        D4 = ifft2(D3);
        imageunpad = D4(2*padnum+1:2*padnum+l, 2*padnum+1:2*padnum+w);
        tissue_img2a = atten_img.*imageunpad;

        attenimgsquaredpad = padarray(atten_img_squared,[padnum padnum],'symmetric','both');
        [a,b] = size(attenimgsquaredpad);
        D1 = fft2(attenimgsquaredpad, a, b);
        D2 = fft2(neg_disk, a, b);
        D2(find(D2 == 0)) = 1e-6;
        D3 = D1.*D2;
        D4 = ifft2(D3);
        tissue_img2b = D4(2*padnum+1:2*padnum+l, 2*padnum+1:2*padnum+w);
        
        teststatimg2 = tissue_img2a + tissue_img2b;
        teststatimg = teststatimg2;
        toc
        
%         figure
%         imshow(teststatimg, [])
%         figure
%         imshow(teststatimg2, [])
%         pause
        
        k
        j = conv_image2(:,:, p);
        j(teststatimg>=cutoff)=thickness(k);
        conv_image2(:,:, p) = j;
    end
end

% figure
% imshow(conv_image2(:,:,4),[])
% figure
% imshow(conv_image2(:,:,8),[])
% figure
% imshow(conv_image2(:,:,12),[])
% figure
% imshow(conv_image2(:,:,16),[])


%Need to develop IQF measure
[l,w,v] = size(conv_image2);
aBase = ones(l,w);
A = zeros(l,w,pmax);
% tic
for m = 1:pmax
   A(:,:,m) = aBase*diameter(m);
end
n = pmax;
IQFdenom = dot(A,conv_image2, 3);
IQF = n./IQFdenom;
% toc
%% Set areas where i'll do calculations
maskingmap = I_dicom_orig;
% threshold 
maskingmap=maskingmap./max(maskingmap(:));
maskingmap = im2bw(maskingmap,0.2);
maskingmap = imcomplement(maskingmap);
IQF = IQF .* maskingmap;


%%
levels = conv_image2;
levels = levels(250:l-250, 250:w-250,:);
IQF = IQF(250:l-250, 250:w-250);
% figure
% imshow(IQF, [])
% pause
