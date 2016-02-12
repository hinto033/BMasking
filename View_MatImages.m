% load('UCSF_3C01005_DCM7_MaskingImage_10-Feb-2016_15-56-03.mat')

storedStructure = load('UCSF_3C01011_DCM7_MaskingImage_10-Feb-2016_20-15-13','-mat');
% Extract out the image from the structure into its own variable.
% Don't use I as the variable name - bad for several reasons.
imageArray = storedStructure.maskimage;  % Or storedStructure.I depending on what members your structure has.
% Display the image in a brand new figure window.


figure
imshow(imageArray, [])


% imgSection = imageArray(ymin:ymin+height, xmin:xmin+width);
% 
% C = unique(imgSection)