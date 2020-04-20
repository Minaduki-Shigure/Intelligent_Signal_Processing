function main()
    iternum = 500;
    test_bench(@legacy, iternum);
    test_bench(@chaos_standalone_1, iternum);
    test_bench(@chaos_standalone_2, iternum);
    test_bench(@chaos_hybrid_1, iternum);
    test_bench(@chaos_hybrid_2, iternum);
end

function test_bench(fun, iternum)
    format long g;
    k_sum = 0; time_sum = 0;
    k_min = 1000000000; time_min = 1000000000;
    k_max = 0; time_max = 0;
    for i = 1:iternum
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
    sprintf("k: min/avg/max\n %d  /  %d  /  %d", k_min, k_average, k_max)
    sprintf("time: min/avg/max\n %f  /  %f  /  %f", time_min, time_average, time_max)
end