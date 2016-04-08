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

% Last Modified by GUIDE v2.5 06-Apr-2016 08:59:04

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

global magn cutoff
global NumImageAnalyze
NumImageAnalyze=1;
handles.thickness = [2, 1.42, 1, .71, .5, .36, .25, .2, .16, .13, .1, .08, .06, .05, .04, .03]; %um
% handles.diameter = [50, 40, 30, 20, 10, 8, 5, 3, 2, 1.6, 1.25, 1, .8, .63, .5, .4, .31, .25, .2, .16, .13, .1, .08, .06]; %mm
handles.diameter = [10, 8, 5, 3, 2, 1.6, 1.25, 1, .8, .63, .5, .4, .31, .25, .2, .16, .13, .1, .08, .06]; %mm
handles.attenuation = [0.8128952,0.862070917,0.900130881,0.927690039,0.948342287,...
    0.962465394,0.973737644,0.978903709,0.983080655,0.986231347,0.989380904,...
    0.991486421,0.993610738,0.994672709,0.995734557,0.996796281];
magn = 1; %1.082;
cutoff = 95000;
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
global NumImageAnalyze FileName PathName FilterIndex ext
global FileName_Naming parts part1 part2 PathName_Naming FilterIndex_Naming extension

for j = 1:NumImageAnalyze
%%Opens up dialogue bo to impore a DICOM file of your choosing
[FileName,PathName,FilterIndex] = uigetfile;
%This section import the DICOM file and sets some initial variables
%need to add in lines that read some of the dicominfo
%Stores variables for the image itself and path to the image
FileName_Naming{j} = FileName
PathName_Naming{j} = PathName;
FilterIndex_Naming{j} = FilterIndex;
[pathstr,name,ext] = fileparts([PathName,'\',FileName]);
extension{j} = ext
s=pathstr;
parts=regexp(s,'\','split');
parts = fliplr(parts);
part1{j} = parts(3);
part2{j} = parts(2);
end

guidata(hObject,handles);


% --- Executes on button press in InsertDisks.
function InsertDisks_Callback(hObject, eventdata, handles)
%% Parameter Setting
%the thicknesses, diameters, and attenuations for the corresponding
%thicknesses of the CDMAM
global magn FileName_Naming NumImageAnalyze part1 part2 %I_dicom_orig
global levels IQF PathName_Naming FilterIndex_Naming extension cutoff
%% Doing calculation for each image that was originally selected
for j = 1:NumImageAnalyze
%%Import an image    
[I_dicom_orig, spacing] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
%%
pixelSpacing = spacing(1)
I_dicom_orig(all(I_dicom_orig>10000,2),:)=[];
%% Calculate the blurred disks and store them
radius = ((handles.diameter.*0.5)./(pixelSpacing*magn));
[atten_disks] = circle_roi4(radius);
[q1, q2] = size(atten_disks(:,:,1))
padamnt = (q1+1)/2;
%% Expand image s.t. the edges go out 250 pixel worth of the reflection
I_DCM_Expanded = padarray(I_dicom_orig,[2*q1 2*q1],'symmetric','both');

center = I_DCM_Expanded(600:805, 600:805)
center1stQuad = center(1:69, 1:69)
figure
imshow(center1stQuad,[])
center2 = imresize(center1stQuad, 2)
figure
imshow(center2, [])
center2 = imresize(center1stQuad, [206, 206])
figure
imshow(center2, [])
% bigBox = 


pause

%% set guess of time to calculate
[l,w] = size(I_dicom_orig);
timePerPixel = 1.183e-6;
timeMin = timePerPixel*(l*w)
pause(2)
%Calculate IQF and Detectability at different diameter levels 
[handles.levels, handles.IQF] = calcTestStat5(I_DCM_Expanded,handles.attenuation, radius, atten_disks, handles.thickness, handles.diameter, cutoff, padamnt); %um);
levels = handles.levels;
IQF = handles.IQF;
%% %%%%%%%

% % % % % global pixelshift magn pixel FileName_Naming I_dicom_orig NumImageAnalyze parts part1 part2

%% Doing calculation for each image that was originally selected
for j = 1:NumImageAnalyze
I_dicom_orig{j}(all(I_dicom_orig{j}>10000,2),:)=[];
[height, width] = size(I_dicom_orig{j});
%% Calculate the blurred disks and store them
radius = ((handles.diameter.*0.5)./(pixel*magn));
handles.diameter
[atten_disks] = circle_roi4(radius);
%% Expand image s.t. the edges go out 250 pixel worth of the reflection
I_DCM_Expanded = padarray(I_dicom_orig{j},[250 250],'symmetric','both');
%% Set areas where i'll do calculations
maskingmap = I_DCM_Expanded;
% threshold 
maskingmap=maskingmap./max(maskingmap(:));
maskingmap = im2bw(maskingmap,0.2);
maskingmap = imcomplement(maskingmap);
[heightExp,widthExp] = size(maskingmap);
fractionIncluded = bwarea(maskingmap) / (heightExp*widthExp);
% figure
% imshow(I_DCM_Expanded, [])
% figure
% imshow(maskingmap, [])
% pause
%% set parms
handles.results = zeros(length(handles.thickness), length(handles.diameter));
[l,w] = size(I_dicom_orig{j})
maskimage = zeros(l,w,3);  %Each layer is a different IQF value
center = [271,271]; %Normally 271,271, but at 250,1050 we hit the nipple (first chance for flipping)
centerstart = [271,271];
centerMask = [21,21]; %Normaly at 21, 21
timePerROI = 0.5;
timeSec = round(((height*width*fractionIncluded) / ((2*pixelshift)^2)) * timePerROI);
timeMin = timeSec / 60
timeHr = timeMin / 60
pause(2)
count = 1;
dat.center = zeros(1,2,1);
dat.cdData = zeros(length(handles.diameter),2,1);
dat.IQF = zeros(1,3,1);
while center(1) < heightExp && center(2) < widthExp-250 
    if mean2(maskingmap(center(1)-202:center(1)+202,center(2)-202:center(2)+202))==1 && mean2(maskingmap(center(1),center(2)))==1 
        %Calculation if the entire searched region is within the actual
        %breast area (Including edge of image)
        %% Calculate the test statistic after inserting them in a region
        handles.results = calcTestStat4(I_DCM_Expanded,I_DCM_Expanded, center, handles.attenuation, radius, atten_disks);
        results = handles.results;
        %% Calculate IQF Based on that
        cutoff = 144500; %For the current calibration
        [cdData, IQF] = calcIQF(results, cutoff, handles.thickness, handles.diameter)
        cdData
        IQF
        pause
        %% Insert that IQF Value into the masking image
        maskimage(centerMask(1)-pixelshift:centerMask(1)+pixelshift,centerMask(2)-pixelshift:centerMask(2)+pixelshift,1)= IQF(1);
        maskimage(centerMask(1)-pixelshift:centerMask(1)+pixelshift,centerMask(2)-pixelshift:centerMask(2)+pixelshift,2)= IQF(2);
        maskimage(centerMask(1)-pixelshift:centerMask(1)+pixelshift,centerMask(2)-pixelshift:centerMask(2)+pixelshift,3)= IQF(3);
        dat.center(:,:,count) = [centerMask(1), centerMask(2)];
        dat.cdData(:,:,count) = cdData;
        dat.IQF(:,:,count) = IQF;
        count = count+1;
        %imshow(maskimage, [])
        %drawnow
    elseif mean2(maskingmap(center(1)-202:center(1)+202,center(2)-202:center(2)+202))~=1 && mean2(maskingmap(center(1)-20:center(1)+20,center(2)-20:center(2)+20))==1 
        %search area goes outside the breast but the center is in  breast
        %Essentially along the breast edge
        addedBreast = I_DCM_Expanded(center(1)-250:center(1)+250,center(2)-250:center(2)+250);
        minMaskMap = maskingmap(center(1)-250:center(1)+250,center(2)-250:center(2)+250);
        BW = minMaskMap;
        [replaced] = breastEdgeReflect(addedBreast, BW, I_DCM_Expanded, center);
        handles.results = calcTestStat4(replaced,replaced, center, handles.attenuation, radius, atten_disks);
        results = handles.results;
        %% Calculate IQF Based on that
        cutoff = 144500; %For the current calibration using only the changing diameter
        %If want more accurate for larger sizes, use 238500
        %Perhaps insert a loop in here to test what the different test
        %statistics output. 
        [cdData, IQF] = calcIQF(results, cutoff, handles.thickness, handles.diameter);
        %% Insert that IQF Value into the masking image
        maskimage(centerMask(1)-pixelshift:centerMask(1)+pixelshift,centerMask(2)-pixelshift:centerMask(2)+pixelshift)= IQF(1);
        dat.center(:,:,count) = [centerMask(1), centerMask(2)];
        dat.cdData(:,:,count) = cdData;
        dat.IQF(:,:,count) = IQF;
        count = count+1;
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

end
guidata(hObject,handles);
end
% % % 
% % % %% Attempt 2
% % % global magn pixel FileName_Naming NumImageAnalyze part1 part2 %I_dicom_orig
% % % global levels IQF PathName_Naming FilterIndex_Naming extension cutoff
% % % j=1;
% % % [I_dicom_orig, spacing] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
% % % % I_dicom_orig = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
% % % 
% % % pixelSpacing = spacing(1)
% % % I_dicom_orig(all(I_dicom_orig>10000,2),:)=[];
% % % %% Calculate the blurred disks and store them
% % % radius = ((handles.diameter.*0.5)./(pixelSpacing*magn));
% % % [atten_disks] = circle_roi4(radius);
% % % [q1, q2] = size(atten_disks(:,:,1));
% % % padamnt = (q1+1)/2;
% % % %% Expand image s.t. the edges go out 250 pixel worth of the reflection
% % % I_DCM_Expanded = padarray(I_dicom_orig,[padamnt padamnt],'symmetric','both');
% % % 
% % % 
% % % % % % I_DCM_Expanded = padarray(I_dicom_orig,[250 250],'symmetric','both');
% % % figure 
% % % imshow(I_DCM_Expanded, [])
% % % %Obtain Point
% % % [xSel,ySel] = ginput(1);  % [x, y]]
% % % close
% % % % % % radius = ((handles.diameter.*0.5)./(pixel*magn));
% % % % % % [atten_disks] = circle_roi4(radius);
% % % %% Expand image s.t. the edges go out 250 pixel worth of the reflection
% % % centerimage = I_DCM_Expanded(ySel-250:ySel+250, xSel-250:xSel+250); %*******FIX*** Should be involved with padarray
% % % % %% Calculate the blurred disks and store them
% % % radius = round((handles.diameter.*0.5)./(pixel*magn))
% % % [atten_disks] = circle_roi4(radius);
% % % 
% % % %% Calculate the test statistic after inserting them in a region
% % % tic
% % % % [handles.levels, handles.IQF] = calcTestStat5(I_DCM_Expanded,handles.attenuation, radius, atten_disks, handles.thickness, handles.diameter, cutoff, padamnt); %um);
% % % [handles.levels, handles.IQF] = calcTestStat6(centerimage,handles.attenuation, radius, atten_disks, handles.thickness, handles.diameter, cutoff, padamnt); %um);
% % % toc
% % % levels = handles.levels;
% % % IQF = handles.IQF;
% % % 
% % % size(levels)
% % % for k = 1:20 %***************FIX, should be length(diameter) or whatever
% % % center=size(levels(:,:,k))/2+.5;
% % % center = ceil(center);
% % % cdThickness(k) = levels(center(1), center(2), k) %thickness
% % % cdDiam(k) = handles.diameter(k)
% % % end
% % % %% If I want to make CD curves of a certain spot. 
% % % %% Export images
% % % %% Export images
% % % formatout = 'dd-mmm-yyyy_HH-MM-SS';
% % % str = datestr(now, formatout);
% % % A1 = char(part1{j});
% % % A2 = char(part2{j});
% % % A3 = char(FileName_Naming{j});
% % % A4 = 'ThicknessEachDiam';
% % % A5 = str;
% % % A6 = '.mat';
% % % formatSpec = '%s_%s_%s_%s_%s%s';
% % % fileForSaving = sprintf(formatSpec,A1,A2, A3, A4, A5, A6)
% % % save(fileForSaving, 'levels')
% % % 
% % % A4_2 = 'IQFMap';
% % % formatSpec2 = '%s_%s_%s_%s_%s%s';
% % % fileForSaving = sprintf(formatSpec,A1,A2, A3, A4_2, A5, A6)
% % % save(fileForSaving, 'IQF')    
% guidata(hObject,handles);


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



