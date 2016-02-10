function [results] = circle_roi2(center_xy, radius,im_size)
%global I
im_size = [2*ceil(radius)+1,2*ceil(radius)+1];
% im_size = size(I);
imageSizeX = im_size(2);
imageSizeY = im_size(1);
[columnsInImage, rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
% Next create the circle in the image.
centerX = radius+1;
centerY = radius+1;
% radius = 100;
circlePixels = (rowsInImage - centerY).^2 + (columnsInImage - centerX).^2 <= radius.^2;
% circlePixels is a 2D "logical" array.
% Now, display it.
% % 
% figure;image(circlePixels) ;
% colormap([0 0 0; 1 1 1]);
% % title('Binary image of a circle');
%imshow(circlePixels)
end
