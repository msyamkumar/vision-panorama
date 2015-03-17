function laplacians = makePyramids(X, n)
    % computes image laplacians
    % X: image
    % n: number of levels
    gaussians{1} = X;
    laplacians = {};
    for i=2:n
        % compute next Gaussian
        gaussians{i} = impyramid(gaussians{i-1}, 'reduce');
        % compute Laplacian
        % size adjustment to deal with expand
        sizes = 2*size(gaussians{i}) - 1;
        G = gaussians{i-1}(1:sizes(1),1:sizes(2),:);
        laplacians{i-1} = G - impyramid(gaussians{i}, 'expand');
    end
    laplacians{n} = gaussians{n};
end