% --- Executes on button press in Thicknesses_Slider.
function Thicknesses_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Thicknesses_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
k = 8
% levels = handles.levels;
% IQF = handles.IQF;
% load('UCSF_3C01029_DCM7_IQFMap_04-Mar-2016_10-19-46.mat')
% load('UCSF_3C01029_DCM7_ThicknessEachDiam_04-Mar-2016_10-19-46.mat')
 
global levels IQF

figure
imshow(IQF,[])
B=levels;
size(B)
fig=figure(100);
set(fig,'Name','Image','Toolbar','figure',...
    'NumberTitle','off')
% Create an axes to plot in
axes('Position',[.15 .05 .7 .9]);
% sliders for epsilon and lambda
slider1_handle=uicontrol(fig,'Style','slider','Max',20,'Min',1,...
    'Value',1, 'SliderStep',[1/(20-1) 1/(20-1)],...
    'Units','normalized','Position',[.02 .02 .14 .05]);
uicontrol(fig,'Style','text','Units','normalized','Position',[.02 .07 .14 .04],...
    'String','Choose Diameter');
% Set up callbacks
vars=struct('slider1_handle',slider1_handle,'B',B);
set(slider1_handle,'Callback',{@slider1_callback,vars});
plotterfcn(vars)
guidata(hObject,handles);
% End of main file

