function [ croppedImg ] = cropImage ( image )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cropImage: Crops the image by eliminating the black pixels
%   Argument: 
%       image - given input image pixels
%   Return value:
%       croppedImg - cropped image after removing blacked out parts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    rowSize = size(image,1);
    colSize = size(image,2);
    
    %For obtaining number of rows and columns after cropping
    newRowSize = rowSize;
    newColSize = colSize;
    
    leftMargin = 0;
    topMargin = 0;
    rightMargin = colSize;
    bottomMargin = rowSize;
    
    %Removing black pixels from left side of the image
    for col = 1:colSize
        nonBlackPix = 0;
        for row = 1:rowSize
           %Checking if current pixel is black
           if(image(row, col, 1) + image(row, col, 2)+image(row, col, 3) ~= 0)
              nonBlackPix = nonBlackPix + 1;               
           end
        end
        if(nonBlackPix == 0)
           %Moving left margin to right side and reducing number of columns
           %by 1
           leftMargin = leftMargin + 1;
           newColSize = newColSize - 1;   
        else
           break;
        end        
    end
    
    %Removing black pixels from right side of the image
    for col = colSize:-1:1 
        nonBlackPix = 0;
        for row = 1:rowSize
           %Checking if current pixel is black
           if(image(row, col, 1) + image(row, col, 2)+ image(row, col, 3) ~= 0)
              nonBlackPix = nonBlackPix + 1;               
           end
        end
        if(nonBlackPix == 0)
           %Moving right margin to left side and reducing number of columns
           %by 1
           rightMargin = rightMargin - 1;
           newColSize = newColSize - 1;   
        else
           break;
        end        
    end
    
    %Removing black pixels from top side of the image
    for row = 1:rowSize
        nonBlackPix = 0;
        for col = 1:colSize
           %Checking if current pixel is black
           if(image(row, col, 1) + image(row, col, 2)+image(row, col, 3) ~= 0)
              nonBlackPix = nonBlackPix + 1;               
           end
        end
        if(nonBlackPix == 0)
           %Moving left margin to right side and reducing number of columns
           %by 1
           topMargin = topMargin + 1;
           newRowSize = newRowSize - 1;   
        else
           break;
        end        
    end
    
    %Removing black pixels from bottom side of the image
    for row = rowSize:-1:1 
        nonBlackPix = 0;
        for col = 1:colSize
           %Checking if current pixel is black
           if(image(row, col, 1) + image(row, col, 2)+ image(row, col, 3) ~= 0)
              nonBlackPix = nonBlackPix + 1;               
           end
        end
        if(nonBlackPix == 0)
           %Moving right margin to left side and reducing number of columns
           %by 1
           bottomMargin = bottomMargin - 1;
           newRowSize = newRowSize - 1;   
        else
           break;
        end        
    end

    croppedImg = imcrop(image, [leftMargin topMargin newColSize newRowSize]);
    %imwrite(croppedImg, '/Users/cs/Documents/MATLAB/vision-panorama/myCylCrop.jpg');

end


