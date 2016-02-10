function varargout = DICOMReplace(varargin)
% DICOMREPLACE MATLAB code for DICOMReplace.fig
%      DICOMREPLACE, by itself, creates a new DICOMREPLACE or raises the existing
%      singleton*.
%
%      H = DICOMREPLACE returns the handle to a new DICOMREPLACE or the handle to
%      the existing singleton*.
%
%      DICOMREPLACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DICOMREPLACE.M with the given input arguments.
%
%      DICOMREPLACE('Property','Value',...) creates a new DICOMREPLACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DICOMReplace_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DICOMReplace_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DICOMReplace

% Last Modified by GUIDE v2.5 15-Jan-2016 10:41:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DICOMReplace_OpeningFcn, ...
                   'gui_OutputFcn',  @DICOMReplace_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DICOMReplace is made visible.
function DICOMReplace_OpeningFcn(hObject, eventdata, handles, varargin)

global roi_size max_diam center_circ radius2 pixelshift magn pixel
global FileName FileName_Naming
global I_dicom I_dicom_orig NumImageAnalyze
NumImageAnalyze=1;
handles.thickness = [2, 1.42, 1, .71, .5, .36, .25, .2, .16, .13, .1, .08, .06, .05, .04, .03]; %um
handles.diameter = [10, 8, 5, 3, 2, 1.6, 1.25, 1, .8, .63, .5, .4, .31, .25, .2, .16, .13, .1, .08, .06]; %mm
handles.attenuation = [0.8128952,0.862070917,0.900130881,0.927690039,0.948342287,...
    0.962465394,0.973737644,0.978903709,0.983080655,0.986231347,0.989380904,...
    0.991486421,0.993610738,0.994672709,0.995734557,0.996796281];
magn = 1; %1.082;
pixel = 0.07;
center_circ = 1;
roi_size = 1;
max_diam = max(handles.diameter); %mm 
radius2 = round(max_diam*0.5/pixel*1.5*magn);
pixelshift = 20 ;  %1 px = .07mm
% Choose default command line output for DICOMReplace
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DICOMReplace wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DICOMReplace_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SelectFile.
function SelectFile_Callback(hObject, eventdata, handles)
% hObject    handle to SelectFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NumImageAnalyze I_dicom I_dicom_orig FileName PathName FilterIndex ext
global FileName_Naming parts part1 part2

% if isempty(NumImageAnalyze) == 1 || NumImageAnalyze==0
%     NumImageAnalyze=1;
% end

% global I_dicom I_dicom_orig
for j = 1:NumImageAnalyze
%%Opens up dialogue bo to impore a DICOM file of your choosing
[FileName,PathName,FilterIndex] = uigetfile;
%This section import the DICOM file and sets some initial variables
%need to add in lines that read some of the dicominfo
%Stores variables for the image itself and path to the image

FileName_Naming{j} = FileName

