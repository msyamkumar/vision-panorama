function [ output_args ] = extractSIFTFeaturs ( image1)%, image2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

grayImg1 = toGrayScale(image1);
%grayImg2 = toGrayScale(image2);

[f, d] = vl_sift(grayImg1);
%[f2, d2] = vl_sift(grayImg2);

perm = randperm(size(f,2)) ;
sel = perm(1:50) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

% h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
% set(h3,'color','g') ;

imwrite(grayImg1, '/Users/cs/Documents/MATLAB/vision_panaroma/gray1.jpg');
%imwrite(grayImg2, '/Users/cs/Documents/MATLAB/vision_panaroma/gray2.jpg');


end

