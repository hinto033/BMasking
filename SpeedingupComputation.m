
I = ones(2000, 3000) * 0.7;
I(400:600, 400:600) = 1;
roi_image = I;

handles.thickness = [2, 1.42, 1, .71, .5, .36, .25, .2, .16, .13, .1, .08, .06, .05, .04, .03]; %um
handles.diameter = [2, 1.6, 1.25, 1, .8, .63, .5, .4, .31, .25, .2, .16, .13, .1, .08, .06]; %mm
handles.attenuation = [0.8128952,0.862070917,0.900130881,0.927690039,0.948342287,...
    0.962465394,0.973737644,0.978903709,0.983080655,0.986231347,0.989380904,...
    0.991486421,0.993610738,0.994672709,0.995734557,0.996796281];

[height, width] = size(I);
boxsize = 40;
pixelshift = 10;   %1 px = .07mm
center = [60,60];
maskimage = zeros(size(I));
[row,col] = size(I)
for j = 1:row
    edges = find(I(j,:)== 1);
    if isempty(edges) || edges(1) > 2000
    else
        maskimage( j, 1:edges(1)) = 1;
    end
end

iqfimage = maskimage;
radius2 = 2;

        rectRegion = [center(1) - pixelshift:center(1) + pixelshift,center(2) - pixelshift:center(2) + pixelshift];
       

% k_pos = 0.625;
magn = 1.082;
pixel = 0.01; %Selenia = 0.07 decrease the pixel size by 7 times
se_pixel = 0.07; %1 pixel = 0.07 mm
se_rescale = se_pixel/pixel; %Rescales the pixel size
BW1 = I;
%Selects the region of interest of the DICOM image 
roi_image1 = BW1(rectRegion);
roi_size_orig = size(roi_image1);
roi_size = round(roi_size_orig*se_rescale); %Rescales that ROI
roi_image = BW1; 

% figure
% imshow(I)
% figure
% imshow(maskimage)

tic
center_circ = 1;
roi_size = 1;

[height, width] = size(I);
boxsize = 40;
pixelshift = 10  ; %1 px = .07mm
center = [60,60];



%NEED TO DETERMINE IF THIS IS GOING IN THE CORRECT DIRECTION

while center(1) < height && center(2) < width
  if mean(mean(maskimage(center(1)-20:center(1)+20,center(2)-20:center(2)+20) )) == 1  
    j = 'youdiidITTTTTT'

    for i = handles.thickness % 2 for single test
      for j = handles.diameter % 1 for single test        
        %%
        %Finds index fo thickness/diameter that we are analyzing
        r = find(handles.thickness==i);
        c = find(handles.diameter==j);
        index = find(handles.thickness==i);
        %Find attenuation coefficient for given thickness
        coeff = handles.attenuation(index);
        %Sets diameter and radius of the disks to be inserted
        diam = handles.diameter(c);
        radius = 10;%round(diam*0.5/pixel*magn);
        radius2 = 15;%round(radius2/pixel*magn);
        %Creates masks for the gold disk circle and the larger area of
        %replacement
        
        %******Replace with circle_roi2************
        smalldisk = circle_roi2(center_circ, radius,roi_size); %*YYY*Y*
        largedisk = circle_roi2(center_circ, radius2,roi_size);
        %*****Replace with circle_roi2
            %Fix CircleROI2 to make it big enough for PSF
            %Or change circleroi2 to give coordinates for region on og
            %image
        
            
            %Need center where disks will be placed and the small circle mask
           test = I(center(1) - radius2:center(1) + radius2,center(2) - radius2:center(2) + radius2);
           largedisk;
          largeRadRegion = I(center(1) - radius2:center(1) + radius2,center(2) - radius2:center(2) + radius2) .* largedisk;
        smallRadRegion = I(center(1) - radius:center(1) + radius,center(2) - radius:center(2) + radius) .* smalldisk;
            
            
            
        %Calculates average value of the region where the area of
        %replacement is
        disk1_mean = mean(roi_image(center(1) - radius2:center(1) + radius2,center(2) - radius2:center(2) + radius2)*(largedisk));  %*YYY*Y*%*YYY*Y*
        bkgr_roi = mean(disk1_mean);%is it redundant to take a mean of a mean value?       
        %%
        
          largeRadRegion = I(center(1) - radius2:center(1) + radius2,center(2) - radius2:center(2) + radius2) .* largedisk;
        smallRadRegion = I(center(1) - radius:center(1) + radius,center(2) - radius:center(2) + radius) .* smalldisk;
         
        rectRegion = I(center(1) - pixelshift:center(1) + pixelshift,center(2) - pixelshift:center(2) + pixelshift);
        %Calculates the value that will be subtracted from base value to
        %create the disk
        disk_diff = (bkgr_roi-50)*(coeff - 1);  %gold disk attenuation, image dark signal=50
        disk_roi = smallRadRegion;
        disk_roi = smallRadRegion*disk_diff; %Creates mask with zeros and negative values in disk in center
        %Gaussian function to blur the disk so it is more realistic
