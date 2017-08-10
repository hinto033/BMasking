%% Define Geog Information  

disp('Importing the image and defining geometry...'); tic

%% ID Projection Directory: DONE

projectionDir = 'Z:\Breast Studies\UCSF-GE Collaboration\GE_reconstruction\Phantom_scans\Projections_QAphantom\'

%% Import Tomo Projections %DONE
tic
for imNum = 1:9
fileName = sprintf('E193S494I%0.0f.DCM', imNum)
full_file_dicomread = strcat(projectionDir,fileName);
DICOMData{imNum} = dicominfo(full_file_dicomread);
projImg{imNum} = double(dicomread(DICOMData{imNum}));
end
toc
%% Identify Lesion Location and Geometry DONE

figure
imshow(projImg{imNum},[])
[x, y] = getpts;
x=round(x);
y=round(y);
close(figure)

lesHeight = input('Enter the desired lesion Height in mm: ')
mmPerPx = DICOMData{1}.ImagerPixelSpacing(1);
lesHeightPx = lesHeight.*(1/mmPerPx); %Px


tumorSizePx = [100, 200, 100] %In Px


%% Identify Shift in Lesion at each Proj - NOT DONE

%NOT DONE: Currently Ignores Y effects, only does x-shift
%Create the insertions of the Object

%TO DO:
%Calculate Thickness Map in Each Projection from Lesion Geometry
%Calculate additional attenuation from that
%Add that in at each projection


for imNum = 1:9
    projAngle = DICOMData{imNum}.DetectorSecondaryAngle;
    %Doesn't calculate Y adjustment
    lesAdj(imNum,:) = [lesHeightPx*tand(projAngle),0] 
end



%Calculate Thickness map
for imNum = 1:9
    
    projAngle = DICOMData{imNum}.DetectorSecondaryAngle;   
    
    % method 2: fill a ellipse and add its volume elements:
    xv = linspace(-1,1,150);
    [xx yy zz]=meshgrid(xv,xv,xv);
    rr = sqrt(xx.^2 + 2.5*yy.^2 + 1.5*zz.^2);
    vol = zeros(numel(xv)*[1 1 1]);
    vol(rr<1)=1;
    
    thetaS = projAngle
    R = [cosd(thetaS),0,sind(thetaS), 0;
        0 ,1 ,0, 0;
        -sind(thetaS),0 ,cosd(thetaS), 0;
        0 0 0 1] %Rotation around y axis
    tform = affine3d(R)
    volR = imwarp(vol,tform);
 
    
%     projz = sum(volR,3);
%     subplot(1,3,1)
%     imagesc(projz); axis image; axis off; colormap gray
%     title 'projection of volume'
    projy = squeeze(sum(volR,2));
%     subplot(1,3,2)
%     imagesc(projy); axis image; axis off; colormap gray
%     title 'projection of volume'
%     projx = squeeze(sum(volR,1));
%     subplot(1,3,3)
%     imagesc(projx); axis image; axis off; colormap gray
%     title 'projection of volume'
%     
%     pause(1)
    
    
%NEED TO account for the fact that the change in size of the box affects
%the insertion

    actProjIns = projy*1000
    [nR, nC] = size(actProjIns)
    %Rotate by a certain amount.
%     figure
%     imshow(actProjIns,[])
%     
%     %Need Ray Tracing Program to calculate thickness Map at each proj.
%     
%     
%     %Doesn't calculate Y adjustment
%     lesAdj(imNum,:) = [lesHeightPx*tand(projAngle),0] 
%     
%     %Currently only inserts in right geographic location, not right
%     %attenuation 
    imWObj{imNum} = projImg{imNum};
    imWObj{imNum}(y+round(lesAdj(imNum,1)):y+round(nR)+round(lesAdj(imNum,1))-1,x:x+round(nC)-1)...
        = actProjIns + imWObj{imNum}(y+round(lesAdj(imNum,1)):y+round(nR)+round(lesAdj(imNum,1))-1,x:x+round(nC)-1);
