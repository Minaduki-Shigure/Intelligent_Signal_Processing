function [k, time] = chaos_standalone_1()
    tic;
    error = 0.001;
    Lb = -100; Ub = 100; u = 1.99;
    x = rand(1, 2);
    X = Lb + (x + 1) .* (Ub - Lb) / 2;
    Y = shaffer6(X);
    Xmin = X; Ymin = Y;
    k = 0;
    while 0 < 1
        x = nlf_1(x, u);
        X = Lb + (x + 1) .* (Ub - Lb) / 2;
        Y = shaffer6(X);
        if Y < Ymin
            Xmin = X;
            Ymin = Y; % Remove the ; here to see every iteration.
        end
        k = k + 1;
        if Ymin < error
            break
        end
    end
    k;
    Xmin;
    Ymin;
    time = toc;
end

function y = nlf_1(x, u)
    y = 1 - u * x .^ 2;
end

function y = shaffer6(x)
    A = (sin(sqrt(x(1) ^2 + x(2) ^2))) ^2 - 0.5;
    B = (1 + 0.001 * (x(1) ^2 + x(2) ^2)) ^2;
    y = 0.5 + A / B;
end