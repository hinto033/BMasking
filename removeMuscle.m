function [imgNoWall, mask]=removeMuscle(dcmImg, dcminfo)
% Developed by Amir Pasha M
% Adapted by Ben Hinton 
%% Pre-calculations

pecSegNeed=strcmp(dcminfo.ViewPosition(1),'M'); %Determines if MLO View
flipNeed=0;
isFlipped=isfield(dcminfo,'FieldOfViewHorizontalFlip') && strcmp(dcminfo.FieldOfViewHorizontalFlip,'YES');
% Determines if need to flip image
if isFlipped
    if strcmp(dcminfo.ImageLaterality,'L')
        flipNeed=1;
    end
else
    if strcmp(dcminfo.ImageLaterality,'R')
        flipNeed=1;
    end
end 
%Flips image based on need
if flipNeed==1
    %if we need to flip it
    img=fliplr(double(dcmImg));
    dcmImg=fliplr(double(dcmImg));
else
    img=double(dcmImg);
end
%% Finding the muscle line
[bdrind, airThresh] = con_breast(img);
%%% pectoral segmentation only really needed in MLO view
if pecSegNeed
    [roiH] = croi(img, bdrind,1); %chooses ROI for hough tform
    roiH=imdilate(roiH,strel('disk',8,0));
    roiH=imfilter(roiH,fspecial('gaussian',[5 5],1));
    %ignore bottom right quadrent (cut corner to corner) other=NaN
    roiH(round(size(roiH,1).*0.66):end,round(size(roiH,2).*0.66):end)=NaN;
    roiH(roiH<=airThresh)=NaN; %ignore air
    % Find pectoral muscle using Hough Transformation
    [peIdx] = pectoral(img,roiH);
else
    peIdx=zeros(size(img,1),1);
end
[mask] = breast(img,peIdx,bdrind,airThresh);
%Reverse the segmentations back so they align with original image
if flipNeed
    mask=fliplr(mask); % When the image was flipped by the program previously, it has to be flipped again now.
    dcmImg = fliplr(dcmImg);
end
size(dcmImg)
size(mask)
imgNoWall = mask.*dcmImg;

end

