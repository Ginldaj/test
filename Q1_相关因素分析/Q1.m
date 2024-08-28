clc;clear;close all;
%% 导入数据
cost_table=readtable('Cost_data.xlsx');
cost_name=["Gasoline Price";"Gasoline Vehicle Energy Efficiency";"Gasoline Vehicle Average Price";...
    "Gasoline Vehicle Fuel Cost";"Electric Vehicle Charging Cost";"New Energy Vehicle Energy Efficiency";...
    "Electric Vehicle Average Price";"Electric Vehicle Electricity Cost";];
indicator_table=readtable("Analyse.xlsx");
indicator_name = ["Holding Ratio";"Market Size";'Number Of Charging Piles';'Average Price Of Fuel Truck';...
    'Fuel Car Fuel Consumption Price';'Average Price Of Electric Vehicles';'Electric Consumption Of Electric Vehicle';...
    'Government Subsidies';'Carbon Emissions Of China';'Market Share Of New Energy Vehicles';...
    'New Energy Vehicle Market Penetration Rate';'New Energy Vehicle Production And Sales Ratio'];


%% 相关性分析
%相关系数
[corrA p_value]=corrcoef(indicator_table{:,:});
corrA=corrA(2:end,1);
figure
set(gcf,'Position',[100 100 1000 500])
h=heatmap(indicator_name(1),indicator_name(2:end),corrA);
colormap jet
set(gca,'FontSize',10)

%变量相关性
corrB=corrcoef(indicator_table{:,2:end});
figure
set(gcf,'Position',[100 100 1200 600])
h=heatmap(indicator_name(2:end),indicator_name(2:end),round(corrB,3));
colormap jet
set(gca,'FontSize',10)

%% 多元回归——岭回归
% 使用ridge函数进行岭回归
x=indicator_table{:,2:end};
y=indicator_table{:,1};
%归一化
% x=(x-mean(x))./std(x);
x=mapminmax(x',0,1)';
X=[ones(size(x,1),1) x];%增广阵


lambda = 0:0.0001:0.001; % 设定一组正则化参数
beta = ridge(y,x,lambda); % beta是系数矩阵，每一列对应一个k值下的系数估计
%岭迹图
figure
plot(lambda,beta,'-^','LineWidth',1.5)
xlabel('lambda')
ylabel('回归系数值')

% 选择lambda

lambda_choose=0.01;
beta = ridge(y,x,lambda_choose,0); % B是系数矩阵，每一列对应一个k值下的系数估计
% beta= lasso(X,y,"Lambda",lambda_choose); % B是系数矩阵，每一列对应一个k值下的系数估计

% [b,mse,minmse_index] = RidgeCV(X,Y,lambda);
% b=b(:,minmse_index);%第二种


ypred=X*beta;

%显示
figure
hold on
set(gcf,'Position',[100 100 800 500])
plot(y,y,'--','LineWidth',1.5,'Color','#20BD4A')
plot(y,ypred,'*r','LineWidth',1.5,'MarkerSize',10)
box on
grid on
set(gca,'FontWeight','bold','FontSize',14)
legend('Real-Real','Real-Predicted','Location','southeast','FontSize',14)
xlabel('Real Value')
ylabel('Predicted Value')
axis tight


%系数直方图
figure
hold on
set(gcf,'Position',[100 100 800 500])
num_bars = length(beta(2:end));
for i = 1:num_bars
    bar(i, abs(beta(i + 1)), 'FaceColor', rand(1,3));
end
set(gca,'XTick',1:11,'XTickLabel',indicator_name(2:end))
box on
grid on
ylabel('Importance')
set(gca,'FontWeight','bold','FontSize',10)


%% 评价指标
% 均方误差（MSE）
mse = mean((y - ypred).^2);

% 平均绝对误差（MAE）
mae = mean(abs(y - ypred));

% 决定系数（R^2）
sst = sum((y - mean(y)).^2);
ssr = sum((ypred - mean(y)).^2);
rSquared = ssr / sst;

%平均绝对百分比误差（MAPE）
mape = mean(abs((y - ypred)./ y)) ;

%% 输出结果
fprintf('MSE: %.4f\n', mse);
fprintf('MAE: %.4f\n', mae);
fprintf('R^2: %.4f\n', rSquared);
fprintf('MAPE: %.4f%%\n', mape);





