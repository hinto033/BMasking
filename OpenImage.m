clc
clear all

%Generalize these for the future.
%1 = MLO, 2 = CC
pos = ones(1,39);
pos(2) = 2;
pos(24) = 2;
pos(33) =2;
pos(34) =2;
pos(35) =2;
pos(36) =2;
pos(37) = 2;
spacing = .07;
DCMS = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 ...
    17 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 39];
for i = 1:37
    cd('W:\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\AnnotationsUCSF_Bonnie')
%     cd('C:\Users\Ben Hinton\Desktop\IWDMMaskingData')
%Check if the image that I saved is MLO or CC and upload/update the image

    if i <=9
    if pos(i) == 1
    formatSpec = '3C0100%d_ML_annotation.mat';
    elseif pos(i) ==2
    formatSpec = '3C0100%d_CC_annotation.mat';
    end
    tim = DCMS(i);    str = sprintf(formatSpec,tim);
    elseif i>9
    if pos(i) ==1
    formatSpec = '3C010%d_ML_annotation.mat';
    elseif pos(i) ==2
    formatSpec = '3C010%d_CC_annotation.mat';
    end
    tim = DCMS(i);    str = sprintf(formatSpec,tim);
    end
    A = exist(str,'file');
    if A == 0
      continue 
    elseif A==2
        disp('The annotations exist')
        file = str;
        load(file);
        cd('Z:\Breast Studies\CBCRP Masking\Analysis Code\Matlab\BMaskingCode') 
