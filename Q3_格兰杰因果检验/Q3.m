clc;clear;close all;
%% 导入数据
%{
新能源汽车全国销量、传统能源汽车全球销量、全球油价变化、传统能源技术研发量
%}
%%
data = [2019, 2020, 2021, 2022;
    120.6, 132.2, 350.7, 385.1;
    2454.8, 2394.5, 2274.1, 1299.9;
    56.99, 39.68, 57.27, 77;
    131.3, 138.9, 147, 155.7]';
data=[ones(4,1) data];
indicator_name = {"Year";"NEV Sales";"Traditiaonal Sales";'Oil Price';'RnD Spending';};


%% 可视化
colors = lines(3);
group= data(:,1);
colors = lines(length(unique(group)));
figure
set(gcf,'Position',[50 50 1000 600])
pairplot(data(:,2:end), indicator_name, ...
    num2cell(num2str(group)), colors, 'bar')

%% 格兰杰因果检验
alpha=0.01;
max_lag=1;
% 1、Rainfall是否为Flow的原因
[F1,c_v1,p1]=Granger_test(data(:,4),data(:,3),alpha,max_lag);

% 1、Rainfall是否为Flow的原因
[F2,c_v2,p2]=Granger_test(data(:,5),data(:,3),alpha,max_lag);

% 1、Rainfall是否为Flow的原因
[F3,c_v3,p3]=Granger_test(data(:,6),data(:,3),alpha,max_lag);

%可视化
figure
set(gcf,'Position',[50 50 1000 600])
hold on
Color={'#F5B92C';'#75FC2B';'#33DAE6';'#732BFC';};
plot(1,p1,'^','MarkerSize',8,'LineWidth',1.5,'MarkerFaceColor',Color{1},'Color','r')
plot(1,p2,'s','MarkerSize',8,'LineWidth',1.5,'MarkerFaceColor',Color{2},'Color','r')
plot(1,p3,'diamond','MarkerSize',8,'LineWidth',1.5,'MarkerFaceColor',Color{3},'Color','r')
yline(0.01,'r--','LineWidth',1.5)
box on
grid on
xlabel('Lag')
ylabel('P Value')
axis tight
legend('NEV Sales-->Traditiaonal Sales','NEV Sales-->Oil Price', ...
    'NEV Sales-->RnD Spending','Reference Line','Location','northeast');
set(gca,'FontWeight','bold','FontSize',14,'FontName','times')
axis ([0 2 0 0.03])

%% 多元回归与相关性分析
% 插值一个新的x值
new_x =linspace(data(1,2),data(4,2),36);
new_y=[];
new_y = [new_y spline(data(:,2),data(:,3),new_x)'];
new_y = [new_y spline(data(:,2),data(:,4),new_x)'];
new_y = [new_y spline(data(:,2),data(:,5),new_x)'];
new_y = [new_y spline(data(:,2),data(:,6),new_x)'];

[beta1,~,~,~,stat1]=regress(new_y(:,2),[ones(size(new_y,1),1),new_y(:,1)]);
[beta2,~,~,~,stat2]=regress(new_y(:,3),[ones(size(new_y,1),1),new_y(:,1)]);
[beta3,~,~,~,stat3]=regress(new_y(:,4),[ones(size(new_y,1),1),new_y(:,1)]);

%相关系数
[coef,pvalue]=corrcoef(new_y);






