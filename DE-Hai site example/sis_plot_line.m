%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot them
%% define the filepath
rootPath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/src/QPy/examples/sens/output/';
folderName={'LH-latosa_xylem_g1_g0/','LH-k_latosa/','LH-k_xylem_sat/','LH-latosa_xylem/','LH-soil_texture_constraint/'};
for iff=1:numel(folderName)
    folderPath=folderName{1,iff};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable

    parameter_table=readtable(strcat(rootPath,folderPath,'parameters.csv'),'HeaderLines', 1);
    parameter_table=table2array(parameter_table);
    parameter_table(:,2:3)=[];

    obs_ET=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_ET_fluxnet.mat');
    obs_GPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_GPP_fluxnet.mat');
    obs_NPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Feb/analyze_output/aggreagate/OBS_NPP_fluxnet.mat');

    dev_ET=loadMatData('/Users/zeyu/remote/home_drive/2025/Apr/development/g1_ET_sim.mat');
    dev_GPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Apr/development/g1_GPP_sim.mat');
    dev_NPP=loadMatData('/Users/zeyu/remote/home_drive/2025/Apr/development/g1_NPP_sim.mat');

    savepath=strcat('/Users/zeyu/remote/home_drive/2025/Mar/test_scale_sensitivity/',folderPath,'/');

    g1_ET=loadMatData(savepath,'g1_ET_sim.mat');
    g1_GPP=loadMatData(savepath,'g1_GPP_sim.mat');
    g1_NPP=loadMatData(savepath,'g1_NPP_sim.mat');


    %% plot lines
    pp_name={'latosa xylem g1 g0','k-latosa','k-xylem-sat','latosa xylem','soil texture'};
    p_name=pp_name{1,iff};

    fig = figure('Color','white','PaperUnits','centimeters','PaperSize',[12 18],'PaperPosition',[0,0,12,18],'Visible','on');

    y_name={'ET','GPP','NPP'};
    y_unit={'mm d^-^1','g m^-^2 d^-^1','g m^-^2 d^-^1'};
    x_com=1:size(g1_NPP,1);


    % 使用 ind2rgb 生成 RGB 颜色
    [~,idx]=sort(parameter_table);
    cmap = ind2rgb(idx,flip(summer(size(parameter_table,1)),1));
    cmap=squeeze(cmap(:,1,:));

    t = tiledlayout(3,1);
    % 创建tiledlayout
    hold on
    for i=1:3
        nexttile;
        eval(['y_sim=g1_',y_name{1,i},';']);
        hold on
        for p=1:size(y_sim,3)
            y_sim_each=squeeze(y_sim(:,1,p));
            plot(x_com',y_sim_each,'Color',cmap(p,:),'LineWidth',0.5);
        end


        eval(['y=obs_',y_name{1,i},';']);
        hold on
        for iy=1:size(y,3)
            [f,pp]=sis_draw_ts_shading(x_com,y(:,1),y(:,2:3),'k');
        end


        eval(['y_dev=dev_',y_name{1,i},';']);
        hold on
        for iy=1:size(y,3)
            [f,pp]=sis_draw_ts_shading(x_com,y_dev(1:175,1),y_dev(1:175,2:3),[.69 .09 .12]);
        end

        ax = gca;
        ax.YLabel.String = strcat(y_name{1,i},32,'(',y_unit{1,i},')');
        ax.XTick=12.5:25:175;
        ax.XLim=[0 175];
        ax.XTickLabel=num2str((2000:1:2006)');
        if i==1
            ax.YLim=[-1 10];
        elseif i<4
            ax.YLim=[-1 30];
        elseif i>4
            ax.YLim=[-3 0];
        end
        FtSize=8;
        ax.FontSize=FtSize;
        box on
    end

    % ax.XLabel.String = 'Year';
    % 添加一个全局 colorbar
    % 为colorbar的每个刻度添加标签

    pa_sort=nan(size(idx,1),4);
    for d=1:size(idx,2)
        pa_sort(:,d)=parameter_table(idx(:,d));
    end

    cmap_sorted = [idx,cmap];
    cmap_sorted_2 = sortrows(cmap_sorted,1);

    colormap(cmap_sorted_2(:,end-2:end))
    cb = colorbar; % 在底部添加 colorbar
    cb.Layout.Tile = 'south';
    clim([0 size(parameter_table,1)]);
    cb.TickLength = 0.005;
    % cb.Ticks = 0.5: 1: size(parameter_table,1)-0.5; % 将colorbar划分为31个刻度
    % cb.TickLabels = num2str(round(pa_sort,2)); % 生成31个标签
    cb.Label.String = 'Parameter combination number';
    FtSize=8;
    ax.FontSize=FtSize;
    cb.Title.FontSize = FtSize;
    cb.FontSize =8;
    sgtitle(p_name);

    colnames = {'latosa','xylem','g1','g0';
        'latosa','n2','n3','n4';
        'xylem','n2','n3','n4';
        'latosa','xylem','n3','n4';
        'sand','silt','n3','n4'};
    T = array2table(pa_sort,'VariableNames',colnames(iff,:));
    savepath=['/Users/zeyu/remote/home_drive/2025/Apr/parameter sensitivity/',folderPath];
    mkdir(savepath);
    writetable(T,[savepath,'parameter_table.xlsx']);

    print(fig,'-dtiff','-r800',strcat(savepath,p_name,'_lines.tif'));%%%%%%%%editable
    close(fig);
    clear pa_sort cmap
end