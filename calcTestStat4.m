function [results] = calcTestStat4(I_dicom_orig, BW1, center, attenuation, radius, atten_disks)
handles.attenuation = attenuation;
dt = round(radius.*2) + 1;
d = ceil((dt.*sqrt(2)));
%% Below this line has to be done after every change of the center.
largeRectRegion = I_dicom_orig(center(1) - max(d):center(1) + max(d),center(2) - max(d):center(2) + max(d));
bkgr_roi = mean2(largeRectRegion);
disk_diff = ((bkgr_roi-50)'*(handles.attenuation - 1))';
handles.xtest = BW1(center(1)-d:center(1)+d, center(2)-d:center(2)+d);  
handles.xtest1 = handles.xtest(:)';
pmax = length(radius);
kmax = length(attenuation);
handles.lambda_npwmf1 = zeros(kmax,pmax);
for p = 1:pmax %All diameters
    for k = 1:kmax %All attenuations
        atten_disk2 = atten_disks(:,:,p)*disk_diff(k);
        inserted = largeRectRegion + atten_disk2;
        handles.ytest1 = inserted(:)';
        figure
        imshow(handles.xtest-inserted,[])
        figure
        imshow(inserted,[])
        pause
        lambda = (handles.xtest1 - handles.ytest1) * handles.ytest1';
        handles.lambda_npwmf1(k,p) = lambda;
    end
end
npwmf1 = handles.lambda_npwmf1;
results = npwmf1;