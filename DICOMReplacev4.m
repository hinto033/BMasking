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

% Last Modified by GUIDE v2.5 16-May-2016 11:18:11

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
handles.diameter = [50, 40, 30, 20, 10, 8, 5, 3, 2, 1.6, 1.25, 1, .8, .63, .5, .4, .31, .25, .2, .16, .13, .1, .08, .06]; %mm
% handles.diameter = [10, 8, 5, 3, 2, 1.6, 1.25, 1, .8, .63, .5, .4, .31, .25, .2, .16, .13, .1, .08, .06]; %mm
handles.attenuation = [0.8128952,0.862070917,0.900130881,0.927690039,0.948342287,...
    0.962465394,0.973737644,0.978903709,0.983080655,0.986231347,0.989380904,...
    0.991486421,0.993610738,0.994672709,0.995734557,0.996796281];
magn = 1; %1.082;
cutoff = 95000;
handles.shape = 'Round'
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
global magn FileName_Naming NumImageAnalyze part1 part2 %shape %I_dicom_orig
global levels IQF PathName_Naming FilterIndex_Naming extension cutoff
for j = 1:NumImageAnalyze %Does calculation for each image that was selected
%Import an image    
[IDicomOrig, DICOMData] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
pixelSpacing = DICOMData.PixelSpacing(1);
%Remove blank top rows (Important for padding)
IDicomOrig(all(IDicomOrig>10000,2),:)=[];
% figure
% imshow(IDicomOrig, [])
% pause
%% Calculate the blurred disks and store them
radius = ((handles.diameter.*0.5)./(pixelSpacing*magn));
shape = handles.shape;
[attenDisks] = circle_roi4(radius, shape);
[q1, q2] = size(attenDisks(:,:,1));
padAmnt = (q1+1)/2;
%% Expand image s.t. the edges reflect out to get full convolution
% IDCMExpanded = padarray(IDicomOrig,[padAmnt padAmnt],'symmetric','both');
IDCMExpanded = IDicomOrig;
%% set guess of time to calculate
timePerImage = 6; %Min
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
global magn FileName_Naming NumImageAnalyze part1 part2 shape
global levels IQF PathName_Naming FilterIndex_Naming extension cutoff
j=1;
%Import Image
% % % % [IDicomOrig, spacing] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
% % % % pixelSpacing = spacing(1);
% % % % IDicomOrig(all(IDicomOrig>10000,2),:)=[];
% % % % % Calculate the blurred disks and store them
% % % % radius = ((handles.diameter.*0.5)./(pixelSpacing*magn));
% % % % [attenDisk] = circle_roi4(radius, shape);
% % % % %Calculate necessary amount of padding
% % % % [q1, q2] = size(attenDisk(:,:,1));
% % % % padAmnt = (q1+1)/2;
% % % % % Expand image s.t. the edges go out 250 pixel worth of the reflection
% % % % IDCMExpanded = padarray(IDicomOrig,[padAmnt padAmnt],'symmetric','both');
% % % % %Open Image and Obtain Point
% % % % figure; imshow(IDCMExpanded, []);
% % % % [xSel,ySel] = ginput(1); close; % [x, y]]
% % % % % Only do analysis on the 250*250 size box
% % % % centerImage = IDCMExpanded(ySel-padAmnt:ySel+padAmnt, xSel-padAmnt:xSel+padAmnt);
% % % % % Calculate the test statistic after inserting them in a region
% % % % [levels,IQF,IQFLarge, IQFMed,IQFSmall] = calcTestStat5(centerImage,handles.attenuation, radius, attenDisk, handles.thickness, handles.diameter, cutoff, padAmnt);
% % % % %Calculate CD Curve
% % % % for k = 1:length(radius) 
% % % % center=size(levels(:,:,k))/2+.5;
% % % % center = ceil(center);
% % % % cdThickness(k) = levels(center(1), center(2), k); %thickness
% % % % cdDiam(k) = handles.diameter(k);
% % % % end


%%Section trying to do computations as fast as possible
[nRows,nCols,p] = size(levels);
% pause
cdDiam = handles.diameter;
x = cdDiam(8:20)';

