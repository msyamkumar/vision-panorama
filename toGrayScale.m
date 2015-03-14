function [ grayScale ] = toGrayScale ( image )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%toGrayScale: Converts the given image pixel values to Gray Scale
%   Argument: 
%       image - pixel values of some image read using readImagePixels.m
%   Return value:
%       grayScale - the pixel values of the given image in gray scale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The vl_sift command requires a single precision gray scale image.
grayScale = rgb2gray(image);
grayScale = single(grayScale);

end

