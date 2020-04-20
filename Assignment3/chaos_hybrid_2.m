function [k, time] = hybrid_2()
    tic;
    error = 0.001;
    Lb = -100; Ub = 100;
    x = rand(1, 2);
    X = Lb + (x - 0) .* (Ub - Lb) / 1;
    X = fminsearch(@shaffer6, X);
    Y = shaffer6(X);
    Xmin = X; Ymin = Y; k = 0;
    while 0 < 1
        x = nlf_2(x);
        X = Lb + (x - 0) .* (Ub - Lb) / 1;
        X = fminsearch(@shaffer6, X);
        Y = shaffer6(X);
        if Y < Ymin
            Xmin = X;
            Ymin = Y;
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

function y = nlf_2(x)
    y = 4 * x .* (1 - x);
end

function y = shaffer6(x)
    A = (sin(sqrt(x(1) ^2 + x(2) ^2))) ^2 - 0.5;
    B = (1 + 0.001 * (x(1) ^2 + x(2) ^2)) ^2;
    y = 0.5 + A / B;
end