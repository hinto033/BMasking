function [levels, IQF] = genLambdaswNoise(I_dicom_orig, attenuation, radius, atten_disks, thickness, diameter, cutoff, padamnt, noiseamnt)
%% Setting Parms
pmax = length(radius);
kmax = length(attenuation);
[l,w] = size(I_dicom_orig);
conv_image2 = ones(l,w, pmax)*2; 
padamnt;
lambdaCenter = zeros(pmax, kmax);
%%
%  center = I_dicom_orig(start(1):start(1)+2*(padamnt-1), start(2):start(2)+2*(padamnt-1));
% figure
% imshow(center, [])
lambdaSet = zeros(pmax,kmax);
for p = 1:pmax %All diameters
    for k = 1:kmax %All attenuations

        center = I_dicom_orig;%(start(1):start(1)+2*(padamnt-1), start(2):start(2)+2*(padamnt-1));
%         centernoise = centernoise+(noiseamnt * 2*(rand(size(center))-.5)))
       
        bkgr_roi = mean2(center);
        disk_diff = ((bkgr_roi-50)'*(attenuation(k) - 1))';
        neg_disk = atten_disks(:,:,p).*disk_diff;
%         neg_disk = atten_disks(:,:,p).*(neg_disk + (noiseamnt * 2*(rand(size(neg_disk))-.5)));
        

        [a,b] = size(neg_disk);
        

        [lsmall, wsmall] = size(center);
        divider = ceil(lsmall/3);
        
        sect1 = center(1:divider, 1:divider);
        sect2 = center(1:divider, divider+1:(2*(divider+1)));
        sect3 = center(1:divider, (2*(divider+1))+1:lsmall);
        sect4 = center(divider+1:(2*(divider+1)), 1:divider);
        sect5 = center(divider+1:(2*(divider+1)), divider+1:(2*(divider+1)));
        sect6 = center(divider+1:(2*(divider+1)), (2*(divider+1))+1:lsmall);
        sect7 = center((2*(divider+1))+1:lsmall, 1:divider);
        sect8 = center((2*(divider+1))+1:lsmall, divider+1:(2*(divider+1)));
        sect9 = center((2*(divider+1))+1:lsmall, (2*(divider+1))+1:lsmall);
        
        %Maybe instead of resizing just do the padding with
        %reflection?Gives actual noise statistics then
        sect1 = imresize(sect1, [a b]);
        sect2 = imresize(sect2, [a b]);
        sect3 = imresize(sect3, [a b]);
        sect4 = imresize(sect4, [a b]);
        sect5 = imresize(sect5, [a b]);
        sect6 = imresize(sect6, [a b]);       
        sect7 = imresize(sect7, [a b]);
        sect8 = imresize(sect8, [a b]);
        sect9 = imresize(sect9, [a b]);
        
        
        ms1 = mean2((sect1+sect3+sect5+sect7+sect9)/5);
        ms2 = mean2((sect2+sect4+sect5+sect6+sect8)/5);
        
        
%         size(neg_disk)
        gs = ((sect1+sect3+sect5+sect7+sect9)/5)-(neg_disk);% +(noiseamnt * 2*(rand(size(center))-.5)));
        gs = gs+(noiseamnt * 2*(rand(size(gs))-.5));

        gn = ((sect2+sect4+sect5+sect6+sect8)/5)  + (ms1-ms2);
        gn = gn+(noiseamnt * 2*(rand(size(gs))-.5));
        w = (gs-gn); %This is probably actually the correct one


        
        center = imresize(center, [a b]);

        gtest = (center -neg_disk);  %Should be + Neg_disk
        gtest = gtest + (noiseamnt * 2*(rand(size(gtest))-.5));
        

        if p==2 && k ==1
            figure
            imshow(gtest, [])
        end
