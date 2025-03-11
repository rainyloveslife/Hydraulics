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



%% 百分比 以及位于一天的哪个时间段
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

%%%%%

cmap = [118,89,133
195,109,154
212,166,196
229,229,240]./255; 

y_name={'GPP','LE','NEE','Reco'};
varName={'gpp','LE','NEE','Reco'};

for i=1:numel(varName)

    eval(['y_flux2_qc=',varName{1,i},'_flux2;']);
    eval(['y_flux3_qc=',varName{1,i},'_flux3;']);
    y_2_reshape=reshape(y_flux2_qc,size(y_flux2_qc,1)/48,48);
    y_3_reshape=reshape(y_flux3_qc,size(y_flux3_qc,1)/48,48);


    % 统计每个数字出现的次数
    [counts_2, edges_2] = histcounts(y_flux2_qc,0:4); 
    [counts_3, edges_3] = histcounts(y_flux3_qc,0:4); 

    fig = figure('Color','white','PaperUnits','centimeters','PaperSize',[12 12],'PaperPosition',[0,0,12,12],'Visible','on');

    subplot(2,2,2)
    pie(counts_2);
     title('FLUXNET La Thuile');

    subplot(2,2,4)
    pie(counts_3);
     title('FLUXNET2015');

    subplot(2,2,1)
    coun_2=nan(4,48);
    for j=1:48
        [coun_2(:,j),~]=histcounts(y_2_reshape(:,j),0:4); 
    end
    h=bar(coun_2'./(size(y_2_reshape,1)),'stacked');
    % 为每个堆叠部分设置颜色
    for l = 1:length(h)
        h(l).FaceColor = cmap(l, :);  % 设置每个堆叠部分的颜色
    end
    colormap(cmap);
    ax = gca;
    ax.XTick=8:8:48;
    ax.YTick=0.2:0.2:1;
    ax.XLim=[0 49];
    ax.YLim=[0 1];
    ax.XTickLabel=num2str((4:4:24)');
    ax.YTickLabel=num2str((20:20:100)');
    ax.XLabel.String = '';
    ax.YLabel.String = '%';
    ax.XLabel.String = 'T';
    title('FLUXNET La Thuile');


    subplot(2,2,3)
    coun_3=nan(4,48);
    for j=1:48
        [coun_3(:,j),~]=histcounts(y_3_reshape(:,j),0:4); 
    end
    h=bar(coun_3'./(size(y_3_reshape,1)),'stacked');
    % 为每个堆叠部分设置颜色
    for l = 1:length(h)
        h(l).FaceColor = cmap(l, :);  % 设置每个堆叠部分的颜色
    end
    
    ax = gca;
    ax.XTick=8:8:48;
    ax.YTick=0.2:0.2:1;
    ax.XLim=[0 49];
    ax.YLim=[0 1];
    ax.XTickLabel=num2str((4:4:24)');
    ax.YTickLabel=num2str((20:20:100)');
    ax.XLabel.String = '';
    ax.YLabel.String = '%';
    ax.XLabel.String = 'T';
    title('FLUXNET2015');

    sgtitle(strcat(sitename,32,y_name{1,i}));

    str= strcat('/Users/zeyu/Desktop/PhD work report/202503/FLUXNET/',sitename,'_',y_name{1,i},'_sta.tiff');
    print(fig,'-dtiff','-r800', str);
    close(fig);

end
end
