function main()
    fun_sym = str2sym("x1^2 + x2^2 + x3^2");
    constraint_sym1 = str2sym("1 - x1 - x2 - x3");
    constraint_sym2 = str2sym("x1 + x2 + x3 - 1");
    % start_X = [0.5 0.5 0.5];
    start_X = [5 5 5];
    
    disp("For the first constrain:");
    disp("MATLAB's built-in function:");
    [x1 fval1 exitflag1] = fmincon(@fun, start_X, [-1 -1 -1], -1)
    disp("Custom function:");
    optimize_constraint(fun_sym, constraint_sym1, start_X, 5 * 10^(-5))
    disp("For the second constrain:");
    disp("MATLAB's built-in function:");
    [x2 fval2 exitflag2] = fmincon(@fun, start_X, [1 1 1], 1)
    disp("Custom function:");
    optimize_constraint(fun_sym, constraint_sym2, start_X, 10^(-6))
end

function f = fun(arg)
    x1 = arg(1);
    x2 = arg(2);
    x3 = arg(3);
    f = x1 .^2 + x2 .^2 + x3.^2;
end

function res = optimize_constraint(fun, constraint_LT, X0, error_tolerance)

    x1 = X0(1); x2 = X0(2); x3 = X0(3);
    c = 1;

    while 1
        c = c * 1.5;
        if eval(constraint_LT) >= 0
            punish = c * constraint_LT^2;
        else
            punish = str2sym("0");
        end
        
        fc = fun + punish;
        x_plus = [10 10 10];
        while abs(x_plus - X0) > error_tolerance
            x_plus = optimize(fc, X0, error_tolerance);
            X0 = x_plus;
        end
        % stop_value = eval(punish) / c
        if (eval(punish) / c < error_tolerance * 0.001) && (c > 10)
            break;
        end
        x1 = X0(1); x2 = X0(2); x3 = X0(3);  
    end
    res = X0;
end


function res = optimize(fun, X0, error_tolerance)
    x1 = X0(1); x2 = X0(2); x3 = X0(3);
    dx1 = diff(fun, "x1");
    dx2 = diff(fun, "x2");
    dx3 = diff(fun, "x3");
    
    while true
        error = (eval(dx1))^2 + (eval(dx2))^2 + (eval(dx3))^2;
        if abs(error) < error_tolerance
            break;
        end
        t_step = calcutale_step(...
            fun, [x1, x2, x3], [eval(dx1), eval(dx2), eval(dx3)], 100, error_tolerance);
        x1 = x1 - t_step * eval(dx1);
        x2 = x2 - t_step * eval(dx2);
        x3 = x3 - t_step * eval(dx3);
    end
    
    res = [x1, x2, x3];
end

function t_step = calcutale_step(fun, X0, grad, tmax, error_tolerance)
    syms t;
    x1 = X0(1); x2 = X0(2); x3 = X0(3);
    t1 = t * grad(1); t2 = t * grad(2); t3 = t * grad(3);

    fun = subs(fun, "x1", str2sym("x1 - t1"));
    fun = subs(fun, "x2", str2sym("x2 - t2"));
    fun = subs(fun, "x3", str2sym("x3 - t3"));
    fun = eval(eval(fun));

    fun_382 = subs(fun,"t","t_382");
    fun_618 = subs(fun,"t","t_618");

    a = 0; b = tmax;
    t_382 = a + 0.382 * (b - a);
    t_618 = a + 0.618 * (b - a);

    while abs(a - b) > error_tolerance
        if(eval(fun_382) <= eval(fun_618))
            b = t_618;
            t_618 = t_382;
            t_382 = a + 0.382 * (b - a);
        else
            a = t_382;
            t_382 = t_618;
            t_618 = a + 0.618 * (b - a);
        end
    end
    t_step = (a + b) / 2;
end