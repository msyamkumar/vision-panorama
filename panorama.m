% master script for running panorama implementation

%% load image metadata
disp('Loading image list...');
% dir = strcat('data/1/');
dir = strcat('/Users/akshaysood/Box Sync/CS766/Panorama/data/1/');
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
    image_name = strcat(dir,image_names{i});
    A = imread(image_name);
    images(:,:,:,i) = A;
end

disp('Done.');

%% warp to cylindrical coordinates
disp('Warping to cylindrical coordinates...');

% focal length in pixels (SEE how to determine)
f = 595;

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

vlfeat_startup;

for i=1:num_images-1
    img1 = cylindrical_images(:,:,:,i);
    img2 = cylindrical_images(:,:,:,i+1);
    % homography estimation
    H{i} = homographyEstimation(img1, img2);
end
disp('Done.');

%% stitch/crop into final image
disp('Stitching/cropping into final image...');

mosaic = feathering(cylindrical_images, H);

disp('Done.');