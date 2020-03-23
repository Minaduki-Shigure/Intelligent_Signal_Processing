function main()
    c = 100;
    k = 1;
    for x = -0.5 : 0.001 : 1.5;
        y(k) = Fc(x, c);
        k = k + 1;
    end
    plot(-0.5 : 0.001 : 1.5, y)
    axis([-0.5 1.5 0 2.5])
    grid
end

function y = Fc(x, c)
    if x >= 1
        y = x^2;
    else
        y = x^2 + c * (1 - x)^2;
    end
end

function [xm, ym] = findvertex_2()
    % taking small gradient as the terminating condition
    x=-10 : 0.01 : 10;
    N = length(x);
    y = zeros(1, N);
    for k = 1 : N;
        y(k) = f(x(k));
    end
    plot(x, y);
    grid on
    x0 = rand*2;
    h = 0.00000001;
    yd = dydx(@f, x0, h)
    alpha = 0.1; %initial step;
    k = 1;
    while abs(yd) > eps
        x0 = x0 - alpha * yd;
        %moving in the direction of negative gradient.
        yd = dydx(@f, x0, h)
        k = k + 1
    end
    xm = x0;
    ym = f(xm);
end

function y = f(x)
    y = 1 * x.^2 + 2 .* x + 1;
end

function y = dydx(fname, x, h)
    % derivative of a point
    y0 = feval(fname, x);
    yh = feval(fname, x + h);
    y = yh / h - y0 / h;
end

function t = step(fname, x0, tmax, P)
    a = 0;
    b = tmax;
    t1 = a + 0.382 * (b - a);
    t2 = a + 0.618 * (b - a);
    x = x0 - t1 * P;
    y(1) = feval(fname, x);
    x = x0 - t2 * P;
    y(2) = feval(fname, x);
    while abs(a - b) > 10^(-6)
        if y(1) <= y(2)
            a = a;
            b = t2;
            t2 = t1;
            t1 = a + 0.382 * (b - a);
            y(2) = y(1);
            x = x0 - t1 * P;
            y(1) = feval(fname, x);
        else
            a = t1;
            b = b;
            t1 = t2;
            t2 = a + 0.618 * (b - a);
            y(1) = y(2);
            x = x0 - t2 * P;
            y(2) = feval(fname, x);
        end
    end
    t = (a + b) / 2;
end 