function [ out ] = blendFeathering( img1t, img2t, split )
% Blends two images using feathering blending
% input: original and transformed images

% out = [img2t(:,1:split,:) img1t(:,split+1:end,:)];
% return;

% assume leftward motion for now
isLeft = 1;

% size of window where blending is done
window_size = 100;
[m,n,k] = size(img2t);
window = zeros(m,window_size+1,k);

for j=0:window_size
    alpha = j/window_size;
    if isLeft
        window(:,j+1,:) = (1-alpha) * img2t(:,split - window_size/2 + j,:) + alpha * img1t(:,split - window_size/2 + j,:);
    %else
    %    window(:,j+1,:) = alpha * img(:,(translation-window_size)/2+j,:) + (1-alpha) * newimg(:,size(newimg,2)-(translation-window_size)/2+j,:);
    end
end
if isLeft
    out = [img2t(:,1:split-window_size/2-1,:) window img1t(:,(split + window_size/2 + 1):end,:)];
%else
%    newimg = [newimg(:,1:size(newimg,2)-(translation-window_size)/2,:) window img(:,(translation+window_size)/2:end,:)];
end

end