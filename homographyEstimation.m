function [ H ] = homographyEstimation ( image1, image2 )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% homographyEstimation: extracts SIFT features using vl_feat and 
%                       estimates homography using RANSAC
%   Arguments: 
%       image1, image2 - given input images in UINT8
%   Return value:
%       H - homography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SIFT matches

%Converting images to gray scale, Reason: The vl_sift command requires a single precision gray scale image.
grayImg1 = toGrayScale(image1);
grayImg2 = toGrayScale(image2);

[f1, d1] = vl_sift(grayImg1);
[f2, d2] = vl_sift(grayImg2);

[matches, scores] = vl_ubcmatch(d1, d2, 1.5);

%% Removing outlier matches to handle drift problem

%Determining which image has minimum column size
colSize1 = size(image1, 2);
colSize2 = size(image2, 2);
minColSize = min([colSize1, colSize2]);

%Maximum possible overlap for matching points could be the min column size
maxOverlap = minColSize;

matchRowSize = size(matches, 1);
matchColSize = size(matches, 2);
newMatches = zeros(matchRowSize, matchColSize);
newMatchCol = 1;

for col = 1:matchColSize 
    match1 = matches(1, col);
    match2 = matches(2, col);
    frame2 = f2(1, match2);

    if(frame2 >= colSize2 - maxOverlap)
        % Retaining inliers
        newMatches(1, newMatchCol) = match1;
        newMatches(2, newMatchCol) = match2;
        newMatchCol = newMatchCol + 1;
    end
end
matches = newMatches(:, 1:(newMatchCol - 1));

%% RANSAC with homography model

%Number of feature pairs
n = 4;
epsilon = 5; 

%Determining k value for repeating RANSAC k number of times
P = 0.99;
p = 0.2;
k = round(log(1 - P) / log(1 - (p ^ n)));

H = zeros(3,3);
maxinliers = 0;

%Run k times
for i = 1:k
    %Draw n samples randomly
    [points] = datasample(matches, n, 2); 
    
    %Frames corresponding to the chosen samples
    firstImgPoints = zeros(2, n);
    secondImgPoints = zeros(2, n);
    for j = 1:size(points, 2);
        firstImgPoints(:, j) = f1(1:2, points(1, j));
        secondImgPoints(:, j) = f2(1:2, points(2, j));
    end
    
    %Compute homography H (exact)
    exactHomography = ComputeHomography(firstImgPoints, secondImgPoints);
    
    %Clearing previous iteration values
    clear inlierpoints1;
    clear inlierpoints2;
    
    %Compute inliners where SSD(pi', Hpi) < epsilon
    c = 0;
    for index = 1:matchColSize
        point1 = zeros(3);
        point1(1:2) = f1(1:2, matches(1, index));
        point1(3) = 1;
        
        point2predicted = exactHomography * point1;
        
        point2 = zeros(3);
        point2(1:2) = f2(1:2, matches(2, index));
        point2(3) = 1;
        
        %Computing 2-norm distance
        distance = norm(point2predicted - point2);
        if (distance < epsilon)
            %Considering the point to be inlier
            c = c + 1;
            inlierpoints1(1:2,c) = point1(1:2);
            inlierpoints2(1:2,c) = point2(1:2);
        end
    end
    
    %Record the largest set of inliers so far
    if (c > maxinliers)
        maxinliers = c;
        %Re-compute least-squares H estimate on the largest set of inliers
        newHomography = ComputeHomography(inlierpoints1, inlierpoints2);
        H = newHomography;
    end
end

end

