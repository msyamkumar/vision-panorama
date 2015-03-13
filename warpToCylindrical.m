function [ cylindricalImg ] = warpToCylindrical( image, f )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%warpToCylindrical: Computes the inverse map to warp the image 
%into the cylindrical coordinates
%   Argument: 
%       image - given input image pixels
%       f - focal length estimate
%   Return value:
%       newImg - inverse map to cylindrical coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rowSize = size(image, 1);
colSize = size(image, 2);

%Center values
xc = colSize / 2;
yc = rowSize / 2;

newImg = zeros(rowSize, colSize, 3);

for row = 1:rowSize
    for col = 1:colSize
        %Calculating theta and h
        theta = atan((col - xc) / f);
        h = (row - yc) / sqrt((col - xc)^2 + f^2);
        
        %Calculating cylindrical image co-ordinates
        xcap = round(f * theta + xc);
        ycap = round(f * h + yc);
        
        newImg(ycap, xcap, :) = image(row, col, :);
        
    end
end

newImg = uint8(newImg);
%Cropping unwanted black pixels
cylindricalImg = cropImage(newImg);

%imwrite(newImg, '/Users/cs/Documents/MATLAB/vision_panaroma/myCylindrical.jpg');
%imwrite(cylindricalImg, '/Users/cs/Documents/MATLAB/vision_panaroma/myCylCrop.jpg');

end

