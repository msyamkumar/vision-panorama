% master script for running panorama implementation
clear all;
close all;
clc;

%% load image metadata
disp('Loading image list...');
dir = strcat('/Users/akshaysood/Box Sync/CS766/Panorama/data/1/');
% dir = strcat('/Users/akshaysood/Box Sync/CS766/Panorama/Pictures/Latest Pics/CapitolRoofWithRail - small size photos - require different focal length/');
% dir = strcat('/Users/cs/Desktop/CS766/HW2/newPhotosSmallSize/Bridge/');
% dir = strcat('/Users/cs/Desktop/CS766/HW2/Pictures/Bridge2/');

imlistfile = strcat(dir, 'image_list.txt');
image_names = importdata(imlistfile);

% number of images
num_images = size(image_names,1);

disp('Done.');

%% load images
disp('Loading images...');
A = imread(strcat(dir,image_names{1}));
m = size(A,1);
n = size(A,2);
images = zeros(m,n,3,num_images);

for i=1:num_images
    disp(image_names{i});
    image_name = strcat(dir,image_names{i});
    A = imread(image_name);
    images(:,:,:,i) = A;
end

disp('Done.');

%% warp to cylindrical coordinates
disp('Warping to cylindrical coordinates...');

% focal length in pixels
%f = 660.8799;
f = 682.05069;
%f = 595;

% assumes all cropped images (with black pixels truncated) of the same size
A = warpToCylindrical(images(:,:,:,1),f);
cylindrical_images = uint8(zeros(size(A,1), size(A,2), size(A,3), ...
    num_images));
cylindrical_images(:,:,:,1) = A;

for i=2:num_images
    A = images(:,:,:,i);
    cylindrical_images(:,:,:,i) = warpToCylindrical(A,f);
end
disp('Done.');

%% estimate homography between each adjacent pair
disp('Estimating homographies...');

%vlfeat_startup;

%Left orientation
isLeft = 1;

for i=1:num_images-1
    img1 = cylindrical_images(:,:,:,i);
    img2 = cylindrical_images(:,:,:,i+1);
    % homography estimation
    if isLeft
        H{i} = homographyEstimation(img2, img1);
    else
        H{i} = homographyEstimation(img1, img2);
    end 
end
disp('Done.');

%% stitch/crop into final image
disp('Stitching/cropping into final image...');
clear mosaic;
mosaic = cylindrical_images(:,:,:,1);

for i=1:num_images-1
    % stitching
    img1 = mosaic;
    img2 = cylindrical_images(:,:,:,i+1);
    h = H{i};
    % transpose to match MATLAB convention
    T = maketform('projective', h');
    [img2t, xdataimg2t, ydataimg2t] = imtransform(img2, T);
    % xdataimg2t and ydataimg2t : bounds of the transformed img2
    xdataout=[min(1,xdataimg2t(1)) max(size(img1,2),xdataimg2t(2))];
    ydataout=[min(1,ydataimg2t(1)) max(size(img1,1),ydataimg2t(2))];
    % transform both images with the computed xdata and ydata
    img2t = imtransform(img2,T,'XData',xdataout,'YData',ydataout);
    img1t = imtransform(img1,maketform('affine',eye(3)), ...
        'XData',xdataout,'YData',ydataout);
    % blending
    mosaic = blendFeathering(img1, img2, img1t, img2t);
end

%mosaic = feathering(cylindrical_images, H);
%mosaic = CreateStitchedImage(cylindrical_images, H);

imwrite(mosaic, 'panorama.jpg');

disp('Done.');