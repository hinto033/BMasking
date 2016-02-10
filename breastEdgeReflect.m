function [replaced] = breastEdgeReflect(addedBreast, BW, I_DCM_Expanded, center)
altered = addedBreast;
flipvert = 0;
fliphorz = 0;
if mean2(BW(:,1:10))>mean2(BW(:,501-10:501));
    %Do nothing
else
    BW = fliplr(BW);
    altered = fliplr(altered);
    fliphorz = 1;
end
%     while mean2(BW) ~= 1
for times = 1:3
for z = 1:501
    row = BW(z,:);
    nonzero = row(row~=0);
    [p1,p2] = size(nonzero);
    og = altered(z,1:p2);
    ogbw = BW(z,1:p2);
    flip = fliplr(og);
    flipbw = fliplr(ogbw);
    total = horzcat(og, flip);
    totalbw = horzcat(ogbw, flipbw);

    if 2*p2 < 501
    altered(z,1:2*p2) = total; 
    BW(z,1:2*p2) = totalbw; 
    elseif 2*p2 >= 501
    altered(z,1:501) = total(1:501);
    BW(z,1:501) = totalbw(1:501); 
    end
end
end
if mean2(BW(1:10,:))>mean2(BW(501-10:501,:));
    %Do nothing
else
    BW = flipud(BW);
    altered = flipud(altered);
    flipvert = 1;
end
for times = 1:3
for z = 1:501
    col = BW(:,z);
    nonzero = col(col~=0);
    [p1,p2] = size(nonzero);
    og = altered(1:p1,z);
    ogbw = BW(1:p1,z);
    flip = flipud(og);
    flipbw = flipud(ogbw);
    total = vertcat(og, flip);
    totalbw = vertcat(ogbw, flipbw);

    if 2*p1 < 501
    altered(1:2*p1,z) = total; 
    BW(1:2*p1,z) = totalbw; 
    elseif 2*p1 >= 501
    altered(1:501,z) = total(1:501);
    BW(1:501,z) = totalbw(1:501); 
    end
end
end
%Now flip that lr back to normal position
if flipvert == 1 && fliphorz==1
altered = flipud(altered);
altered = fliplr(altered);
elseif flipvert == 1 && fliphorz==0
altered = flipud(altered);
elseif flipvert == 0 && fliphorz==1
altered = fliplr(altered);
elseif flipvert == 0 && fliphorz==0
    %Do nothing
end
%Now insert that into the OG image
replaced = I_DCM_Expanded;
replaced(center(1)-250:center(1)+250,center(2)-250:center(2)+250) = altered;  
        