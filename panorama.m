% master script for running panorama implementation
clear all;
close all;
clc;

%% load image metadata
disp('Loading image list...');
dir = strcat('data/Capitol/');

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
images = {};

for i=1:num_images
    disp(image_names{i});
    image_name = strcat(dir,image_names{i});
    A = imread(image_name);
    images{i} = A;
end

disp('Done.');

%% Exposure correction
% disp('Executing exposure correction...');
% images = exposureCorrection(images);
% disp('Done.');

%% warp to cylindrical coordinates
disp('Warping to cylindrical coordinates...');

% focal length in pixels
%f = 660.8799;
f = 682.05069;
% f = 595;

% assumes all cropped images (with black pixels truncated) of the same size
A = warpToCylindrical(images{1},f);
cylindrical_images = {};
cylindrical_images{1} = A;

for i=2:num_images
    A = images{i};
    cylindrical_images{i} = warpToCylindrical(A,f);
end
disp('Done.');

%% estimate homography between each adjacent pair
disp('Estimating homographies...');

warning('off','all');
vlfeat_startup;

%Left orientation
isLeft = 1;

for i=1:num_images-1
    img1 = cylindrical_images{i};
    img2 = cylindrical_images{i+1};
    % homography estimation
    if isLeft
        % H{i} = homographyAlternative(img2, img1);
        H{i} = homographyEstimation(img2, img1);
    else
        % H{i} = homographyAlternative(img1, img2);
        H{i} = homographyEstimation(img1, img2);
    end 
end
disp('Done.');

%% stitch/crop into final image
disp('Stitching/cropping into final image...');
clear mosaic;
mosaic = cylindrical_images{1};

for i=1:num_images-1
    % stitching
    img1 = mosaic;
    img2 = cylindrical_images{i+1};

    [img1t, img2t, split] = stitchTransform(img1, img2, H{i}(1,3));
    mosaic = blendFeathering(img1t, img2t, split);
    
end

% cropping
cropped = cropImage2(mosaic);

imshow(mosaic);
imwrite(mosaic, 'panorama.jpg');
imwrite(mosaic, strcat(dir, 'panorama.jpg'));

disp('Done.');