aMat = zeros(nRows,nCols);
bMat = zeros(nRows,nCols);
RSquare = zeros(nRows,nCols);
tic
for i = 51:100:nRows
    for j = 51:100:nCols
        cdThickness = reshape(levels(i,j,:), [1,20]);
        y = cdThickness(8:20)';
        [f, gof] = fit(x,y,'power1');
        RSquare(i,j) = gof.rsquare;
        coeffs = coeffvalues(f);
        aMat(i-50:i+50,j-50:j+50) = coeffs(1);
        bMat(i-50:i+50,j-50:j+50) = coeffs(2);
        %Add in the map for the different a b, and rsquared
    end
end
figure
imshow(bMat,[])
figure
imshow(aMat, [])
toc
%MAKE OPTION TO PLOT WHICHEVER ONE I WANT
p = 'fdsafdsa'
pause
%% regular section
% thickTest = reshape(levels(1,1,:), [1,20])
% diamTest = handles.diameter


cdThickness
cdDiam
pause
%Do the Linear Fit Here
y = cdThickness(8:20)';
x = cdDiam(8:20)';
[f, gof] = fit(x,y,'power1');
r2 = gof.rsquare;
coeffs = coeffvalues(f);
a = coeffs(1);
b = coeffs(2);
% CONFINT extracts the confidence intervals
figure
plot(f,x,y)
xlabel('Detail Diameter (mm)')
ylabel('Threshold Gold Thickness(um)')
figure
plot(f,cdDiam,cdThickness)
xlabel('Detail Diameter (mm)')
ylabel('Threshold Gold Thickness(um)')
set(gca,'xscale','log')
set(gca,'yscale','log')
axis([ 10^-2 10 0.01 10])  
hold on
formatSpec = 'R^2 = %f';
textBox = sprintf(formatSpec, r2);
text(1,1,textBox)
guidata(hObject,handles);


% --- Executes on selection change in ShapeSelect.
function ShapeSelect_Callback(hObject, eventdata, handles)
%Allows you to select a type of shape for the inserted disk
%CURRENTLY DOES NOTHING
contents = cellstr(get(hObject,'String')) %returns ShapeSelect contents as cell array
handles.shape = contents{get(hObject,'Value')}
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
guidata(hObject,handles);


% --- Executes on button press in MakeVideo.
function MakeVideo_Callback(hObject, eventdata, handles)
%Creates video of disks being inserted into the region that you select.
%CURRENTLY DOES NOT WORK.
global magn FileName_Naming NumImageAnalyze part1 part2 shape
global levels IQF PathName_Naming FilterIndex_Naming extension cutoff
j=1;
%Import Image
[IDicomOrig, DICOMData] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
pixelSpacing =DICOMData.PixelSpacing(1);
figure; imshow(IDicomOrig, []);
[xSel,ySel] = ginput(1); close; 
%Calculate disks
radius = ((handles.diameter.*0.5)./(pixelSpacing*magn));
[attenDisk] = circle_roi4(radius, shape);
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
A37 = num2str(fps);
A38 = 'fps';
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
figure
imshow(IQF, [])
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



% --- Executes on button press in GenLambdasAtPoint.
function GenLambdasAtPoint_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generate Lambda of point and compare with lambda of region with white
%noise added in
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global magn pixel FileName_Naming NumImageAnalyze part1 part2 shape %I_dicom_orig
global levels IQF PathName_Naming FilterIndex_Naming extension cutoff
j=1;
[IDicomOrig, DICOMData] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);
pixelSpacing = DICOMData.PixelSpacing(1);
IDicomOrig(all(IDicomOrig>10000,2),:)=[];
%% Calculate the blurred disks and store them
radius = ((handles.diameter.*0.5)./(pixelSpacing*magn));
[attenDisk] = circle_roi4(radius, shape);
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
         
         h(j,k) = ttest2(imgWDisk(:), centerImage(:));
         if h(j,k) == 0
             figure
             imshow(imgWDisk,[])
             pause
             close
         end
         hNoise(j,k) = ttest2(imgWDiskNoise(:), centerImageNoise(:));
%          returns a test decision for the null hypothesis that the data in
% vectors x and y comes from independent random samples from normal
% distributions with equal means and equal but unknown variances, using the
% two-sample t-test. The alternative hypothesis is that the data in x and y
% comes from populations with unequal means. The result h is 1 if the test 
% rejects the null hypothesis at the 5% significance level, and 0 otherwise.
%          pause        
     end
 end
%Lets you see test stat for each level of noise
lambda;
lambdaNoise;
h;
hNoise;
lambda2_2(i) = lambdaNoise(1,1);
lambdasmall_small(i) = lambdaNoise(9,9);
pause
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


