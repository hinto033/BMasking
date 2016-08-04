function [binaryNoPhantom, IDicomOrig, maxArea] = removePhantom(IDicomOrig)
%% Create masking map from simple threshold
OGImage = IDicomOrig;
OGImage= OGImage./max(OGImage(:));
initialThreshold = im2bw(OGImage,0.20);
initialThreshold = imcomplement(initialThreshold);
%% characterize number of individual blobs
[labeledImage, numberOfBlobs] = bwlabel(initialThreshold);
blobMeasurements = regionprops(labeledImage, 'area', 'Centroid');
%Selects largest blob by area
allAreas = [blobMeasurements.Area]; numToExtract = 1; 
[sortedAreas, sortIndexes] = sort(allAreas, 'descend');
biggestBlob = ismember(labeledImage, sortIndexes(1:numToExtract));
%% Convert from integer labeled image into binary (logical) image.
binaryNoPhantom = biggestBlob > 0; maxArea = max(sortedAreas);
binaryNoPhantom(1,:) = 0; binaryNoPhantom(:,1) = 0;
binaryNoPhantom(end,:) = 0; binaryNoPhantom(:,end) = 0;
IDicomOrig = IDicomOrig .* binaryNoPhantom;