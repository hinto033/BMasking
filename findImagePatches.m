function [imgInfo, imgPatch, regionnRow, regionNCol, errFlags] = findImagePatches(IDicomOrig,attenuation, ...
    radius, binDisk, spacing,binaryOutline,errFlags)
%% Setting Parms
pMax = length(radius); kMax = length(attenuation);
[nRows,nCols] = size(IDicomOrig); [nRowPatch,nColPatch] = size(binDisk(:,:,1));
padAmnt = ceil((nRowPatch+1)/2); patchRadius = padAmnt-1;
IDicomOrig = padarray(IDicomOrig, [padAmnt,padAmnt], 'symmetric');

oneMmPixels = ceil(1/spacing); pixelRadInIQFImg = ceil(oneMmPixels*2.5);
rowIndices = pixelRadInIQFImg+1:2*pixelRadInIQFImg:nCols;
colIndices = pixelRadInIQFImg+1:2*pixelRadInIQFImg:nRows;
nValidPatches = 0;
disp('Determining Locations to calculate...');tic
for rowIdx = rowIndices
    for colIdx = colIndices
        if binaryOutline(colIdx,rowIdx) == 0 %Do nothing, not a patch to store
        else nValidPatches = nValidPatches+1; %say we will store that location
        end
    end
end
t=toc; str = sprintf('time elapsed: %0.2f seconds', t); disp(str)
%VERY GREEDY RAM, creates matrix that I'll store all the image patches in.
if mod(nRowPatch,2) == 0
    imgPatch = zeros((patchRadius*2)^2,nValidPatches);
else
    imgPatch = zeros((patchRadius*2+1)^2,nValidPatches);
end
imgInfo = zeros(nValidPatches,5);
nValidPatches = 0;
disp('Storing Image Patches...');tic
for rowIdx = rowIndices
    for colIdx = colIndices
        paddedColIdx = colIdx+padAmnt;
        paddedRowIdx = rowIdx+padAmnt;
        %Define Region
        if mod(nRowPatch,2) == 0
            region = IDicomOrig(paddedColIdx-patchRadius:paddedColIdx+patchRadius-1, ...
            paddedRowIdx-patchRadius:paddedRowIdx+patchRadius-1);
        else
            region = IDicomOrig(paddedColIdx-patchRadius:paddedColIdx+patchRadius, ...
            paddedRowIdx-patchRadius:paddedRowIdx+patchRadius);
        end
        [regionnRow,regionNCol] = size(region);
        regionMedian = median(region(:));
        regionStDev = std(region(:));
        %Calculate NPS HERE AS WELL***********************? Is there fast
        %way to do this.....?
        if binaryOutline(colIdx,rowIdx) == 0 %Do not store the location
        else  %Do store the location
            nValidPatches = nValidPatches+1;
            imgInfo(nValidPatches,1) = paddedColIdx;
            imgInfo(nValidPatches,2) = paddedRowIdx;
            imgInfo(nValidPatches,3) = colIdx;
            imgInfo(nValidPatches,4) = rowIdx;
            imgInfo(nValidPatches,5) = regionMedian;
            imgInfo(nValidPatches,6) = regionStDev;
            %imgInfo(nValidPatches,7) = NPS
            imgPatch(:,nValidPatches) = region(:);
            
        end
    end
end
errFlags=errFlags