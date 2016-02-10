
% clc
% clear all

%Upload Image
% figure
% load('DCM7_MaskingImage_05-Feb-2016_17-59-52.mat','-mat')

[FileName,PathName,FilterIndex] = uigetfile;
%This section import the DICOM file and sets some initial variables
%need to add in lines that read some of the dicominfo
%Stores variables for the image itself and path to the image

[pathstr,name,ext] = fileparts([PathName,'\',FileName])

    handles.filename = FileName;
    handles.pathname = PathName;
    handles.filterIndex = FilterIndex;
    handles.fullpath = [handles.pathname,'\',handles.filename];
FileName = handles.filename;   %'DCM2';
    %***************ALSO SHOULD GET DICOM INFO IN HERE***************%
    % Creating image files of DICOM Image
    %Imports the .png file associated with the DICOM
    full_file_png = [handles.pathname,'\',FileName];
    % I  = double(imread(full_file_png));
    full_file_dicomread = [handles.pathname,'\',FileName];
    info_dicom = dicominfo(full_file_dicomread); %uncomment for dicom
    %Reads the DICOM file into the system
    I_dicom = double(dicomread(info_dicom));
    I_dicom_orig =  I_dicom; %Stores as original image
    % I = -log(I/12314)*10000; 

    
    figure
    imshow(I_dicom,[])
    rect = getrect

xmin = rect(1)
ymin = rect(2)
width = rect(3)
height = rect(4)
% Load entire mat file contents into a structure.
% The structure has a member "I" that is a double 512x512 array.
storedStructure = load('DCM7_MaskingImage_05-Feb-2016_17-21-41','-mat');
% Extract out the image from the structure into its own variable.
% Don't use I as the variable name - bad for several reasons.
imageArray = storedStructure.maskimage;  % Or storedStructure.I depending on what members your structure has.
% Display the image in a brand new figure window.


imgSection = imageArray(ymin:ymin+height, xmin:xmin+width);

C = unique(imgSection)

% figure(1);
% % Display double image, scaled appropriately.
% % No need to cast to uint8 - could even be bad
% % if your double numbers don't span the 0-255 range nicely.
% imshow(imageArray, []);
% figure(2);
% % Display double image, scaled appropriately.
% % No need to cast to uint8 - could even be bad
% % if your double numbers don't span the 0-255 range nicely.
% imshow(imgSection, []);

% figure
% openfig('DCM7_MaskingImage_05-Feb-2016_17-59-52.mat')