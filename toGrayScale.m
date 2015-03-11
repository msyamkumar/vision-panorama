function [ grayScale ] = toGrayScale ( image )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%toGrayScale: Converts the given image pixel values to Gray Scale
%   Argument: 
%       image - pixel values of some image read using readImagePixels.m
%   Return value:
%       grayScale - the pixel values of the given image in gray scale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

grayScale = rgb2gray(image);
grayScale = single(grayScale);
grayScale = uint8(grayScale);

end