%         figure
%         surf(gtest)
        lambda = abs(w(:)'*gtest(:));

        lambdaSet(p,k) = lambda;

        

    end
end

levels = lambdaSet;
% cdData
IQF = 2
% IQFImage(start(1):start(1)+2*(padamnt-1), start(2):start(2)+2*(padamnt-1)) = IQF;

end






% % % % % % % % %% New Section fixed bias term...THIS SHOULD BE MOST ACCURATE< CUrrently, wrong
% % % % % % % % for p = 1:pmax %All diameters
% % % % % % % %     for k = 1:kmax %All attenuations
% % % % % % % %         neg_disk = atten_disks(:,:,p);
% % % % % % % %         pos_disk = -neg_disk;
% % % % % % % %         atten_img = ((I_dicom_orig-50)'*(attenuation(k) - 1))';
% % % % % % % %         atten_img_squared = atten_img.*atten_img;
% % % % % % % %         
% % % % % % % %         
% % % % % % % % 
% % % % % % % %         if diameter(p)>=2 %If diameter of disk is greater or equal to 2 mm ->Do FFT
% % % % % % % %         tic
% % % % % % % %         origpad = padarray(I_dicom_orig,[padamnt padamnt],'symmetric','both');
% % % % % % % %         [a,b] = size(origpad);
% % % % % % % %         D1 = fft2(origpad, a, b);
% % % % % % % %         D2 = fft2(pos_disk, a, b);
% % % % % % % %         D3 = D1.*D2;
% % % % % % % %         D4 = ifft2(D3);
% % % % % % % %         imageunpad = D4(2*padamnt+1:2*padamnt+l, 2*padamnt+1:2*padamnt+w);
% % % % % % % %         tissue_img2a = atten_img.*imageunpad;
% % % % % % % % 
% % % % % % % %         attenimgsquaredpad = padarray(atten_img_squared,[padamnt padamnt],'symmetric','both');
% % % % % % % %         [a,b] = size(attenimgsquaredpad);
% % % % % % % %         D1 = fft2(attenimgsquaredpad, a, b);
% % % % % % % %         D2 = fft2(neg_disk, a, b);
% % % % % % % %         D2(find(D2 == 0)) = 1e-6;
% % % % % % % %         D3 = D1.*D2;
% % % % % % % %         D4 = ifft2(D3);
% % % % % % % %         tissue_img2b = D4(2*padamnt+1:2*padamnt+l, 2*padamnt+1:2*padamnt+w);
% % % % % % % %         
% % % % % % % %         teststatimg2 = tissue_img2a + tissue_img2b;
% % % % % % % %         teststatimg = teststatimg2;
% % % % % % % %         size(teststatimg)
% % % % % % % %         toc
% % % % % % % %         diameter(p)
% % % % % % % %         elseif diameter(p)<2 %Do Conv if diameter less than 2 mm
% % % % % % % %                    % USE THIS TO SPEED UP THE SSECTION OF CODE with small disks
% % % % % % % %         tic
% % % % % % % %         conv_tissue = conv2(I_dicom_orig,pos_disk, 'same' ); %Maybe Valid
% % % % % % % %         tissue_img = atten_img.*conv_tissue;
% % % % % % % %         toc
% % % % % % % %         tic
% % % % % % % %         disk_img = conv2(atten_img_squared,neg_disk, 'same' ); %Maybe Valid
% % % % % % % %         toc
% % % % % % % %         
% % % % % % % %         diameter(p)
% % % % % % % %         teststatimg = tissue_img + disk_img;
% % % % % % % %         size(teststatimg)
% % % % % % % %             
% % % % % % % %         end
% % % % % % % %         
% % % % % % % % 
% % % % % % % %         [a,b] = size(teststatimg);
% % % % % % % %         
% % % % % % % %         center = [(round(a+1)/2), round((b+1)/2)];
% % % % % % % %         lambda = teststatimg(center(1), center(2))
% % % % % % % %         lambdaCenter(p,k) = lambda;
% % % % % % % %  
% % % % % % % % 
% % % % % % % %     end
% % % % % % % % end
% % % % % % % % 
% % % % % % % % levels = lambdaCenter
% % % % % % % % IQF = 0
% pause
% %% Calculate Full IQF
% [l,w,v] = size(conv_image2);
% aBase = ones(l,w);
% A = zeros(l,w,pmax);
% for m = 1:pmax
%    A(:,:,m) = aBase*diameter(m);
% end
% n = pmax;
% IQFdenom = dot(A,conv_image2, 3);
% IQF = sum(diameter(:))./IQFdenom;  %originally n./IQFdenom;, but this way normalizes for different ranges
% %% Calculate Subset IQFs
% IQFLargeDenom = dot(A(:,:,1:6),conv_image2(:,:,1:6), 3);
% IQFMedDenom = dot(A(:,:,7:12),conv_image2(:,:,7:12), 3);
% IQFSmallDenom = dot(A(:,:,13:20),conv_image2(:,:,13:20), 3);
% IQFLarge = sum(diameter(1:6))./IQFLargeDenom;
% IQFMed = sum(diameter(7:12))./IQFMedDenom;
% IQFSmall = sum(diameter(13:20))./IQFSmallDenom;
% %% Set areas where i'll do calculations
% maskingmap = I_dicom_orig;
% % threshold 
% maskingmap=maskingmap./max(maskingmap(:));
% maskingmap = im2bw(maskingmap,0.2);
% maskingmap = imcomplement(maskingmap);
% IQF = IQF .* maskingmap;
% IQFLarge = IQFLarge .* maskingmap;
% IQFMed = IQFMed .* maskingmap;
% IQFSmall = IQFSmall .* maskingmap;
% %%
% levels = conv_image2;
% levels = levels(padamnt:l-padamnt, padamnt:w-padamnt,:);
% IQF = IQF(padamnt:l-padamnt, padamnt:w-padamnt);
% IQFLarge = IQFLarge(padamnt:l-padamnt, padamnt:w-padamnt);
% IQFMed = IQFMed(padamnt:l-padamnt, padamnt:w-padamnt);
% IQFSmall = IQFSmall(padamnt:l-padamnt, padamnt:w-padamnt);
% figure
% imshow(IQF, [])
% figure
% imshow(IQFLarge, [])
% figure
% imshow(IQFMed, [])
% figure
% imshow(IQFSmall, [])
% pause

