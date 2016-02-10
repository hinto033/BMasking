%%Opens up dialogue bo to impore a DICOM file of your choosing
[FileName,PathName,FilterIndex] = uigetfile;

%This section import the DICOM file and sets some initial variables
%need to add in lines that read some of the dicominfo
%Stores variables for the image itself and path to the image

handles.filename = FileName;
handles.pathname = PathName;
handles.filterIndex = FilterIndex;
handles.fullpath = [handles.pathname,'\',handles.filename,'raw.png'];

FileName = handles.filename;   %'DCM2';


%%
% Creating image files of DICOM Image
%Imports the .png file associated with the DICOM
% full_file_png = [PathName,'\',FileName, 'raw.png'];  %In real one I % uncomment this
full_file_png = [PathName,'\',FileName]; 
I  = double(imread(full_file_png));
full_file_dicomread = [handles.pathname,'\',FileName];
% info_dicom = dicominfo(full_file_dicomread);      %REALLY UNCOMMENT THIS
%Reads the DICOM file into the system
% I_dicom = double(dicomread(info_dicom));  %REALLY UNCOMMENT THIS
% I_dicom_orig =  I_dicom; %Stores as original image  %REALLY UNCOMMENT THIS
I = -log(I/12314)*10000; %Transforms the image to produce a negative
%This is the display image that is useful to display. 

% k = 1; %0.7 for GE... some correction factor

%%  CREATE MASKING MAP  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
% %%%%%%MAke masking map
% create canny filter like Serghei did

%Creates images of the background, black and white images,%etc. %%%%%%%%%%
background = imopen(I,strel('disk',100));
J = I - background; %creates;
mn_size = round([500,2500,500,2000]*k);
mn = mean2(J(mn_size(1):mn_size(2),mn_size(3):mn_size(4)));
BW1 = J >(mn+500); %figure;imagesc(BW1);colormap(gray);
BW = edge(BW1, 'canny', [0.04 0.10], 1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
edgemap = BW
[row,col] = size(BW)
maskingmap = zeros(row,col)


for j = 1:row
    edges = find(BW(j,:)== 1)
    if isempty(edges) || edges(1) > 2000
    else
        maskingmap( j, 1:edges(1)) = 1;
    end
end
%Or I think there is a fill function to do. 

%%
%Parameter import
%the thicknesses, diameters, and attenuations for the corresponding
%thicknesses of the CDMAM
handles.thickness = [2, 1.42, 1, .71, .5, .36, .25, .2, .16, .13, .1, .08, .06, .05, .04, .03]; %um
handles.diameter = [2, 1.6, 1.25, 1, .8, .63, .5, .4, .31, .25, .2, .16, .13, .1, .08, .06]; %mm
handles.attenuation = [0.8128952,0.862070917,0.900130881,0.927690039,0.948342287,...
    0.962465394,0.973737644,0.978903709,0.983080655,0.986231347,0.989380904,...
    0.991486421,0.993610738,0.994672709,0.995734557,0.996796281];
    %Attenuations from Serghei's gold attenuations corrected .txt file

%%
% Adjusts scaling of the image based on Selenia scaling
global roi 
% k_pos = 0.625;
magn = 1.082;
pixel = 0.01; %Selenia = 0.07 decrease the pixel size by 7 times
se_pixel = 0.07; %1 pixel = 0.07 mm
se_rescale = se_pixel/pixel; %Rescales the pixel size
BW1 = I_dicom;
%Selects the region of interest of the DICOM image 
roi_image1 = BW1(topRow:bottomRow,leftColumn:rightColumn);
roi_size_orig = size(roi_image1);
roi_size = round(roi_size_orig*se_rescale); %Rescales that ROI
roi_image = imresize(roi_image1, roi_size); 


%%
%***Can probably find a way to get rid of this stuff. (the n, etc.)
max_diam = 2; %mm max(cdmam_params(:,2));

%Sets radius of larger circular region that we will subtract and then
%replace
radius2 = max_diam*0.5/pixel*1.5*magn;
center_xy = center*se_rescale ;

%Sets values of center of the circle
center_circ = ceil((roi_size)./2);
 
tic
%P values will go in here once we go through the loop
handles.results = zeros(length(handles.thickness), length(handles.diameter));
%% MAKING IQF MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[height, width] = size(I)
boxsize = 40
pixelshift = 10   %1 px = .07mm
center = [20,20]
maskimage = zeros(size(I))

while center(1) < height && center(2) < width
  if mean2(maskingmap(center(1)-20:center(1)+20,center(2)-20:center(2)+20) )==1   %all areas in teh region are 1 and I can do it
%       IQFCalc, store in that location, reset that value of IQFMatrix
%       
%       Calculates P values
    %   Later will have to make this a (g-g)*g
    
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
        radius = diam*0.5/pixel*magn;
        %Creates masks for the gold disk circle and the larger area of
        %replacement
        %******Replace with circle_roi2************
        disk(1).ind = circle_roi(center_circ, radius,roi_size);
        disk(1).ind2 = circle_roi(center_circ, radius2,roi_size);
        %Calculates average value of the region where the area of
        %replacement is
        disk1_mean = mean2(roi_image(disk(1).ind2));
        bkgr_roi = mean(disk1_mean);%is it redundant to take a mean of a mean value?       
        %%
        
        %Calculates the value that will be subtracted from base value to
        %create the disk
        disk_diff = (bkgr_roi-50)*(coeff - 1);  %gold disk attenuation, image dark signal=50
        roirot_size = size(roi_image);
        disk_roi = zeros(roirot_size);
        disk_roi = disk(1).ind*disk_diff; %Creates mask with zeros and negative values in disk in center
        %Gaussian function to blur the disk so it is more realistic
        PSF = fspecial('gaussian',18,18);
        disk_roi_blur = imfilter(disk_roi,PSF,'symmetric','conv');
                
        %Takes the region of interest and adds thhe blurred disk
        %*****Resizing work here********
        roi_rot4 = roi_image + disk_roi_blur;
        %Resizes to size of original image
        roi_rot5 = imresize(roi_rot4, roi_size_orig);
        roi_rot6 = imresize(roi_image, roi_size_orig);
        %This is the disk+Background(roi5) - backgroun(roi6), yielding just
        %the blurred gold disk
        roi_rot5 = roi_rot5 - roi_rot6;
                
        %May need to add in erosion/unerosion here
        BW_roi = zeros(size(BW1));
        BW_roi(topRow:bottomRow,leftColumn:rightColumn) = roi_rot5; % assignment
        BW_final = BW_roi + BW1;
        
        I_final = uint16(BW_final);
        %%
        %tests
        
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
        [h,p,ci,stats] = ttest2(handles.xtest1,handles.ytest1);
        handles.results(r, c) = p;
      end
    end
results = handles.results
%%Calculates IQF
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
    maskimage(center(1)-pixelshift:center(1)+pixelshift,center(2)-pixelshift:center(2)+pixelshift)= IQF

  else
  end %if

  if center(1)+30 < height
        center(1) = center(1) + pixelshift
        center(2) = center(2)
  elseif center(1) + 30 >= height
        center(1) = 20
        center(2) = center(2) + pixelshift
    %Do nothing, shift 
  end %if
end % while

displayimage = maskimage + edgeimage;

figure
imshow(displayimage, []) 
figure
imshow(maskimage, [])



    