% Callback subfunctions to support UI actions
function slider1_callback(~,~,vars)
    % Run slider1 which controls value of epsilon
    vars.slider1_handle
    plotterfcn(vars)

function plotterfcn(vars)
    % Plots the image
    imshow(vars.B(:,:,get(vars.slider1_handle,'Value')));
    title(num2str(get(vars.slider1_handle,'Value')));

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


% --- Executes on button press in Plot_IsoContour.
function Plot_IsoContour_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_IsoContour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% storedStructure = load('UCSF_3C01029_DCM7_IQFMap_18-Mar-2016_11-34-44','-mat');
% Extract out the image from the structure into its own variable.
% Don't use I as the variable name - bad for several reasons.
global levels IQF
imageArray = flipud(IQF); 

contourSizes = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
figure
contourf(imageArray, contourSizes)
colormap(gray)
colorbar
guidata(hObject,handles);


% --- Executes on button press in ImportMATs.
function ImportMATs_Callback(hObject, eventdata, handles)
% hObject    handle to ImportMATs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global levels IQF
[FileName,PathName,FilterIndex] = uigetfile
full_file_mat = [PathName,'\',FileName];
storedStructure = load(full_file_mat,'-mat');
IQF = (storedStructure.IQF(:,:,1)); 

[FileName,PathName,FilterIndex] = uigetfile
full_file_mat = [PathName,'\',FileName];
storedStructure = load(full_file_mat,'-mat');
levels = (storedStructure.levels); 

figure
imshow(IQF,[])
figure
imshow(levels(:,:,13),[])
guidata(hObject,handles);



% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global magn pixel FileName_Naming NumImageAnalyze part1 part2 %I_dicom_orig
global levels IQF PathName_Naming FilterIndex_Naming extension cutoff
j=1;
[I_dicom_orig, spacing] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
% I_dicom_orig = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);

pixelSpacing = spacing(1)
I_dicom_orig(all(I_dicom_orig>10000,2),:)=[];
%% Calculate the blurred disks and store them
radius = ((handles.diameter.*0.5)./(pixelSpacing*magn));
[atten_disks] = circle_roi4(radius);
[q1, q2] = size(atten_disks(:,:,1));
padamnt = (q1+1)/2;
%% Expand image s.t. the edges go out 250 pixel worth of the reflection
I_DCM_Expanded = padarray(I_dicom_orig,[padamnt padamnt],'symmetric','both');


% % % I_DCM_Expanded = padarray(I_dicom_orig,[250 250],'symmetric','both');
figure 
imshow(I_DCM_Expanded, [])
%Obtain Point
[xSel,ySel] = ginput(1);  % [x, y]]
close
% % % radius = ((handles.diameter.*0.5)./(pixel*magn));
% % % [atten_disks] = circle_roi4(radius);
%% Expand image s.t. the edges go out 250 pixel worth of the reflection
centerimage = I_DCM_Expanded(ySel-padamnt:ySel+padamnt, xSel-padamnt:xSel+padamnt) 

