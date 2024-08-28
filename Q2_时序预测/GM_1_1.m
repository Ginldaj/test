function [Yp,error,u] = GM_1_1(y,c,t)
%输入：原始数据/参考数据列、平移系数C、预测步长
%输出：预测结果、误差
y=y+c;%平移变换
n=length(y);%序列长度
%级比检验
lambda=y(1:n-1)./y(2:n);%级比值
Theta=[exp((-2/(n+1))) exp((2/(n+1)))];
%lambda的最小值大于区间下限且最大值小于区间上限，满足级比检验
if (min(lambda)>Theta(1))&&(max(lambda)<Theta(2))
    %提示
    disp(['满足级比检验，当前平移系数C: ',num2str(c)])
    %构造数据序列
    y_AGO=cumsum(y);%一阶累加生成序列
    z=(y_AGO(1:n-1)+y_AGO(2:n))/2;%均值生成序列
    %构造YB矩阵
    Y=y(2:n)';
    B=[-z' ones(n-1,1)];
    %矩阵运算求解ab/通过函数求解
    x=dsolve('Dx+a*x=b','x(0)=c');
    %求解ab
    u=lsqr(B,Y);
    %赋予系数值
    x=subs(x,{'a','b','c'},{u(1),u(2),y_AGO(1)});
    %进行预测,一阶累加生成的预测
    Y_AGO=eval(subs(x,'t',0:n-1+t));
    %累减还原
    Yp=[Y_AGO(1) diff(Y_AGO)];
    %计算相对误差
    error=abs((Yp(1:n)-c)-(y-c))./(y-c);
    %平移还原
    Yp=Yp-c;
else
    disp('不满足级比检验，请重新确定平移系数C')
    Yp=nan;
    error=nan;
    u=nan;
end
end