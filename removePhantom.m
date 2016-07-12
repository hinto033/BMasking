function [maskingMap1, IDicomOrig, maxArea] = removePhantom(IDicomOrig)
%% Create masking map from simple threshold
maskingMap = IDicomOrig;
maskingMap= maskingMap./max(maskingMap(:));
maskingMap1 = im2bw(maskingMap,0.20);
maskingMap1 = imcomplement(maskingMap1);
%% characterize number of individual blobs
[labeledImage, numberOfBlobs] = bwlabel(maskingMap1);
blobMeasurements = regionprops(labeledImage, 'area', 'Centroid');
%Selects largest blob by area
allAreas = [blobMeasurements.Area]; numToExtract = 1; 
[sortedAreas, sortIndexes] = sort(allAreas, 'descend');
biggestBlob = ismember(labeledImage, sortIndexes(1:numToExtract));
%% Convert from integer labeled image into binary (logical) image.
maskingMap1 = biggestBlob > 0; maxArea = max(sortedAreas);
maskingMap1(1,:) = 0; maskingMap1(:,1) = 0;
maskingMap1(end,:) = 0; maskingMap1(:,end) = 0;
IDicomOrig = IDicomOrig .* maskingMap1;