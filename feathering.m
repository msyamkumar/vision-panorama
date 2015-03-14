function [ newimg ] = feathering( cylindrical_images, H )

% Stitches mosaic using feathering-based blending 
% Input:
%   cylindrical_images - input images (cylindrically warped)
%   H - homography


newimg = cylindrical_images(:,:,:,1);
num_images = size(cylindrical_images, 4);

for i=1:num_images-1
    img = cylindrical_images(:,:,:,i+1);
    h = H{i};
    translation = round((h(1,3))/2)*2;
    % get direction from sign of translation
    direction = (translation < 0);
    window_size = 20;
    [m,n,k] = size(img);
    window = zeros(m,window_size+1,k);
    for j=0:window_size
        alpha = j/window_size;
        if (direction == 0)
            window(:,j+1,:) = alpha * newimg(:,(translation-window_size)/2+j,:) + (1-alpha) * img(:,n-(translation-window_size)/2+j,:);
        else
            window(:,j+1,:) = alpha * img(:,(translation-window_size)/2+j,:) + (1-alpha) * newimg(:,size(newimg,2)-(translation-window_size)/2+j,:);
        end
    end
    if (direction == 0)
        newimg = [img(:,1:n-(translation-window_size)/2,:) window newimg(:,(translation+window_size)/2:end,:)];
    else
        newimg = [newimg(:,1:size(newimg,2)-(translation-window_size)/2,:) window img(:,(translation+window_size)/2:end,:)];
    end
end

end

