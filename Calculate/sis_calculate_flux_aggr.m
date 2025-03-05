%% calculate 
%% OBS
output_path= '/Users/zeyu/remote/BSI/scratch/zduanmu/quincy_exp/exp_82_baseline_options_transient_fluxnet2_dynbnf_cnp_ssm_7d8940fd/DE-Hai/output/';
pp_scaler=0.963;
et_scaler=24*60*60;
gpp_obs=ncread(strcat(output_path,'obs.nc'),'GPP');
gpp_obs=squeeze(gpp_obs(1,1,:))./pp_scaler;

Reco_obs=ncread(strcat(output_path,'obs.nc'),'Reco');
Reco_obs=squeeze(Reco_obs(1,1,:))./pp_scaler;

% calculate NPP
% Ra（Rh = 0.5 * Reco）
Ra = Reco_obs - (0.5 * Reco_obs);
npp_obs = gpp_obs - Ra;

% calculate the aggregate ts
window=15;
GPP_OBS_aggr=Cal_halfhour_day(gpp_obs,window);
Reco_OBS_aggr=Cal_halfhour_day(Reco_obs,window);
NPP_OBS_aggr=Cal_halfhour_day(npp_obs,window);

% save
savepath='/Users/zeyu/remote/BSI/scratch/zduanmu/quincy_exp/exp_82_baseline_options_transient_fluxnet2_dynbnf_cnp_ssm_7d8940fd/analyze_output/aggreagate/';

save(strcat(savepath,'OBS_GPP_fluxnet.mat'),'GPP_OBS_aggr');
save(strcat(savepath,'OBS_NPP_fluxnet.mat'),'NPP_OBS_aggr');


clear all
clc
%% QUINCY simulation outputs
pp_scaler=0.963;
et_scaler=24*60*60;

output_path= '/Users/zeyu/remote/BSI/scratch/zduanmu/quincy_exp/exp_80_baseline_options_transient_fluxnet2_unlbnf_c_ssm_7d8940fd/DE-Hai/output/';

% GPP
gpp=ncread(strcat(output_path,'Q_ASSIMI_fluxnetdata_timestep.nc'),'gpp_avg')./pp_scaler;
% NPP
npp=ncread(strcat(output_path,'VEG_fluxnetdata_timestep.nc'),'npp_avg')./pp_scaler;
% ET
eva=ncread(strcat(output_path,'SPQ_fluxnetdata_timestep.nc'),'evaporation_avg').*et_scaler;
tran=ncread(strcat(output_path,'SPQ_fluxnetdata_timestep.nc'),'transpiration_avg').*et_scaler;
et=eva+tran;

% calculate the aggregate ts
window=15;
ET_aggr=Cal_sim_halfhour_day(et,window);
GPP_aggr=Cal_sim_halfhour_day(gpp,window);
NPP_aggr=Cal_sim_halfhour_day(npp,window);

% save
savepath='/Users/zeyu/remote/BSI/scratch/zduanmu/quincy_exp/exp_80_baseline_options_transient_fluxnet2_unlbnf_c_ssm_7d8940fd/analyze_output/aggreagate/';

save(strcat(savepath,'sim_ET_fluxnet.mat'),'ET_aggr');
save(strcat(savepath,'sim_GPP_fluxnet.mat'),'GPP_aggr');
save(strcat(savepath,'sim_NPP_fluxnet.mat'),'NPP_aggr');
