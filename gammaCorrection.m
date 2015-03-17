
 X = imread('/Users/cs/Documents/MATLAB/vision-panorama/doc/images/Capitol/4.JPG');
 Y=gamma_correction(X, [], [0 255], 0.4);
figure,imshow(X);
      figure,imshow((Y),[]);
 