% --- Executes on button press in AddF3Noise.
function AddF3Noise_Callback(hObject, eventdata, handles)
global shape magn

%Setting Parms
cdcomDiams = fliplr([0.08 0.10 0.13 0.16 0.20 0.25	0.31 0.40 0.50 0.63	0.80 1.00]);
diams = [10, 8, 5, 3, 2, 1.6, 1.25, 1, .8, .63, .5, .4, .31, .25, .2, .16, .13, .1, .08, .06];
cutoff = zeros(5,length(diams))
pathstr = 'W:\Breast Studies\CDMAM\Selenia Feb15\';
name = 'DCM';
dcmEnding = [1 2 3 4 5 6 7 8 20 21];
%Adjust these results with results from 1/f3 noise
dcmResults{1} = [1.175	0.812	0.395	0.235	0.147	0.115	0.113	0.098	0.060	0.048	0.041	0.027;
1.751	1.278	0.641	0.397	0.259	0.211	0.216	0.194	0.124	0.103	0.092	0.065;
1.722	1.066	0.640	0.452	0.325	0.245	0.193	0.150	0.123	0.101	0.085	0.074;
0.925	0.545	0.294	0.209	0.165	0.124	0.095	0.074	0.068	0.064	0.056	0.056];
dcmResults{2} = [1.057	0.591	0.442	0.254	0.179	0.094	0.078	0.058	0.043	0.029	0.022	0.030;
1.564	0.912	0.722	0.429	0.314	0.174	0.151	0.117	0.092	0.067	0.053	0.070;
1.566	1.020	0.620	0.427	0.290	0.204	0.150	0.109	0.087	0.072	0.063	0.059;
0.841	0.521	0.285	0.197	0.147	0.103	0.074	0.054	0.048	0.046	0.042	0.044];
dcmResults{3} = [0.680	0.466	0.374	0.310	0.235	0.150	0.099	0.058	0.028	0.029	0.028	0.024;
0.979	0.710	0.607	0.526	0.414	0.274	0.190	0.117	0.063	0.066	0.065	0.058;
1.481	1.014	0.646	0.457	0.318	0.225	0.165	0.118	0.091	0.072	0.060	0.053;
0.795	0.518	0.297	0.211	0.161	0.114	0.081	0.058	0.050	0.046	0.040	0.040];
dcmResults{4} = [1.103	0.319	0.244	0.167	0.144	0.128	0.063	0.057	0.062	0.049	0.036	0.036;
1.637	0.481	0.393	0.282	0.254	0.235	0.123	0.115	0.127	0.103	0.080	0.082;
0.670	0.509	0.372	0.296	0.235	0.190	0.158	0.130	0.112	0.097	0.087	0.079;
0.360	0.260	0.171	0.137	0.119	0.096	0.078	0.064	0.061	0.061	0.057	0.060];
dcmResults{5} = [0.746	0.548	0.420	0.302	0.200	0.113	0.076	0.069	0.051	0.040	0.034	0.028;
1.080	0.842	0.683	0.511	0.352	0.209	0.148	0.138	0.107	0.086	0.076	0.067;
1.413	0.974	0.628	0.450	0.318	0.231	0.174	0.129	0.104	0.086	0.075	0.068;
0.759	0.498	0.288	0.208	0.161	0.116	0.086	0.063	0.057	0.054	0.049	0.052];
dcmResults{6} = [1.192	0.549	0.349	0.189	0.155	0.141	0.108	0.045	0.037	0.031	0.022	0.014;
1.778	0.844	0.565	0.318	0.273	0.259	0.205	0.093	0.081	0.069	0.054	0.039;
1.177	0.831	0.550	0.402	0.288	0.210	0.157	0.113	0.086	0.066	0.052	0.042;
0.632	0.424	0.253	0.186	0.146	0.106	0.077	0.055	0.047	0.041	0.034	0.032];
dcmResults{7} = [1.025	0.479	0.386	0.268	0.172	0.122	0.086	0.060	0.046	0.036	0.029	0.031;
1.513	0.731	0.627	0.453	0.303	0.225	0.165	0.121	0.097	0.080	0.068	0.072;
1.265	0.878	0.572	0.413	0.295	0.216	0.165	0.124	0.100	0.083	0.072	0.066;
0.680	0.449	0.263	0.191	0.150	0.109	0.081	0.061	0.055	0.052	0.047	0.050];
dcmResults{8} = [1.142	0.580	0.350	0.191	0.148	0.141	0.105	0.070	0.059	0.043	0.032	0.031;
1.698	0.894	0.565	0.323	0.261	0.258	0.200	0.141	0.122	0.092	0.074	0.072;
1.293	0.839	0.533	0.393	0.293	0.227	0.181	0.142	0.117	0.096	0.080	0.068;
0.695	0.429	0.245	0.181	0.148	0.114	0.089	0.070	0.064	0.060	0.052	0.052];
dcmResults{9} = [1.07	0.18	0.19	0.24	0.20	0.11	0.06	0.05	0.05	0.04	0.03	0.01;
1.58	0.28	0.31	0.41	0.35	0.19	0.12	0.10	0.10	0.09	0.06	0.03;
0.57	0.44	0.33	0.27	0.21	0.17	0.14	0.11	0.09	0.07	0.06	0.05;
0.30	0.23	0.15	0.12	0.11	0.09	0.07	0.05	0.05	0.05	0.04	0.04];
dcmResults{10} = [0.897	0.426	0.289	0.199	0.130	0.109	0.080	0.070	0.059	0.040	0.039	0.032;
1.312	0.648	0.465	0.336	0.230	0.200	0.153	0.141	0.121	0.088	0.086	0.074;
1.019	0.670	0.435	0.327	0.249	0.198	0.163	0.132	0.112	0.096	0.083	0.075;
0.548	0.342	0.200	0.151	0.126	0.100	0.080	0.065	0.062	0.060	0.055	0.057];
dcm1_5_results = [0.906	0.533	0.350	0.236	0.166	0.111	0.082	0.064	0.047	0.037	0.031	0.027;
1.327	0.818	0.566	0.398	0.291	0.205	0.158	0.128	0.099	0.081	0.071	0.064;
1.193	0.834	0.548	0.399	0.287	0.212	0.162	0.122	0.099	0.082	0.071	0.064;
0.208	0.138	0.082	0.060	0.047	0.035	0.026	0.019	0.018	0.017	0.015	0.016];
dcm6_21_results = [0.989	0.462	0.313	0.214	0.159	0.124	0.084	0.058	0.046	0.036	0.030	0.024;
1.456	0.705	0.504	0.362	0.279	0.228	0.162	0.118	0.098	0.080	0.068	0.059;
1.006	0.725	0.495	0.372	0.276	0.209	0.163	0.124	0.099	0.081	0.068	0.059;
0.175	0.120	0.074	0.056	0.045	0.034	0.026	0.020	0.018	0.016	0.014	0.014];