%         PSF = fspecial('gaussian',18,18);%NEED THIS IN REEAL LIFE
%         disk_roi_blur = imfilter(disk_roi,PSF,'symmetric','conv');%EED
%         THIS IN REAL LIFE
        disk_roi_blur = disk_roi;
            %************THIS WONT WORK GIVEN SMALL DIAM VALUE of circle
            %roi2
                
        %Takes the region of interest and adds thhe blurred disk
        %*****Resizing work here********
        roi_rot4 = roi_image(center(1) - radius:center(1) + radius,center(2) - radius:center(2) + radius) + disk_roi_blur;   %Normally, I -> roi_image
        %Resizes to size of original image
        roi_rot5 = roi_rot4; %imresize(roi_rot4, roi_size_orig);
        roi_rot6 = roi_image(center(1) - radius:center(1) + radius,center(2) - radius:center(2) + radius); %imresize(roi_image, roi_size_orig);
        %This is the disk+Background(roi5) - backgroun(roi6), yielding just
        %the blurred gold disk
        roi_rot5 = roi_rot5 - roi_rot6;
                
        %May need to add in erosion/unerosion here
%         BW_roi = zeros(size(BW1));
%         BW_roi(topRow:bottomRow,leftColumn:rightColumn) = roi_rot5; % assignment

        BW2 = BW1; %to conserve the BW1 image
        BW2(center(1) - radius:center(1) + radius,center(2) - radius:center(2) + radius) = BW2(center(1) - radius:center(1) + radius,center(2) - radius:center(2) + radius) + roi_rot5;
        BW_final = BW2;
        
%         I_final = uint16(BW_final);
        %%
        %tests
%         
%         figure
%         imshow(BW1)
%         figure
%         imshow(BW2)
        
        
        %Adjust this based on the different types of tests that I want to
        %perform..... 
        
        %Gives correct amount!
        if diam>=0.2 %40 pixels for 2.8 mm search area
            handles.xtest = BW1(center(2) - 20:center(2) + 20, center(1) - 20:center(1) + 20);  
            handles.xtest1 = handles.xtest(:)';
            handles.ytest = BW_final(center(2) - 20:center(2) + 20, center(1) - 20:center(1) + 20);
            handles.ytest1 = handles.ytest(:)';
        elseif diam<0.2
            handles.xtest = BW1(center(2) - 20:center(2) + 20, center(1) - 20:center(1) + 20);
            handles.xtest1 = handles.xtest(:)';
            handles.ytest = BW_final(center(2) - 20:center(2) + 20, center(1) - 20:center(1) + 20);
            handles.ytest1 = handles.ytest(:)';
        end
        p = sum(handles.xtest1) - sum(handles.ytest1);
%         [h,p,ci,stats] = ttest2(handles.xtest1,handles.ytest1);
        handles.results(r, c) = p;
      end
    end
    
 cdData = zeros(1,2);
iqfDenom = 0;

    for j = 1:16%6 %Scroll through diameters 1:16
        handles.results(:,j);  %Shows all the p values at that diameter
        minThickness = find(handles.results(j,:) > 0.05);
        if isempty(minThickness)
            minThickness = 14; %(the minimum thickness) I might need to change this to maximum thickness
        end

        if minThickness(1) == 1
            thresholdThickness = 2;
        else
            pn = handles.results(minThickness(1), j);
            pnMinusOne = handles.results(minThickness(1) - 1, j);
            tn = handles.thickness(minThickness(1));
            tnMinusOne = handles.thickness(minThickness(1) - 1);
            thresholdThickness = (((.05 - pnMinusOne)/(pn - pnMinusOne)) * (tn - tnMinusOne)) + tnMinusOne ;
        end
        cdData(j,:) = [handles.diameter(j) , thresholdThickness];
        iqfDenom = iqfDenom + (cdData(j,1)*cdData(j,2));
    end

    IQF = 16/iqfDenom
    iqfimage(center(1)-pixelshift:center(1)+pixelshift,center(2)-pixelshift:center(2)+pixelshift)= IQF;

  else
  end %if

  if center(1)+30 < height
        center(1) = center(1) + pixelshift
        center(2) = center(2)
  elseif center(1) + 30 >= height
        center(1) = 60   %normally 20 ******%%%%%%******%%%%%%*****
        center(2) = center(2) + pixelshift
    %Do nothing, shift 
  end %if
end % while


figure
imshow(iqfimage)

displayimage = maskimage + edgeimage;

figure
imshow(displayimage, []) 
figure
imshow(maskimage, [])



       
toc