function main()
    iternum = 100;
    result_1 = test_bench(@basic, iternum);
    result_2 = test_bench(@immu, iternum);
    result_3 = test_bench(@advanced, iternum);
    result_4 = test_bench(@niche, iternum);
    result_5 = test_bench(@monkey, iternum);
    disp_result(result_1);
    disp_result(result_2);
    disp_result(result_3);
    disp_result(result_4);
    disp_result(result_5);
end

function result = test_bench(fun, iternum)
    format long g;
    k_sum = 0; time_sum = 0;
    k_min = 1000000000; time_min = 1000000000;
    k_max = 0; time_max = 0;
    for i = 1:iternum
        sprintf("iter %d", i)
        [k, time] = fun();
        if k < k_min
            k_min = k;
        end
        if k > k_max
            k_max = k;
        end
        if time < time_min
            time_min = time;
        end
        if time > time_max
            time_max = time;
        end
        k_sum = k_sum + k;
        time_sum = time_sum + time;
    end
    k_average = k_sum / iternum;
    time_average = time_sum / iternum;
    result = zeros(3, 2);
    result(1, 1) = k_min;
    result(2, 1) = k_average;
    result(3, 1) = k_max;
    result(1, 2) = time_min;
    result(2, 2) = time_average;
    result(3, 2) = time_max;
end

function disp_result(result)
    k_min = result(1, 1);
    k_average = result(2, 1) ;
    k_max = result(3, 1);
    time_min = result(1, 2);
    time_average = result(2, 2);
    time_max = result(3, 2);
    sprintf("k: min/avg/max\n %d  /  %d  /  %d", k_min, k_average, k_max)
    sprintf("time: min/avg/max\n %f  /  %f  /  %f", time_min, time_average, time_max)
end