radius = round((handles.diameter.*0.5)./(pixelSpacing*magn))
[atten_disks] = circle_roi4(radius);
[Lambdas, IQF] = genLambdas(centerimage,handles.attenuation, radius, atten_disks, handles.thickness, handles.diameter, cutoff, padamnt); %um);

Lambdas


figure
imshow(centerimage, [])
pause


for k = 1:9
aa = mean2(centerimage)
noiseAmplitude = [5, 10, 50, 100, 500, 1000, 1500, 2000, 5000]
NoiseImg = centerimage + (noiseAmplitude(k) * 2*(rand(size(centerimage))-.5));

mean2(NoiseImg)

figure
imshow(NoiseImg, [])

%% Calculate the test statistic after inserting them in a region
tic
% [handles.levels, handles.IQF] = calcTestStat5(I_DCM_Expanded,handles.attenuation, radius, atten_disks, handles.thickness, handles.diameter, cutoff, padamnt); %um);

[LambdasNoise, IQFNoise] = genLambdas(NoiseImg,handles.attenuation, radius, atten_disks, handles.thickness, handles.diameter, cutoff, padamnt); %um);
toc


LambdasNoise
Lambdas - LambdasNoise
noiseAmplitude
noiseAmplitude/aa
pause
end

pause
levels = handles.levels;
IQF = handles.IQF;

size(levels)
for k = 1:20 %***************FIX, should be length(diameter) or whatever
center=size(levels(:,:,k))/2+.5;
center = ceil(center);
cdThickness(k) = levels(center(1), center(2), k) %thickness
cdDiam(k) = handles.diameter(k)
end
guidata(hObject,handles);
