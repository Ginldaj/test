function [Yp,forecast]= combined_forecast(ts_data, forecast_years,c)
forecast = [];
for i = 1:1
    %数据
    X = 1:length(ts_data);
    y = ts_data;
    %线性模型
    [fitresult, ~] = fit(X', y','poly2');
    linear_forecast =fitresult(X(end)+1);
    %灰色模型
    ystar=y+c;%平移变换
    n=length(ystar);%序列长度
    %级比检验
    lambda=ystar(1:n-1)./ystar(2:n);%级比值
    Theta=[exp((-2/(n+1))) exp((2/(n+1)))];
    while ~((min(lambda)>Theta(1))&&(max(lambda)<Theta(2)))
        c=c+5;
        ystar=y+c;%平移变换
        n=length(ystar);%序列长度
        %级比检验
        lambda=ystar(1:n-1)./ystar(2:n);%级比值
        Theta=[exp((-2/(n+1))) exp((2/(n+1)))];
    end
    gm_forecast = GM_1_1(y,c,1);
    gm_forecast=gm_forecast(end);
    combined = linear_forecast*1/2+ gm_forecast*1 /2;
    forecast = [forecast, combined];
    for j = 1:forecast_years-1
        X = [X  X(end)+1];
        y = [y  combined];
        c=c;
        [fitresult, ~] = fit(X', y','poly2');
        linear_forecast =fitresult(X(end)+1);
        ystar=y+c;%平移变换
        n=length(ystar);%序列长度
        %级比检验
        lambda=ystar(1:n-1)./ystar(2:n);%级比值
        Theta=[exp((-2/(n+1))) exp((2/(n+1)))];
        while ~((min(lambda)>Theta(1))&&(max(lambda)<Theta(2)))
            c=c+5;
            ystar=y+c;%平移变换
            n=length(ystar);%序列长度
            %级比检验
            lambda=ystar(1:n-1)./ystar(2:n);%级比值
            Theta=[exp((-2/(n+1))) exp((2/(n+1)))];
        end
        gm_forecast = GM_1_1(y,c,1);
        gm_forecast=gm_forecast(end);
        combined = linear_forecast*1/2 + gm_forecast*1/2;
        forecast = [forecast, combined];


    end
    Yp_linear=fitresult(1:length(ts_data));
    Yp_gm=GM_1_1(ts_data,c,0)';
    Yp=(Yp_linear + Yp_gm) / 2;



end
end