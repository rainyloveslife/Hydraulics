%% QUINCY development OUTPUT

%% define the filepath
rootPath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/src/QPy/examples/sens/output/';
folderPath='development/';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
fileName=[rootPath,folderPath,'DE-Hai/output/'];
%% load the variables
pp_scaler=0.963;
et_scaler=24*60*60;
ET_aggr_sen=nan(325,3);
GPP_aggr_sen=nan(325,3);
NPP_aggr_sen=nan(325,3);
SWC_aggr_sen=nan(325,3);

% GPP
gpp=ncread(strcat(fileName,'Q_ASSIMI_fluxnetdata_timestep.nc'),'gpp_avg')./pp_scaler;
% NPP
npp=ncread(strcat(fileName,'VEG_fluxnetdata_timestep.nc'),'npp_avg')./pp_scaler;
% ET
eva=ncread(strcat(fileName,'SPQ_fluxnetdata_timestep.nc'),'evaporation_avg').*et_scaler;
tran=ncread(strcat(fileName,'SPQ_fluxnetdata_timestep.nc'),'transpiration_avg').*et_scaler;
inte=ncread(strcat(fileName,'SPQ_fluxnetdata_timestep.nc'),'interception_avg').*et_scaler;
et=eva+tran+inte;
% SWC
wcs=ncread(strcat(fileName,'SPQ_fluxnetdata_timestep.nc'),'water_content_soil');

% calculate the aggregate ts
window=15;
ET_aggr_sen(:,:)=Cal_sim_halfhour_day(et,window);
GPP_aggr_sen(:,:)=Cal_sim_halfhour_day(gpp,window);
NPP_aggr_sen(:,:)=Cal_sim_halfhour_day(npp,window);
SWC_aggr_sen(:,:)=Cal_sim_halfhour_day(wcs,window);


% save
savepath=strcat('/Users/zeyu/remote/home_drive/2025/Apr/',folderPath,'/');
mkdir(savepath);
save(strcat(savepath,'g1_GPP_sim.mat'),'GPP_aggr_sen');
save(strcat(savepath,'g1_NPP_sim.mat'),'NPP_aggr_sen');
save(strcat(savepath,'g1_ET_sim.mat'),'ET_aggr_sen');
save(strcat(savepath,'g1_SWC_sim.mat'),'SWC_aggr_sen');



