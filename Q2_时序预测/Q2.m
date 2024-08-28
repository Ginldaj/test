clc;clear;close all;
%% 导入数据
%{
市场规模、电动汽车平均价格、新能源汽车保有量、新能源汽车市场份额
等对新能源汽车发展影响最大的四个指标
%}
%%
indicator_table=readtable("Analyse.xlsx");
indicator_name = ["Holding Ratio";"Market Size";'Number Of Charging Piles';'Average Price Of Fuel Truck';...
    'Fuel Car Fuel Consumption Price';'Average Price Of Electric Vehicles';'Electric Consumption Of Electric Vehicle';...
    'Government Subsidies';'Carbon Emissions Of China';'Market Share Of New Energy Vehicles';...
    'New Energy Vehicle Market Penetration Rate';'New Energy Vehicle Production And Sales Ratio'];

%% 数据展示
figure
set(gcf,'Position',[100 100 800 500])
ind_choose=[1,2,3,11];
year=(2013:2022)';
Color={'#F5B92C';'#75FC2B';'#33DAE6';'#732BFC';};
for i=1:4
    subplot(2,2,i)
    hold on
    data_indicator=indicator_table{:,ind_choose(i)};
    plot(year,data_indicator,'.--','MarkerSize',20,'LineWidth',1.5,'Color',Color{i})
    box on
    grid on
    xlabel('Year')
    ylabel('Value')
    axis tight
    set(gca,'FontWeight','bold','FontSize',14,'FontName','times')
    title(indicator_name{ind_choose(i)},'FontSize',12,'FontWeight','bold','FontName','times')
    xlim([2012.5 2022.5])
end


%% 数据拟合
figure
set(gcf,'Position',[50 50 1400 700])
ind_choose=[1,2,3,11];
year=(2013:2022)';
Color={'#F5B92C';'#75FC2B';'#33DAE6';'#732BFC';};
rSquared=[];
mse=[];
Ypred=[];
for i=1:4
    subplot(2,2,i)
    hold on
    data_indicator=indicator_table{:,ind_choose(i)};
    plot(year,data_indicator,'.--','MarkerSize',20,'LineWidth',1.5,'Color',Color{i})
    %预测
    [Yp,forecast]= combined_forecast(data_indicator',10,0);
    plot(year,Yp,'r-','MarkerSize',20,'LineWidth',1.5)
    plot(year(end)+1:year(end)+10,forecast,'or','LineWidth',1.5)

    box on
    grid on
    xlabel('Year')
    ylabel('Value')
    axis tight
    legend('Real Value','Fitted Line','Predicted Value','Location','southeast')
    set(gca,'FontWeight','bold','FontSize',14,'FontName','times')
    title(indicator_name{ind_choose(i)},'FontSize',12,'FontWeight','bold','FontName','times')
    xlim([2012.5 2032.5])
    Ypred=[Ypred round(forecast',2)];
    %评价值
    % 决定系数（R^2）
    [R, P] = corrcoef(Yp,data_indicator);
    r = R(1,2)^2;
    rSquared =[rSquared;r] ;
    % 均方误差（MSE）
    mse = [mse;round(mean((data_indicator - Yp).^2),5)];

end




