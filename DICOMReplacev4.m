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
global shape
handles.output = hObject;
guidata(hObject, handles);

% --- NA
function varargout = DICOMReplace_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

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
%%Opens up dialogue box to import a DICOM file of your choosing
[FileName,PathName,FilterIndex] = uigetfile('*.*', 'Select Multiple Files', 'MultiSelect', 'on');
%Stores filepath
NumImageAnalyze = length(FileName);
PathName_Naming = PathName;
FilterIndex_Naming = FilterIndex;
if iscellstr(FileName) == 0
    [pathstr,name,ext] = fileparts([PathName,'\',FileName]);
    extension{1} = ext; s=pathstr;
    parts=regexp(s,'\','split');
    parts = fliplr(parts); part1{1} = parts(3); part2{1} = parts(2);
    FileName_Naming = cell(1);
    FileName_Naming{1} = FileName;
    NumImageAnalyze = 1;
else
    for j = 1:NumImageAnalyze
        FileName_Naming = FileName;
        [pathstr,name,ext] = fileparts([PathName,'\',FileName{j}]);
        extension{j} = ext; s=pathstr;
        parts=regexp(s,'\','split');
        parts = fliplr(parts); part1{j} = parts(3); part2{j} = parts(2);
    end
end
guidata(hObject,handles);

% --- Main analyzing function -- Creates IQF maps and saves them.
function InsertDisks_Callback(hObject, eventdata, handles)
%Parameter Setting
global FileName_Naming NumImageAnalyze part1 part2
global PathName_Naming FilterIndex_Naming extension shape
thickness = [2, 1.42, 1, .71, .5, .36, .25, .2, .16, .13, .1, .08, .06,...
    .05, .04, .03]; %um
diameter = [50, 40, 30, 20, 10, 8, 5, 3, 2, 1.6, 1.25, 1, .8, .63, .5,...
    .4, .31, .25, .2, .16, .13, .1, .08, .06]; %mm
for j = 1:NumImageAnalyze %Does calculation for each image that was selected
%% Import the image & DICOMData   
timePerImage = 7; %Min
TotalTimeRemaining = timePerImage*(NumImageAnalyze - j + 1);
str = sprintf('time remaining: %0.2f minutes', TotalTimeRemaining); disp(str)
disp('Importing the image...'); tic
[IDicomOrig, DICOMData] = importImage(j, FileName_Naming,...
    PathName_Naming, FilterIndex_Naming, extension);
t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
%% Pre-processing data
disp('Calculating the MTF...'); tic
[SigmaPixels, errFlags] = determineMTF(IDicomOrig);
t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
disp('Calculating the disk attenuations based on KVP, mAs...'); tic
[attenuation, errFlags] = getSpectraAttens(DICOMData, thickness, errFlags);
t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
%% Calculate the disk attenuations
disp('Calculating lesions of appropriate attenuations/shapes...'); tic
pixelSpacing = DICOMData.PixelSpacing(1);
radius = ((diameter.*0.5)./(pixelSpacing));
[attenDisks, errFlags] = createLesionShape(radius, shape, SigmaPixels, errFlags);
t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
%% Remove the phantom itself
disp('Removing the phantom and unnecessary artifacts...'); tic
[maskingMap1, IDicomOrig, maxArea] = removePhantom(IDicomOrig);
t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
binaryOutline = maskingMap1;
%% Remove excess material
disp('Removing the outer Breast edge and Muscle...'); tic
[maskingMap1] = erodeUnecessaryEdges(maskingMap1, maxArea);
IDicomEroded = IDicomOrig .* maskingMap1; IDicomVector = IDicomEroded(:);
IDicomVectorNoZeros =IDicomVector(IDicomVector~=0);
IDicomAvg = mean(IDicomVectorNoZeros);
IDicomStdev = std(IDicomVectorNoZeros);
t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
%% Calculate the beta value (Used for thresholding)
disp('Calculating Beta Value...'); tic
PatchSize = 256;
[beta, errFlags] = deriveBeta(IDicomEroded, pixelSpacing, PatchSize, errFlags);
t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
%% Doing Calculations
disp('Calculating thresholds for each lesion diameter...');tic
[cutoffs] = calcThresholds(IDicomAvg,IDicomStdev,attenDisks,...
    diameter, attenuation,beta);
t = toc; str = sprintf('time elapsed: %0.2f', t); disp(str)
disp('Calculating all IQF values and IQF Maps (~5 mins)...'); tic
[IQF, aMat, bMat, RSquare, errFlags] = calcIQFData(IDicomOrig,attenuation, radius,...
    attenDisks, thickness, diameter, cutoffs, pixelSpacing,binaryOutline, errFlags);
t = toc; str = sprintf('time elapsed: %0.2f', t); disp(str)
%% Calculate Statistics that are relevant to test
saveIQFData(aMat, bMat, IQF,DICOMData,cutoffs,SigmaPixels,attenuation,...
    part1, part2, FileName_Naming, beta, RSquare, j, errFlags);
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


% --- allows you to select Masking Maps (The full masking map so far..
function ImportMATs_Callback(hObject, eventdata, handles)
%Allows you to import previous data files to analyze them later on
global SelectedData multipleImagesYesNo FileName_Naming IQFSizeType
[FileName,PathName,FilterIndex] = uigetfile('*.*', 'Select Multiple Files', 'MultiSelect', 'on');
%Stores filepath
disp('Importing the .mat file(s)...')
tic
NumImageAnalyze = length(FileName);
PathName_Naming = PathName;
FilterIndex_Naming = FilterIndex;
% clear SelectedData
if iscellstr(FileName) == 0
    [pathstr,name,ext] = fileparts([PathName,'\',FileName]);
    extension{1} = ext; s=pathstr;
    parts=regexp(s,'\','split');
    parts = fliplr(parts); part1{1} = parts(3); part2{1} = parts(2);
    FileName_Naming = cell(1);
    FileName_Naming{1} = FileName;
    NumImageAnalyze = 1;
    full_file_mat = [PathName,'\',FileName];
    SelectedData = load(full_file_mat,'-mat')
    multipleImagesYesNo = 0;
    splitUp=regexp(FileName_Naming{1},'_','split');
    IQFSizeType = splitUp{3};
    IQFSizeType = IQFSizeType(1:end-9);
elseif iscellstr(FileName) == 1
    SelectedData = cell(1,NumImageAnalyze);
    IQFSizeType = cell(1,NumImageAnalyze);
    for j = 1:NumImageAnalyze
        imageNum{j} = j;
        FileName_Naming = FileName;
        [pathstr,name,ext] = fileparts([PathName,'\',FileName{j}]);
        extension{j} = ext; s=pathstr;
        parts=regexp(s,'\','split');
        parts = fliplr(parts); part1{j} = parts(3);
        part2{j} = parts(2);
        full_file_mat = [PathName,'\',FileName{j}];
        SelectedData{j} = load(full_file_mat,'-mat');
        multipleImagesYesNo = 1;
        splitUp=regexp(FileName_Naming{j},'_','split');
        IQFSizeType{j} = splitUp{3};
        IQFSizeType{j} = IQFSizeType{j}(1:end-9);
    end
end
toc
disp('Finished and ready to plot.')
guidata(hObject,handles);

% --- Executes on button press in Plot_IsoContour.
function Plot_IsoContour_Callback(hObject, eventdata, handles)
global SelectedData multipleImagesYesNo IQFSizeType
disp('Working on plotting the isocontour image(s)...')
if multipleImagesYesNo == 0
    figure
    imageArray = SelectedData.(IQFSizeType);
    imageArray = flipud(imageArray);
    contourSizes = [0, 1 , 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24];
    contourf(imageArray, contourSizes)
    % colormap(gray)
    colorbar
    title(IQFSizeType)
else
    for j = 1:length(IQFSizeType)
    figure
    imageArray = SelectedData{j}.(IQFSizeType{j});
    imageArray = flipud(imageArray);
    contourSizes = [0, 1 , 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24];
    contourf(imageArray, contourSizes)
    % colormap(gray)
    colorbar
    title(IQFSizeType{j})
    end
end
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
global FileName_Naming NumImageAnalyze part1 part2
global PathName_Naming FilterIndex_Naming extension shape
thickness = [2, 1.42, 1, .71, .5, .36, .25, .2, .16, .13, .1, .08, .06,...
    .05, .04, .03]; %um
diameter = [50, 40, 30, 20, 10, 8, 5, 3, 2, 1.6, 1.25, 1, .8, .63, .5,...
    .4, .31, .25, .2, .16, .13, .1, .08, .06]; %mm
j = 1
%% Import the image & DICOMData   
timePerImage = 7; %Min
TotalTimeRemaining = timePerImage*(NumImageAnalyze - j + 1);
str = sprintf('time remaining: %0.2f minutes', TotalTimeRemaining); disp(str)
disp('Importing the image...'); tic
[IDicomOrig, DICOMData] = import_image(j, FileName_Naming,...
    PathName_Naming, FilterIndex_Naming, extension);
t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
%% Pre-processing data
disp('Calculating the MTF...'); tic
[SigmaPixels] = determineMTF(IDicomOrig);
t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
disp('Calculating the disk attenuations based on KVP, mAs...'); tic
[attenuation] = getSpectraAttens(DICOMData, thickness);
t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
%% Calculate the disk attenuations
disp('Calculating lesions of appropriate attenuations/shapes...'); tic
pixelSpacing = DICOMData.PixelSpacing(1);
radius = ((diameter.*0.5)./(pixelSpacing));
[attenDisks] = circle_roi4(radius, shape, SigmaPixels);
t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
%% Remove the phantom itself
disp('Removing the phantom and unnecessary artifacts...'); tic
[maskingMap1, IDicomOrig, maxArea] = removePhantom(IDicomOrig);
t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
figure; imshow(IDicomOrig, []);
[xSel,ySel] = ginput(1); close; 
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

% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


guidata(hObject,handles);
