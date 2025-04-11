%%
%% OBS
output_path= '/Users/zeyu/remote/home_drive/2025/Mar/FLUXNET2/';
pp_scaler=0.963;
gpp_obs=ncread(strcat(output_path,'DE-Hai.2000-2006.obs.nc'),'GPP');
gpp_obs=squeeze(gpp_obs(1,1,:))./pp_scaler;
[sos,eos]=retrive_phenology(gpp_obs);
sos_obs_mean=mean(sos,2);
eos_obs_mean=mean(eos,2);
los_obs_mean=eos_obs_mean-sos_obs_mean;

%% simulation
cd('/Users/zeyu/remote/BSI/work_scratch/zduanmu/phd/implement hydraulics/phenology/site phenology/')
folderName={'LH-t_air_senescence/','LH-k_gddreq/','LH-k_gdd_dormance/','LH-gdd_req_max/','LH-min_leaf_age/','LH-k_gddreq_Tsen_leafage/','LH-Tsen_leafage/'};
pp_scaler=0.963;
savepath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/phd/implement hydraulics/phenology/parameter analysis/';

for iff=1:numel(folderName)
    folderPath=folderName{1,iff};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
    rootPath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/src/QPy/examples/sens/output/';
    mkdir([savepath,folderPath]);

    sos_mean_mat=nan(7,100);
    eos_mean_mat=nan(7,100);
    los_mean_mat=nan(7,100);

    rho_rmse_sos=nan(100,2);
    rho_rmse_eos=nan(100,2);
    rho_rmse_los=nan(100,2);

    parfor i=1:100                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
        fileName=strcat(rootPath,folderPath,num2str(i-1),'/');
        gpp=ncread(strcat(fileName,'Q_ASSIMI_fluxnetdata_timestep.nc'),'gpp_avg')./pp_scaler;
        [sos_sim,eos_sim]=retrive_phenology(gpp);
        sos_mean=mean(sos_sim,2);
        eos_mean=mean(eos_sim,2);
        los_mean=eos_mean-sos_mean;
        sos_mean_mat(:,i)=sos_mean;
        eos_mean_mat(:,i)=eos_mean;
        los_mean_mat(:,i)=los_mean;
        % sos statistical
        [rho_sos,p_sos]=corr(sos_mean,sos_obs_mean);
        rmse_sos = sqrt(mean((sos_mean-sos_obs_mean).^2));
        rho_rmse_sos(i,:)=[rho_sos,rmse_sos];
        % eos statistical
        [rho_eos,p_eos]=corr(eos_mean,eos_obs_mean);
        rmse_eos = sqrt(mean((eos_mean-eos_obs_mean).^2));
        rho_rmse_eos(i,:)=[rho_eos,rmse_eos];
        % los statistical
        [rho_los,p_los]=corr(los_mean,los_obs_mean);
        rmse_los = sqrt(mean((los_mean-los_obs_mean).^2));
        rho_rmse_los(i,:)=[rho_los,rmse_los];
    end

    save(strcat(savepath,folderPath,'sos_mean_mat'),'sos_mean_mat');
    save(strcat(savepath,folderPath,'eos_mean_mat'),'eos_mean_mat');
    save(strcat(savepath,folderPath,'los_mean_mat'),'los_mean_mat');

    save(strcat(savepath,folderPath,'rho_rmse_sos'),'rho_rmse_sos');
    save(strcat(savepath,folderPath,'rho_rmse_eos'),'rho_rmse_eos');
    save(strcat(savepath,folderPath,'rho_rmse_los'),'rho_rmse_los');
end

