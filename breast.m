function [mask] =  breast(img,peInd,bdrind,airThresh)
%  store the breast region

%  muscle information/create a new grey level information
[dimX,dimY] = size(img);
mask = zeros(dimX, dimY);
minI=airThresh;
for i = 1:dimX
    for j = 1:dimY
         mask(i,j) = (j > peInd(i)&& j <= bdrind(i) && img(i,j)>minI);
    end
end
tmp=bwlabel(mask);tmp(tmp==0)=NaN;
mask=double(tmp==mode(tmp(:)));
%now lets fill in any "islands" in the breast mask, can happen in processed
%mammograms where processing makes the intensity of breast pixels<=air
%pixels
mask_neg=~mask;
[L,NUM] = bwlabeln(mask_neg,8);
%Any 'background' region NOT adjacent to the image border needs to be
%filled in
%First, find labels of border regions
Lu=unique([L(1,:),L(:,1)',L(end,:),L(:,end)']);
%next, make a map of where to fill in the mask
fill_in=zeros(size(mask));
NUM;
for ii=1:NUM
    ii;
    if ~max(Lu==ii)
        ii
        fill_in(L==ii)=1;
    end
end
%now fill the holes (if its 1 in either mask or fill_in, it's breast area)
mask=mask+fill_in;
     
