function [ out ] = exposureCorrection( images )
% simple exposure correction to make all images comparably bright

gray_images = {};
num_images = size(images,2);
for i=1:num_images
    gray_images{i} = rgb2gray(images{i});
end

ref = gray_images{1};
ref_intensity = mean(mean(ref));
factors = ones(num_images,1);

for i=2:num_images
    intensity = mean(mean(gray_images{i}));
    factors(i) = ref_intensity/intensity;
end

% alpha = 1;
for i=1:num_images
    images{i} = factors(i) * images{i};
end

out = images;

end