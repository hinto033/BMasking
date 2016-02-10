function [results] = calcTestStat(I_dicom_orig, BW1, center, attenuation,thickness,diameter)
global roi_size max_diam center_circ radius2 pixelshift magn pixel shape
handles.attenuation = attenuation;
handles.thickness = thickness;
handles.diameter = diameter;
for i = handles.thickness % 2 for single test
    for j = handles.diameter % 1 for single test
        %% Very quick, finding variables ~.1% of comps
        %Finds index of thickness/diameter that we are analyzing
        c = find(handles.diameter==j);
        index = find(handles.thickness==i);
        r = index;
        %Find attenuation coefficient for given thickness
        coeff = handles.attenuation(index);
        %Sets diameter and radius of the disks to be inserted
        diam = handles.diameter(c);
%         radius = ceil(diam*0.5/pixel*magn);
        radius = round(diam*0.5/pixel*magn); %Rounds to nearest
        d = ceil((radius * 2 * sqrt(2)));
        dCenter = ceil((2*d+1)/2 +0.5);
        smalldisk = circle_roi2(center_circ, radius,roi_size, shape);
%         maxrad = round((max(handles.diameter))*0.5/pixel*magn)  %New code, rad = 1.4*maxrad = constant search size
        largeRectRegion = I_dicom_orig(center(1) - d:center(1) + d,center(2) - d:center(2) + d);
% % %         largeRectRegion = I_dicom_orig(center(1) - maxrad:center(1) + maxrad,center(2) - maxrad:center(2) + maxrad);
            %Maxrad was originally d
        
        
        %Calculates average value of the region where the area of disk
        bkgr_roi = mean2(largeRectRegion);  
        disk_diff = (bkgr_roi-50)*(coeff - 1); %gold disk attenuation, image dark signal=50
        disk_roi = smalldisk*disk_diff;
        empty = zeros(2*d+1,2*d+1);
        middle = ceil((size(empty)/2) + 0.5);
        empty(middle(2) - radius:middle(2) + radius,middle(1) - radius:middle(1) + radius) = disk_roi;


        %Gaussian function to blur the disk so it is more realistic
        PSF = fspecial('gaussian',18,18);
        disk_roi_blur = imfilter(empty,PSF,'symmetric','conv');
        BW2 = I_dicom_orig; %to conserve the BW1 image
        disk_roi_blur2 =  disk_roi_blur;
        rad = d;    %In original code, rad=d = radius of search area =  changes each iteration
        
        inserted = largeRectRegion;
        inserted(dCenter - rad:dCenter + rad,dCenter - rad:dCenter + rad) = inserted(middle - rad:middle + rad,middle - rad:middle + rad) + disk_roi_blur2;
        
%         figure
%         imshow(inserted,[])
%         pause
%         
        if diam>=0.2 %40 pixels for 2.8 mm search area
            handles.xtest = BW1(center(1) - d:center(1) + d, center(2) - d:center(2) + d);  
            handles.xtest1 = handles.xtest(:)';
            handles.ytest = inserted(dCenter - d:dCenter + d, dCenter - d:dCenter + d);
            handles.ytest1 = handles.ytest(:)';
%             handles.xtest = BW1(center(1) - maxrad:center(1) + maxrad, center(2) - maxrad:center(2) + maxrad);  
%             handles.xtest1 = handles.xtest(:)';
%             handles.ytest = inserted(dCenter - maxrad:dCenter + maxrad, dCenter - maxrad:dCenter + maxrad);
%             handles.ytest1 = handles.ytest(:)';
        elseif diam<0.2
            handles.xtest = BW1(center(1) - d:center(1) + d, center(2) - d:center(2) + d);
            handles.xtest1 = handles.xtest(:)';
            handles.ytest = inserted(dCenter - d:dCenter + d, dCenter - d:dCenter + d);
            handles.ytest1 = handles.ytest(:)';
%             handles.xtest = BW1(center(1) - maxrad:center(1) + maxrad, center(2) - maxrad:center(2) + maxrad);
%             handles.xtest1 = handles.xtest(:)';
%             handles.ytest = inserted(dCenter - maxrad:dCenter + maxrad, dCenter - maxrad:dCenter + maxrad);
%             handles.ytest1 = handles.ytest(:)';
        end
        [h,p,ci,stats] = ttest2(handles.xtest1,handles.ytest1);
%         handles.results(r, c) = p;
        

        lambda = (handles.xtest1 - handles.ytest1) * handles.ytest1';
        
        handles.lambda_npwmf1(r,c) = lambda;


    end
end
% results = handles.results;
npwmf1 = handles.lambda_npwmf1;
% npwmf2 = handles.lambda2_npwmf2
results = npwmf1
end
