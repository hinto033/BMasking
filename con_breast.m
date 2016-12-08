function [bdrind, airthresh] = con_breast(I0)
%  Find the contour of breast.
%  bdrind  returns the axis index of the boundary point


%First remove pixel rows from consideration of determining the threshold if
%the row is the basically the exact the same value
%I call them nonsense bars, because they can't possibly involve a breast/air
%interface, and we only want to use "central pixels"
row_range=max(I0,[],2)-min(I0,[],2);
row_range=row_range./max(row_range);
C1=find(row_range>0.001,1,'first');
C2=find(row_range>0.001,1,'last');
I0_center=I0(C1:C2,:);

[dimr] = size(I0,1);
%boundary between air and fat
bdrind = zeros(1,dimr);
%find "air-threshold"

img_pixs=double(I0_center(:));
x=min(img_pixs):(max(img_pixs)-min(img_pixs))/1000:max(img_pixs); % central location of bins in the histogram
n_elements = histc(img_pixs,x);
c_elements = [0 cumsum(n_elements)'];
dd=diff(c_elements,1);
dd=conv(dd,gausswin(25),'same');
peaklocation=find(dd>max(dd)*0.05,1);% note: old value for GE in med phys = 0.2 ie 20%
airthresh=x(peaklocation+find(dd(peaklocation:end)<=(dd(dd==max(dd))*0.05),1)+1);%med phys = 0.01 ie 1% Raised the threshold to 0.04 in response to the smoothing. --> 0.05 for better performance.

% threshold the air region(s) away, and take the 
%largest contiguous region juxtaposed to left-image-edge (from
%alignment). The breast is one object, it will be in one piece, 
%along the left-image-edge. In case there are columns of 'zeros' along the
%left edge, like as with the rows above, we wont start on column 1, per-se,
%but on the first column with values
I0mask=I0>=airthresh;
I0mask_cc = bwlabel(I0mask,8);
col_check = max(I0mask_cc,[],1);
init_col = find(col_check>0,1); %first non-zero label on left
if isempty(init_col) % not likely as that would mean there is nothing brighter than air
   init_col=1; %but JUST IN CASE, to avoid crashing out
end
%...now, on the off chance there are multiple objects sticking out of the
%left-image-edge (i.e., like a tag AND the breast) take the largest object
labels_2_check=unique(I0mask_cc(:,init_col)); %always at least 2: 0 and label
labels_2_check(labels_2_check==0)=[]; %drop 0

%if there is more than 1 non-zero label, select by area, otherwise its
%obvious which label we need to keep
if length(labels_2_check)>1 
    area_sizes=zeros(size(labels_2_check));
    for i=1:length(labels_2_check)
        tmp=I0mask_cc==labels_2_check(i);
        area_sizes(i)=sum(tmp(:));
    end
    %biggest object to keep is...
    label_2_keep=labels_2_check(area_sizes==max(area_sizes));
    %and if there just happens to be 2 regions of EXACTLY the same size, just
    %keep the first one, since its on the left an the images are oriented
    %that the breast will be on the left
    label_2_keep=label_2_keep(1);
else
    label_2_keep=labels_2_check;
end

I0mask=double(I0mask_cc==label_2_keep);

for y = 1:dimr
    i=find(I0mask(y,:),1,'last');
    if isempty(i)
        bdrind(1,y) =  1;
    else
        bdrind(1,y) = i;
    end
end

%Cut all points below "narrowest"
bb=min(bdrind(:));
cutpoint=find(bdrind(1,floor(dimr/2):end)==bb,1)+floor(dimr/2)-1;
bdrind(1,cutpoint:end)=1;
