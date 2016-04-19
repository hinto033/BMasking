function [IDicomOrig, spacing] = import_image(j, FileNameNaming, PathNameNaming, FilterIndexNaming, extension)

    handles.filename = FileNameNaming{j};
    handles.pathname = PathNameNaming{j};
    handles.filterIndex = FilterIndexNaming{j};
    handles.fullpath = [handles.pathname,'\',handles.filename];
    ext = extension{j}
FileName = handles.filename;   %'DCM2';
if (strcmp(ext, '') || strcmp(ext, '.dcm') || strcmp(ext, '.DCM') )
    k = 'DCM import'
    %***************ALSO SHOULD GET DICOM INFO IN HERE***************%
    % Creating image files of DICOM Image
    %Imports the .png file associated with the DICOM
    fullFilePng = [handles.pathname,'\',FileName];
    % I  = double(imread(full_file_png));
    full_file_dicomread = [handles.pathname,'\',FileName];
    info_dicom = dicominfo(full_file_dicomread); %uncomment for dicom
    %Reads the DICOM file into the system
    IDicom = double(dicomread(info_dicom));
    IDicomOrig =  IDicom; %Stores as original image
    % I = -log(I/12314)*10000; 
    %% Define scaling factor, etc. 
    handles.bodyPartThickness = info_dicom.BodyPartThickness;
    handles.anodeTargetMaterial = info_dicom.AnodeTargetMaterial;
    handles.pixelSpacing = info_dicom.PixelSpacing;
    spacing = handles.pixelSpacing;
    handles.pixelAspectRatio = info_dicom.PixelAspectRatio;
    handles.KVP = info_dicom.KVP;
    handles.exposureInuAs = info_dicom.ExposureInuAs;
elseif (strcmp(ext, '.png'))
    %Importing Breast Images if .png
    k = 'png import'
    FileName = handles.filename;   %'DCM2';

    % Creating image files of DICOM Image
    %Imports the .png file associated with the DICOM
    fullFilePng = [handles.pathname,'\',FileName];
    I  = double(imread(fullFilePng));
    % % % full_file_dicomread = [handles.pathname,'\',FileName];
    % % % info_dicom = dicominfo(full_file_dicomread); %uncomment for dicom
    %Reads the DICOM file into the system
    spacing = 0.07
    % I_dicom = double(dicomread(info_dicom));
    % I_dicom_orig =  I_dicom; %Stores as original image

    IDicom = I;
    IDicomOrig = I;
    % I = -log(I/12314)*10000; 
else
    errmsg = 'Imported wrong type of file: Import a .png or DICOM file'
    error(errmsg)
end


global shape
shape = 'Round';