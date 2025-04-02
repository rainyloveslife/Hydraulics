%% scatter and label the best scatter
cd('/Users/zeyu/remote/home_drive/2025/Apr/DE-Hai site example/')
%% Here is the function of plot the output of parameter sensitivity
%% calculate R, rmse, R square
folderName={'LH-latosa_xylem_g1_g0/','LH-k_latosa/','LH-k_xylem_sat/','LH-latosa_xylem/','LH-soil_texture_constraint/','LH-g1_g0/'};

for iff=1:numel(folderName)
    folderPath=folderName{1,iff};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable

    obs_ET=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_ET_fluxnet.mat');
    obs_GPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_GPP_fluxnet.mat');
    obs_NPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_NPP_fluxnet.mat');

    savepath=strcat('/Users/zeyu/remote/home_drive/2025/Mar/test_scale_sensitivity/',folderPath,'/');

    g1_ET=loadMatData(savepath,'g1_ET_sim.mat');
    g1_GPP=loadMatData(savepath,'g1_GPP_sim.mat');
    g1_NPP=loadMatData(savepath,'g1_NPP_sim.mat');

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
        savepath='/Users/zeyu/remote/home_drive/2025/Apr/parameter sensitivity/';
        save(strcat(savepath,folderPath,y_name{1,t},'_sta.mat'),'sta_mat');%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable

        clear sta_mat
    end
end




%%
savepath='/Users/zeyu/remote/home_drive/2025/Apr/parameter sensitivity/';
folderName={'LH-latosa_xylem_g1_g0/','LH-k_latosa/','LH-k_xylem_sat/','LH-latosa_xylem/','LH-soil_texture_constraint/','LH-g1_g0/'};

for iff=1:numel(folderName)
    folderPath=folderName{1,iff};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
    pp_name={'latosa xylem g1 g0','k-latosa','k-xylem-sat','latosa xylem','soil texture','g1 g0'};
    p_name=pp_name{1,iff};
    rootPath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/src/QPy/examples/sens/output/';
    parameter_table=readtable(strcat(rootPath,folderPath,'parameters.csv'),'HeaderLines', 1);
    parameter_table=table2array(parameter_table);
    parameter_table(:,2:3)=[];

    [~,idx]=sort(parameter_table);
    pa_sort=nan(size(idx,1),4);
    for d=1:size(idx,2)
        pa_sort(:,d)=parameter_table(idx(:,d));
    end

    ET_sta=loadMatData(savepath,folderPath,'ET_sta.mat');
    GPP_sta=loadMatData(savepath,folderPath,'GPP_sta.mat');
    NPP_sta=loadMatData(savepath,folderPath,'NPP_sta.mat');

    ET_sta(isnan(ET_sta))=0;
    GPP_sta(isnan(GPP_sta))=0;
    NPP_sta(isnan(NPP_sta))=0;

    cmap=[120 94 240
        220 38 127
        255 176 0]./255;

    %% find the best option
    % min RMSE + max R2
    [min_Three, min_Three_row]= normalize_columns(ET_sta+GPP_sta+NPP_sta);

    %%

    typename={'RMSE','R^2'};
    for t=1:numel(typename)
        x1=idx(:,1);
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
        xlabel(ax(1),"Parameter combination number",'FontSize',ftsize);
        ylabel(ax(1),"ET",'FontSize',ftsize);
        ylabel(ax(2),"GPP",'FontSize',ftsize);
        ylabel(ax(3),"NPP",'FontSize',ftsize);
        title(strcat(p_name,32,'(',typename{1,t},')'));
        set(gca,'FontSize',ftsize);
        line([idx(min_Three_row,1) idx(min_Three_row,1)],[0 max([y1;y2;y3])],'linestyle','--','Color',[135,135,135]./255,'LineWidth',0.8);
        str= strcat(savepath,folderPath,typename{1,t},'.tiff');
        print(gcf,'-dtiff','-r800', str);
        close(gcf);
        clear ax hlines
    end
end

%%
%%
savepath='/Users/zeyu/remote/home_drive/2025/Apr/parameter sensitivity/';
folderName={'LH-latosa_xylem_g1_g0/','LH-k_latosa/','LH-k_xylem_sat/','LH-latosa_xylem/','LH-soil_texture_constraint/','LH-g1_g0/'};

