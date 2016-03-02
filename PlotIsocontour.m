% UCSF_3C01029_DCM7_MaskingImage_26-Feb-2016_11-45-40



storedStructure = load('UCSF_3C01029_DCM7_MaskingImage_26-Feb-2016_11-45-40','-mat');
% Extract out the image from the structure into its own variable.
% Don't use I as the variable name - bad for several reasons.
imageArray = storedStructure.maskimage(:,:,1);  % Or storedStructure.I 
% depending on what members your structure has.
% UCSF_3C01029_DCM7_MaskingImage_24-Feb-2016_11-35-34
% UCSF_3C01029_DCM7_MaskingImage_24-Feb-2016_12-06-03
figure
imshow(imageArray, [])


storedStructure = load('UCSF_3C01029_DCM7_MaskingImage_26-Feb-2016_11-45-40','-mat');
% Extract out the image from the structure into its own variable.
% Don't use I as the variable name - bad for several reasons.
imageArray = flipud(storedStructure.maskimage(:,:,1)); 

number = 10
levels = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
figure
contour(imageArray, levels)
figure
contourf(imageArray, levels)

