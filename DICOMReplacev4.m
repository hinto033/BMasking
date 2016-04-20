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
%Sets Initial Variables.
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
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = DICOMReplace_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes on button press in SelectFile.
function SelectFile_Callback(hObject, eventdata, handles)
%Selects a certain number of files and stores the path for use later
global NumImageAnalyze FileName PathName FilterIndex ext
global FileName_Naming parts part1 part2 PathName_Naming FilterIndex_Naming extension
for j = 1:NumImageAnalyze
%%Opens up dialogue box to import a DICOM file of your choosing
[FileName,PathName,FilterIndex] = uigetfile;
%Stores filepath
FileName_Naming{j} = FileName
PathName_Naming{j} = PathName;
FilterIndex_Naming{j} = FilterIndex;
[pathstr,name,ext] = fileparts([PathName,'\',FileName]);
extension{j} = ext;
s=pathstr;
parts=regexp(s,'\','split');
parts = fliplr(parts);
part1{j} = parts(3);
part2{j} = parts(2);
end
guidata(hObject,handles);

% --- Executes on button press in InsertDisks.
function InsertDisks_Callback(hObject, eventdata, handles)
%Parameter Setting
global magn FileName_Naming NumImageAnalyze part1 part2 %I_dicom_orig
global levels IQF PathName_Naming FilterIndex_Naming extension cutoff
for j = 1:NumImageAnalyze %Does calculation for each image that was selected
%Import an image    
[IDicomOrig, spacing] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
pixelSpacing = spacing(1)
%Remove blank top rows (Important for padding)
IDicomOrig(all(IDicomOrig>10000,2),:)=[];
%% Calculate the blurred disks and store them
radius = ((handles.diameter.*0.5)./(pixelSpacing*magn));
[attenDisks] = circle_roi4(radius);
[q1, q2] = size(attenDisks(:,:,1));
padAmnt = (q1+1)/2;
%% Expand image s.t. the edges reflect out to get full convolution
IDCMExpanded = padarray(IDicomOrig,[padAmnt padAmnt],'symmetric','both');
%% set guess of time to calculate
timePerImage = 5 %Min
pause(2)
%Calculate IQF and Detectability at different diameter levels 
[levels, IQF,IQFLarge, IQFMed,IQFSmall] = calcTestStat5(IDCMExpanded,handles.attenuation, radius, attenDisks, handles.thickness, handles.diameter, cutoff, padAmnt);
%% Export images as .mats
formatOut = 'dd-mmm-yyyy_HH-MM-SS';
str = datestr(now, formatOut);
A1 = char(part1{j});
A2 = char(part2{j});
A3 = char(FileName_Naming{j});
A4 = 'ThicknessEachDiam';
A5 = str;
A6 = '.mat';
formatSpec = '%s_%s_%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A1,A2, A3, A4, A5, A6)
save(fileForSaving, 'levels')

A4_2 = 'IQFMap';
formatSpec2 = '%s_%s_%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A1,A2, A3, A4_2, A5, A6)
save(fileForSaving, 'IQF')
end %Going through set of images
guidata(hObject,handles);

% --- Executes on button press in CreateCDIQF.
function CreateCDIQF_Callback(hObject, eventdata, handles)
%Allows you to select a point on the first file, and it produces a CD curve
%from that
global magn FileName_Naming NumImageAnalyze part1 part2
global levels IQF PathName_Naming FilterIndex_Naming extension cutoff
j=1;
%Import Image
[IDicomOrig, spacing] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
pixelSpacing = spacing(1);
IDicomOrig(all(IDicomOrig>10000,2),:)=[];
% Calculate the blurred disks and store them
radius = ((handles.diameter.*0.5)./(pixelSpacing*magn));
[attenDisk] = circle_roi4(radius);
%Calculate necessary amount of padding
[q1, q2] = size(attenDisk(:,:,1));
padAmnt = (q1+1)/2;
% Expand image s.t. the edges go out 250 pixel worth of the reflection
IDCMExpanded = padarray(IDicomOrig,[padAmnt padAmnt],'symmetric','both');
%Open Image and Obtain Point
figure; imshow(IDCMExpanded, []);
[xSel,ySel] = ginput(1); close; % [x, y]]
% Only do analysis on the 250*250 size box
centerImage = IDCMExpanded(ySel-padAmnt:ySel+padAmnt, xSel-padAmnt:xSel+padAmnt);
% Calculate the test statistic after inserting them in a region
[levels,IQF,IQFLarge, IQFMed,IQFSmall] = calcTestStat5(centerImage,handles.attenuation, radius, attenDisk, handles.thickness, handles.diameter, cutoff, padAmnt);
%Calculate CD Curve
for k = 1:length(radius) 
center=size(levels(:,:,k))/2+.5;
center = ceil(center);
cdThickness(k) = levels(center(1), center(2), k); %thickness
cdDiam(k) = handles.diameter(k);
end
% If I want to make CD curves of a certain spot. 
figure
scatter(cdDiam, cdThickness)
xlabel('Detail Diameter (mm)')
ylabel('Threshold Gold Thickness(um)')
set(gca,'xscale','log')
set(gca,'yscale','log')
axis([ 10^-2 10 0.01 10])       
guidata(hObject,handles);


% --- Executes on selection change in ShapeSelect.
function ShapeSelect_Callback(hObject, eventdata, handles)
%Allows you to select a type of shape for the inserted disk
%CURRENTLY DOES NOTHING
contents = cellstr(get(hObject,'String')) %returns ShapeSelect contents as cell array
global shape
shape = contents{get(hObject,'Value')}
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
%Creates video of disks being inserted into the region that you select.
%CURRENTLY DOES NOT WORK.
global magn FileName_Naming NumImageAnalyze part1 part2
global levels IQF PathName_Naming FilterIndex_Naming extension cutoff
j=1;
%Import Image
[IDicomOrig, spacing] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
pixelSpacing = spacing(1); 
figure; imshow(IDicomOrig, []);
[xSel,ySel] = ginput(1); close; 
%Calculate disks
radius = ((handles.diameter.*0.5)./(pixelSpacing*magn));
[attenDisk] = circle_roi4(radius);
%Calculate necessary amount of padding
[q1, q2] = size(attenDisk(:,:,1));
padAmnt = floor((q1)/2);
centerImage = IDicomOrig(ySel-padAmnt:ySel+padAmnt, xSel-padAmnt:xSel+padAmnt);
%Set up to save the name of the video
X = round(xSel);
Y = round(ySel);
fps = 3;
formatout = 'dd-mmm-yyyy_HH-MM-SS';
str = datestr(now, formatout);
A1 = char(part1{j});
A2 = char(part2{j});
A3 = char(FileName_Naming{j});
A35 = 'fdsafdsa'
A37 = num2str(fps)
A38 = 'fps'
A4 = num2str(X);
A45 = num2str(Y);
A5 = str;
A6 = '.avi';
formatSpec = '%s_%s_%s_%s%s_%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A1,A2,A3,A37,A38, A4,A45, A5, A6)

nDiam = length(handles.diameter);
nThickness = length(handles.attenuation);
attenuation = handles.attenuation;
%Create the video by cycling thru diams/attens and saving each frame
figure
v = VideoWriter(fileForSaving);
v.FrameRate = fps;
open(v)
 for j = 1:nDiam
     for k = 1:nThickness
         %Obtain the disk that I'm interested in
         negDisk = attenDisk(:,:,j);
         avgROI = mean2(centerImage);
         attenDisks = negDisk*((avgROI-50)'*(attenuation(k) - 1));
         imgWDisk = attenDisks+centerImage;
         
         imshow(imgWDisk, []);
         drawnow

         F = getframe;
         writeVideo(v,F)
     end 
 end
close(v)
guidata(hObject,handles);



% --- Executes on button press in Thicknesses_Slider.
function Thicknesses_Slider_Callback(hObject, eventdata, handles)
%Takes Levels and IQF and makes a slider where you can look at the
%detectability of different diameters.
global levels IQF

B=levels;
size(B);
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
plotterfcn(vars);
guidata(hObject,handles);

% Callback subfunctions to support UI actions
function slider1_callback(~,~,vars)
    % Run slider1 which controls value of epsilon
    vars.slider1_handle;
    plotterfcn(vars)

function plotterfcn(vars)
    % Plots the image
    imshow(vars.B(:,:,get(vars.slider1_handle,'Value')));
    title(num2str(get(vars.slider1_handle,'Value')));

function NumImageImport_Callback(hObject, eventdata, handles)
%Allows you to say how many images you want to analyze
global NumImageAnalyze
NumImageAnalyze = str2double(get(hObject,'String'));
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function NumImageImport_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Plot_IsoContour.
function Plot_IsoContour_Callback(hObject, eventdata, handles)
%Plots a contour image of the IQF Image
%Load and flip
global IQF
imageArray = flipud(IQF); 
%Plot
contourSizes = [10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34];
figure
contourf(imageArray, contourSizes)
colormap(gray)
colorbar
guidata(hObject,handles);


% --- Executes on button press in ImportMATs.
function ImportMATs_Callback(hObject, eventdata, handles)
%Allows you to import previous data files to analyze them later on
global levels IQF
[FileName,PathName,FilterIndex] = uigetfile;
full_file_mat = [PathName,'\',FileName];
storedStructure = load(full_file_mat,'-mat');
IQF = (storedStructure.IQF(:,:,1)); 

[FileName,PathName,FilterIndex] = uigetfile;
full_file_mat = [PathName,'\',FileName];
storedStructure = load(full_file_mat,'-mat');
levels = (storedStructure.levels); 
guidata(hObject,handles);



% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generate Lambda of point and compare with lambda of region with white
%noise added in
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global magn pixel FileName_Naming NumImageAnalyze part1 part2 %I_dicom_orig
global levels IQF PathName_Naming FilterIndex_Naming extension cutoff
j=1;
[IDicomOrig, spacing] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
pixelSpacing = spacing(1);
IDicomOrig(all(IDicomOrig>10000,2),:)=[];
%% Calculate the blurred disks and store them
radius = ((handles.diameter.*0.5)./(pixelSpacing*magn));
[attenDisk] = circle_roi4(radius);
[q1, q2] = size(attenDisk(:,:,1));
padAmnt = floor((q1)/2);
% Expand image s.t. the edges go out 250 pixel worth of the reflection
IDCMExpanded = padarray(IDicomOrig,[padAmnt padAmnt],'symmetric','both');
%Obtain Point
figure; imshow(IDCMExpanded, []);
[xSel,ySel] = ginput(1); close;  % [x, y]]
% Expand image s.t. the edges go out 250 pixel worth of the reflection
centerImage = IDCMExpanded(ySel-padAmnt:ySel+padAmnt, xSel-padAmnt:xSel+padAmnt) ;
%Add in disk
nDiam = length(handles.diameter);
nThickness = length(handles.attenuation);
attenuation = handles.attenuation;
meanImg = mean2(centerImage);
noiseAmplitude = [0*meanImg, .005*meanImg, .01*meanImg, .05*meanImg, .1*meanImg, .2*meanImg, .3*meanImg, .5*meanImg, .6*meanImg, .8*meanImg, 1*meanImg];
%Scrolls through different levels of noise
for i = 1:11
noiseAmnt = noiseAmplitude(i)
lambda = zeros(nDiam, nThickness);
lambdaNoise = zeros(nDiam, nThickness);
%Creates test statistic for each thickness/diameter
 for j = 1:nDiam
     for k = 1:nThickness
        negDisk = attenDisk(:,:,j);
         avgROI = mean2(centerImage);
         attenDisks = negDisk*((avgROI-50)'*(attenuation(k) - 1)); %Is my w=gs-gn
         imgWDisk = attenDisks+centerImage;
         imgWDiskNoise = imgWDisk+(noiseAmnt * 2*(rand(size(imgWDisk))-.5));  %Is my gtest
         
         w = attenDisks(:);
         wNoise = attenDisks(:) + (noiseAmnt * 2*(rand(size(attenDisks(:)))-.5));
         gTest = imgWDisk(:);
         gTestNoise = imgWDiskNoise(:);

         lambda(j,k) = w'*gTest;
         lambdaNoise(j,k) = wNoise'*gTestNoise;

     end
 end
%Lets you see test stat for each level of noise
lambda
lambdaNoise
pause
end
%Calculate IQF Values and table and stuff.
guidata(hObject,handles);
