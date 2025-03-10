%% Here is the function of plot the output of parameter sensitivity
%% calculate R, rmse, R square

rootPath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/src/QPy/examples/sens/output/';
folderPath='LH-k_latosa/';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable

obs_ET=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_ET_fluxnet.mat');
obs_GPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_GPP_fluxnet.mat');
obs_NPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_NPP_fluxnet.mat');

g1_ET=loadMatData('/Users/zeyu/remote/home_drive/2025/Mar/test_scale_sensitivity/',folderPath,'/g1_ET_sim.mat');%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
g1_GPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Mar/test_scale_sensitivity/',folderPath,'/g1_GPP_sim.mat');%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
g1_NPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Mar/test_scale_sensitivity/',folderPath,'/g1_NPP_sim.mat');%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable


y_name={'ET','GPP','NPP'};
y_unit={'mm d^-^1','g m^-^2 d^-^1','g m^-^2 d^-^1'};

for t=1:3
    eval(['y_sim=g1_',y_name{1,t},';']);
    eval(['y_obs=obs_',y_name{1,t},';']);

    sta_mat=nan(size(g1_GPP,3),3);
    for i=1:size(g1_GPP,3)

        y_sim_each=squeeze(y_sim(:,1,i));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
        y_obs_mean=squeeze(y_obs(:,1));

        [rho,p]=corr(y_sim_each,y_obs_mean);
        rmse = sqrt(mean((y_sim_each-y_obs_mean).^2));
        mdl = fitlm(y_obs_mean,y_sim_each);
        r_square = mdl.Rsquared.Ordinary;

        sta_mat(i,:)=[rmse,r_square,rho];

    end
    savepath='/Users/zeyu/remote/home_drive/2025/Mar/test_scale_sensitivity/';
    save(strcat(savepath,folderPath,y_name{1,t},'_sta.mat'),'sta_mat');%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable

    clear sta_mat

end




%%
savepath='/Users/zeyu/remote/home_drive/2025/Mar/test_scale_sensitivity/';
folderPath='LH-k_latosa/';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
parameter_name='k-latosa';

rootPath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/src/QPy/examples/sens/output/';
parameter_table=readtable(strcat(rootPath,folderPath,'parameters.csv'),'HeaderLines', 1);
parameter_table=table2array(parameter_table);
parameter_table(:,2:3)=[];

ET_sta=loadMatData(savepath,folderPath,'ET_sta.mat');
GPP_sta=loadMatData(savepath,folderPath,'GPP_sta.mat');
NPP_sta=loadMatData(savepath,folderPath,'NPP_sta.mat');

cmap=[120 94 240
220 38 127
255 176 0]./255;


typename={'RMSE','R^2','r'};
for t=1:numel(typename)
    x1=parameter_table;
    x2=x1;
    x3=x1;
    y1=ET_sta(:,t);
    y2=GPP_sta(:,t);
    y3=NPP_sta(:,t);

    ftsize=8;
    ylabels{1}='ET';
    ylabels{2}='GPP';
    ylabels{3}='NPP';
    [ax,hlines] = multiplotyyy({x1,y1},{x2,y2},{x3,y3},ylabels);
    % set(gcf, 'Units', figureUnits, 'Position', [0 0 figureWidth figureHeight]);
    set(hlines{1}(:),'LineStyle','none','Marker','o','MarkerFaceColor',cmap(1,:),'Markersize',5);
    set(hlines{2}(:),'LineStyle','none','Marker','o','MarkerFaceColor',cmap(2,:),'Markersize',5);
    set(hlines{3}(:),'LineStyle','none','Marker','o','MarkerFaceColor',cmap(3,:),'Markersize',5);
    xlabel(ax(1),"Parameter",'FontSize',ftsize);
    ylabel(ax(1),"ET",'FontSize',ftsize);
    ylabel(ax(2),"GPP",'FontSize',ftsize);
    ylabel(ax(3),"NPP",'FontSize',ftsize);
    title(strcat(parameter_name,32,typename{1,t}));
    set(gca,'FontSize',ftsize);

    str= strcat(savepath,folderPath,typename{1,t},'.tiff');
    print(gcf,'-dtiff','-r800', str);
    close(gcf);
    clear ax hlines
end