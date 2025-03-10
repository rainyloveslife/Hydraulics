%% Here is the function of plot the output of parameter sensitivity

%% define the filepath
rootPath='/Users/zeyu/remote/BSI/scratch/zduanmu/quincy_exp/';
folderPath='exp_82_hydraulics_ET_g1_ParaSen_51d3421c/';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
fileName=cell(100,1);                                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
for i=1:100                                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
    fileName{i,1}=strcat(rootPath,folderPath,num2str(1000+i),'_DE-Hai/output/');
end

%% take care the abandon case
discard=loadMatData(rootPath,folderPath,'parameter_list/fileTime.mat');
discard_mask=discard==122640;
fileName(~discard_mask)=[];

%% load the variables
pp_scaler=0.963;
et_scaler=24*60*60;
ET_aggr_sen=nan(175,3,size(fileName,1));
GPP_aggr_sen=nan(175,3,size(fileName,1));
NPP_aggr_sen=nan(175,3,size(fileName,1));
for i = 1:size(fileName,1)  
        % GPP
        gpp=ncread(strcat(fileName{i,1},'Q_ASSIMI_fluxnetdata_timestep.nc'),'gpp_avg')./pp_scaler;
        % NPP
        npp=ncread(strcat(fileName{i,1},'VEG_fluxnetdata_timestep.nc'),'npp_avg')./pp_scaler;
        % ET
        eva=ncread(strcat(fileName{i,1},'SPQ_fluxnetdata_timestep.nc'),'evaporation_avg').*et_scaler;
        tran=ncread(strcat(fileName{i,1},'SPQ_fluxnetdata_timestep.nc'),'transpiration_avg').*et_scaler;
        inte=ncread(strcat(fileName{i,1},'SPQ_fluxnetdata_timestep.nc'),'interception_avg').*et_scaler;
        et=eva+tran+inte;
        
        % calculate the aggregate ts
        window=15;
        ET_aggr_sen(:,:,i)=Cal_sim_halfhour_day(et,window);
        GPP_aggr_sen(:,:,i)=Cal_sim_halfhour_day(gpp,window);
        NPP_aggr_sen(:,:,i)=Cal_sim_halfhour_day(npp,window);
end

% save
savepath=strcat('/Users/zeyu/remote/home_drive/2025/Feb/sensitivity_analysis/');
save(strcat(savepath,'g1_GPP_sim.mat'),'GPP_aggr_sen');
save(strcat(savepath,'g1_NPP_sim.mat'),'NPP_aggr_sen');
save(strcat(savepath,'g1_ET_sim.mat'),'ET_aggr_sen');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot them
%% define the filepath
rootPath='/Users/zeyu/remote/BSI/scratch/zduanmu/quincy_exp/';
folderPath='exp_82_hydraulics_ET_g1_ParaSen_51d3421c/';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
discard=loadMatData(rootPath,folderPath,'parameter_list/fileTime.mat');
discard_mask=discard==122640;
parameter_sample=readtable(strcat(rootPath,folderPath,'parameter_list/parameter_table.txt'));
parameter_sample(1, :) = [];
parameter_sample(:,1)=[];
parameter_sample=table2array(parameter_sample);
% g0_p4=0.01;
g1_medlyn_p4=4.64;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
parameter_table=parameter_sample.*g1_medlyn_p4;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
parameter_table(~discard_mask)=[];

%% find the parameter

obs_ET=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_ET_fluxnet.mat');
obs_GPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_GPP_fluxnet.mat');
obs_NPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_NPP_fluxnet.mat');

g1_ET=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/sensitivity_analysis/g1_ET_sim.mat');
g1_GPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/sensitivity_analysis/g1_GPP_sim.mat');
g1_NPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/sensitivity_analysis/g1_NPP_sim.mat');

%% plot lines

fig = figure('Color','white','PaperUnits','centimeters','PaperSize',[12 16],'PaperPosition',[0,0,12,16],'Visible','on');

