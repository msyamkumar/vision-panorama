function [ output_args ] = warpToCylindrical( image, f )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%warpToCylindrical: Shift all images on pixelVals by the calculated shifts
%   Argument: 
%       shifts - shifts for individual images with respect to reference
%       image
%       pixelVals - pixel values for the original images
%   Return value:
%       shiftedPixelVals - shifted image pixels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rowSize = size(image, 1);
colSize = size(image, 2);

xc = colSize / 2;
yc = rowSize / 2;

for row = 1:rowSize
    for col = 1:colSize
        theta = atan((col - xc) / f);
        h = (row - yc) / sqrt((col - xc)^2 + f^2);
        
    end
end

end