full_file_dicomread = [pathstr,name,num2str(dcmEnding(1))];
info_dicom = dicominfo(full_file_dicomread);
pixelSpacing = info_dicom.PixelSpacing(1);

radius = ((handles.diameter.*0.5)./(pixelSpacing*magn));
dt = round(radius.*2) + 1;
rt = dt./2;
shape = 'Round'
[attenDisk] = circle_roi4(radius, shape);
rowNum=3;
[q1, q2] = size(attenDisk(:,:,1));
padamnt = round((q1)/2)-1
nDiam = length(handles.diameter)
nThickness = length(handles.thickness)
attenuation = handles.attenuation;

%Do Calibration Multiple Times
for cycle = 1:5
    cutoffLambda = zeros(10,nDiam)
    for j = 1:10
        error = 0;
        %Import DCM Images
        full_file_dicomread = [pathstr,name,num2str(dcmEnding(j))];
        info_dicom = dicominfo(full_file_dicomread);
        I_dicom{j} = double(dicomread(info_dicom));
%         figure
%         imshow(I_dicom{j}, [])
%         [xSel,ySel] = ginput(1);
%         close
        xSel = 2300
        ySel = 3050
        center = [round(ySel),round(xSel)];
        centerImage = I_dicom{j}(ySel-padamnt:ySel+padamnt, xSel-padamnt:xSel+padamnt);
%*********TODO%
        %Insert Noise into the DCM Images
        %Adjust so that has same average and stuff as a breast tissue
