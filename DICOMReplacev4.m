function varargout = DICOMReplace(varargin)
% DICOMREPLACE MATLAB code for DICOMReplace.fig
%      DICOMREPLACE, by itself, creates a new DICOMREPLACE or raises the existing
%      singleton*.
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help DICOMReplace
% Last Modified by GUIDE v2.5 08-Jul-2016 11:17:05

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
global magn diameter thickness NumImageAnalyze shape
NumImageAnalyze=1;
thickness = [2, 1.42, 1, .71, .5, .36, .25, .2, .16, .13, .1, .08, .06,...
    .05, .04, .03]; %um
diameter = [50, 40, 30, 20, 10, 8, 5, 3, 2, 1.6, 1.25, 1, .8, .63, .5,...
    .4, .31, .25, .2, .16, .13, .1, .08, .06]; %mm
magn = 1;
shape = 'Round';
handles.output = hObject;
guidata(hObject, handles);

% --- NA
function varargout = DICOMReplace_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Allows you to select the number of images you want analyzed.
function NumImageImport_Callback(hObject, eventdata, handles)
%Allows you to say how many images you want to analyze
global NumImageAnalyze
NumImageAnalyze = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Allows you to select the shape of the lesion you want to insert
function ShapeSelect_Callback(hObject, eventdata, handles)
%Allows you to select a type of shape for the inserted disk
%Will be useful for making different lesion sizes
global shape
contents = cellstr(get(hObject,'String'));
shape = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Allows you to select unanalyzed files to analyze.
function SelectFile_Callback(hObject, eventdata, handles)
%Selects a certain number of files and stores the path for use later
%This will allow you to analyze these files later
global NumImageAnalyze FileName PathName FilterIndex ext
global FileName_Naming parts part1 part2 PathName_Naming FilterIndex_Naming extension
global isMultipleFiles
%%Opens up dialogue box to import a DICOM file of your choosing
[FileName,PathName,FilterIndex] = uigetfile('*.*', 'Select Multiple Files', 'MultiSelect', 'on')
%Stores filepath
NumImageAnalyze = length(FileName)
PathName_Naming = PathName
isMultipleFiles = iscellstr(FileName)
FilterIndex_Naming = FilterIndex;
if iscellstr(FileName) == 0
    [pathstr,name,ext] = fileparts([PathName,'\',FileName])
    extension{1} = ext; s=pathstr;
    parts=regexp(s,'\','split');
    parts = fliplr(parts); part1{1} = parts(3); part2{1} = parts(2);
    FileName_Naming = cell(1)
    FileName_Naming{1} = FileName
    NumImageAnalyze = 1
else
    for j = 1:NumImageAnalyze
        FileName_Naming = FileName
        [pathstr,name,ext] = fileparts([PathName,'\',FileName{j}])
        extension{j} = ext; s=pathstr;
        parts=regexp(s,'\','split');
        parts = fliplr(parts); part1{j} = parts(3); part2{j} = parts(2);
    end
end
guidata(hObject,handles);

% --- allows you to select Masking Maps (The full masking map so far..
function ImportMATs_Callback(hObject, eventdata, handles)
%Allows you to import previous data files to analyze them later on
global IQFFull
[FileName,PathName,FilterIndex] = uigetfile;
full_file_mat = [PathName,'\',FileName];
storedStructure = load(full_file_mat,'-mat');
IQFFull = (storedStructure.IQFFull(:,:,1)); 
guidata(hObject,handles);


% --- Main analyzing function -- Creates IQF maps and saves them.
function InsertDisks_Callback(hObject, eventdata, handles)
%Parameter Setting
global magn FileName_Naming NumImageAnalyze part1 part2
global levels PathName_Naming FilterIndex_Naming extension cutoffs
global diameter thickness attenuation SigmaPixels shape
for j = 1:NumImageAnalyze %Does calculation for each image that was selected
%% Pre-processing data
%Import the image & DICOMData   
tic
[IDicomOrig, DICOMData] = import_image(j, FileName_Naming,...
    PathName_Naming, FilterIndex_Naming, extension);
toc
disp('Calculating the MTF...')
tic
[SigmaPixels] = determineMTF(IDicomOrig);
toc
disp('Calculating the disk attenuations based on KVP, mAs...')
tic
[attenuation] = getSpectraAttens(DICOMData, thickness);
toc
% set guess of time to calculate
timePerImage = 20; %Min
TotalTimeRemaining = timePerImage*(NumImageAnalyze - j + 1)
pause(2)
disp('Calculating lesions of appropriate attenuations/shapes...')
pixelSpacing = DICOMData.PixelSpacing(1);
radius = ((diameter.*0.5)./(pixelSpacing*magn));
tic
[attenDisks] = circle_roi4(radius, shape, SigmaPixels);
toc
%% Doing Calculations
tic
disp('Calculating thresholds for each lesion diameter...')
% [cutoffs] = calcThresholds(IDicomOrig,attenDisks,diameter, attenuation);
toc
disp('Calculating all IQF values and IQF Maps...')
tic
% [levels, IQF] = calcTestStat5(IDicomOrig,attenuation, radius,...
%     attenDisks, thickness, diameter, cutoffs, pixelSpacing);
% cutoffs = ones(24,1)*1e-10
[levels, IQF] = calcTestStat7(IDicomOrig,attenuation, radius,...
    attenDisks, thickness, diameter, cutoffs, pixelSpacing);
toc
disp('Performing Exponential fit on the C/D Curves...')
tic
[aMat, bMat, RSquare] = PerformExpFit(levels, pixelSpacing, diameter);
toc
pause
%% Calculate Statistics that are relevant to test
% mean, stdev, sum, entropy, kurtosis, skewness, 5th percentile, 25th
% percentile, 75th percentile, 95th percentile, GLCM Contrast, GLCM
% correlation, GLCM Energy, (All for full, small, med, large)
% GLCM Homogeneity, BIRADS, VBD
disp('Calculating the statistics of the IQF levels...')
A1 = char(part1{j});
A2 = char(part2{j});
A3 = char(FileName_Naming{j});

aMatVector = aMat(:);
aMatVectorNoZeros = aMatVector(aMatVector~=0);
aVals = aMatVectorNoZeros;
bMatVector = bMat(:);
bMatVectorNoZeros = bMatVector(bMatVector~=0);
bVals = bMatVectorNoZeros;

stats.imgA.Mean = mean(aVals);
stats.imgA.Median = median(aVals); 
stats.imgA.Sum = sum(aVals); 
stats.imgA.Pctile10 = prctile(aVals,10);
stats.imgA.Pctile25 = prctile(aVals,25); 
stats.imgA.Pctile75 = prctile(aVals,75);
stats.imgA.Pctile90 = prctile(aVals,90);
stats.imgB.Mean = mean(bVals);
stats.imgB.Median = median(bVals); 
stats.imgB.Sum = sum(bVals); 
stats.imgB.Pctile10 = prctile(bVals,10); 
stats.imgB.Pctile25 = prctile(bVals,25);
stats.imgB.Pctile75 = prctile(bVals,75); 
stats.imgB.Pctile90 = prctile(bVals,90); 

%1 = full, 2=small, 3=medium, 4=large
names = {'Full', 'Small', 'Medium','Large'};
for y = 1:4
    if y==1; img = IQF.Full;
    elseif y==2; img = IQF.Small;
    elseif y==3; img = IQF.Med;
    elseif y==4; img = IQF.Large;
    end
    imgVector = img(:);
    imgVectorNoZeros = imgVector(imgVector~=0);
    IQFvals = imgVectorNoZeros;
    imgMean = mean(IQFvals); stats.(names{y}).Mean = imgMean;
    imgMedian = median(IQFvals); stats.(names{y}).Median = imgMedian;
    imgStDev = std(IQFvals); stats.(names{y}).StDev = imgStDev;
    imgSum = sum(IQFvals); stats.(names{y}).Sum = imgSum;
    imgEntropy = entropy(IQFvals); stats.(names{y}).Entropy = imgEntropy;
    imgKurtosis = kurtosis(IQFvals); stats.(names{y}).Kurtosis = imgKurtosis;
    imgSkewness = skewness(IQFvals); stats.(names{y}).Skewness = imgSkewness;
    img10thPercentile = prctile(IQFvals,10); stats.(names{y}).Pctile10 = img10thPercentile;
    img25thPercentile = prctile(IQFvals,25); stats.(names{y}).Pctile25 = img25thPercentile;
    img75thPercentile = prctile(IQFvals,75); stats.(names{y}).Pctile75 = img75thPercentile;
    img90thPercentile = prctile(IQFvals,90); stats.(names{y}).Pctile90 = img90thPercentile;
    %Calculate GLCM
    numBins = 64;
    glcm = graycomatrix(IQF.Full, 'NumLevels',numBins, 'GrayLimits', []);
    statsGLCM = graycoprops(glcm);
    imgGLCMContrast = statsGLCM.Contrast; stats.(names{y}).GLCMContrast = imgGLCMContrast;
    imgGLCMCorrelation = statsGLCM.Correlation; stats.(names{y}).GLCMCorr = imgGLCMCorrelation;
    imgGLCMEnergy = statsGLCM.Energy; stats.(names{y}).GLCMEnergy = imgGLCMEnergy;
    imgGLCMHomogeneity = statsGLCM.Homogeneity; stats.(names{y}).GLCMHomog = imgGLCMHomogeneity;
end

stats.DICOMData.KVP = DICOMData.KVP;
stats.DICOMData.AnodeTargetMat = DICOMData.AnodeTargetMaterial;
stats.DICOMData.Spacing = DICOMData.PixelSpacing(1);
stats.DICOMData.ExposureuAs = DICOMData.ExposureInuAs;
stats.DICOMData.Position = DICOMData.ViewPosition;
stats.DICOMData.XRayCurrent = DICOMData.XrayTubeCurrent;
stats.DICOMData.ImageOrientation = DICOMData.SeriesDescription;
stats.DICOMData.FilterMaterial = DICOMData.FilterMaterial;
stats.DICOMData.FilterThickness = (DICOMData.FilterThicknessMinimum + DICOMData.FilterThicknessMaximum) / 2; 

stats.Data.Thresholds = cutoffs;
stats.Data.MTFSigmaPixels = SigmaPixels;
stats.Data.Attenuations = attenuation;

%% Export images/data as .mats
disp('Saving all Data...')

A4 = 'GeneratedStatistics';
A5 = '.mat';
formatSpec = '%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A2,A3, A4, A5)
save(fileForSaving, 'stats')
%Save the DICOMData
DICOMData.ScanNumber = char(FileName_Naming{j});
DICOMData.Study = char(part1{j});
DICOMData.Patient = char(part2{j});
A4 = 'DICOMData';
A5 = '.mat';
formatSpec = '%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A2,A3,A4, A5)
save(fileForSaving, 'DICOMData')

A1 = char(part1{j}); A2 = char(part2{j});
A3 = char(FileName_Naming{j}); A4 = 'ThicknessEachDiam';
A6 = '.mat';
formatSpec = '%s_%s_%s%s';
fileForSaving = sprintf(formatSpec,A2,A3,  A4, A6)
save(fileForSaving, 'levels') %Large file before processing it
A4_2 = 'IQFAllDisks';
IQFFull = IQF.Full;
fileForSaving = sprintf(formatSpec,A2,A3,  A4_2,  A6)
save(fileForSaving, 'IQFFull') %IQF Image
A4_3 = 'IQFSmallDisks';
IQFSmall = IQF.Small;
fileForSaving = sprintf(formatSpec,A2,A3,A4_3,  A6)
save(fileForSaving, 'IQFSmall') %IQF Image of small disks
A4_4 = 'IQFMediumDisks';
IQFMed = IQF.Med;
fileForSaving = sprintf(formatSpec,A2,A3, A4_4, A6)
save(fileForSaving, 'IQFMed') % IQF Image of medium disks
A4_5 = 'IQFLargeDisks';
IQFLarge = IQF.Large;
fileForSaving = sprintf(formatSpec,A2,A3, A4_5, A6)
save(fileForSaving, 'IQFLarge') % IQF Image of large disks
A4_6 = 'A_ValueOfFit';
fileForSaving = sprintf(formatSpec,A2,A3, A4_6, A6)
save(fileForSaving, 'aMat')% a value from exponential fit at each point
A4_7 = 'B_ValueOfFit';
fileForSaving = sprintf(formatSpec,A2,A3, A4_7, A6)
save(fileForSaving, 'bMat')% b value from exponential fit at each point
A4_8 = 'RSquareOfFit';
fileForSaving = sprintf(formatSpec,A2,A3, A4_8, A6)
save(fileForSaving, 'RSquare')% r^2 value from exp fit at each point
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
[SigmaPixels] = determineMTF(IDicomOrig);
[attenuation] = getSpectraAttens(DICOMData, thickness);
% Calculate the blurred disks and store them
radius = ((diameter.*0.5)./(pixelSpacing*magn));
[attenDisks] = circle_roi4(radius, shape, SigmaPixels);
[cutoffs] = calcThresholds(IDicomOrig,attenDisks,diameter, attenuation);
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
   
% --- Executes during object creation, after setting all properties.
function NumImageImport_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Plot_IsoContour.
function Plot_IsoContour_Callback(hObject, eventdata, handles)
global IQFFull
imageArray = flipud(IQFFull);
contourSizes = [0, 1 , 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24];
figure
contourf(imageArray, contourSizes)
% colormap(gray)
colorbar
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

% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global magn FileName_Naming NumImageAnalyze part1 part2
global levels PathName_Naming FilterIndex_Naming extension cutoffs
global diameter thickness attenuation SigmaPixels shape
j = 1 %Does calculation for each image that was selected
%% Pre-processing data
%Import the image & DICOMData    
[IDicomOrig, DICOMData] = import_image(j, FileName_Naming,...
    PathName_Naming, FilterIndex_Naming, extension);



%Take out the phantom
maskingMap = IDicomOrig;
maskingMap= maskingMap./max(maskingMap(:));
maskingMap1 = im2bw(maskingMap,0.20);
maskingMap1 = imcomplement(maskingMap1);

[labeledImage, numberOfBlobs] = bwlabel(maskingMap1);
blobMeasurements = regionprops(labeledImage, 'area', 'Centroid');
allAreas = [blobMeasurements.Area]; numToExtract = 1;

[sortedAreas, sortIndexes] = sort(allAreas, 'descend');
biggestBlob = ismember(labeledImage, sortIndexes(1:numToExtract));
% Convert from integer labeled image into binary (logical) image.
maskingMap1 = biggestBlob > 0; maxArea = max(sortedAreas);
maskingMap1(1,:) = 0; maskingMap1(:,1) = 0;
maskingMap1(end,:) = 0; maskingMap1(:,end) = 0;

IDicomOrig = IDicomOrig .* maskingMap1;
%Erode the image
se = strel('disk',5,6);
count = 1; trigger = 0;
while trigger == 0
maskingMap1 = imerode(maskingMap1,se);
IDicomOrig = IDicomOrig .* maskingMap1;
IDicomVector = IDicomOrig(:);
IDicomVectorNoZeros =IDicomVector(IDicomVector~=0);
reducedArea = length(IDicomVectorNoZeros);
if reducedArea/maxArea <=0.5
    trigger=1;
end
IDicomAvg = mean(IDicomVectorNoZeros);
IDicomStdev = std(IDicomVectorNoZeros);
end
%See how far it's been eroded
figure
imshow(IDicomOrig,[])

IDicomOrig(all(IDicomOrig==0,2),:)=[];
IDicomOrig(:,all(IDicomOrig==0,1))=[];
figure
imshow(IDicomOrig,[])

im = IDicomOrig;
LargestInscribedImage(im)




pause




% 
% [labeledImage, numberOfBlobs] = bwlabel(maskingMap1);
% blobMeasurements = regionprops(labeledImage, 'area', 'Centroid', 'BoundedBox', 'FilledImage');
% allAreas = [blobMeasurements.Area]; numToExtract = 1;
% 
% %Find way to get only the nonzero section
% something like the bounded box
% or filledimage
% %And then erode from the top,L/R, bot, in order to get rid of all zero
% %values.
% 
% Or... Delete any row / column that is all zero... because then I would have my bounding box
%     
% or any row column that contains a zero
out1 = IDicomOrig(all(IDicomOrig,2),:);
figure
imshow(out1,[])
out2 = out1(all(out1,1),:); % Probably for columns. 
figure
imshow(out2, [])
%Then take FFT of this, and then turn to 2d and then find slope. 


%In this....
%Take image, erode it, Take FFT of it... that is my NPS

%average that NPS to a 1D NPS

guidata(hObject,handles);



% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


guidata(hObject,handles);
