function [levels, IQF] = calcTestStat5(I_dicom_orig, attenuation, radius, atten_disks, thickness, diameter, cutoff)
handles.attenuation = attenuation;
dt = round(radius.*2) + 1;
d = ceil((dt.*sqrt(2)));
%% Setting Parms

%% New Section fixed bias term...THIS SHOULD BE MOST ACCURATE< CUrrently, wrong
pmax = length(radius);
kmax = length(attenuation);
cutoff = cutoff;
[l,w] = size(I_dicom_orig);
b=2*max(d);
conv_image2 = ones(l,w, pmax)*2; 

for p = 1:pmax %All diameters
    for k = 1:kmax %All attenuations
        neg_disk = atten_disks(:,:,p);
        pos_disk = -neg_disk;
        atten_img = ((I_dicom_orig-50)'*(handles.attenuation(k) - 1))';
        atten_img_squared = atten_img.*atten_img;
        
        tic
        conv_tissue = conv2(I_dicom_orig,pos_disk, 'same' ); %Maybe Valid
        tissue_img = atten_img.*conv_tissue;
        toc
        tic
        disk_img = conv2(atten_img_squared,neg_disk, 'same' ); %Maybe Valid
        toc
        
        k
        teststatimg = tissue_img + disk_img;

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
% figure
% imshow(IQF, [])

%%
levels = conv_image2;
levels = levels(250:l-250, 250:w-250,:);
IQF = IQF(250:l-250, 250:w-250);
