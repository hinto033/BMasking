function [levels, IQF] = calcTestStat5(I_dicom_orig, BW1, center, attenuation, radius, atten_disks, thickness, diameter)
handles.attenuation = attenuation;
dt = round(radius.*2) + 1;
d = ceil((dt.*sqrt(2)));
%% Setting Parms
largeRectRegion = I_dicom_orig(center(1) - max(d):center(1) + max(d),center(2) - max(d):center(2) + max(d));
bkgr_roi = mean2(largeRectRegion);
disk_diff = ((bkgr_roi-50)'*(handles.attenuation - 1))';
pmax = length(radius);
kmax = length(attenuation);
[l,w] = size(I_dicom_orig);
b=2*max(d);
conv_image2 = zeros(l-b,w-b, pmax); 
cutoff = 110000;
% pause

avgfilt = ones(size(atten_disks(:,:,1)));
[a,b]=size(avgfilt);
avgfilt = avgfilt/(a*b);


biasMat = conv2(I_dicom_orig, avgfilt, 'valid');
figure
imshow(biasMat, [])
pause
for p = 1:pmax %All diameters
    for k = 1:kmax %All attenuations
        atten_disk2 = atten_disks(:,:,p)*disk_diff(k);
        pos_disk = -atten_disk2;
        bias_term = pos_disk(:)' * atten_disk2(:);
        
        tic
        conv_image = conv2(I_dicom_orig,pos_disk, 'valid' );
        toc
        teststatimg = conv_image + bias_term;

        j = conv_image2(:,:, p);
        j(teststatimg>=cutoff)=thickness(k);
        conv_image2(:,:, p) = j;
    end
end

% for p = 1:pmax %All diameters
%     for k = 1:kmax %All attenuations
%         atten_disk2 = atten_disks(:,:,p)*disk_diff(k);
%         pos_disk = -atten_disk2;
%         bias_term = pos_disk(:)' * atten_disk2(:);
%         
%         tic
%         conv_image = conv2(I_dicom_orig,pos_disk, 'valid' );
%         toc
%         teststatimg = conv_image + bias_term;
% 
%         j = conv_image2(:,:, p);
%         j(teststatimg>=cutoff)=thickness(k);
%         conv_image2(:,:, p) = j;
%     end
% end
%Need to develop IQF measure
[l,w,m] = size(conv_image2);
aBase = ones(l,w);
A = zeros(l,w,pmax);
tic
for m = 1:pmax
   A(:,:,m) = aBase*diameter(m);
end
n = pmax
IQFdenom = dot(A,conv_image2, 3);
IQF = n./IQFdenom;
toc

levels = conv_image2;
IQF = IQF;