% load('UCSF_3C01005_DCM7_MaskingImage_10-Feb-2016_15-56-03.mat')

storedStructure = load('UCSF_3C01029_DCM7_MaskingImage_24-Feb-2016_12-06-03','-mat');
% Extract out the image from the structure into its own variable.
% Don't use I as the variable name - bad for several reasons.
imageArray = storedStructure.maskimage;  % Or storedStructure.I depending on what members your structure has.
% UCSF_3C01029_DCM7_MaskingImage_24-Feb-2016_11-35-34
% UCSF_3C01029_DCM7_MaskingImage_24-Feb-2016_12-06-03
figure
imshow(imageArray, [])


% UCSF_3C01017_DCM7_MaskingImage_19-Feb-2016_20-31-33
% UCSF_3C01008_DCM7_008_008_MaskingImage_19-Feb-2016_20-08-55
% UCSF_3C01012_DCM7_MaskingImage_19-Feb-2016_20-08-48
% UCSF_3C01024_DCM7_MaskingImage_19-Feb-2016_19-50-09
% UCSF_3C01025_DCM7_MaskingImage_19-Feb-2016_19-35-58
% UCSF_3C01006_DCM7_MaskingImage_19-Feb-2016_19-22-57
% UCSF_3C01013_DCM7_MaskingImage_19-Feb-2016_19-00-11
% UCSF_3C01015_DCM7_MaskingImage_19-Feb-2016_18-39-20
% UCSF_3C01003_DCM7_MaskingImage_19-Feb-2016_18-19-53
% UCSF_3C01024_DCM7_MaskingImage_19-Feb-2016_17-55-35
% UCSF_3C01019_DCM7_1_MaskingImage_19-Feb-2016_17-41-23
% UCSF_3C01011_DCM7_MaskingImage_19-Feb-2016_17-24-52
% UCSF_3C01014_DCM7_MaskingImage_19-Feb-2016_17-08-50
% UCSF_3C01009_DCM7_MaskingImage_19-Feb-2016_16-45-46
% UCSF_3C01005_DCM7_MaskingImage_19-Feb-2016_16-17-57
% UCSF_3C01015_DCM7_MaskingImage_17-Feb-2016_15-28-13
% UCSF_3C01029_DCM7_MaskingImage_17-Feb-2016_15-53-37
% UCSF_3C01030_DCM7_MaskingImage_17-Feb-2016_16-16-09
% UCSF_3C01033_DCM7_MaskingImage_17-Feb-2016_16-30-04

