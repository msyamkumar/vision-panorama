function [ out ] = blending( cylindrical_images, H )
% master stitching/blending/cropping function

num_images = size(cylindrical_images, 2);
% keep power-of-2 images
% hardcode for now
num_images = 16;

candidates = cylindrical_images;
num_candidates = num_images;
k = 0;

while (num_candidates > 1)
    new_candidates = {};
    c = 1;
    d = 2^k;
    for i=1:2:num_candidates
        h = H{d};
        % hack to fix translation
        translation = -size(candidates{i+1}, 2) -h(1,3);
        [I1, I2, ~] = stitchTransform(candidates{i}, candidates{i+1}, translation);
        new_candidates{c} = blendPyramid(I2, I1);
        c = c+1;
        d = d+2^(k+1);
    end
    candidates = new_candidates;
    num_candidates = size(candidates, 2);
    k = k+1;
end

out = candidates{1};

end