% 
    imshow(imWObj{imNum}, [])
    pause(1)
end





%%


%Calculate Thickness map
for imNum = 1:9
    
    projAngle = DICOMData{imNum}.DetectorSecondaryAngle;   
    
    % method 2: fill a ellipse and add its volume elements:
    xv = linspace(-1,1,150);
    [xx yy zz]=meshgrid(xv,xv,xv);
    rr = sqrt(xx.^2 + 2.5*yy.^2 + 1.5*zz.^2);
    vol = zeros(numel(xv)*[1 1 1]);
    vol(rr<1)=1;
    projImg = sum(vol,3);
    figure
    subplot(1,3,1)
    imagesc(projImg); axis image; axis off; colormap gray
    title 'projection of volume'
    projImg = squeeze(sum(vol,2));
    subplot(1,3,2)
    imagesc(projImg); axis image; axis off; colormap gray
    title 'projection of volume'
    projImg = squeeze(sum(vol,1));
    subplot(1,3,3)
    imagesc(projImg); axis image; axis off; colormap gray
    title 'projection of volume'
    
    thetaS = 25 + projAngle
    R = [cosd(thetaS),0,sind(thetaS), 0;
        0 ,1 ,0, 0;
        -sind(thetaS),0 ,cosd(thetaS), 0;
        0 0 0 1] %Rotation around y axis
    tform = affine3d(R)
    volR = imwarp(vol,tform);
    
    figure
    projImg = sum(volR,3);
    subplot(1,3,1)
    imagesc(projImg); axis image; axis off; colormap gray
    title 'projection of volume'
    projImg = squeeze(sum(volR,2));
    subplot(1,3,2)
    imagesc(projImg); axis image; axis off; colormap gray
    title 'projection of volume'
    projImg = squeeze(sum(volR,1));
    subplot(1,3,3)
    imagesc(projImg); axis image; axis off; colormap gray
    title 'projection of volume'
    
    pause(1)
    
    %Rotate by a certain amount.
    
    
    
%     vol = zeros(numel(xv)*[1 1 1]);
%     vol(ellipsoid(0,0,0,5.9,3.25,3.25,30)<1)=1;
%     [x, y, z] = ellipsoid(0,0,0,5.9,3.25,3.25,30);
%     
%     %Need Ray Tracing Program to calculate thickness Map at each proj.
%     
%     
%     %Doesn't calculate Y adjustment
%     lesAdj(imNum,:) = [lesHeightPx*tand(projAngle),0] 
%     
%     %Currently only inserts in right geographic location, not right
%     %attenuation 
%     imWObj{imNum} = proj{imNum};
%     imWObj{imNum}(y-100+lesAdj(imNum,1):y+100+lesAdj(imNum,1),x-50:x+50) = 10000;
% 
%     imshow(imWObj{imNum}, [])
%     pause(3)
end
%% 
    
    %% method 2: fill a sphere and add its volume elements:
    xv = linspace(-1,1,100);
    [xx yy zz]=meshgrid(xv,xv,xv);
    rr = sqrt(xx.^2 + yy.^2 + zz.^2);
    vol = zeros(numel(xv)*[1 1 1]);
    vol(rr<1)=1;
    projImg = sum(vol,3);
    subplot(1,3,2)
    imagesc(projImg); axis image; axis off; colormap gray
    title 'projection of volume'
    
    %% method 2: fill a rectangle and add its volume elements:
    xv = linspace(-1,1,100);
    [xx yy zz]=meshgrid(xv,xv,xv);
    rr = sqrt(xx.^2 + yy.^2 + zz.^2);
    vol = zeros(numel(xv)*[1 1 1]);
    vol(xx.^2<.5)=1;
    vol(yy.^2<.25)=1;
    vol(zz.^2<.25)=1;
    projImg = sum(vol,3);
    subplot(1,3,1)
    imagesc(projImg); axis image; axis off; colormap gray
    title 'projection of volume'
    projImg = squeeze(sum(vol,2));
    subplot(1,3,2)
    imagesc(projImg); axis image; axis off; colormap gray
    title 'projection of volume'
    projImg = squeeze(sum(vol,1));
    subplot(1,3,3)
    imagesc(projImg); axis image; axis off; colormap gray
    title 'projection of volume'



