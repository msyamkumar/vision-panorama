function [ output_args ] = extractSIFTFeaturs ( image1, image2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


grayImg1 = toGrayScale(image1);
grayImg2 = toGrayScale(image2);

[sift1, d1] = vl_sift(grayImg1);
[sift2, d2] = vl_sift(grayImg2);

%imwrite(grayImg1, '/Users/cs/Documents/MATLAB/vision_panaroma/gray1.jpg');
%imwrite(grayImg2, '/Users/cs/Documents/MATLAB/vision_panaroma/gray2.jpg');


end

