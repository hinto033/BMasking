function varargout = DICOMReplace(varargin)
% DICOMREPLACE MATLAB code for DICOMReplace.fig
%      DICOMREPLACE, by itself, creates a new DICOMREPLACE or raises the existing
%      singleton*.
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help DICOMReplace
% Last Modified by GUIDE v2.5 08-Jun-2016 11:30:55

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
global magn cutoffs diameter attenuation thickness
global NumImageAnalyze
NumImageAnalyze=1;
thickness = [2, 1.42, 1, .71, .5, .36, .25, .2, .16, .13, .1, .08, .06,...
    .05, .04, .03]; %um
diameter = [50, 40, 30, 20, 10, 8, 5, 3, 2, 1.6, 1.25, 1, .8, .63, .5,...
    .4, .31, .25, .2, .16, .13, .1, .08, .06]; %mm
% attenuation = [0.8128952,0.862070917,0.900130881,0.927690039,0.948342287,...
%     0.962465394,0.973737644,0.978903709,0.983080655,0.986231347,0.989380904,...
%     0.991486421,0.993610738,0.994672709,0.995734557,0.996796281];
magn = 1; %1.082;
% cutoffs = 1e5*[-.4*1e5, -.32*1e5, -.16*1e5, -.06*1e5,-.02*1e5,-.013*1e5,...
%     -.006*1e5,-.0025*1e5,-.00145*1e5,-.0009*1e5,-.0007*1e5, -.0005*1e5,-.0004*1e5,...
%     -2.3610,-1.7207,-1.5966,-1.2005,-1.5624,-1.3016,-1.2426,...
%     -1.6839,-1.3971,-1.9411, -1.9411];
handles.shape = 'Round';
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = DICOMReplace_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes on button press in SelectFile.
function SelectFile_Callback(hObject, eventdata, handles)
%Selects a certain number of files and stores the path for use later
%This will allow you to analyze these files later
global NumImageAnalyze FileName PathName FilterIndex ext
global FileName_Naming parts part1 part2 PathName_Naming FilterIndex_Naming extension
for j = 1:NumImageAnalyze
%%Opens up dialogue box to import a DICOM file of your choosing
[FileName,PathName,FilterIndex] = uigetfile;
%Stores filepath
FileName_Naming{j} = FileName; PathName_Naming{j} = PathName;
FilterIndex_Naming{j} = FilterIndex;
[pathstr,name,ext] = fileparts([PathName,'\',FileName]);
extension{j} = ext; s=pathstr;
parts=regexp(s,'\','split');
parts = fliplr(parts); part1{j} = parts(3); part2{j} = parts(2);
end
guidata(hObject,handles);

% --- Executes on button press in InsertDisks.
function InsertDisks_Callback(hObject, eventdata, handles)
%Parameter Setting
global magn FileName_Naming NumImageAnalyze part1 part2 %shape %I_dicom_orig
global levels PathName_Naming FilterIndex_Naming extension cutoffs %IQF
global diameter thickness attenuation SigmaPixels spacing
for j = 1:NumImageAnalyze %Does calculation for each image that was selected
%% Pre-processing data
%Import the image & DICOMData    
[IDicomOrig, DICOMData] = import_image(j, FileName_Naming,...
    PathName_Naming, FilterIndex_Naming, extension);
%Remove blank top rows (Important for padding)
IDicomOrig(all(IDicomOrig>10000,2),:)=[];
%Determine MTF and get the attenuation values for disks
[SigmaPixels] = determineMTF(IDicomOrig);
[attenuation] = getSpectraAttens(DICOMData, thickness);
% set guess of time to calculate
timePerImage = 30; %Min
TotalTimeRemaining = timePerImage*(NumImageAnalyze - j + 1)
pause(2)
% Calculate the blurred disks of different diameters and store them
pixelSpacing = DICOMData.PixelSpacing(1);
radius = ((diameter.*0.5)./(pixelSpacing*magn));
shape = handles.shape;
[attenDisks] = circle_roi4(radius, shape, SigmaPixels);
%% Doing Calculations
%Calculate the thresholds for the breast image (Takes most time
[cutoffs] = calcThresholds(IDicomOrig,attenDisks,diameter, attenuation);
%Calculate IQF and Detectability at different diameter levels 
[levels, IQF] = calcTestStat5(IDicomOrig,attenuation, radius,...
    attenDisks, thickness, diameter, cutoffs, pixelSpacing);
%Perform Exp fit of the detectability data at each pixel
[aMat, bMat, RSquare] = PerformExpFit(levels, pixelSpacing, diameter);
%% Export images/data as .mats
formatOut = 'dd-mmm-yyyy_HH-MM-SS';
str = datestr(now, formatOut);
A1 = char(part1{j}); A2 = char(part2{j});
A3 = char(FileName_Naming{j}); A4 = 'ThicknessEachDiam';
A5 = str; A6 = '.mat';
formatSpec = '%s_%s_%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A1,A2, A3, A4, A5, A6)
save(fileForSaving, 'levels') %Large file before processing it
A4_2 = 'IQFMap';
formatSpec2 = '%s_%s_%s_%s_%s%s';
IQFFull = IQF.Full;
fileForSaving = sprintf(formatSpec,A1,A2, A3, A4_2, A5, A6)
save(fileForSaving, 'IQFFull') %IQF Image
A4_3 = 'IQFSmallDisks';
IQFSmall = IQF.Small;
formatSpec2 = '%s_%s_%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A1,A2, A3, A4_3, A5, A6)
save(fileForSaving, 'IQFSmall') %IQF Image of small disks
A4_4 = 'IQFMediumDisks';
IQFMed = IQF.Med;
formatSpec2 = '%s_%s_%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A1,A2, A3, A4_4, A5, A6)
save(fileForSaving, 'IQFMed') % IQF Image of medium disks
A4_5 = 'IQFLargeDisks';
IQFLarge = IQF.Large;
formatSpec2 = '%s_%s_%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A1,A2, A3, A4_5, A5, A6)
save(fileForSaving, 'IQFLarge') % IQF Image of large disks
A4_6 = 'A_ValueOfFit';
formatSpec2 = '%s_%s_%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A1,A2, A3, A4_6, A5, A6)
save(fileForSaving, 'aMat')% a value from exponential fit at each point
A4_7 = 'B_ValueOfFit';
formatSpec2 = '%s_%s_%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A1,A2, A3, A4_7, A5, A6)
save(fileForSaving, 'bMat')% b value from exponential fit at each point
A4_8 = 'RSquareOfFit';
formatSpec2 = '%s_%s_%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A1,A2, A3, A4_8, A5, A6)
save(fileForSaving, 'RSquare')% r^2 value from exp fit at each point
A4_9 = 'IQF_Statistics';
IQFStats = IQF.Stats;
formatSpec2 = '%s_%s_%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A1,A2, A3, A4_9, A5, A6)
save(fileForSaving, 'IQFStats')% Statistics of IQF Value (Mean,stdev etc)
end %Going through set of images
guidata(hObject,handles);

% --- Executes on button press in CreateCDIQF.
function CreateCDIQF_Callback(hObject, eventdata, handles)
%Creates a CD Curve and Exp fit of an image at a specific point
global magn FileName_Naming NumImageAnalyze part1 part2 shape
global levels IQF PathName_Naming FilterIndex_Naming extension cutoffs
global diameter thickness attenuation spacing SigmaPixels
%Set as first selected file
j=1;
%% Preprocessing Data
%Import Image
[IDicomOrig, DICOMData] = import_image(j, FileName_Naming,...
    PathName_Naming, FilterIndex_Naming, extension);
pixelSpacing = DICOMData.PixelSpacing(1);
IDicomOrig(all(IDicomOrig>10000,2),:)=[];
[SigmaPixels] = determineMTF(IDicomOrig);
[attenuation] = getSpectraAttens(DICOMData, thickness);
% Calculate the blurred disks and store them
radius = ((diameter.*0.5)./(pixelSpacing*magn));
[attenDisks] = circle_roi4(radius, shape, SigmaPixels);
[cutoffs] = calcThresholds(IDicomOrig,attenDisks,diameter, attenuation)
%Calculate necessary amount of padding
[q1, q2] = size(attenDisks(:,:,1)); padAmnt = (q1+1)/2;
%Open Image and Obtain Point
figure; imshow(IDicomOrig, []);
[xSel,ySel] = ginput(1); close;
% Only do analysis on the 250*250 size box
centerImage = IDicomOrig(ySel-padAmnt:ySel+padAmnt, xSel-padAmnt:xSel+padAmnt);
% Calculate the test statistic after inserting them in a region
[cdThickness, cdDiam] = calcTestStatPoint(centerImage,attenuation, radius,...
    attenDisks, thickness, diameter, cutoffs, pixelSpacing);%Calculate CD Curve
%% Do the Linear Fit Here
y = cdThickness(:); x = cdDiam(:);
[f, gof] = fit(x,y,'power1');
r2 = gof.rsquare; coeffs = coeffvalues(f);
a = coeffs(1); b = coeffs(2); figure; plot(f,x,y);
xlabel('Detail Diameter (mm)'); ylabel('Threshold Gold Thickness(um)')
figure; plot(f,cdDiam,cdThickness)
xlabel('Detail Diameter (mm)'); ylabel('Threshold Gold Thickness(um)')
set(gca,'xscale','log'); set(gca,'yscale','log')
axis([ 10^-2 10 0.01 10])  
hold on; formatSpec = 'R^2 = %f';
textBox = sprintf(formatSpec, r2); text(1,1,textBox)
guidata(hObject,handles);

% --- Executes on selection change in ShapeSelect.
function ShapeSelect_Callback(hObject, eventdata, handles)
%Allows you to select a type of shape for the inserted disk
%Will be useful for making different lesion sizes
contents = cellstr(get(hObject,'String'));
%returns ShapeSelect contents as cell array
handles.shape = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ShapeSelect_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject,handles);

% --- Executes on button press in MakeVideo.
function MakeVideo_Callback(hObject, eventdata, handles)
%Creates video of disks being inserted into the region that you select.
global magn FileName_Naming part1 part2 shape
global PathName_Naming FilterIndex_Naming extension cutoffs
global attenuation thickness diameter SigmaPixels
j=1;
%% Preprocessing
%Import Image
[IDicomOrig, DICOMData] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
pixelSpacing =DICOMData.PixelSpacing(1);
figure; imshow(IDicomOrig, []);
[xSel,ySel] = ginput(1); close; 
%Calculate disks
[SigmaPixels] = determineMTF(IDicomOrig);
[attenuation] = getSpectraAttens(DICOMData, thickness);
radius = ((handles.diameter.*0.5)./(pixelSpacing*magn));
[attenDisk] = circle_roi4(radius, shape, SigmaPixels);
[cutoffs] = calcThresholds(IDicomOrig,attenDisk,diameter, attenuation)
%Pad Image and create a regional image
[q1, q2] = size(attenDisk(:,:,1));
padAmnt = floor((q1)/2);
centerImage = IDicomOrig(ySel-padAmnt:ySel+padAmnt, xSel-padAmnt:xSel+padAmnt);
%Set up to save the name of the video
X = round(xSel); Y = round(ySel); fps = 3;
formatout = 'dd-mmm-yyyy_HH-MM-SS'; str = datestr(now, formatout);
A1 = char(part1{j}); A2 = char(part2{j});
A3 = char(FileName_Naming{j}); A37 = num2str(fps);
A38 = 'fps'; A4 = num2str(X); A45 = num2str(Y);
A5 = str; A6 = '.avi'; formatSpec = '%s_%s_%s_%s%s_%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A1,A2,A3,A37,A38, A4,A45, A5, A6);
nDiam = length(diameter);
nThickness = length(attenuation);
%Create the video by cycling thru diams/attens and saving each frame
figure
v = VideoWriter(fileForSaving);
v.FrameRate = fps; open(v)
 for j = 1:nDiam
     for k = 1:nThickness
         %Obtain the disk that I'm interested in
         negDisk = attenDisk(:,:,j); avgROI = mean2(centerImage);
         attenDisks = negDisk*((avgROI-50)'*(attenuation(k) - 1));
         imgWDisk = attenDisks+centerImage;
         imshow(imgWDisk, []);
         drawnow
         F = getframe; writeVideo(v,F)
     end 
 end
close(v)
guidata(hObject,handles);



% --- Executes on button press in Thicknesses_Slider.
function Thicknesses_Slider_Callback(hObject, eventdata, handles)
%Takes Levels and IQF and makes a slider where you can look at the
%detectability of different diameters.
global levels IQF
B=levels; size(B); fig=figure(100);
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
imageArray = flipud(IQF.IQFFull);
%Plot
%Right now this is arbitrary
contourSizes = [0, 1 , 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24];
figure
contourf(imageArray, contourSizes)
% colormap(gray)
colorbar
guidata(hObject,handles);


% --- Executes on button press in ImportMATs.
function ImportMATs_Callback(hObject, eventdata, handles)
%Allows you to import previous data files to analyze them later on
global levels IQF
[FileName,PathName,FilterIndex] = uigetfile;
full_file_mat = [PathName,'\',FileName];
storedStructure = load(full_file_mat,'-mat');
IQF = (storedStructure(:,:,1)); 
IQF = (storedStructure.IQF(:,:,1)); 
[FileName,PathName,FilterIndex] = uigetfile;
full_file_mat = [PathName,'\',FileName];
storedStructure = load(full_file_mat,'-mat');
levels = (storedStructure.levels); 
guidata(hObject,handles);



% --- Executes on button press in GenLambdasAtPoint.
function GenLambdasAtPoint_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generate Lambda of point and compare with lambda of region with white
%noise added in
%Doesn't do anything useful yet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global magn pixel FileName_Naming NumImageAnalyze part1 part2 shape %I_dicom_orig
global levels IQF PathName_Naming FilterIndex_Naming extension cutoffs
global attenuation thickness diameter SigmaPixels
j=1;
[IDicomOrig, DICOMData] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
pixelSpacing = DICOMData.PixelSpacing(1);
IDicomOrig(all(IDicomOrig>10000,2),:)=[];
%% Calculate the blurred disks and store them
[SigmaPixels] = determineMTF(IDicomOrig);
[attenuation] = getSpectraAttens(DICOMData, thickness);
radius = ((diameter.*0.5)./(pixelSpacing*magn));
[attenDisk] = circle_roi4(radius, shape, SigmaPixels);
[cutoffs] = calcThresholds(IDicomOrig,attenDisk,diameter, attenuation)
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
nDiam = length(diameter);
nThickness = length(attenuation);
meanImg = mean2(centerImage);
noiseAmplitude = [0*meanImg, .005*meanImg, .01*meanImg, .05*meanImg,...
    .1*meanImg, .2*meanImg, .3*meanImg, .5*meanImg, .6*meanImg,...
    .8*meanImg, 1*meanImg];
%Scrolls through different levels of noise
for i = 1:11
noiseAmnt = noiseAmplitude(i);
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
         centerImageNoise = centerImage + (noiseAmnt * 2*(rand(size(centerImage))-.5));
         w = attenDisks(:);
         wNoise = attenDisks(:) + (noiseAmnt * 2*(rand(size(attenDisks(:)))-.5));
         gTest = imgWDisk(:);
         gTestNoise = imgWDiskNoise(:);

         lambda(j,k) = w'*gTest;
         lambdaNoise(j,k) = wNoise'*gTestNoise;
         %To do a T test
%          h(j,k) = ttest2(imgWDisk(:), centerImage(:));
%          if h(j,k) == 0
            %Shows the image if the t-test said it was undetectable
%              figure
%              imshow(imgWDisk,[])
%              pause
%              close
%          end
%          hNoise(j,k) = ttest2(imgWDiskNoise(:), centerImageNoise(:));     
     end
 end
%Lets you see test stat for each level of noise
lambda;
lambdaNoise
% h;
% hNoise;
lambda2_2(i) = lambdaNoise(1,1);
lambdasmall_small(i) = lambdaNoise(9,9);
% pause
end
avgArea = mean2(centerImage)
stDevArea = std2(centerImage)
%Generate other 50 features here! :)
%Figure out what to save and what to compare and things like that.
figure
scatter(noiseAmplitude./meanImg, lambda2_2)
xlabel('Noise Amount (as fraction of Average image Value')
ylabel('Threshold Lambda Values')
title('Threshold Lambda Values for 2 cm diam and 2 mm thick disk')
figure
scatter(noiseAmplitude./meanImg, lambdasmall_small)
xlabel('Noise Amount (as fraction of Average image Value')
ylabel('Threshold Lambda Values')
title('Threshold Lambda Values for small diam and small thickness')
%Calculate IQF Values and table and stuff.
guidata(hObject,handles);

% --- Executes on button press in ConfirmCorrectCalcs.
function ConfirmCorrectCalcs_Callback(hObject, eventdata, handles)
% hObject    handle to ConfirmCorrectCalcs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global magn FileName_Naming NumImageAnalyze part1 part2 %shape %I_dicom_orig
global levels IQF PathName_Naming FilterIndex_Naming extension cutoffs
global diameter thickness attenuation SigmaPixels
%Import an image    
j=1;
[IDicomOrig, DICOMData] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
pixelSpacing = DICOMData.PixelSpacing(1);
%Remove blank top rows (Important for padding)
IDicomOrig(all(IDicomOrig>10000,2),:)=[];
[SigmaPixels] = determineMTF(IDicomOrig)
[attenuation] = getSpectraAttens(DICOMData, thickness)
IDCMExpanded = IDicomOrig;
%Open Image and Obtain Point
figure; imshow(IDCMExpanded, []);
[xSel,ySel] = ginput(1); close; % [x, y]]
%% Calculate the blurred disks and store them
radius = ((diameter.*0.5)./(pixelSpacing*magn));
shape = handles.shape;
[attenDisks] = circle_roi4(radius, shape, SigmaPixels);
[cutoffs] = calcThresholds(IDicomOrig,attenDisk,diameter, attenuation)
[q1, q2] = size(attenDisks(:,:,1));
padAmnt = floor((q1)/2);
centerImage = IDCMExpanded(ySel-padAmnt:ySel+padAmnt, xSel-padAmnt:xSel+padAmnt);
%Calculate IQF and Detectability at different diameter levels 
[lambdaNPW, lambdaFFT,lambdaConv] = confirmCalcs(centerImage,attenuation, radius,...
    attenDisks, thickness, diameter, cutoffs, pixelSpacing)
guidata(hObject,handles);



% --- Executes on button press in YesNoSituation.
function YesNoSituation_Callback(hObject, eventdata, handles)
% hObject    handle to YesNoSituation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global magn FileName_Naming NumImageAnalyze part1 part2 %shape %I_dicom_orig
global levels PathName_Naming FilterIndex_Naming extension cutoffs %IQF
global diameter thickness attenuation SigmaPixels spacing
%Import an image    
j = 1
[IDicomOrig, DICOMData] = import_image(j, FileName_Naming,...
    PathName_Naming, FilterIndex_Naming, extension);
pixelSpacing = DICOMData.PixelSpacing(1);
%Remove blank top rows (Important for padding)
IDicomOrig(all(IDicomOrig>10000,2),:)=[];
[SigmaPixels] = determineMTF(IDicomOrig);
[attenuation] = getSpectraAttens(DICOMData, thickness);
%% Calculate the blurred disks and store them
radius = ((diameter.*0.5)./(pixelSpacing*magn));
shape = handles.shape; [attenDisks] = circle_roi4(radius, shape, SigmaPixels);
% [cutoffs] = calcThresholds(IDicomOrig,attenDisk,diameter, attenuation)
%%
figure; imshow(IDicomOrig, []);
[xSel,ySel] = ginput(1); close; % [x, y]]
%% Calculate the blurred disks and store them
[q1, q2] = size(attenDisks(:,:,1));
padAmnt = floor((q1)/2)
centerImage = IDicomOrig(ySel-padAmnt:ySel+padAmnt, xSel-padAmnt:xSel+padAmnt);
%Calculate IQF and Detectability at different diameter levels 
[results] = seeTestStat5(centerImage,attenuation, radius,...
    attenDisks, thickness, diameter, cutoffs, pixelSpacing);
% [aMat, bMat, RSquare] = PerformExpFit(levels, pixelSpacing, diameter);
guidata(hObject,handles);

% --- Executes on button press in AFCBothMethods.
function AFCBothMethods_Callback(hObject, eventdata, handles)
%% Import Variables
global magn FileName_Naming NumImageAnalyze part1 part2 %shape %I_dicom_orig
global levels PathName_Naming FilterIndex_Naming extension cutoffs %IQF
global diameter thickness attenuation SigmaPixels spacing
j=1
%% Import Image
[IDicomOrig, DICOMData] = import_image(j, FileName_Naming,...
    PathName_Naming, FilterIndex_Naming, extension);
pixelSpacing = DICOMData.PixelSpacing(1);
%Take away blank rows
IDicomOrig(all(IDicomOrig>10000,2),:)=[];
%Calculate MTF and generate discs
[SigmaPixels] = determineMTF(IDicomOrig);
[attenuation] = getSpectraAttens(DICOMData, thickness);
% Calculate the blurred disks and store them
radius = ((diameter.*0.5)./(pixelSpacing*magn));
shape = handles.shape; 
[attenDisk] = circle_roi4(radius, shape, SigmaPixels);

[cutoffs] = calcAFC(IDicomOrig,attenDisk,diameter, attenuation)
guidata(hObject,handles);
