%%%%%%%%%%%%%%%%%%
%%
%%
site={'DE-Hai.2000-2006.obs.nc','DE-Tha.1998-2003.obs.nc'};
sitenn={'DE-Hai','DE-Tha'};

for s=1:numel(site)
sitename=sitenn{1,s};
site_each=site{1,s};
yr_st=str2double(site_each(end-15:end-12));
yr_en=str2double(site_each(end-10:end-7));

fluxnet3_obs_path=['/Users/zeyu/remote/BSI/work_scratch/ppapastefanou/fluxnet2022/',sitename,'_flux.nc'];
% ncdisp(fluxnet3_obs_path);
fluxnet2_obs_path=['/Users/zeyu/remote/BSI/work_scratch/zduanmu/data/evaluation/FLUXNET/',site{1,s}];
% ncdisp(fluxnet2_obs_path);
gpp_flux2=ncread(fluxnet2_obs_path,'GPP');
LE_flux2=ncread(fluxnet2_obs_path,'LE');
NEE_flux2=ncread(fluxnet2_obs_path,'NEE');
Reco_flux2=ncread(fluxnet2_obs_path,'Reco');

gpp_flux3=ncread(fluxnet3_obs_path,'GPP');
LE_flux3=ncread(fluxnet3_obs_path,'Qle');
NEE_flux3=ncread(fluxnet3_obs_path,'NEE');
Reco_flux3=ncread(fluxnet3_obs_path,'reco');
%% aggreagte ts

gpp_flux2=squeeze(gpp_flux2(1,1,:));
gpp_flux3=squeeze(gpp_flux3(1,1,:)).*10^8;
LE_flux2=squeeze(LE_flux2(1,1,:));
LE_flux3=squeeze(LE_flux3(1,1,:));
NEE_flux2=squeeze(NEE_flux2(1,1,:));
NEE_flux3=squeeze(NEE_flux3(1,1,:)).*10^8;
Reco_flux2=squeeze(Reco_flux2(1,1,:));
Reco_flux3=squeeze(Reco_flux3(1,1,:)).*10^8;

w=15;
varName={'gpp','LE','NEE','Reco'};
fluxtype={'flux2','flux3'};

for i=1:numel(varName)
    for j=1:numel(fluxtype)
        eval(['y=',varName{1,i},'_',fluxtype{1,j},';']);
        y_aggre=Cal_sim_halfhour_day(y,w);
        eval([varName{1,i},'_',fluxtype{1,j},'_agg=y_aggre;']);
    end
end


fig = figure('Color','white','PaperUnits','centimeters','PaperSize',[12 18],'PaperPosition',[0,0,12,18],'Visible','on');
cmap=[243,231,155
    92,83,165]./255;
x_2=(yr_st-1990)*25+1:1:(yr_st-1990)*25+size(gpp_flux2_agg,1);
x_3=1:1:size(gpp_flux3_agg,1);

y_name={'GPP (umol m^-^2 s^-^1)','LE (W m^-^2)','NEE (umol m^-^2 s^-^1)','Reco (umol m^-^2 s^-^1)'};

for i=1:numel(varName)
subplot(4,1,i)
hold on
eval(['y_flux2_agg=',varName{1,i},'_flux2_agg;']);
eval(['y_flux3_agg=',varName{1,i},'_flux3_agg;']);
plot(x_3,y_flux3_agg(:,1),'-','Color',cmap(2,:),'LineWidth',1.2);
plot(x_2,y_flux2_agg(:,1),'-','Color',cmap(1,:),'LineWidth',1.2);
box on;
ax = gca;
ax.YLabel.String = y_name{1,i};
ax.XTick=25:25*5:size(gpp_flux3_agg,1);
ax.XTickLabel={};
ax.XLim=[0 size(gpp_flux3_agg,1)];
end

