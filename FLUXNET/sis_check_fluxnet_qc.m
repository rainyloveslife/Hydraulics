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
gpp_flux2=ncread(fluxnet2_obs_path,'GPP_flag');
LE_flux2=ncread(fluxnet2_obs_path,'LE_flag');
NEE_flux2=ncread(fluxnet2_obs_path,'NEE_flag');
Reco_flux2=ncread(fluxnet2_obs_path,'Reco_flag');

gpp_flux3=ncread(fluxnet3_obs_path,'GPP_qc');
LE_flux3=ncread(fluxnet3_obs_path,'Qle_qc');
NEE_flux3=ncread(fluxnet3_obs_path,'NEE_qc');
Reco_flux3=ncread(fluxnet3_obs_path,'reco_qc');
%% aggreagte ts

gpp_flux2=squeeze(gpp_flux2(1,1,:));
gpp_flux3=double(squeeze(gpp_flux3(1,1,:)));
LE_flux2=squeeze(LE_flux2(1,1,:));
LE_flux3=double(squeeze(LE_flux3(1,1,:)));
NEE_flux2=squeeze(NEE_flux2(1,1,:));
NEE_flux3=double(squeeze(NEE_flux3(1,1,:)));
Reco_flux2=squeeze(Reco_flux2(1,1,:));
Reco_flux3=double(squeeze(Reco_flux3(1,1,:)));


fig = figure('Color','white','PaperUnits','centimeters','PaperSize',[12 18],'PaperPosition',[0,0,12,18],'Visible','on');
cmap=[243,231,155
    92,83,165]./255;
x_2=(yr_st-1990)*365*48+2+1:1:(yr_st-1990)*365*48+2+size(gpp_flux2,1);
x_3=1:1:size(gpp_flux3,1);

y_name={'GPP','LE','NEE','Reco'};
varName={'gpp','LE','NEE','Reco'};

for i=1:numel(varName)
subplot(4,1,i)
hold on
eval(['y_flux2_qc=',varName{1,i},'_flux2;']);
eval(['y_flux3_qc=',varName{1,i},'_flux3;']);
p2=plot(x_2,y_flux2_qc,'-','Color',cmap(1,:),'LineWidth',0.5);
p1=plot(x_3,y_flux3_qc,'-','Color',cmap(2,:),'LineWidth',0.5);

p1.LineStyle = "none";
p1.Marker = ".";
p2.LineStyle = ":";
p2.Marker = ".";

box on;
ax = gca;
ax.YLabel.String = y_name{1,i};
ax.XTick=365*48:365*48*5:size(gpp_flux3,1);
ax.XTickLabel={};
ax.XLim=[0 size(gpp_flux3,1)];
end

ax.XTickLabel=num2str((1990:5:2021)');
ax.XLabel.String = 'Year';

sgtitle(sitename);

str= strcat('/Users/zeyu/Desktop/PhD work report/202503/FLUXNET/',sitename,'QC.tiff');
print(fig,'-dtiff','-r800', str);

end