y_name={'ET','GPP','NPP'};
y_unit={'mm d^-^1','g m^-^2 d^-^1','g m^-^2 d^-^1'};
x_com=1:size(obs_NPP,1);


% 使用 ind2rgb 生成 RGB 颜色
[~,idx]=sort(parameter_table);
cmap = ind2rgb(idx,flip(summer(size(parameter_table,1)),1));
cmap=squeeze(cmap(:,1,:));


% 创建tiledlayout
t = tiledlayout(3,1); 

hold on
for i=1:3
    nexttile;
    eval(['y=obs_',y_name{1,i},';']);
    hold on
    for iy=1:size(y,3)   
        [f,pp]=sis_draw_ts_shading(x_com,y(:,1),y(:,2:3),'k'); 
    end
    eval(['y_sim=g1_',y_name{1,i},';']);
    for p=1:size(y_sim,3)
        y_sim_each=squeeze(y_sim(:,1,p));
        plot(x_com',y_sim_each,'Color',cmap(p,:),'LineWidth',0.5);
    end
    ax = gca;
    ax.YLabel.String = strcat(y_name{1,i},32,'(',y_unit{1,i},')');
    ax.XTick=15.5:25:175;
    ax.XLim=[0 180];
    ax.XTickLabel={'2000','2001','2002','2003','2004','2005','2006'};
    FtSize=8;
    ax.FontSize=FtSize;
    box on
end

ax.XLabel.String = 'Year';
% 添加一个全局 colorbar

cmap_sorted = [idx,cmap];
cmap_sorted_2 = sortrows(cmap_sorted,1);

colormap(cmap_sorted_2(:,2:4))
cb = colorbar; % 在底部添加 colorbar
cb.Layout.Tile = 'east'; 
clim([0 size(parameter_table,1)]);
cb.TickLength = 0.005;
cb.Ticks = 0.5: 1: size(parameter_table,1)-0.5; % 将colorbar划分为31个刻度
% 为colorbar的每个刻度添加标签
pa_sort=sort(parameter_table);
cb.TickLabels = num2str(round(pa_sort,2)); % 生成31个标签
cb.Title.String = 'Parameter';
FtSize=8;
ax.FontSize=FtSize;
cb.Title.FontSize = FtSize;
cb.FontSize =6;
sgtitle('g_1 medlyn');

print(fig,'-dtiff','-r800',strcat('/Users/zeyu/Desktop/PhD work report/202502/Sensitivity analysis/g1_lines.tif'));%%%%%%%%editable

%% 
%%
%%
%% calculate R, rmse, R square


rootPath='/Users/zeyu/remote/BSI/scratch/zduanmu/quincy_exp/';
folderPath='exp_82_hydraulics_ET_g1_ParaSen_51d3421c/';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
discard=loadMatData(rootPath,folderPath,'parameter_list/fileTime.mat');
discard_mask=discard==122640;
parameter_sample=readtable(strcat(rootPath,folderPath,'parameter_list/parameter_table.txt'));
parameter_sample(1, :) = [];
parameter_sample(:,1)=[];
parameter_sample=table2array(parameter_sample);
% g0_p4=0.01;
g1_medlyn_p4=4.64;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
parameter_table=parameter_sample.*g1_medlyn_p4;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
parameter_table(~discard_mask)=[];


obs_ET=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_ET_fluxnet.mat');
obs_GPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_GPP_fluxnet.mat');
obs_NPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_NPP_fluxnet.mat');

g1_ET=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/sensitivity_analysis/g1_ET_sim.mat');
g1_GPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/sensitivity_analysis/g1_GPP_sim.mat');
g1_NPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/sensitivity_analysis/g1_NPP_sim.mat');

for i=1:size(g1_GPP,3)

    ET_sim_each=squeeze(g1_ET(:,1,i));
    ET_obs=squeeze(obs_ET(:,1));

    [rho,p]=
