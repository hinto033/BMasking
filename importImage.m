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
%****
%     full_file_png = [pathname,'\',FileName]
    full_file_png = strcat(pathname,'\',FileName)
    full_file_png = full_file_png{1}
%****
    IDicomOrig = imread(full_file_png); 
    IDicomOrig = im2double(IDicomOrig);
    pathname;
    [base,rem]=strtok(FileName,'.');
    DICOMInfoName = strcat(base, '.mat');
    full_file_DICOMInfo = char(strcat(pathname,'\',DICOMInfoName));
    class(full_file_DICOMInfo);
    %****
%     DICOMDataFull = load(full_file_DICOMInfo, '-mat');
    DICOMDataFull = load(full_file_DICOMInfo ,'-mat');
    %****
    DICOMData = DICOMDataFull.info_dicom_blinded;
    [nRows, nCols] = size(IDicomOrig);
    
   
    if class(DICOMData.Rows) == 'uint16'
    imgRows = im2double(DICOMData.Rows, 'indexed') - 1;
    else 
        imgRows = DICOMData.Rows;
    end
    if class(DICOMData.Columns) == 'uint16'
    imgCols = im2double(DICOMData.Columns, 'indexed') - 1;
    else
        imgCols = DICOMData.Columns;
    end
%     pause
    
    
    DICOMData.PixelSpacing(1) = DICOMData.PixelSpacing(1)*(imgRows/nRows);
    DICOMData.PixelSpacing(2) = DICOMData.PixelSpacing(2)*(imgCols/nCols);

DICOMData.PixelSpacing(1);
DICOMData.PixelSpacing(2);


    IDicomOrig = IDicomOrig.*(2^16-1);

    
    
else
    errmsg = 'Imported wrong type of file: Import a DICOM file';
    error(errmsg)
end
%Remove blank top rows (Important for padding)
IDicomOrig(all(IDicomOrig>10000,2),:)=[];

% figure
% imshow(IDicomOrig, [])
% pause

end