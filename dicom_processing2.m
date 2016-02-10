

%Plan of Code:
    %Import image
    %Separate out into ~1cm2 regions
    %place gold disk of specific size and thickness in that region
    %calculate contrast and detectability (similar statistical method as euref
    %prgrm)
    %repeat this for all sizes/thicknesses in cdmam 3.4 phantom
    %From these, produce a "masking %" metric or something like that. 
    %Repeat for each 1cm2 region
    %Produce visualization of this

%Set Variables and constants of interest
t = [.03, .04, .05, .06, .08, .1, .13, .16, .2, .25, .36, ...
        .5, .71, 1, 1.42, 2] %units are um
d = [2, 1.6, 1.25, 1, .8, 0.63, 0.5, 0.4, 0.31, 0.25,...
    0.2, 0.16, 0.13, 0.1, 0.08, 0.06] %units are in mm
    

study = '\UCSF'
files = '\3C01036\png_files'
enddir = strcat(study,files)       


BHinton_GUI1




%for UCSF: files = 3C01001-3C01200
%for Moffitt: files = 3C02001-3C02149
%For UCSF-Pilot: files = 

%Import Image        

global roi I

% parentdir = uigetdir('\\win\bbdg\aaData\Breast Studies\CDMAM');
parentdir = '\\win\bbdg\aaData\Breast Studies\3C_data\RO1_3Cimages'
maindir = strcat(parentdir,enddir)


        file_name = 'HECC'    %[name,ext]      %'DCM1';
