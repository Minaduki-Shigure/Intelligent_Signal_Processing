function optim()
    objm = 'objmtry'; dobjm = 'dobjmtry'; pcx = 'pcxtry';
    n = 2; c = 1; X = 50 * rand(n, 1);
    e = 10^(-10); pe = 10^(-5); s = 100; k = 0;
    while s > e
        k = k + 1; c = c * 1.5;
        p = -feval(dobjm, X, c); %p=p/sqrt(p'*p)
        while sqrt(p' * p) > pe
            re = 10^(-10); a = 0; b = 1; r = b - a;
            while r > re
                t1 = a + 0.382 * (b - a); t2 = a + 0.618 * (b - a);
                X1 = X + t1 * p; X2 = X + t2 * p;
                y1 = feval(objm, X1, c); y2 = feval(objm, X2, c);
                    if y1 <= y2
                        b = t2; t2 = t1; t1 = a + 0.382 * (b - a);
                        y2 = y1; X1 = X + t1 * p; y1 = feval(objm, X1, c);
                    else
                        a = t1; t1 = t2; t2 = a + 0.618 * (b - a);
                        y1 = y2; X2 = X + t2 * p; y2 = feval(objm, X2, c);
                    end
                r = b - a;
            end
            X = (X1 + X2) / 2; p = -feval(dobjm, X, c);
            s = feval(pcx, X, c) / c;
        end
    end
    X
    y = sum(X.^2)
    s
end

%subfunctions
function y = objmtry(X, c);
    temp = 1 - sum(X);
    if temp <= 0;
        temp = 0;
    end
    y = sum(X.^2) + c * temp.^2;
end

function dy_dX = dobjmtry(X, c);
    n = length(X);
    dy_dX = zeros(n, 1);
    X0 = X;
    for I = 1 : n;
        h = 10^(-12);
        X(I) = X0(I) + h;
        dy_dX(I, 1) = (objmtry(X, c) - objmtry(X0, c)) ./ h;
    end
end

function y = pcxtry(X, c);
    temp = 1 - sum(X);
    if temp <= 0;
        temp = 0;
    end
    y = c * temp^2;
end