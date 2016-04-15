 
 % load the images
%  images    = cell(48,1);

%   testimages    = cell(48,1);
% % %  As for drawing a white square or rectangle around th
% e white dot, you could just manipulate the three images after you've resized
% them, executing code to draw four white lines. For example, we could draw
% the white rectangle for the first image as
% % % 
% % %  images{1}(100,85:145,:)  = 255;
% % %  images{1}(150,85:145,:)  = 255;
% % %  images{1}(100:150,85,:)  = 255;
% % %  images{1}(100:150,145,:) = 255
% % %  


 
%  images{2} = imread('im2.png');
%  images{3} = imread('im3.png');

% % % % 
% % % % % create the video writer with 1 fps
% % % %  writerObj = VideoWriter('myVideo_HardToSee1.avi');
% % % %  writerObj.FrameRate = 2;
% % % %  % set the seconds per image
% % % %  secsPerImage = ones(48,1)*0.25;
% % % %  % open the video writer
% % % %  open(writerObj);
% % % %  % write the frames to the video
% % % %  length(images)
% % % %  for u=1:length(images)
% % % %      % convert the image to a frame
% % % % 
% % % % %      map =    uint8( 256 * gray(256) );
% % % % %      frame = images{u};
% % % % 
% % % % %      for v=1:secsPerImage(u) 
% % % % %          writeVideo(writerObj, frame);
% % % % %      end
% % % %  end

 % close the writer object
%  close(writerObj);

% figure
% Z = peaks;
% surf(Z)
% axis tight manual
% ax = gca;
% ax.NextPlot = 'replaceChildren';
% 
% 
% loops = 40;
% F(loops) = struct('cdata',[],'colormap',[]);
% for j = 1:loops
%     X = sin(j*pi/10)*Z;
%     surf(X,Z)
%     drawnow
%     F(j) = getframe;
% end
% 
% movie(F,2)


% % % % figure
% % % %  for j = 1:48
% % % %     imgfile = sprintf('1029_DCM7_Video_%1.0f_1138_986.png', j);
% % % %     full_file_png = ['Hard to See','\',imgfile];
% % % %     images = imread(full_file_png);
% % % %     imshow(images)
% % % % %     pause
% % % %     class(images);
% % % %     drawnow
% % % %     F(j) = getframe;
% % % % 
% % % %  end
% % % % %  figure
% % % % %   movie(F,2,5)
% % % % v = VideoWriter('HARDTOSEE.avi')
% % % % v.FrameRate = 2
% % % % open(v)
% % % % writeVideo(v,F)
% % % % close(v)





figure
 for j = 1:48
    imgfile = sprintf('1029_DCM7_Video_%1.0f_1138_986.png', j);
    full_file_png = ['Hard to See','\',imgfile];
    images = imread(full_file_png);
    size(images)
    imshow(images(500:1500,600:1500))%,[0,20])
%     pause
    class(images);
    drawnow
    F(j) = getframe;

 end

v = VideoWriter('HARDTOSEE_Zoomed_2fps.avi')
v.FrameRate = 2
open(v)
writeVideo(v,F)
close(v)

