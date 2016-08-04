function [IDicomOrig, DICOMData] = importImage(j, FileNameNaming, PathNameNaming, extension)
    pathname = PathNameNaming;
    ext = extension{j};
    FileName = FileNameNaming{j};
if (strcmp(ext, '') || strcmp(ext, '.dcm') || strcmp(ext, '.DCM') )
    full_file_dicomread = [pathname,'\',FileName];
    info_dicom = dicominfo(full_file_dicomread);
    IDicomOrig = double(dicomread(info_dicom)); 
    DICOMData = info_dicom;
elseif (strcmp(ext, '.png'))
    % Importing Breast Images if .png
    errmsg = 'Imported wrong type of file: Import a DICOM file';
    error(errmsg) 
    % fullFilePng = [handles.pathname,'\',FileName];
    % IDicomOrig  = double(imread(fullFilePng));
else
    errmsg = 'Imported wrong type of file: Import a DICOM file';
    error(errmsg)
end
%Remove blank top rows (Important for padding)
IDicomOrig(all(IDicomOrig>10000,2),:)=[];
end