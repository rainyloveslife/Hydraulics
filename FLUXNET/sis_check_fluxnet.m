%%
fluxnet3_obs_path='/Users/zeyu/remote/BSI/work_scratch/ppapastefanou/fluxnet2022/DE-Hai_flux.nc';
% ncdisp(fluxnet3_obs_path);

fluxnet2_obs_path='/Users/zeyu/remote/BSI/scratch/zduanmu/quincy_exp/exp_82_baseline_options_transient_fluxnet2_dynbnf_cnp_ssm_7d8940fd/DE-Hai/output/obs.nc';
% ncdisp(fluxnet2_obs_path);

gpp_flux2=ncread(fluxnet2_obs_path,'GPP');
LE_flux2=ncread(fluxnet2_obs_path,'LE');
NEE_flux2=ncread(fluxnet2_obs_path,'NEE');
Reco_flux2=ncread(fluxnet2_obs_path,'Reco');

gpp_flux3=ncread(fluxnet3_obs_path,'GPP');
LE_flux3=ncread(fluxnet3_obs_path,'Qle');
NEE_flux3=ncread(fluxnet3_obs_path,'NEE');
Reco_flux3=ncread(fluxnet3_obs_path,'reco');

%% plot ts
fluxnet3_time=1:1:561024;
fluxnet2_time=(365*10+2)*48+1:1:(365*10+2)*48+122736;

gpp_flux2=squeeze(gpp_flux2(1,1,:));
gpp_flux3=squeeze(gpp_flux3(1,1,:)).*10^8;

LE_flux2=squeeze(LE_flux2(1,1,:));
LE_flux3=squeeze(LE_flux3(1,1,:));

NEE_flux2=squeeze(NEE_flux2(1,1,:));
NEE_flux3=squeeze(NEE_flux3(1,1,:)).*10^8;

Reco_flux2=squeeze(Reco_flux2(1,1,:));
Reco_flux3=squeeze(Reco_flux3(1,1,:)).*10^8;



fig = figure('Color','white','PaperUnits','centimeters','PaperSize',[12 18],'PaperPosition',[0,0,12,18],'Visible','on');
cmap=[243,231,155
248,160,126
206,102,147
92,83,165]./255;

subplot(4,1,1)
hold on
plot(fluxnet3_time,gpp_flux3,'-','Color',cmap(2,:));
plot(fluxnet2_time,gpp_flux2,'-','Color',cmap(1,:));
box on;
ax = gca;
ax.YLabel.String = 'GPP (umol m^-^2 s^-^1)';



subplot(4,1,2)
hold on

plot(fluxnet3_time,LE_flux3,'-','Color',cmap(2,:));
plot(fluxnet2_time,LE_flux2,'-','Color',cmap(1,:));
box on;
ax = gca;
ax.YLabel.String = 'LE (W m^-^2)';


subplot(4,1,3)
hold on

plot(fluxnet3_time,NEE_flux3,'-','Color',cmap(2,:));
plot(fluxnet2_time,NEE_flux2,'-','Color',cmap(1,:));
box on;
ax = gca;
ax.YLabel.String = 'NEE (umol m^-^2 s^-^1)';


subplot(4,1,4)
hold on

plot(fluxnet3_time,Reco_flux3,'-','Color',cmap(2,:));
plot(fluxnet2_time,Reco_flux2,'-','Color',cmap(1,:));
box on;
ax = gca;
ax.YLabel.String = 'Reco (umol m^-^2 s^-^1)';
ax.XLabel.String = 'Time';

str= strcat(savepath,folderPath,typename{1,t},'.tiff');
print(gcf,'-dtiff','-r800', str);