obs_ET=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_ET_fluxnet.mat');
obs_GPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_GPP_fluxnet.mat');
obs_NPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_NPP_fluxnet.mat');


for iff=1:numel(folderName)
    folderPath=folderName{1,iff};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
    pp_name={'latosa xylem g1 g0','k-latosa','k-xylem-sat','latosa xylem','soil texture','g1 g0'};
    p_name=pp_name{1,iff};
    rootPath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/src/QPy/examples/sens/output/';
    parameter_table=readtable(strcat(rootPath,folderPath,'parameters.csv'),'HeaderLines', 1);
    parameter_table=table2array(parameter_table);
    parameter_table(:,2:3)=[];

    [~,idx]=sort(parameter_table);
    pa_sort=nan(size(idx,1),4);
    for d=1:size(idx,2)
        pa_sort(:,d)=parameter_table(idx(:,d));
    end

    ET_sta=loadMatData(savepath,folderPath,'ET_sta.mat');
    GPP_sta=loadMatData(savepath,folderPath,'GPP_sta.mat');
    NPP_sta=loadMatData(savepath,folderPath,'NPP_sta.mat');

    ET_sta(isnan(ET_sta))=0;
    GPP_sta(isnan(GPP_sta))=0;
    NPP_sta(isnan(NPP_sta))=0;

    cmap=[120 94 240
        220 38 127
        255 176 0]./255;

    %% find the best option
    % min RMSE + max R2
    [min_Three, min_Three_row]= normalize_columns(ET_sta+GPP_sta+NPP_sta);

    spath=strcat('/Users/zeyu/remote/home_drive/2025/Mar/test_scale_sensitivity/',folderPath,'/');

    g1_ET=loadMatData(spath,'g1_ET_sim.mat');
    g1_GPP=loadMatData(spath,'g1_GPP_sim.mat');
    g1_NPP=loadMatData(spath,'g1_NPP_sim.mat');

    fig = figure('Color','white','PaperUnits','centimeters','PaperSize',[6 18],'PaperPosition',[0,0,6,18],'Visible','off');

    y_name={'ET','GPP','NPP'};
    y_unit={'mm d^-^1','g m^-^2 d^-^1','g m^-^2 d^-^1'};

    for i=1:3
        nexttile;
        eval(['y_sim=g1_',y_name{1,i},';']);
        hold on
        eval(['y=obs_',y_name{1,i},';']);

        obs_sim=nan(175,2);
        obs_sim(:,1)=y(:,1);
        obs_sim(:,2)=y_sim(:,1,min_Three_row);
        zero_mask=obs_sim(:,1)==0|obs_sim(:,2)==0;
        A = repelem(1:7, 25)';
        hold on
        for j=1:175
            jc=zero_mask(j,1);
            hold on
            scatter(obs_sim(j,1),obs_sim(j,2),15,cmap(i,:),'filled');
        end
        box on
        % 线性拟合
        p = polyfit(obs_sim(:,1),obs_sim(:,2), 1); % 一次多项式拟合（线性）
        y_fit = polyval(p,obs_sim(:,1)); % 计算拟合曲线的 y 值
        % 计算 R²（决定系数）
        R = corrcoef(obs_sim(:,2), y_fit); % 计算相关系数矩阵
        R2 = R(1,2)^2; % 取平方得到 R²
        plot(obs_sim(:,1), y_fit, '-k', 'LineWidth', 1);
        if i<2
            text(1.5,8,strcat('R^2=',num2str(round(R2,2))));
        else
            text(1.5,13,strcat('R^2=',num2str(round(R2,2))));
        end
        hold off
        ax=gca;
        FtSize=8;
        ax.FontSize=FtSize;
        xticks([0:5:15]);
        yticks([0:5:15]);
        axis square
        xlabel(strcat('Observed',32,y_name{1,i}));
        ylabel(strcat('Simulated',32,y_name{1,i}));
        if i<2
            xlim([-2 10]);
            ylim([-2 10]);
        else
            xlim([-2 15]);
            ylim([-2 15]);
        end
    end

    figpath=['/Users/zeyu/remote/home_drive/2025/Apr/parameter sensitivity/',folderPath];
   
    print(fig,'-dtiff','-r800',strcat(figpath,p_name,'_best_para.tif'));%%%%%%%%editable
    % close(fig);
end

