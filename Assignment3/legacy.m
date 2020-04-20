function [k, time] = legacy()
    tic; error = 0.001; Ymin = 1000000; k = 0;
    while 0 < 1
        [X, Y] = LocalSearch();
        if Y < Ymin
            Ymin = Y; % Remove the ; here to see every iteration.
            Xmin = X;
        end
        if Ymin < error
            break;
        end
        k = k + 1;
    end
    k;
    Xmin
    Ymin
    time = toc;
end

function [X, Y] = LocalSearch()
    f = @(x) 0.5 + ((sin(sqrt(x(1) .^ 2 + x(2) .^ 2))) ^2  - 0.5) ...
        / ...
        (1 + 0.001 * (x(1) .^ 2 + x(2) .^ 2)) ^ 2;
    X0 = 200 * (rand(2, 1) - 0.5);
    X = fminsearch(@(x) f(x), X0);
    Y = f(X);
end