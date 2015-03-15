function [ H ] = ComputeHomography( firstImgPoints, secondImgPoints )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HEstimation: Given the matching points on both the images,
% computes the homography H between both images
%   Arguments: 
%       firstImgPoints, secondImgPoints - selected matching points
%   Return value:
%       H - homography between the two images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colSize1 = size(firstImgPoints, 2);
colSize2 = size(secondImgPoints, 2);

%Computing matrix A
A = zeros(colSize1 * 3, 9);
for col = 1:colSize1
    startRow = (col - 1) * 3 + 1;
    for j = 1:3
        startCol = (j - 1) * 3 + 1;
        A(startRow + j - 1, startCol) = firstImgPoints(1, col);
        A(startRow + j - 1, startCol + 1) = firstImgPoints(2, col);
        A(startRow + j - 1, startCol + 2) = 1;
    end
end

%Computing matrix b
b = ones(colSize2 * 3);
for col = 1:colSize2
    startRow = (col - 1) * 3 + 1;
    b(startRow) = secondImgPoints(1, col);
    b(startRow + 1) = secondImgPoints(2, col);
end

%Computing h to calculate homography matrix H
h = A\b;
%Changing into 3 * 3 matrix form
H = zeros(3,3);
for col = 1:3
    currStart = (col - 1) * 3 + 1;
    H(col, :) = h(currStart:currStart + 2);
end
    
end