function [b,CV_mseall,minmse_index] = RidgeCV(x,y,k)
%输入：自变量、因变量、岭参数范围
%输出：回归系数、均方误差、最小均方误差的序号
[n,~]=size(x);%数据尺寸
X=[x];%增广阵
CV_mseall=[];
for i=1:length(k)
    b=ridge(y,x,k(i));%回归系数
    predfun = @(XTRAIN,YTRAIN,XTEST)(XTEST*b);
    cv_mse = crossval('mse',X, y, 'Predfun', predfun, 'kfold',5);
    CV_mseall=[CV_mseall cv_mse];
end
[~,minmse_index]=min(CV_mseall);
b=ridge(y,x,k,0);%回归系数
end
