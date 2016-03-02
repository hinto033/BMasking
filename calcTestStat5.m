function [results] = calcTestStat5(I_dicom_orig, BW1, center, attenuation, radius, atten_disks, thickness)
handles.attenuation = attenuation;
% handles.thickness = [2, 1.42, 1, .71, .5, .36, .25, .2, .16, .13, .1, .08, .06, .05, .04, .03]; %um
dt = round(radius.*2) + 1;
d = ceil((dt.*sqrt(2)));
%% Below this line has to be done after every change of the center.
largeRectRegion = I_dicom_orig(center(1) - max(d):center(1) + max(d),center(2) - max(d):center(2) + max(d));
bkgr_roi = mean2(largeRectRegion);
disk_diff = ((bkgr_roi-50)'*(handles.attenuation - 1))';
handles.xtest = BW1(center(1)-d:center(1)+d, center(2)-d:center(2)+d);  
handles.xtest1 = handles.xtest(:)';
pmax = length(radius)
kmax = length(attenuation)
handles.lambda_npwmf1 = zeros(kmax,pmax);
[l,w] = size(I_dicom_orig)
% conv_image2 = zeros(l,w,kmax, pmax); %TOO LARGE
conv_image2 = zeros(l,w, pmax); %TOO LARGE
cutoff = 110000;
% pause
for p = 1:pmax %All diameters
    for k = 1:kmax %All attenuations
        atten_disk2 = atten_disks(:,:,p)*disk_diff(k);
%         inserted = largeRectRegion + atten_disk2;
%         handles.ytest1 = inserted(:)';
        pos_disk = -atten_disk2;
%         figure
%         imshow(atten_disk2,[])
%         figure 
%         imshow(pos_disk)

        bias_term = pos_disk(:)' * atten_disk2(:);
tic
        conv_image = conv2(I_dicom_orig,pos_disk, 'same' );
    toc
%         figure
%         imshow(conv_image,[])
        c = clock
%         pause
        teststatimg = conv_image + bias_term;
% %         teststatimg(teststatimg<cutoff)=0;
% %         teststatimg(teststatimg>=cutoff)=k;
%         size(conv_image2(:,:, p))
%         size(teststatimg)
        j = conv_image2(:,:, p);
j(teststatimg>=cutoff)=thickness(k);
conv_image2(:,:, p) = j;
%         conv_image2(:,:, p) = conv_image2(l,w, p) + teststatimg;
%         figure
%         imshow(conv_image2,[])

%         lambda = (handles.xtest1 - handles.ytest1) * handles.ytest1';
%         handles.lambda_npwmf1(k,p) = lambda;
    end
end
figure
imshow(conv_image2(:,:, 4), [])
figure
imshow(conv_image2(:,:, 8), [])
figure
imshow(conv_image2(:,:, 12), [])
figure
imshow(conv_image2(:,:, 16), [])

%Need to develop IQF measure
%Need to develop way to visualize the data for all the regions 

% IQF = 

% 
% thresh=my_image;
% thresh(thresh<0.5)=0;
% thresh(thresh>3)=255;

% % read in tiff image and convert it to double format
% my_image = im2double(imread('picture.tif'));
% my_image = my_image(:,:,1);
% % perform thresholding by logical indexing
% image_thresholded = my_image;
% image_thresholded(my_image>3) = 256;
% image_thresholded(my_image<0.5) = 0;
% % display result
% figure()
% subplot(1,2,1)
% imshow(my_image,[])
% title('original image')
% subplot(1,2,2)
% imshow(image_thresholded,[])
% title('thresholded image')

% conv_image2(200,200,:,:) %Should be test stat matrix at pixel 200,200

npwmf1 = handles.lambda_npwmf1;
results = npwmf1;