PathName;
FilterIndex;
[pathstr,name,ext] = fileparts([PathName,'\',FileName]);

s=pathstr;
parts=regexp(s,'\','split');
parts = fliplr(parts);
part1{j} = parts(3);
part2{j} = parts(2);

    handles.filename = FileName;
    handles.pathname = PathName;
    handles.filterIndex = FilterIndex;
    handles.fullpath = [handles.pathname,'\',handles.filename];
FileName = handles.filename;   %'DCM2';
if (strcmp(ext, '') || strcmp(ext, '.dcm'))
    k = 'DCM import'
    %***************ALSO SHOULD GET DICOM INFO IN HERE***************%
    % Creating image files of DICOM Image
    %Imports the .png file associated with the DICOM
    full_file_png = [handles.pathname,'\',FileName];
    % I  = double(imread(full_file_png));
    full_file_dicomread = [handles.pathname,'\',FileName];
    info_dicom = dicominfo(full_file_dicomread); %uncomment for dicom
    %Reads the DICOM file into the system
    I_dicom{j} = double(dicomread(info_dicom));
    I_dicom_orig{j} =  I_dicom{j}; %Stores as original image
    % I = -log(I/12314)*10000; 
elseif (strcmp(ext, '.png'))
    %Importing Breast Images if .png
    k = 'png import'
    FileName = handles.filename;   %'DCM2';

    % Creating image files of DICOM Image
    %Imports the .png file associated with the DICOM
    full_file_png = [handles.pathname,'\',FileName];
    I{j}  = double(imread(full_file_png));
    % % % full_file_dicomread = [handles.pathname,'\',FileName];
    % % % info_dicom = dicominfo(full_file_dicomread); %uncomment for dicom
    %Reads the DICOM file into the system

    % I_dicom = double(dicomread(info_dicom));
    % I_dicom_orig =  I_dicom; %Stores as original image

    I_dicom{j} = I{j};
    I_dicom_orig{j} = I{j};
    % I = -log(I/12314)*10000; 
else
    errmsg = 'Imported wrong type of file: Import a .png or DICOM file'
    error(errmsg)
end

end  


global shape
shape = 'Round';


 
% handles.fullpath = [handles.pathname,'\',handles.filename];
% handles.info_dicom = dicominfo(handles.fullpath);
% dicominfo(handles.fullpath)
% info_dicom = dicominfo(handles.fullpath);
% handles.width = info_dicom.Width;
% handles.height = info_dicom.Height;
% handles.bitDepth = info_dicom.BitDepth;
% handles.colorType = info_dicom.ColorType;
% handles.anodeTargetMaterial = info_dicom.AnodeTargetMaterial;
% handles.KVP = info_dicom.KVP;
% handles.bodyPartExamined = info_dicom.BodyPartExamined;
% handles.exposureInuAs = info_dicom.ExposureInuAs;
% handles.filterMaterial = info_dicom.FilterMaterial;
% handles.filterThicknessMinimum = info_dicom.FilterThicknessMinimum;
% handles.filterThicknessMaximum = info_dicom.FilterThicknessMaximum;
% handles.filterThickness = (handles.filterThicknessMinimum+handles.filterThicknessMaximum)/2;
% handles.halfValueLayer = info_dicom.HalfValueLayer;
% handles.bodyPartThickness = info_dicom.BodyPartThickness;
% handles.estimatedRadiographicMagnificationFactor = info_dicom.EstimatedRadiographicMagnificationFactor; 
% handles.distanceSourceToDetector = info_dicom.DistanceSourceToDetector;
% handles.distanceSourceToPatient = info_dicom.DistanceSourceToPatient;
% handles.exposureTime = info_dicom.ExposureTime;
% handles.detectorActiveDimensions = info_dicom.DetectorActiveDimensions;
% handles.fieldOfViewOrigin = info_dicom.FieldOfViewOrigin;
% handles.pixelSpacing = info_dicom.PixelSpacing;
% handles.pixelAspectRatio = info_dicom.PixelAspectRatio;
% handles.windowCenter = info_dicom.WindowCenter;
% handles.windowWidth = info_dicom.WindowWidth;

guidata(hObject,handles);


% --- Executes on button press in InsertDisks.
function InsertDisks_Callback(hObject, eventdata, handles)
%% Parameter Setting
%the thicknesses, diameters, and attenuations for the corresponding
%thicknesses of the CDMAM
global pixelshift magn pixel FileName_Naming I_dicom_orig NumImageAnalyze parts part1 part2

%% Doing calculation for each image that was originally selected
for j = 1:NumImageAnalyze
I_dicom_orig{j}(all(I_dicom_orig{j}>10000,2),:)=[];
[height, width] = size(I_dicom_orig{j});
%% Calculate the blurred disks and store them
radius = round((handles.diameter.*0.5)./(pixel*magn));
[atten_disks] = circle_roi4(radius);
%% Expand image s.t. the edges go out 250 pixel worth of the reflection
I_DCM_Expanded = padarray(I_dicom_orig{j},[250 250],'symmetric','both');
%% Set areas where i'll do calculations
maskingmap = I_DCM_Expanded;
% threshold 
t = 9000;
% find values below and above
ind_below = (maskingmap < t);
ind_above = (maskingmap >= t);
% set values below to white and black
maskingmap(ind_below) = 1;
maskingmap(ind_above) = 0;
[heightExp,widthExp] = size(maskingmap);
fractionIncluded = length(maskingmap(ind_below)) / (height*width);

%% set parms
handles.results = zeros(length(handles.thickness), length(handles.diameter));
maskimage = zeros(size(I_dicom_orig{j}));
center = [271,271]; %Normally 271,271, but at 250,1050 we hit the nipple (first chance for flipping)
centerstart = [271,271];
centerMask = [21,21]; %Normaly at 21, 21
timePerROI = 0.42;
timeSec = round(((height*width*fractionIncluded) / ((2*pixelshift)^2)) * timePerROI);
timeMin = timeSec / 60
timeHr = timeMin / 60
pause(2)
while center(1) < heightExp && center(2) < widthExp-250 
    if mean2(maskingmap(center(1)-202:center(1)+202,center(2)-202:center(2)+202))==1 && mean2(maskingmap(center(1),center(2)))==1 
        %Calculation if the entire searched region is within the actual
        %breast area (Including edge of image)
        %% Calculate the test statistic after inserting them in a region
        tic
        handles.results = calcTestStat4(I_DCM_Expanded,I_DCM_Expanded, center, handles.attenuation, radius, atten_disks);
        toc
        results = handles.results;
        %% Calculate IQF Based on that
        cutoff = 110000; %For the current calibration
        [cdData, IQF] = calcIQF(results, cutoff, handles.thickness, handles.diameter);
        %% Insert that IQF Value into the masking image
        maskimage(centerMask(1)-pixelshift:centerMask(1)+pixelshift,centerMask(2)-pixelshift:centerMask(2)+pixelshift)= IQF;
        %imshow(maskimage, [])
        %drawnow
    elseif mean2(maskingmap(center(1)-202:center(1)+202,center(2)-202:center(2)+202))~=1 && mean2(maskingmap(center(1),center(2)))==1 
        %search area goes outside the breast but the center is in  breast
        %Essentially along the breast edge
        tic
        addedBreast = I_DCM_Expanded(center(1)-250:center(1)+250,center(2)-250:center(2)+250);
        minMaskMap = maskingmap(center(1)-250:center(1)+250,center(2)-250:center(2)+250);
        BW = minMaskMap;
        [replaced] = breastEdgeReflect(addedBreast, BW, I_DCM_Expanded, center);
        handles.results = calcTestStat4(replaced,replaced, center, handles.attenuation, radius, atten_disks);
        results = handles.results;
        toc
        %% Calculate IQF Based on that
        cutoff = 110000; %For the current calibration using only the changing diameter
        [cdData, IQF] = calcIQF(results, cutoff, handles.thickness, handles.diameter);
        %% Insert that IQF Value into the masking image
        maskimage(centerMask(1)-pixelshift:centerMask(1)+pixelshift,centerMask(2)-pixelshift:centerMask(2)+pixelshift)= IQF;
        %imshow(maskimage, []) 
        %drawnow
    else %Do nothing if completely out of search area
    end %if
    if center(1)+(2*pixelshift) < height+250
        center(1) = center(1) + 2*pixelshift;
        centerMask(1) = centerMask(1) + 2*pixelshift;
        center(2) = center(2);
    elseif center(1) +(2*pixelshift) >= height+250
        center(1) = centerstart(1);
        center(2) = center(2) + 2*pixelshift;
        centerMask(1) = pixelshift+1;
        centerMask(2) = centerMask(2) + 2*pixelshift;
    end %if
centerMask
end %while
%% Export images
formatout = 'dd-mmm-yyyy_HH-MM-SS';
str = datestr(now, formatout);
A1 = char(part1{j});
A2 = char(part2{j});
A3 = char(FileName_Naming{j});
A4 = 'MaskingImage';
A5 = str;
A6 = '.mat';
formatSpec = '%s_%s_%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A1,A2, A3, A4, A5, A6)
save(fileForSaving, 'maskimage')
% pause
% fileForSaving = [parts(3),'_',parts(2), '_',FileName_Naming{j},'_MaskingImage_',str,'.mat']
% %As I continue this, I can include the scan type, details of scan, etc.
% save(fileForSaving, 'maskimage')
end %Going through set of images
guidata(hObject,handles);

% --- Executes on button press in CreateCDIQF.
function CreateCDIQF_Callback(hObject, eventdata, handles)
% hObject    handle to CreateCDIQF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global magn pixel I_dicom_orig
figure 
imshow(I_dicom_orig{1}, [])
%Obtain Point
[xSel,ySel] = ginput(1);  % [x, y]]
close
centerm = [round(ySel)+250,round(xSel)+250];
% %% Calculate the blurred disks and store them
radius = round((handles.diameter.*0.5)./(pixel*magn))
[atten_disks] = circle_roi4(radius);

%% Expand image s.t. the edges go out 250 pixel worth of the reflection
I_DCM_Expanded = padarray(I_dicom_orig{1},[250 250],'symmetric','both');
%% Calculate the test statistic after inserting them in a region
tic
handles.results = calcTestStat4(I_DCM_Expanded,I_DCM_Expanded, centerm, handles.attenuation, radius, atten_disks);
toc
results = handles.results;
%% Calculate IQF Based on that
cutoff = 110000; %For the current calibration using only the changing diameter
[cdData, IQF] = calcIQF(results, cutoff, handles.thickness, handles.diameter);
cdData
IQF

%% If I want to make CD curves of a certain spot. 
figure
scatter(cdData(:,1), cdData(:,2))%,'Parent', handles.PNGImage)
xlabel('Detail Diameter (mm)')
ylabel('Threshold Gold Thickness(um)')
set(gca,'xscale','log')
set(gca,'yscale','log')
axis([ 10^-2 10 0.01 10])       
guidata(hObject,handles);


% --- Executes on selection change in ShapeSelect.
function ShapeSelect_Callback(hObject, eventdata, handles)
% hObject    handle to ShapeSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String')) %returns ShapeSelect contents as cell array
%        contents{get(hObject,'Value')}

global shape
shape = contents{get(hObject,'Value')}
% Hints: contents = cellstr(get(hObject,'String')) returns ShapeSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ShapeSelect




guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function ShapeSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ShapeSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MakeVideo.
function MakeVideo_Callback(hObject, eventdata, handles)
% hObject    handle to MakeVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % Display image
figure 
imshow(handles.I_dicom_orig, [])
%Obtain rectangular region of where video will go
rect = getrect %[xmin ymin width height]
xmin = round(rect(1))
ymin = round(rect(2))
width = round(rect(3))
height = round(rect(4))
bottomRow = ymin + height
topRow = ymin
leftColumn = xmin
rightColumn = xmin + width
region = handles.I_dicom_orig(topRow:bottomRow,leftColumn:rightColumn)

figure
imshow(region, [])


pause
%Insert disks in middle of this region and save that section as an image
%file (or not?)
figure
 for j = 1:48
    imgfile = sprintf('1029_DCM7_Video_%1.0f_1138_986.png', j);
    full_file_png = ['Hard to See','\',imgfile];
    images = imread(full_file_png);
    size(images)
    imshow(images(500:1500,600:1500))%,[0,20])
%     pause
    class(images);
    drawnow
    F(j) = getframe;

 end

v = VideoWriter('HARDTOSEE_Zoomed_2fps.avi')
v.FrameRate = 2
open(v)
writeVideo(v,F)
close(v)
guidata(hObject,handles);



% --- Executes on button press in AdditionalInfo.
function AdditionalInfo_Callback(hObject, eventdata, handles)
% hObject    handle to AdditionalInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


guidata(hObject,handles);



function NumImageImport_Callback(hObject, eventdata, handles)
% hObject    handle to NumImageImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NumImageAnalyze
NumImageAnalyze = str2double(get(hObject,'String'))
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of NumImageImport as text
%        str2double(get(hObject,'String')) returns contents of NumImageImport as a double


% --- Executes during object creation, after setting all properties.
function NumImageImport_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumImageImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
