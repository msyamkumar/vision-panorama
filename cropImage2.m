function [ out ] = cropImage2( image )
% crops image (mosaic) to remove rows/columns on edges with black pixels

[m,n,k] = size(image);

x_min = 1;
x_max = n;
y_min = 1;
y_max = m;

x_threshold = 50;
y_threshold = 5;

function out = isBlack( pixel )
    out = 1;
    for c=1:3
        if pixel(c) ~= 0
            out = 0;
        end
    end
end

for i=1:n
    num_blacks = 0;
    truncate = 0;
    for j=1:m
        if isBlack(image(j,i,:))
            num_blacks = num_blacks + 1;
        else
            num_blacks = 0;
        end
        if num_blacks > x_threshold
            truncate = 1;
            break;
        end
    end
    if truncate
        x_min = i+1;
        continue;
    else
        break;
    end
end

for i=n:-1:1
    num_blacks = 0;
    truncate = 0;
    for j=1:m
        if isBlack(image(j,i,:))
            num_blacks = num_blacks + 1;
        else
            num_blacks = 0;
        end
        if num_blacks > x_threshold
            truncate = 1;
            break;
        end
    end
    if truncate
        x_max = i-1;
        continue;
    else
        break;
    end
end

for j=1:m
    num_blacks = 0;
    truncate = 0;
    for i=1:n
        if isBlack(image(j,i,:))
            num_blacks = num_blacks + 1;
        else
            num_blacks = 0;
        end
        if num_blacks > y_threshold
            truncate = 1;
            break;
        end
    end
    if truncate
        y_min = j+1;
        continue;
    else
        break;
    end
end

for j=m:-1:1
    num_blacks = 0;
    truncate = 0;
    for i=1:n
        if isBlack(image(j,i,:))
            num_blacks = num_blacks + 1;
        else
            num_blacks = 0;
        end
        if num_blacks > y_threshold
            truncate = 1;
            break;
        end
    end
    if truncate
        y_max = j-1;
        continue;
    else
        break;
    end
end

out = image(y_min:y_max, x_min:x_max, :);

end

