%% find the best parameters
output_path= '/Users/zeyu/remote/home_drive/2025/Mar/FLUXNET2/';
pp_scaler=0.963;
gpp_obs=ncread(strcat(output_path,'DE-Hai.2000-2006.obs.nc'),'GPP');
gpp_obs=squeeze(gpp_obs(1,1,:))./pp_scaler;
window=3;
gpp_obs_ts=Cal_sim_halfhour_day(gpp_obs,window);
x_com=1:size(gpp_obs_ts,1);
cmap=[0.3, 0.7, 0.4
    0.58, 0.44, 0.86
    0.2, 0.6, 0.86];

pp_scaler=0.963;
gpp_sim=ncread('/Users/zeyu/remote/BSI/work_scratch/zduanmu/src/QPy/examples/sens/output/hydraulic_test/Q_ASSIMI_fluxnetdata_timestep.nc','gpp_avg')./pp_scaler;
window=3;
gpp_sim_ts=Cal_sim_halfhour_day(gpp_sim,window);

folderName={'LH-t_air_senescence/','LH-k_gddreq/','LH-k_gdd_dormance/','LH-gdd_req_max/','LH-min_leaf_age/','LH-k_gddreq_Tsen_leafage/','LH-Tsen_leafage/'};
titleName={'t air senescence','k gdd dormance&gdd req max','k gdd dormance','gdd req max','min leaf age','kgdd&gddreq&Tsen&minleafage',' Tsen&minleafage'};
pp_scaler=0.963;
savepath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/phd/implement hydraulics/phenology/parameter analysis/';


for iff=1:numel(folderName)
    folderPath=folderName{1,iff};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
    rootPath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/src/QPy/examples/sens/output/';
    mkdir([savepath,folderPath]);

    rho_rmse_sos=loadMatData(savepath,folderPath,'rho_rmse_sos');
    rho_rmse_eos=loadMatData(savepath,folderPath,'rho_rmse_eos');
    rho_rmse_los=loadMatData(savepath,folderPath,'rho_rmse_los');

    sos_best=find(rho_rmse_sos(:,2)==min(rho_rmse_sos(:,2)));
    eos_best=find(rho_rmse_eos(:,2)==min(rho_rmse_eos(:,2)));
    los_best=find(rho_rmse_los(:,2)==min(rho_rmse_los(:,2)));

    bestcom=[sos_best,eos_best,los_best];

    fig = figure('Color','white','PaperUnits','centimeters','PaperSize',[18 6],'PaperPosition',[0,0,18,6],'Visible','on');
    [f,pp]=sis_draw_ts_shading(x_com,gpp_obs_ts(:,1),gpp_obs_ts(:,2:3),'k');
    [f0,pp0]=sis_draw_ts_shading(x_com,gpp_sim_ts(:,1),gpp_sim_ts(:,2:3),'r');
    
    hold on
    for i=1:size(bestcom,2)
        fileName=strcat(rootPath,folderPath,num2str(i-1),'/');
        gpp=ncread(strcat(fileName,'Q_ASSIMI_fluxnetdata_timestep.nc'),'gpp_avg')./pp_scaler;
        gpp_ts=Cal_sim_halfhour_day(gpp,window);
        [f2,pp2]=sis_draw_ts_shading(x_com,gpp_ts(:,1),gpp_ts(:,2:3),cmap(i,:));
        
    end
    ax=gca;
    FtSize=8;
    ax.FontSize=FtSize;
    xticks(122-61:122:854-61);
    yticks(0:5:40);
    ax.XLim=[0 854];
    ax.YLim=[0 40];
    ax.XTickLabel=num2str((2000:1:2006)');

    xlabel('GPP(mm d^-^1)');
    ylabel('Year');
    box on
    title(titleName{1,iff});
    print(fig,'-dtiff','-r800',strcat(savepath,titleName{1,iff},'gppts.tif'));%%%%%%%%editable
    close(fig);
end