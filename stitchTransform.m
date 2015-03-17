function [ img1t, img2t, split ] = stitchTransform( img1, img2, translation )
% intermediate stitching step
% returns transformed but unblended images and a suitable stitching point

% only use translation along x-axis
h = eye(3);
h(1,3) = translation;
    
% transpose to match MATLAB convention
% xdataimg2t and ydataimg2t : bounds of the transformed img2
T = maketform('projective', h');
[img2t, xdataimg2t, ydataimg2t] = imtransform(img2, T);

% compute bounds of output image
xdataout = [min(1,xdataimg2t(1)) max(size(img1,2),xdataimg2t(2))];
ydataout = [min(1,ydataimg2t(1)) max(size(img1,1),ydataimg2t(2))];

% transform both images with the computed xdata and ydata
img2t = imtransform(img2,T,'XData',xdataout,'YData',ydataout);
img1t = imtransform(img1,maketform('affine',eye(3)), ...
    'XData',xdataout,'YData',ydataout);

% find merge point: assume isLeft for now
split = round((xdataimg2t(2) + 1)/2 - xdataout(1));

end

