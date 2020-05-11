function y=Schaffer6(x)
    yup=sin(sqrt(sum(x.^2)));
    yup=yup^2-0.5;
    ydown=[sum(x.^2)*0.001+1.0].^2;
    y=yup/ydown+0.5;
end