function [ cylindricalImg ] = warpToCylindrical( image, f )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%warpToCylindrical: Computes the inverse map to warp the image 
%into the cylindrical coordinates
%   Arguments: 
%       image - given input image pixels
%       f - focal length estimate in pixels
%   Return value:
%       newImg - inverse map to cylindrical coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rowSize = size(image, 1);
colSize = size(image, 2);

%Center values
xc = colSize / 2;
yc = rowSize / 2;

newImg = zeros(rowSize, colSize, 3);

for row = 1:rowSize
    for col = 1:colSize
        % Centered coordinates on image plane 
        x = col - xc;
        y = row - yc;

        % Calculating theta and h
        theta = atan(x / f);
        h = y / sqrt(x^2 + f^2);
        
        % Calculating cylindrical image co-ordinates
        xcap = round(f * theta + xc);
        ycap = round(f * h + yc);
        
        newImg(ycap, xcap, :) = image(row, col, :);
    end
end

newImg = uint8(newImg);

% Cropping unwanted black pixels
cylindricalImg = cropImage(newImg);

end