%Calculate Attenuation and Add
for imNum = 1:9
    
    projAngle = DICOMData{imNum}.DetectorSecondaryAngle;
    
    %Doesn't calculate Y adjustment
    lesAdj(imNum,:) = [lesHeightPx*tand(projAngle),0] 
    
    %Currently only inserts in right geographic location, not right
    %attenuation 
    imWObj{imNum} = projImg{imNum};
    imWObj{imNum}(y-100+lesAdj(imNum,1):y+100+lesAdj(imNum,1),x-50:x+50) = 10000;

    imshow(imWObj{imNum}, [])
    pause(3)
end

%Display
for imNum = 1:9
    
    projAngle = DICOMData{imNum}.DetectorSecondaryAngle;
    
    %Doesn't calculate Y adjustment
    lesAdj(imNum,:) = [lesHeightPx*tand(projAngle),0] 
    
    %Currently only inserts in right geographic location, not right
    %attenuation 
    imWObj{imNum} = projImg{imNum};
    imWObj{imNum}(y-100+lesAdj(imNum,1):y+100+lesAdj(imNum,1),x-50:x+50) = 10000;

    imshow(imWObj{imNum}, [])
    pause(3)
end




%% 







projAngle(1,imNum) = DICOMData{imNum}.DetectorSecondaryAngle
distDetector(imNum) = DICOMData{imNum}.DistanceSourceToDetector
distPatient(imNum) = DICOMData{imNum}.DistanceSourceToPatient
partThickness(imNum) = DICOMData{imNum}.BodyPartThickness





imshow(projImg, [0,5000])
pause(2)
drawnow



figure
imshow(projImg, [])

%RelevantDicomData
KVP = DICOMData.KVP
DistanceSourceToDetector
DistanceSourceToPatient
EstimatedRadiographicMagnificationFactor
XrayTubeCurrent
ExposureTime
FieldOfViewDimensions
BodyPartThickness
FocalSpot
FilterType
ImagerPixelSpacing
DetectorSecondaryAngle
PositionerPrimaryAngle
CompressionForce
CollimatorRightVerticalEdge
CollimatorLowerHorizontalEdge
CollimatorUpperHorizontalEdge
CollimatorLeftVerticalEdge
ImagesInAcquisition
DistanceSourceToEntrance
PixelIntensityRelationship
BitDepth
FieldOfViewShape

AnodeTargetMaterial
ViewPosition
% Import Tomo imaging geometry

% Calculate Tube Position at each projection angle


% Define object geometry/shape

% Define object position/orientation in space

% Define Object material

t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)


%% Ray Trace & Spectrum simulation 
disp('Importing the image...'); tic

% Calculate object thickness for each projection via ray tracing
    % Forward projection for all psoitions
    
% Calculate Linear attenuation coefficient from Boone et al for all projs


% Correct for Beam Hardening

t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)


%% Resolution Modification
disp('Importing the image...'); tic

% Define/Lookup/Calculate the MTF

% Multiply MTF by template for each proj angle.


t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)


%% Scatter and Noise
disp('Importing the image...'); tic

% Lookup the Scatter to primary ratio for each angle from sechopoulous et
% al


% Calculate scatter fraction from SPR

t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)


%% Insertion 

disp('Importing the image...'); tic

%Estimate Primary Component (Subtract scatter offset)

% perform insertion (as in shaheen et al)


t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)


%% Reconstruction
disp('Importing the image...'); tic

%FBP algorithm

t = toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)