function [F,c_v,p]=Granger_test(var1,var2,alpha,max_lag)
% 输入参数：var1 和var2是两个时间序列，alpha 是显著性水平，max_lag 是最大滞后期数
% 结果表明var2对var1的关系，若p小于0.05，拒绝原假设，var2是var1的格杰兰原因

% 初始化变量
T = length(var1); % 时间序列长度
BIC = [];
RSSR =[];

i = 1;

% 遍历不同滞后期数
while i <= max_lag
    % 提取 y 的滞后部分
    ystar = var1(i+1:T,:);

    % 构建设计矩阵 xstar，包括常数项和 x 的滞后项
    xstar = [ones(T-i,1) zeros(T-i,i)];

    % 添加 x 的滞后项到设计矩阵
    j = 1;
    while j <= i
        xstar(:,j+1) = var1(i+1-j:T-j);
        j = j+1;
    end

    % 使用线性回归模型拟合 ystar 到 xstar
    [b,bint,r] = regress(ystar,xstar);

    % 计算 BIC 和 RSSR
    BIC(i,:) = T*log(r'*r) + (i+1)*log(T);
    RSSR(i,:) = r'*r;

    % 更新 i
    i = i+1;
end

% 寻找最小 BIC 的滞后期数
x_lag = find(BIC==min(BIC));

% 重新初始化变量
BIC = [];
RSSUR =[];

% 遍历不同滞后期数
i = 1;
while i <= x_lag
    % 提取 y 的滞后部分
    ystar = var1(x_lag+1:T,:);

    % 构建设计矩阵 xstar，包括常数项和 x 的滞后项
    xstar = [ones(T-x_lag,1) zeros(T-x_lag,x_lag)];

    % 添加 x 和 y 的滞后项到设计矩阵
    j = 1;
    while j <= x_lag
        xstar(:,j+1) = var1(x_lag-j+1:T-j,:);
        j = j+1;
    end

    j = 1;
    while j <= i
        xstar(:,x_lag+j+1) = var2(x_lag-j+1:T-j,:);
        j = j+1;
    end

    % 使用线性回归模型拟合 ystar 到 xstar
    [b,bint,r] = regress(ystar,xstar);

    % 计算 BIC 和 RSSUR
    BIC(i,:) = T*log(r'*r) + (i+x_lag+1)*log(T);
    RSSUR(i,:) = r'*r;

    % 更新 i
    i = i+1;
end

% 寻找最小 BIC 的滞后期数
y_lag = find(BIC==min(BIC));

% 计算 F 统计量
F_num = (RSSR(x_lag,:) - RSSUR(y_lag,:))/y_lag;
F_den = RSSUR(y_lag,:)/(T-(x_lag+y_lag+1));
F = F_num./F_den;

% 计算临界值 c_v
c_v = finv(1-alpha,y_lag,(T-(x_lag+y_lag+1)));

% 计算 p 值
p = 1-fcdf(F,y_lag,(T-(x_lag+y_lag+1)));