%*********TODO%

        %Calculte Test Statistics of the region
         for i = 1:nDiam
             for k = 1:nThickness
                negDisk = attenDisk(:,:,i);
                avgROI = mean2(centerImage);
                attenDisks = negDisk*((avgROI-50)'*(attenuation(k) - 1)); %Is my w=gs-gn
                imgWDisk = attenDisks+centerImage;%Is my gtest
                w = attenDisks(:);
                gTest = imgWDisk(:);
                lambda(i,k) = w'*gTest;
                biasterm(i,k) = attenDisks(:)'*attenDisks(:);
                tissueterm(i,k) = attenDisks(:)'*centerImage(:);
                shouldbeLambda(i,k) = biasterm(i,k)+tissueterm(i,k);
             end
         end
         biasterm;
         tissueterm;
         shouldbeLambda;
         lambda
        
        %Diams are rows in lambda
        %Thicknesses are columns
        for p = 1:length(cdcomDiams)
            Diam = cdcomDiams(p);
                     
            Actual_Thickness = fliplr(dcm1_5_results(rowNum, :));
            Actual_Thickness = Actual_Thickness(p);
            rownum = find(handles.diameter == Diam);
            lambdasAtDiam = lambda(rownum,:);
            tooThickInd = find(handles.thickness>=Actual_Thickness);
            if isempty(tooThickInd)
                tooThick = 2;
                lambAbove = lambdasAtDiam(1);
            else  
                tooThick = handles.thickness(tooThickInd(end));
                lambAbove = lambdasAtDiam(tooThickInd(end));
            end
            tooThinInd = find(handles.thickness<=Actual_Thickness);
            if isempty(tooThinInd)
                tooThin = 0.03;
                lambBelow = lambdasAtDiam(end);
            else  
                tooThin = handles.thickness(tooThinInd(1));
                lambBelow = lambdasAtDiam(tooThinInd(1));
            end
            
            dl = tooThick - Actual_Thickness;
            dr = tooThin - Actual_Thickness;
            dist = tooThick - tooThin;
            valTest = tooThick - (dl/(dist)*dist);
            
            distLamb = lambAbove - lambBelow ;
            LambValTest = lambAbove - (dl/(dist)*distLamb);
            cutoffLambda(j,rownum) = LambValTest;
%             pause
        end
    end
    BestLambdas(cycle,:) = mean(cutoffLambda);% (Should be row vector)
    %Need to do additional treating ot make sure I get the other sides of
    %the diameters in this equation
end
LambCutoffs = mean(BestLambdas)
Ds = handles.diameter

figure
scatter(Ds, LambCutoffs)

figure
scatter(Ds, LambCutoffs)
xlabel('Detail Diameter (mm)')
ylabel('Threshold Lambda Values(um)')
set(gca,'xscale','log')
set(gca,'yscale','log')

% % % % % % handles.thickness = [2, 1.42, 1, .71, .5, .36, .25, .2, .16, .13, .1, .08, .06, .05, .04, .03]; %um
% % % % % % handles.diameter = [2, 1.6, 1.25, 1, .8, .63, .5, .4, .31, .25, .2, .16, .13, .1, .08, .06]; %mm
% % % % % % handles.attenuation = [0.8128952,0.862070917,0.900130881,0.927690039,0.948342287,...
% % % % % %     0.962465394,0.973737644,0.978903709,0.983080655,0.986231347,0.989380904,...
% % % % % %     0.991486421,0.993610738,0.994672709,0.995734557,0.996796281];
guidata(hObject,handles);


% --- Executes on button press in DICOMDATA.
function DICOMDATA_Callback(hObject, eventdata, handles)
% hObject    handle to DICOMDATA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global magn FileName_Naming NumImageAnalyze part1 part2 shape
global levels IQF PathName_Naming FilterIndex_Naming extension cutoff
j=1;
[IDicomOrig, DICOMData] = import_image(j, FileName_Naming, PathName_Naming, FilterIndex_Naming, extension);

    bodyPartThickness= DICOMData.BodyPartThickness
    anodeTargetMaterial = DICOMData.AnodeTargetMaterial
    spacing = DICOMData.PixelSpacing(1)
    pixelAspectRatio = DICOMData.PixelAspectRatio
    KVP = DICOMData.KVP
    exposureInuAs = DICOMData.ExposureInuAs
    filterThickness = (DICOMData.FilterThicknessMinimum + DICOMData.FilterThicknessMaximum) / 2
    filterMaterial = DICOMData.FilterMaterial
    imageOrientation = DICOMData.SeriesDescription
    xRayCurrent = DICOMData.XrayTubeCurrent
    exposure = DICOMData.Exposure
    exposureTime = DICOMData.ExposureTime
    
guidata(hObject,handles);