ax.XTickLabel=num2str((1990:5:2021)');
ax.XLabel.String = 'Year';

sgtitle(sitename);

str= strcat('/Users/zeyu/Desktop/PhD work report/202503/FLUXNET/',sitename,' time series.tiff');
print(fig,'-dtiff','-r800', str);

end


%%
% %%
% fluxnet3_obs_path='/Users/zeyu/remote/BSI/work_scratch/ppapastefanou/fluxnet2022/DE-Hai_flux.nc';
% % ncdisp(fluxnet3_obs_path);
% fluxnet2_obs_path='/Users/zeyu/remote/BSI/scratch/zduanmu/quincy_exp/exp_82_baseline_options_transient_fluxnet2_dynbnf_cnp_ssm_7d8940fd/DE-Hai/output/obs.nc';
% % ncdisp(fluxnet2_obs_path);
% gpp_flux2=ncread(fluxnet2_obs_path,'GPP');
% LE_flux2=ncread(fluxnet2_obs_path,'LE');
% NEE_flux2=ncread(fluxnet2_obs_path,'NEE');
% Reco_flux2=ncread(fluxnet2_obs_path,'Reco');
% 
% gpp_flux3=ncread(fluxnet3_obs_path,'GPP');
% LE_flux3=ncread(fluxnet3_obs_path,'Qle');
% NEE_flux3=ncread(fluxnet3_obs_path,'NEE');
% Reco_flux3=ncread(fluxnet3_obs_path,'reco');
% %% plot ts
% fluxnet2_time=1:1:122736;
% fluxnet3_time=fluxnet2_time;
% st=(365*10+2)*48+1;
% en=(365*10+2)*48+122736;
% gpp_flux2=squeeze(gpp_flux2(1,1,:));
% gpp_flux3=squeeze(gpp_flux3(1,1,:)).*10^8;
% LE_flux2=squeeze(LE_flux2(1,1,:));
% LE_flux3=squeeze(LE_flux3(1,1,:));
% NEE_flux2=squeeze(NEE_flux2(1,1,:));
% NEE_flux3=squeeze(NEE_flux3(1,1,:)).*10^8;
% Reco_flux2=squeeze(Reco_flux2(1,1,:));
% Reco_flux3=squeeze(Reco_flux3(1,1,:)).*10^8;
% fig = figure('Color','white','PaperUnits','centimeters','PaperSize',[12 18],'PaperPosition',[0,0,12,18],'Visible','on');
% cmap=[243,231,155
%     92,83,165]./255;
% subplot(4,1,1)
% hold on
% plot(fluxnet3_time,gpp_flux3(st:en,1),'-','Color',cmap(2,:));
% plot(fluxnet2_time,gpp_flux2,'-','Color',cmap(1,:));
% box on;
% ax = gca;
% ax.YLabel.String = 'GPP (umol m^-^2 s^-^1)';
% ax.XTick=[17568,35088,52608,70128,87696,105216,122736];
% ax.XTickLabel=num2str((2000:1:2006)');
% subplot(4,1,2)
% hold on
% plot(fluxnet3_time,LE_flux3(st:en,1),'-','Color',cmap(2,:));
% plot(fluxnet2_time,LE_flux2,'-','Color',cmap(1,:));
% box on;
% ax = gca;
% ax.YLabel.String = 'LE (W m^-^2)';
% ax.XTick=[17568,35088,52608,70128,87696,105216,122736];
% ax.XTickLabel=num2str((2000:1:2006)');
% subplot(4,1,3)
% hold on
% plot(fluxnet3_time,NEE_flux3(st:en,1),'-','Color',cmap(2,:));
% plot(fluxnet2_time,NEE_flux2,'-','Color',cmap(1,:));
% box on;
% ax = gca;
% ax.YLabel.String = 'NEE (umol m^-^2 s^-^1)';
% ax.XTick=[17568,35088,52608,70128,87696,105216,122736];
% ax.XTickLabel=num2str((2000:1:2006)');
% subplot(4,1,4)
% hold on
% plot(fluxnet3_time,Reco_flux3(st:en,1),'-','Color',cmap(2,:));
% plot(fluxnet2_time,Reco_flux2,'-','Color',cmap(1,:));
% box on;
% ax = gca;
% ax.YLabel.String = 'Reco (umol m^-^2 s^-^1)';
% ax.XLabel.String = 'Year';
% ax.XTick=[17568,35088,52608,70128,87696,105216,122736];
% ax.XTickLabel=num2str((2000:1:2006)');
% str= strcat('/Users/zeyu/Desktop/PhD work report/202503/FLUXNET/time series.tiff');
% print(fig,'-dtiff','-r800', str);
