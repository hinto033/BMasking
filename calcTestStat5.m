function [levels, IQF] = calcTestStat5(I_dicom_orig, BW1, center, attenuation, radius, atten_disks, thickness, diameter)
handles.attenuation = attenuation;
dt = round(radius.*2) + 1;
d = ceil((dt.*sqrt(2)));
%% Setting Parms
% pmax = length(radius);
% kmax = length(attenuation);
% cutoff = 144500;
% [l,w] = size(I_dicom_orig);
% b=2*max(d);
% conv_image2 = zeros(l,w, pmax); 

% for p = 1%1:pmax %All diameters
%     for k = 9%1:kmax %All attenuations
%         disk_diff_img = ((I_dicom_orig-50)'*(handles.attenuation(k) - 1))';
%         
%         atten_disk = atten_disks(:,:,p);
% 
%         xt = conv2(I_dicom_orig,atten_disk, 'same' );
%         size(xt)
%         size(I_dicom_orig)
%         
%         yt = I_dicom_orig - xt;
%         
%         conv_image2(:,:,p) = xt.*yt;
%         teststatimg = conv_image2(:,:,p);
% 
% 
%         j = conv_image2(:,:, p);
%         j(teststatimg>=cutoff)=thickness(k);
%         conv_image2(:,:, p) = j;
%         
%         
%         figure
%         imshow(conv_image2(:,:,p),[])
%         pause
%     end
% end




%% 

% % % 
% % % 
% % % largeRectRegion = I_dicom_orig(center(1) - max(d):center(1) + max(d),center(2) - max(d):center(2) + max(d));
% % % bkgr_roi = mean2(largeRectRegion);
% % % disk_diff_img = ((bkgr_roi-50)'*(handles.attenuation - 1))';
% % % pmax = length(radius);
% % % kmax = length(attenuation);
% % % [l,w] = size(I_dicom_orig);
% % % b=2*max(d);
% % % conv_image2 = zeros(l-b,w-b, pmax); 
% % % cutoff = 110000;
% % % % pause
% % % 
% % % avgfilt = ones(size(atten_disks(:,:,1)));
% % % [a,b]=size(avgfilt);
% % % avgfilt = avgfilt/(a*b);
% % % 
% % % 
% % % biasMat = conv2(I_dicom_orig, avgfilt, 'valid');
% % % figure
% % % imshow(biasMat, [])
% % % pause
% % % for p = 1:pmax %All diameters
% % %     for k = 1:kmax %All attenuations
% % %         atten_disk2 = atten_disks(:,:,p)*disk_diff(k);
% % %         pos_disk = -atten_disk2;
% % %         bias_term = pos_disk(:)' * atten_disk2(:);
% % %         
% % %         tic
% % %         conv_image = conv2(I_dicom_orig,pos_disk, 'valid' );
% % %         toc
% % %         teststatimg = conv_image + bias_term;
% % % 
% % %         j = conv_image2(:,:, p);
% % %         j(teststatimg>=cutoff)=thickness(k);
% % %         conv_image2(:,:, p) = j;
% % %     end
% % % end

%% New Section fixed bias term...THIS SHOULD BE MOST ACCURATE< CUrrently, wrong
pmax = length(radius);
kmax = length(attenuation);
cutoff = 144500;
[l,w] = size(I_dicom_orig);
b=2*max(d);
conv_image2 = zeros(l,w, pmax); 

% disk_diff_img = ((I_dicom_orig-50)'*(handles.attenuation - 1))';

for p = 1:pmax %All diameters
    for k = 1:kmax %All attenuations
        neg_disk = atten_disks(:,:,p);
        pos_disk = -neg_disk;
        atten_img = ((I_dicom_orig-50)'*(handles.attenuation(k) - 1))';
        
%         atten_disk2 = atten_disks(:,:,p)*disk_diff(k);
%         pos_disk = -atten_disk2;
%         bias_term = pos_disk(:)' * neg_disk(:);
%         bias_img = (atten_img.*atten_img)*bias_term;
        
        tic
        bias_conv_image = conv2(atten_img,pos_disk, 'same' );
        bias_img = -(bias_conv_image.*bias_conv_image);
        toc
        
        tic
        conv_image = conv2(I_dicom_orig,pos_disk, 'same' ); %Maybe Valid
        toc
        
        size(conv_image)
        size(bias_img)
        conv_imgf = atten_img.*conv_image;
        teststatimg = conv_imgf + bias_img;

        j = conv_image2(:,:, p);
        j(teststatimg>=cutoff)=thickness(k);
        conv_image2(:,:, p) = j;
        

    end
end

figure
imshow(conv_image2(:,:,4),[])
figure
imshow(conv_image2(:,:,8),[])
figure
imshow(conv_image2(:,:,12),[])
figure
imshow(conv_image2(:,:,16),[])
% pause




%% New Section if Wanted %Produces similar to OG Results, which is good.
pmax = length(radius);
kmax = length(attenuation);
cutoff = 144500;
[l,w] = size(I_dicom_orig);
b=2*max(d);
conv_image2 = zeros(l,w, pmax); 

% disk_diff_img = ((I_dicom_orig-50)'*(handles.attenuation - 1))';

for p = 1:pmax %All diameters
    for k = 1:kmax %All attenuations
        neg_disk = atten_disks(:,:,p);
        pos_disk = -neg_disk;
        atten_img = ((I_dicom_orig-50)'*(handles.attenuation(k) - 1))';
        
%         atten_disk2 = atten_disks(:,:,p)*disk_diff(k);
%         pos_disk = -atten_disk2;
        bias_term = pos_disk(:)' * neg_disk(:);
        bias_img = (atten_img.*atten_img)*bias_term;
        tic
        conv_image = conv2(I_dicom_orig,pos_disk, 'same' ); %Maybe Valid
        toc
        
        size(conv_image)
        size(bias_img)
        conv_imgf = atten_img.*conv_image;
        teststatimg = conv_imgf + bias_img;
%         teststatimg = conv_imgf + bias_term; this produced items similar
%         to what we needed (The OG Result)

        j = conv_image2(:,:, p);
        j(teststatimg>=cutoff)=thickness(k);
        conv_image2(:,:, p) = j;
        

    end
end

figure
imshow(conv_image2(:,:,4),[])
figure
imshow(conv_image2(:,:,8),[])
figure
imshow(conv_image2(:,:,12),[])
figure
imshow(conv_image2(:,:,16),[])
pause

%% OG Section
pmax = length(radius);
kmax = length(attenuation);
cutoff = 144500;
[l,w] = size(I_dicom_orig);
b=2*max(d);
conv_image2 = zeros(l-b,w-b, pmax); 
largeRectRegion = I_dicom_orig(center(1) - max(d):center(1) + max(d),center(2) - max(d):center(2) + max(d));
bkgr_roi = mean2(largeRectRegion);
disk_diff = ((bkgr_roi-50)'*(handles.attenuation - 1))';

for p = 1:pmax %All diameters
    for k = 1:kmax %All attenuations
        atten_disk2 = atten_disks(:,:,p)*disk_diff(k);
        pos_disk = -atten_disk2;
        bias_term = pos_disk(:)' * atten_disk2(:);
        
        tic
        conv_image = conv2(I_dicom_orig,pos_disk, 'valid' );
        toc
        k
        teststatimg = conv_image + bias_term;

        j = conv_image2(:,:, p);
        j(teststatimg>=cutoff)=thickness(k);
        conv_image2(:,:, p) = j;
        

    end
end

figure
imshow(conv_image2(:,:,4),[])
figure
imshow(conv_image2(:,:,8),[])
figure
imshow(conv_image2(:,:,12),[])
figure
imshow(conv_image2(:,:,16),[])
pause

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