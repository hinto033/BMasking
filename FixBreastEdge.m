
%Function Padded = padarray = [ImageSection]

% a = imread('1015_DCM7_CD_870_2586.png');
a = (imread('CC_642_2007.png'));


APadded = padarray(a,[250 250],'symmetric','both');

% figure
% imshow(APadded,[])

center = [360, 500];
testRegion = a(center(2)-200:center(2)+200, center(1)-200:center(1)+200);

% figure
% imshow(testRegion, [])
altered = testRegion;

BW = im2bw(testRegion, 0.1) ;
[height,width] = size(BW);

% figure
% imshow(BW, [])
% pause

%Works if breast comes from left side and is full on the side. 
%If from right side, just do fliplr and do thi ame function on it. 
 figure
%      mean(BW(1:10,:))
%     mean(BW(401-10:401,:))
%     pause
 


%Maybe make this flip up down if necessary?
if mean2(BW(:,1:10))>mean2(BW(:,401-10:401));
    %Do nothing
else
    k = 5;
    BW = fliplr(BW);
    altered = fliplr(altered);
end
while mean2(BW) ~= 1
for j = 1:height
    row = BW(j,:);
    nonzero = row(row~=0);
    [p1,p2] = size(nonzero);
    og = altered(j,1:p2);
    flip = fliplr(og);
    total = horzcat(og, flip);
    
    if 2*p2 < 401
    altered(j,1:2*p2) = total; 
    BW(j,1:2*p2) = total; 
    elseif 2*p2 >= 401
    altered(j,1:height) = total(1:height);
    BW(j,1:height) = total(1:height); 
    end
    
%     testRegion(j,:) = testRegion(j,:) + fliplr(testRegion(j,:))
end
% BW = im2bw(altered, 0.3) ;
figure
imshow(BW)
figure
imshow(altered)
pause
end
imshow(altered, [])
pause

figure
imshow(BW, [])
pause
close all



% CC_642_2007
% CC_2008_697
% MLO_646_2007
% MLO_701_2008