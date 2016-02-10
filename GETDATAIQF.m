


[FileName,PathName,FilterIndex] = uigetfile;

    handles.filename = FileName;
    handles.pathname = PathName;
    handles.filterIndex = FilterIndex;
full_file_png = [handles.pathname,'\',FileName];
I  = double(imread(full_file_png));

figure
imshow(I,[])

I = -log(I/12314)*10000; 

figure
imshow(I,[])

% openfig('MaskingImage_1029_DCM7_1.8.16_20Max2.fig');
% 
% openfig('MaskingImage_1030_DCM7_1.8.16_20Max2.fig');

% h = openfig('Masking_1015_DCM7_1.7.16v03EDITED.fig');


% % % % % % % % % hgload('MaskingImage_1030_DCM7_1.8.16_20Max.fig');
% % % % % % % % % rectdense = getrect
% % % % % % % % % rectnotdense = getrect
% % % % % % % % % % pause
% % % % % % % % % myhandle = findall(gcf,'type','image');
% % % % % % % % % data = get(myhandle,'cdata');
% % % % % % % % % 
% % % % % % % % % datadense = data(rectdense(2):rectdense(2)+rectdense(4),rectdense(1):rectdense(1)+rectdense(3))
% % % % % % % % % datanotdense = data(rectnotdense(2):rectnotdense(2)+rectnotdense(4),rectnotdense(1):rectnotdense(1)+rectnotdense(3))
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % expecteddense = ceil((rectdense(4)*rectdense(3)) / 400) +1
% % % % % % % % % expectednotdense = ceil((rectnotdense(4)*rectnotdense(3)) / 400) +1
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % denseunique = unique(datadense);
% % % % % % % % % notdenseunique = unique(datanotdense);
% % % % % % % % % 
% % % % % % % % % size(denseunique)
% % % % % % % % % size(notdenseunique)
% 
% 
% XData=get(h);

% hdense = h(rectdense(1):rectdense(1)+rectdense(3),rectdense(2):rectdense(2)+rectdense(4))

% dense = h(100:1000, 100:1000)
% notdense = h(100:1000, 100:1000)
% imshow(dense)

