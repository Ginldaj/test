clc;clear;close all;
%% 导入数据
cost_table=readtable('Cost_data.xlsx');
cost_name=["Gasoline Price";"Gasoline Vehicle Energy Efficiency";"Gasoline Vehicle Average Price";...
    "Gasoline Vehicle Fuel Cost";"Electric Vehicle Charging Cost";"New Energy Vehicle Energy Efficiency";...
    "Electric Vehicle Average Price";"Electric Vehicle Electricity Cost";];
indicator_table=readtable("Analyse.xlsx");
indicator_name = ["Holding Ratio";"Market Size";'Number Of Charging Piles';'Average Price Of Fuel Truck';...
    'Fuel CarFuel Consumption Price';'Average Price Of Electric Vehicles';'Electric Consumption Of Electric Vehicle';...
    'Government Subsidies';'Carbon Emissions Of China';'Market Share Of New Energy Vehicles';...
    'New Energy Vehicle Market Penetration Rate';'New Energy Vehicle Production And Sales Ratio'];


%% 数据可视化，需要美化
figure
hold on
set(gcf,'Position',[100 100 800 300])
plot(cost_table{:,1},cost_table{:,2},'.-','MarkerSize',10)
plot(cost_table{:,1},cost_table{:,3},'.-','MarkerSize',10)
plot(cost_table{:,1},cost_table{:,4},'.-','MarkerSize',10)
plot(cost_table{:,1},cost_table{:,5},'.-','MarkerSize',10)
text(cost_table{:,1},cost_table{:,2}+1,num2str(round(cost_table{:,2},2)),"FontWeight","bold")
text(cost_table{:,1},cost_table{:,3}+1,num2str(round(cost_table{:,3},2)),"FontWeight","bold")
text(cost_table{:,1},cost_table{:,4}+1,num2str(round(cost_table{:,4},2)),"FontWeight","bold")
text(cost_table{:,1},cost_table{:,5}+1,num2str(round(cost_table{:,5},2)),"FontWeight","bold")
box on
grid on
set(gca,'FontWeight','bold','FontSize',12)
legend(cost_name(1:4),'Location','northeast','FontSize',8)
xlabel('Year')
ylabel('Gasoline Vehicle Indicators')
axis([2012.5 2022.5 0 22])

figure
hold on
set(gcf,'Position',[100 100 800 300])
plot(cost_table{:,1},cost_table{:,6},'.-','MarkerSize',10)
plot(cost_table{:,1},cost_table{:,7},'.-','MarkerSize',10)
plot(cost_table{:,1},cost_table{:,8},'.-','MarkerSize',10)
plot(cost_table{:,1},cost_table{:,9},'.-','MarkerSize',10)
text(cost_table{:,1},cost_table{:,6}+1,num2str(round(cost_table{:,2},2)),"FontWeight","bold")
text(cost_table{:,1},cost_table{:,7}+1,num2str(round(cost_table{:,3},2)),"FontWeight","bold")
text(cost_table{:,1},cost_table{:,8}+1.5,num2str(round(cost_table{:,4},2)),"FontWeight","bold")
text(cost_table{:,1},cost_table{:,9}-1.5,num2str(round(cost_table{:,5},2)),"FontWeight","bold")
legend(cost_name(5:8))
box on
grid on
set(gca,'FontWeight','bold','FontSize',12)
legend(cost_name(5:8),'Location','northeast','FontSize',6)
xlabel('Year')
ylabel('Electric Vehicle Indicators')
axis ([2012.5 2022.5 -3 40])


%% 数据预处理，需要美化
figure
set(gcf,'Position',[100 100 1200 500])
for i=1:10%符号=数组，符号会依次取数组中的值，直接取完所有数组中的值，循环停止
    subplot(2,5,i)
    boxplot(indicator_table{:,i},'Whisker',3)
    h=findobj(gca,'Tag','Box');
    patch(get(h,'XData'),get(h,'YData'),rand(1,3),'FaceAlpha',0.5)
    title(indicator_name{i,:})
    set(gca,'FontWeight','bold','FontSize',6)
end


