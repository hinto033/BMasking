clc
clear all

%Generalize these for the future.
%1 = MLO, 2 = CC
pos = ones(1,39)
pos(2) = 2;
pos(24) = 2;
pos(33) =2;
pos(34) =2;
pos(35) =2;
pos(36) =2;
pos(37) = 2;
spacing = .07
DCMS = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 ...
    17 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 39];
for i = 1:37
    %Determine if CC or MLO Image and check if the respective annotation
    %exists
    %%%***************GENERALIZE
    cd('W:\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\AnnotationsUCSF_Bonnie')
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
        load(file)
        cd('Z:\Breast Studies\CBCRP Masking\Analysis Code\Matlab\BMaskingCode') 
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
            disp('DO IT 5')
            trigger = 1;
            stringcase = 1;
        elseif C1 ==2 && C2 ==2 && C3==2
            disp('DO IT 7')
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
            %Do calc here
            ratio = size(IQFImage)./size(image);
            lesionPoints = FreeForm.FreeFormCluster.face;
            lesionArea = FreeForm.Area; lesionHandle = FreeForm.handle;
            [numPoints,c] = size(lesionPoints);

            %Convert to dimensions of IQF Image
            lesionPointsIQFDims = lesionPoints;
            lesionPointsIQFDims(:,1) = round(lesionPointsIQFDims(:,1)*ratio(1));
            lesionPointsIQFDims(:,2) = round(lesionPointsIQFDims(:,2)*ratio(2));
            lesionAreaIQF = lesionArea * mean(ratio);
            %Not sure if this is mm2 or not
            lesionAreamm2 = lesionAreaIQF/(spacing^2);  
            lesionAreacm2 = lesionAreamm2/100;
            %Get stats on Tumor Region
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
    %**********************
    %*******************
            IQFImgVect = IQFImage(:);
            IQFImgVectNoZero =  IQFImgVect(IQFImgVect~=0);

            
            %Make subplots here
            figure(1)
            subplot(1,3,times); imshow(IQFImage,[])
%             imshow(IQFImage, [])
            
            
            
            figure(2)
            subplot(3,1,times)
            histogram(IQFImgVectNoZero)
            hold on
            %Need to get max line or to top of axes or whatever
            %*************************%
            line([medianLesionRegion,medianLesionRegion],[0,100000],'color', 'red') 
            


            end
            
            
            %Need an image here that clearly shows where the tumo ris. 
            %So that I can locate it and stuff like that.
            figure(4)
            imshow(image,[])
            figure(5)
            bwOpp = imcomplement(BWLesionArea)
%             imWOTumor = image.*
            pause
        end
        trigger = 0;


            
        %Store rest of Data 
        DiamLarge = [50, 40, 30, 20, 10, 8, 5, 3]
        DiamMed = [2, 1.6, 1.25, 1, .8, .63, .5, .4]
        DiamSmall = [.31, .25, .2, .16, .13, .1, .08, .06]

        LesionDiamCm(i) = LesDiamCm
        LesionAreaCmSquared(i) = LesAreamm2/100
        if LesDiamCm >=3
            sizeClass(i) = 'Large'
        elseif LesDiamCm < 3 && LesDiamCm > 0.4
            sizeClass(i) = 'Medium'
        elseif LesDiamCm < .4
            sizeClass(i) = 'Small'
        end
        %NEED TO STORE DATA HERE
        %**********************
%Save image of the Tumor Location

        
        %Need to check if I have the file for both IQF and the 
        
        %Do it 3 times for (large, med, small)
        
        %Save all relevant data.
    end
    pause 
end





%Need to save 
% area from annotation file, 
% the area in pixels (once scaled up to my IQF image scale) -done
% the area in cm^2 -done
% create a figure (Subplot, 1,3) for all three IQF scales
% create a histogram for all three and match up the IQF values for all
%     Indicate which one has an area 
 
err('forced stop')



