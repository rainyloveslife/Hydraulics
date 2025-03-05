%% define the filepath
rootPath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/src/QPy/examples/sens/output/';
folderPath='LH-k_latosa/';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
fileName=cell(50,1);                                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
for i=1:50                                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
    fileName{i,1}=strcat(rootPath,folderPath,num2str(i-1),'/');
end


%% load the variables
pp_scaler=0.963;
et_scaler=24*60*60;
ET_aggr_sen=nan(175,3,size(fileName,1));
GPP_aggr_sen=nan(175,3,size(fileName,1));
NPP_aggr_sen=nan(175,3,size(fileName,1));

parfor i = 1:size(fileName,1)  
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
savepath=strcat('/Users/zeyu/remote/home_drive/2025/Mar/test_scale_sensitivity/',folderPath,'/');
save(strcat(savepath,'g1_GPP_sim.mat'),'GPP_aggr_sen');
save(strcat(savepath,'g1_NPP_sim.mat'),'NPP_aggr_sen');
save(strcat(savepath,'g1_ET_sim.mat'),'ET_aggr_sen');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot them
%% define the filepath
rootPath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/src/QPy/examples/sens/output/';
folderPath='LH-k_latosa/';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable

parameter_table=readtable(strcat(rootPath,folderPath,'parameters.csv'),'HeaderLines', 1);
parameter_table=table2array(parameter_table);
parameter_table(:,2:3)=[];

obs_ET=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_ET_fluxnet.mat');
obs_GPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_GPP_fluxnet.mat');
obs_NPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_NPP_fluxnet.mat');
savepath=strcat('/Users/zeyu/remote/home_drive/2025/Mar/test_scale_sensitivity/',folderPath,'/');

g1_ET=loadMatData(savepath,'g1_ET_sim.mat');
g1_GPP=loadMatData(savepath,'g1_GPP_sim.mat');
g1_NPP=loadMatData(savepath,'g1_NPP_sim.mat');

%% plot lines
folderPath='LH-k_latosa/';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
p_name='k-latosa';

fig = figure('Color','white','PaperUnits','centimeters','PaperSize',[12 16],'PaperPosition',[0,0,12,16],'Visible','on');

y_name={'ET','GPP','NPP'};
y_unit={'mm d^-^1','g m^-^2 d^-^1','g m^-^2 d^-^1'};
x_com=1:size(g1_NPP,1);


% 使用 ind2rgb 生成 RGB 颜色
[~,idx]=sort(parameter_table);
cmap = ind2rgb(idx,flip(cool(size(parameter_table,1)),1));
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
    hold on
    for p=1:size(y_sim,3)
        y_sim_each=squeeze(y_sim(:,1,p));
        plot(x_com',y_sim_each,'Color',cmap(p,:),'LineWidth',0.5);
    end
    ax = gca;
    ax.YLabel.String = strcat(y_name{1,i},32,'(',y_unit{1,i},')');
    ax.XTick=12.5:25:175;
    ax.XLim=[0 175];
    ax.XTickLabel=num2str((2000:1:2006)');
    if i==1
        ax.YLim=[-1 5];
    else
        ax.YLim=[-1 15];
    end
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
sgtitle(p_name);

print(fig,'-dtiff','-r800',strcat('/Users/zeyu/remote/home_drive/2025/Mar/test_scale_sensitivity/',folderPath,'/',p_name,'_lines.tif'));%%%%%%%%editable