%           file_name = 'DCM3'
        full_file_png = [maindir,'\',file_name, 'raw.png'];
        I  = double(imread(full_file_png));
        
[r,c] = size(I)
imshow(I)
max(I)   %Need to normalize this somehow
Ifix = I/2456;

figure(1)
imshow(Ifix)


%Selects a certain area
rect = getrect  % [xmin, ymin, width, height]

Xmid = rect(1) + 0.5*rect(3)
Ymid = rect(2) + 0.5*rect(4)
Xbl = rect(1) + 0.25*rect(3)
Ybl = rect(2) + 0.25*rect(4)
Xbr = rect(1) + 0.75*rect(3)
Ybr = rect(2) + 0.25*rect(4)
Xtl = rect(1) + 0.25*rect(3)
Ytl = rect(2) + 0.75*rect(4)
Xtr = rect(1) + 0.75*rect(3)
Ytr = rect(2) + 0.75*rect(4)

centerMid = [Xmid, Ymid]
centerbl = [Xbl, Ybl]
centerbr = [Xbr, Ybr]
centertl = [Xtl, Ytl]
centertr = [Xtr, Ytr]

rad = 5

circMid = circle_roi(centerMid, rad,size(I));
circbl = circle_roi(centerbl, rad,size(I));
circbr = circle_roi(centerbr, rad,size(I));
circtl = circle_roi(centertl, rad,size(I));
circtr = circle_roi(centertr, rad,size(I));

searchMid = circle_roi(centerMid, rad*2,size(I));
searchbl = circle_roi(centerbl, rad*2,size(I));
searchbr = circle_roi(centerbr, rad*2,size(I));
searchtl = circle_roi(centertl, rad*2,size(I));
searchtr = circle_roi(centertr, rad*2,size(I));

[rMid,cMid]=find((circMid(:,:))~=0)
[rbl,cbl]=find((circbl(:,:))~=0)
[rbr,cbr]=find((circbr(:,:))~=0)
[rtl,ctl]=find((circtl(:,:))~=0)
[rtr,ctr]=find((circtr(:,:))~=0)

%Insert Gold Disks in two of these locations

%#########
%NEED TO MAKE THIS FUNCTION (Probably look through sergheis code)
%#########
GoldMid = circMid*.2;
Goldbl = circbl*.2;


%for j = t
%    for k = d
%        
%    end
%end




circs_and_breast = Ifix + GoldMid + Goldbl;
figure(6)
imshow(cirs_and_breast)





%Get Pixel Locations of these regions


%Calc average value in each corner
AvgValMid = mean2(circs_and_breast(rMid,cMid))
AvgValbl = mean2(circs_and_breast(rbl,cbl))
AvgValbr = mean2(circs_and_breast(rbr,cbr))
AvgValtl = mean2(circs_and_breast(rtl,ctl))
AvgValtr = mean2(circs_and_breast(rtr,ctr))


BackgroundAvg = (AvgValbr+AvgValtl+AvgValtr) / 3

%Weber
MidContrast = (AvgValMid - BackgroundAvg) / BackgroundAvg
blContrast = (AvgValbl - BackgroundAvg) / BackgroundAvg

%Low Contrast Example
brContrast = (AvgValbr - BackgroundAvg) / BackgroundAvg
trContrast = (AvgValtr - BackgroundAvg) / BackgroundAvg
tlContrast = (AvgValtl - BackgroundAvg) / BackgroundAvg


%Need to scan across and get total entropy of each searchMid Regions


%Need to calculate contrast (Read the papers to find out what they do!)


%Do I need to add noise into all of this? PROBABLY.... do it mathmatically
%and find out how



%After that, need to convolve that and make it happen in every region


%For each region, calculate image quality factor:
 %   IQF = 16/sum((from 1 to 16) Ci, Di,min)
 %  d is the smallest diameter perceived in the ith column corresponting to
 %  gold thickness C




 
 %%%
 p(d) = 0.75 / (1+ exp(-f(C-Ct) ) + 0.25
        C = log of signal contrast
            = ln (1 - exp(-mew*d))   d is thickness of gold
                                    mew is linear atten coeff of gold.
                                    mew = 190 / mm
            f is free parameter to be fitted (Can use fixed value of f for all diameters
            
            
 need p = .625 to say detectable. 
 DONT KNOW WHAT Ct is
 %%%




















%Next place the gold disks in here and do statistical test. Just do for one
%case. 
figure(2)
        background = imopen(Ifix,strel('disk',100));
        imshow(background)
        J = Ifix - background; %figure;imagesc(J);colormap(gray);
        figure(3)
        imshow(J)
          k=1


        mn_size = round([1,1600,1,1200]*k);
        mn = mean2(J(mn_size(1):mn_size(2),mn_size(3):mn_size(4)));
        BW1 = J >(mn+500); %figure;imagesc(BW1);colormap(gray);
        figure(4)
        imshow(BW1)
        BW = edge(Ifix, 'canny', [0.04 0.10], 1);
                figure(5)
        imshow(BW)


        
%use the edge to determine where to place disks and do contrast detail curves
cir_and_edge = BW + test;
figure(6)
imshow(cir_and_edge)
        
        
        
        




%  I = -log(I/12314)*10000;
  imshow(I)

        



file_names = dir(parentdir);
sza = size(file_names);
count = 0;
lenf = sza(1);
warning off;




   

\\win\bbdg\aaData\Breast Studies\3C_data\RO1_3Cimages

global roi I
 tic
% parentdir = uigetdir('\\win\bbdg\aaData\Breast Studies\CDMAM');
parentdir = '\\win\bbdg\aaData\Breast Studies\CDMAM\Selenia Feb15'
file_names = dir(parentdir);
sza = size(file_names);
count = 0;
lenf = sza(1);
warning off;

for m = 3: lenf
    filename_read = file_names(m).name;
    fullfilename_read = [parentdir,'\',filename_read];
    [pathstr,name,ext] = fileparts(fullfilename_read);
    if (strcmp(ext, '') | strcmp(ext, '.dcm')) & ~isdir(fullfilename_read)
        count = count + 1
        file_name = [name,ext]      %'DCM1';
%           file_name = 'DCM3'
        full_file_png = [parentdir,'\',file_name, 'raw.png'];
        I  = double(imread(full_file_png));
        full_file_dicomread = [parentdir,'\',file_name];
        info_dicom = dicominfo(full_file_dicomread);
        I_dicom = double(dicomread(info_dicom));
        I_dicom_orig =  I_dicom;
        % I  = double(imread('R:\aaData\Breast Studies\CDMAM\Manufacturer\DPm.1.2.840.113681.2229459122.1658.3509939858.433raw.png'));
        % I  = double(imread('R:\aaData\Breast Studies\CDMAM\Essential_Oct14\IM13raw.png'));
        
        I = -log(I/12314)*10000;
        % J = imadjust(I,stretchlim(I),[0.8 1]);
        %  figure;imagesc(I);colormap(gray);
        k = 1; %0.7 for GE
        
        
        % %  ind = find(I<mn);
        % % %  J(ind)=mn;
        % % BW = J>mn;
        % % % BW = edge(J,'canny');
        % % se = strel('disk',3);
        % % closeBW = imclose(BW,se);
        % % BW = J>(mn+800);figure;imagesc(BW);colormap(gray);
        % % IM2 = imopen(closeBW,se);
        
        
        % BW1 = I>(mn+700);%figure;imagesc(BW);colormap(gray);
        % se = strel('disk',17);
        % BW = imclose(BW1,se);
        background = imopen(I,strel('disk',100));
        J = I - background; %figure;imagesc(J);colormap(gray);
        mn_size = round([500,2500,500,2000]*k);
        mn = mean2(J(mn_size(1):mn_size(2),mn_size(3):mn_size(4)));
        BW1 = J >(mn+500); %figure;imagesc(BW1);colormap(gray);
        BW = edge(BW1, 'canny', [0.04 0.10], 1);
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
function circuit_example()
% % I  = imread('circuit.tif');
% % rotI = imrotate(I,33,'crop');
% % fig1 = imshow(rotI);

global roi I
 tic
% parentdir = uigetdir('\\win\bbdg\aaData\Breast Studies\CDMAM');
parentdir = '\\win\bbdg\aaData\Breast Studies\CDMAM\Selenia Feb15'
file_names = dir(parentdir);
sza = size(file_names);
count = 0;
lenf = sza(1);
warning off;

for m = 3: lenf
    filename_read = file_names(m).name;
    fullfilename_read = [parentdir,'\',filename_read];
    [pathstr,name,ext] = fileparts(fullfilename_read);
    if (strcmp(ext, '') | strcmp(ext, '.dcm')) & ~isdir(fullfilename_read)
        count = count + 1
        file_name = [name,ext]      %'DCM1';
%           file_name = 'DCM3'
        full_file_png = [parentdir,'\',file_name, 'raw.png'];
        I  = double(imread(full_file_png));
        full_file_dicomread = [parentdir,'\',file_name];
        info_dicom = dicominfo(full_file_dicomread);
        I_dicom = double(dicomread(info_dicom));
        I_dicom_orig =  I_dicom;
        % I  = double(imread('R:\aaData\Breast Studies\CDMAM\Manufacturer\DPm.1.2.840.113681.2229459122.1658.3509939858.433raw.png'));
        % I  = double(imread('R:\aaData\Breast Studies\CDMAM\Essential_Oct14\IM13raw.png'));
        
        I = -log(I/12314)*10000;
        % J = imadjust(I,stretchlim(I),[0.8 1]);
        %  figure;imagesc(I);colormap(gray);
        k = 1; %0.7 for GE
        
        
        % %  ind = find(I<mn);
        % % %  J(ind)=mn;
        % % BW = J>mn;
        % % % BW = edge(J,'canny');
        % % se = strel('disk',3);
        % % closeBW = imclose(BW,se);
        % % BW = J>(mn+800);figure;imagesc(BW);colormap(gray);
        % % IM2 = imopen(closeBW,se);
        
        
        % BW1 = I>(mn+700);%figure;imagesc(BW);colormap(gray);
        % se = strel('disk',17);
        % BW = imclose(BW1,se);
        background = imopen(I,strel('disk',100));
        J = I - background; %figure;imagesc(J);colormap(gray);
        mn_size = round([500,2500,500,2000]*k);
        mn = mean2(J(mn_size(1):mn_size(2),mn_size(3):mn_size(4)));
        BW1 = J >(mn+500); %figure;imagesc(BW1);colormap(gray);
        BW = edge(BW1, 'canny', [0.04 0.10], 1);
        
        %%
        % line detection
        
        [lines_desc_comb, lines_asc_comb] = line_detect(BW)
        
        % % figure;imagesc(BW);colormap(gray);
        % % [H,theta,rho] = hough(BW,'RhoResolution',0.5,'Theta',[43:0.1:47,-47:0.1:-43]); %,'RhoResolution',0.5,'Theta',-50:0.01:-40
        % % P = houghpeaks(H,100,'threshold',ceil(0.4*max(H(:))));
        % % lines = [];
        % % lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',500);
        % % max_len = 0;
        % % kd = 0;
        % % ka = 0;
        % % clear lines_desc;
        % % clear lines_asc;
        % % clear lines_desc_sort;
        % % clear lines_asc_comb
        % %
        % % for k = 1:length(lines)
        % % %    xy = [lines(k).point1; lines(k).point2];
        % % %    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
        % %    if lines(k).theta == 45
        % %        kd = kd + 1;
        % %        lines(k).b = lines(k).point1(1) + lines(k).point1(2);
        % %        lines_asc(kd) = lines(k);
        % %      else
        % %        ka = ka + 1;
        % %        lines(k).b = lines(k).point1(2) - lines(k).point1(1);
        % %        lines_desc(ka) = lines(k);
        % %    end
        % %
        % % end
        
%         hh = figure;imagesc(BW);colormap(gray);hold on;
        ln_desc = length(lines_desc_comb)
        ln_asc = length(lines_asc_comb)
        
        
        if ln_desc ~= 17 | ln_asc ~= 17
            file_name
            continue;
        end
        
        % for ascending lines
        points = [];
        lines_temp(1) = lines_desc_comb(8);
        lines_temp(2) = lines_desc_comb(9);
        line_desc89 = mean_lines(lines_temp);
        for km = 1:ln_desc
            points(km,:) = line_intersect(line_desc89,lines_asc_comb(km));
            y_1vect = [];
            y_2vect = [];
            y_mvect = [];
            
            for kk = -30:10:30
                
                xi = points(km,1) - kk;
                alfa = (lines_asc_comb(km).point2(2) - lines_asc_comb(km).point1(2))/(lines_asc_comb(km).point2(1) - lines_asc_comb(km).point1(1));
                b= ((lines_asc_comb(km).point1(2) + lines_asc_comb(km).point2(2)) - alfa*(lines_asc_comb(km).point1(1)+lines_asc_comb(km).point2(1)))/2;
%                 yi = alfa*xi + lines_asc_comb(km).b;
%                 yi = lines_asc_comb(km).alfa*xi + lines_asc_comb(km).b;
                yi =  alfa*xi + b;
                xpr = [xi,xi];
                ypr = [yi-15,yi+15];
                ln1 =  improfile(BW,xpr,ypr);
                ind = find(ln1==1);
                ids = kmeans(ind,2);
                ln1 = [ind,ids];
                ids_1 = find(ln1(:,2) == 1);
                ids_2 = find(ln1(:,2) == 2);
                y_1 = mean(ind(ids_1));
                y_2 = mean(ind(ids_2));
                y_m = mean([y_1,y_2]);
                              
                y_1vect = [y_1vect,y_1];
                y_2vect = [y_2vect,y_2];
                y_mvect = [y_mvect,y_m];
                               
                
% %                 plot( xi,(yi - (15-y_1)),'*r');
% %                 plot( xi,(yi - (15-y_2)),'*b');
% %                 plot( xi,(yi - (15-y_m)),'*m');hold on;
                %    plot( points(km,1),points(km,2),'.r');
                %    plot( points(km,1),points(km,2),'.r');
                % %     xy = [lines_asc_comb(km).point1; lines_asc_comb(km).point2];
                % %    plot(xy(:,1),xy(:,2),'LineWidth',1.5,'Color','cyan');
            end
             ind_min = find(y_mvect==min(y_mvect));
                ind_max = find(y_mvect==max(y_mvect));
              if length(ind_max) > 1 & length(ind_min) >1
                  ym = mean(y_mvect);
              elseif length(ind_max) > 1 & length(ind_min) ==1
                  y_mvect2 =  y_mvect;
                 y_mvect2([ind_min]) = [];                
                 ym = mean(y_mvect2);
              elseif length(ind_max) == 1 & length(ind_min) >1
                  y_mvect2 =  y_mvect;
                 y_mvect2([ind_max]) = [];                
                 ym = mean(y_mvect2);
              else 
                y_mvect2 =  y_mvect;
                y_mvect2([ind_min,ind_max]) = [];                
                ym = mean(y_mvect2);
              end
                
            lines_asc_comb(km).point1(2) = lines_asc_comb(km).point1(2) -(15-ym);
            lines_asc_comb(km).point2(2) = lines_asc_comb(km).point2(2) -(15-ym);
            %    figure(hh);imagesc(BW);colormap(gray);hold on;
% %             plot( points(km,1),points(km,2)-(15-ym),'*r');
% %             xy = [lines_asc_comb(km).point1; lines_asc_comb(km).point2];
% %             plot(xy(:,1),xy(:,2),'LineWidth',1.5,'Color','cyan')
            
            a = 1;
            
        end
        
           % for ascending lines
           points = [];
        lines_temp(1) = lines_asc_comb(9);
        lines_temp(2) = lines_asc_comb(10);
        line_asc910 = mean_lines(lines_temp);
        for km = 1:ln_desc
            points(km,:) = line_intersect(line_asc910,lines_desc_comb(km));
            y_1vect = [];
            y_2vect = [];
            y_mvect = [];
            
            for kk = -30:10:30
                xi = points(km,1) - kk;
%                 yi = lines_desc_comb(km).alfa*xi + lines_desc_comb(km).b;
                alfa = (lines_desc_comb(km).point2(2) - lines_desc_comb(km).point1(2))/(lines_desc_comb(km).point2(1) - lines_desc_comb(km).point1(1));
                yi = alfa*xi + lines_desc_comb(km).b;
                xpr = [xi,xi];
                ypr = [yi-15,yi+15];
                ln1 =  improfile(BW,xpr,ypr);
                ind = find(ln1==1);
                ids = kmeans(ind,2);
                ln1 = [ind,ids];
                ids_1 = find(ln1(:,2) == 1);
                ids_2 = find(ln1(:,2) == 2);
                y_1 = mean(ind(ids_1));
                y_2 = mean(ind(ids_2));
                y_m = mean([y_1,y_2]);
                
                y_1vect = [y_1vect,y_1];
                y_2vect = [y_2vect,y_2];
                y_mvect = [y_mvect,y_m];
                
% %                 ind_min = find(y_mvect==min(y_mvect));
% %                 ind_max = find(y_mvect==max(y_mvect));
% %                 y_mvect2 =  y_mvect;
% %                 y_mvect2([ind_min,ind_max]) = [];
% %                 ym = mean(y_mvect2);
                
% %                 plot( xi,(yi - (15-y_1)),'*r');
% %                 plot( xi,(yi - (15-y_2)),'*b');
% %                 plot( xi,(yi - (15-y_m)),'*m');hold on;
                %    plot( points(km,1),points(km,2),'.r');
                %    plot( points(km,1),points(km,2),'.r');
                % %     xy = [lines_asc_comb(km).point1; lines_asc_comb(km).point2];
                % %    plot(xy(:,1),xy(:,2),'LineWidth',1.5,'Color','cyan');
            end
            ind_min = find(y_mvect==min(y_mvect));
                ind_max = find(y_mvect==max(y_mvect));
              if length(ind_max) > 1 & length(ind_min) >1
                  ym = mean(y_mvect);
              elseif length(ind_max) > 1 & length(ind_min) ==1
                  y_mvect2 =  y_mvect;
                 y_mvect2([ind_min]) = [];                
                 ym = mean(y_mvect2);
              elseif length(ind_max) == 1 & length(ind_min) >1
                  y_mvect2 =  y_mvect;
                 y_mvect2([ind_max]) = [];                
                 ym = mean(y_mvect2);
              else 
                y_mvect2 =  y_mvect;
                y_mvect2([ind_min,ind_max]) = [];                
                ym = mean(y_mvect2);
              end
            
            lines_desc_comb(km).point1(2) = lines_desc_comb(km).point1(2) -(15-ym);
            lines_desc_comb(km).point2(2) = lines_desc_comb(km).point2(2) -(15-ym);
            %    figure(hh);imagesc(BW);colormap(gray);hold on;
% %             plot( points(km,1),points(km,2)-(15-ym),'*r');
% %             xy = [lines_desc_comb(km).point1; lines_desc_comb(km).point2];
% %             plot(xy(:,1),xy(:,2),'LineWidth',1.5,'Color','cyan')
% %             
            a = 1;
            
        end
       
         
        % % [lines_desc_sort index1] = sortStruct(lines_desc,'b', -1);
        % % [lines_asc_sort index2] = sortStruct(lines_asc,'b', -1);
        % %
        % % len_desc = size(lines_desc);
        % % len_asc = size(lines_asc);
        % %
        % % figure;imagesc(BW);colormap(gray);hold on;
        % % for k = 1:length(lines_desc)
        % %    xy = [lines_desc_sort(k).point1; lines_desc_sort(k).point2];
        % %    plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','green');
        % %    xy = [lines_asc_sort(k).point1; lines_asc_sort(k).point2];
        % %    plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','blue');
        % %    a = 1;
        % % end
        
%         figure;imagesc(BW);colormap(gray);hold on;
% %         for k = 1:ln_asc
% %             xy = [lines_asc_comb(k).point1; lines_asc_comb(k).point2];
% %             plot(xy(:,1),xy(:,2),'LineWidth',1.5,'Color','blue');
% %             a = 1;
% %         end
% %         
% %         for k = 1:ln_desc
% %             xy = [lines_desc_comb(k).point1; lines_desc_comb(k).point2];
% %             plot(xy(:,1),xy(:,2),'LineWidth',1.5,'Color','red');
% %             a = 1;
% %         end
        
          roi = [];
         points_corr = find_intersections(lines_desc_comb,lines_asc_comb);
% %          plot( points_corr(:,1),points_corr(:,2),'*c');
%         plot( points(:,1),points(:,2),'.c');
        
        
        
        
        %   points(1,:) = line_intersect(lines_desc_comb(1),lines_asc_comb(2));
        %      figure;imagesc(BW);colormap(gray);hold on;
        %     xy = [lines_desc_comb(1).point1; lines_desc_comb(1).point2];
        %     plot(xy(:,1),xy(:,2),'LineWidth',1.5,'Color','red');
        %       xy = [lines_asc_comb(2).point1; lines_asc_comb(2).point2];
        %     plot(xy(:,1),xy(:,2),'LineWidth',1.5,'Color','blue');
        %     plot( points(1,1),points(1,2),'.c');
        
        %    a = 1;
        % end
        
        %%Line and 205 ROIs assignment
        % % % % %  points = find_intersections(lines_desc_comb,lines_asc_comb);
        % % % % %
        % % % % % % figure;imagesc(BW);colormap(gray);
        % % % % %
        % % % % % for j=1:205
        % % % % %         for ii=1:4
        % % % % %       plot(roi(j).xy(ii,1),roi(j).xy(ii,2), '.c');
        % % % % %      end
        % % % % % end
        
        % % % roi_cur = roi(45);
        % % % rmax_rows = max(roi_cur.xy(:,2));
        % % % rmin_rows = min(roi_cur.xy(:,2));
        % % % rmax_cols = max(roi_cur.xy(:,1));
        % % % rmin_cols = min(roi_cur.xy(:,1));
        % % % figure; imagesc(BW);colormap(gray);hold on;
        % % % for ii=1:4
        % % %    plot(roi_cur.xy(ii,1),roi_cur.xy(ii,2), 'r*');
        % % % end
        % % % roi_image = BW(rmin_rows:rmax_rows,rmin_cols:rmax_cols);
        % % % figure; imagesc(roi_image);colormap(gray);
        toc
        roi_sz = size(roi);
        lnroi = roi_sz(2)
        file_name
         tic
        for k = 1: lnroi %6
%               kk = k
          
            I_final = double(create_dicom(k, I_dicom));
            I_dicom = I_final;
            
               
            % %     full_file_dicomwrite = ['\\win\bbdg\aaData\Breast Studies\CDMAM\Selenia Feb15\',file_name,num2str(k),'_mod.dcm'];
            % %     I_dcm = uint16(I_dicom);
            % %      dicomwrite(I_dcm, full_file_dicomwrite);
            
        end
        toc
        
        
        a = 1;
        
        I_dicom = uint16(I_dicom);
        full_file_dicomwrite = [parentdir,'\DICOMS_2disks\',file_name,'_2disks10mkm_gaus18corr.dcm'];
         tic
        dicomwrite(I_dicom, full_file_dicomwrite,info_dicom,'CreateMode','copy');
         toc
        %dicomwrite(XX1,fname_towrite,info_dicom_blinded,'CreateMode','copy');
        a = 1;
    end
end
a = 1;

end

%%
% function points = line_intersect(lines_desc_comb,lines_asc_comb)
% %A = [1, 1; -1, 1];
% A = [-1, 1; 1, 1];
% alfa_desc = (lines_desc_comb.point2(2) - lines_desc_comb.point1(2))/(lines_desc_comb.point2(1) - lines_desc_comb.point1(1));
% b_desc = lines_desc_comb.point2(2) - alfa_desc*lines_desc_comb.point2(1);
% alfa_asc = (lines_asc_comb.point2(2) - lines_asc_comb.point1(2))/(lines_asc_comb.point2(1) - lines_asc_comb.point1(1));
% b_asc = lines_asc_comb.point2(2) - alfa_asc*lines_asc_comb.point2(1);
%
% B = [b_desc;b_asc];
% points= A\B;
% end

%%
function points = line_intersect(lines_desc_comb,lines_asc_comb)
%line1
x1  = [lines_desc_comb.point1(1) lines_desc_comb.point2(1)];
y1  = [lines_desc_comb.point1(2) lines_desc_comb.point2(2)];

%line2
x2  = [lines_asc_comb.point1(1) lines_asc_comb.point2(1)];
y2  = [lines_asc_comb.point1(2) lines_asc_comb.point2(2)];


%fit linear polynomial
p1 = polyfit(x1,y1,1);
p2 = polyfit(x2,y2,1);

%calculate intersection
x_intersect = fzero(@(x) polyval(p1-p2,x),3);
y_intersect = polyval(p1,x_intersect);

% figure;
% line(x1,y1);
% hold on;
% line(x2,y2);
% plot(x_intersect,y_intersect,'r*')
points = [x_intersect,y_intersect];
end

