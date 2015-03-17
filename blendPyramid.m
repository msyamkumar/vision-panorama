function [ out ] = blendPyramid( I1, I2 )
% executes pyramid blending of images A and B
% images must be of the same size
% blending is done at the midpoint

I1 = im2double(I1);
I2 = im2double(I2);

levels = 5;
mask_size = 20;

% compute image pyramids
L1 = makePyramids(I1, levels);
L2 = makePyramids(I2, levels);

% weight matrices
[m,n,~] = size(I1);
midpoint = floor(n/2);
offset = 0;
if mod(n,2) == 1
    offset = 1;
end

W1 = zeros(m,n,3);
W1(:,1:midpoint - mask_size/2,:) = ones(m,midpoint - mask_size/2,3);
W1(:,midpoint - mask_size/2 + ~offset:midpoint + mask_size/2,:) = 0.5 * ones(m,mask_size + offset,3);
W2 = ones(m,n,3) - W1;

L = {};
for j=1:levels
    L{j} = L1{j} .* imresize(W1,[size(L1{j},1) size(L1{j},2)]) ...
        + L2{j} .* imresize(W2,[size(L1{j},1) size(L1{j},2)]);
end
G{levels} = L{levels};
for j=levels:-1:2
    g = impyramid(G{j}, 'expand');
    G{j-1} = g + imresize(L{j-1},[size(g,1) size(g,2)]);
end
out = G{1};

end

