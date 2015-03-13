function [ output_args ] = PanoramaMain ( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% 
img = imread('/Users/cs/Documents/MATLAB/vision-hdr-data/Pictures/Ceiling 2/IMG_4504.JPG') ;
image(img);

imshow(img);

grayImg1 = toGrayScale(img);
imshow(grayImg1);

% 
% I = vl_impattern('roofs1') ;
% image(I) ;
% imshow(I);
% 
% %extractSIFTFeaturs(I);
% 
% I = single(rgb2gray(I)) ;
% imshow(I);
% [f,d] = vl_sift(I) ;
% 
% perm = randperm(size(f,2)) ;
% sel = perm(1:50) ;
% h1 = vl_plotframe(f(:,sel)) ;
% h2 = vl_plotframe(f(:,sel)) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;

end