%         cd('C:\Users\Ben Hinton\Desktop\IWDMMaskingData')
        if i <=9
            formatSpecSmall5 = 'UCSF_3C0100%d_DCM5_IQFSmallDisks.mat';
            formatSpecMedium5 = 'UCSF_3C0100%d_DCM5_IQFMediumDisks.mat';
            formatSpecLarge5 = 'UCSF_3C0100%d_DCM5_IQFLargeDisks.mat';
            formatSpecSmall7 = 'UCSF_3C0100%d_DCM7_IQFSmallDisks.mat';
            formatSpecMedium7 = 'UCSF_3C0100%d_DCM7_IQFMediumDisks.mat';
            formatSpecLarge7 = 'UCSF_3C0100%d_DCM7_IQFLargeDisks.mat';
            tim = DCMS(i);    str1 = sprintf(formatSpecSmall5,tim);
            str2 = sprintf(formatSpecMedium5,tim);
            str3 = sprintf(formatSpecLarge5,tim);
            str4 = sprintf(formatSpecSmall7,tim);
            str5 = sprintf(formatSpecMedium7,tim);
            str6 = sprintf(formatSpecLarge7,tim);
            B1 = exist(str1,'file');C1 = exist(str4,'file');
            B2 = exist(str2,'file');C2 = exist(str5,'file');
            B3 = exist(str3,'file');C3 = exist(str6,'file');
        elseif i>9
            formatSpecSmall5 = 'UCSF_3C010%d_DCM5_IQFSmallDisks.mat';
            formatSpecMedium5 = 'UCSF_3C010%d_DCM5_IQFMediumDisks.mat';
            formatSpecLarge5 = 'UCSF_3C010%d_DCM5_IQFLargeDisks.mat';
            formatSpecSmall7 = 'UCSF_3C0100%d_DCM7_IQFSmallDisks.mat';
            formatSpecMedium7 = 'UCSF_3C0100%d_DCM7_IQFMediumDisks.mat';
            formatSpecLarge7 = 'UCSF_3C0100%d_DCM7_IQFLargeDisks.mat';
            tim = DCMS(i);    str1 = sprintf(formatSpecSmall5,tim);
            str2 = sprintf(formatSpecMedium5,tim);
            str3 = sprintf(formatSpecLarge5,tim);
            str4 = sprintf(formatSpecSmall7,tim);
            str5 = sprintf(formatSpecMedium7,tim);
            str6 = sprintf(formatSpecLarge7,tim);
            B1 = exist(str1,'file');C1 = exist(str4,'file');
            B2 = exist(str2,'file');C2 = exist(str5,'file');
            B3 = exist(str3,'file');C3 = exist(str6,'file');
        end
        trigger = 0;
        if B1 == 2 && B2 == 2 && B3 == 2
            trigger = 1;
            stringcase = 1;
        elseif C1 ==2 && C2 ==2 && C3==2
            trigger = 1;
            stringcase = 2;
        end  
        if trigger == 1
            for times = 1:3
            if stringcase == 1
                if times == 1; file = str1;
                elseif times == 2;file = str2;
                elseif times == 3;file = str3;
                end
                load(file)
            elseif stringcase == 2
                if times == 1; file = str4;
                elseif times == 2;file = str5;
                elseif times == 3;file = str6;
                end
                load(file)
            end
           if times == 1; IQFImage = IQFSmall2;
           elseif times == 2;IQFImage = IQFMed;
           elseif times == 3;IQFImage = IQFLarge2;
           end 
            %Derive Points of Lesion - DONE
            ratio = size(IQFImage)./size(image);
            lesionPoints = FreeForm.FreeFormCluster.face;
            lesionArea = FreeForm.Area; lesionHandle = FreeForm.handle;
            [numPoints,c] = size(lesionPoints);

            %Convert to dimensions of IQF Image -DONE
            lesionPointsIQFDims = lesionPoints;
            lesionPointsIQFDims(:,1) = round(lesionPointsIQFDims(:,1)*ratio(1));
            lesionPointsIQFDims(:,2) = round(lesionPointsIQFDims(:,2)*ratio(2));
            lesionAreaIQF = lesionArea * mean(ratio);
            %Get stats on Tumor Region - DONE
            BWLesionArea = roipoly(IQFImage,  lesionPointsIQFDims(:,1), lesionPointsIQFDims(:,2));
            IQFLargeONLYLESION = IQFImage.*BWLesionArea;
            lesionRegionIQFVect = IQFLargeONLYLESION(:);
            lesionRegionIQFVectNoZeros = IQFLargeONLYLESION(IQFLargeONLYLESION~=0);
            numLesionPixels = length(lesionRegionIQFVectNoZeros);
            LesAreamm2 = numLesionPixels * spacing * spacing;
            LesRadmm = sqrt(LesAreamm2/pi);
            LesDiammm = LesRadmm*2;
            LesDiamCm = LesDiammm/10;
            avgLesionRegion = mean(lesionRegionIQFVectNoZeros);
            medianLesionRegion = median(lesionRegionIQFVectNoZeros);

            %Need to remove the phantom before doing this quantitatively
            % - DONE
            numberToExtract =1;
            IQFBinary = im2bw(IQFImage, .001);
            [labeledImage, numberOfBlobs] = bwlabel(IQFBinary);
            blobMeasurements = regionprops(labeledImage, 'area');
            allAreas = [blobMeasurements.Area];
            [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
            biggestBlob = ismember(labeledImage, sortIndexes(1:numberToExtract));
            binaryImage = biggestBlob > 0;
            IQFImage = IQFImage.*binaryImage;
            IQFImgVect = IQFImage(:);
            IQFImgVectNoZero =  IQFImgVect(IQFImgVect~=0);

            %Make subplots here - DONE
            figure
%             subplot(1,3,times);
            imshow(IQFImage,[])
            titleSpec = sprintf('Image Number %d',DCMS(i));
            title(titleSpec)
            figure
%             subplot(3,1,times)
            histogram(IQFImgVectNoZero)
            title(titleSpec)
            hold on
            yl = ylim;
            line([medianLesionRegion,medianLesionRegion],[0,max(yl)],'color', 'red') 
            %**********ADD TITLES BASED ON IMAGE NUMBER!!!!!!!!!!
            end

            bwLesOpp = imcomplement(BWLesionArea);
            imgwoTumor = bwLesOpp.*IQFImage;
            figure
            imshow(imgwoTumor,[])
            title(titleSpec)
            imageLarger = imresize(image,size(IQFImage));
            imageLargerNoTumor = imageLarger.*bwLesOpp;
            figure
            imshow(imageLarger,[])
            title(titleSpec)
            figure
            imshow(imageLargerNoTumor,[])
            title(titleSpec)
        end
        i
        trigger = 0;
        DiamLarge = [50, 40, 30, 20, 10, 8, 5, 3];
        DiamMed = [2, 1.6, 1.25, 1, .8, .63, .5, .4];
        DiamSmall = [.31, .25, .2, .16, .13, .1, .08, .06];
        LesionDiamCm(i) = LesDiamCm
        LesionAreaCmSquared(i) = LesAreamm2/100
        if LesDiamCm >=3
            sizeClass(i) = 1 %Large
        elseif LesDiamCm < 3 && LesDiamCm > 0.4
            sizeClass(i) = 2 %Medium
        elseif LesDiamCm < .4 && LesDiamCm > 0
            sizeClass(i) = 3 %Small
        end
        LesDiamCm = 0;
        LesAreamm2 = 0;
        %NEED TO STORE DATA HERE
        %**********************
        %NEED TITLE FOR THE DIFFERENT GRAPHS (Whivh image number it is
        %working on
    end
    pause 
    close all
end