%% find the best parameter combination
folderName={'LH-t_air_senescence/','LH-k_gddreq/','LH-k_gdd_dormance/','LH-gdd_req_max/','LH-min_leaf_age/','LH-k_gddreq_Tsen_leafage/','LH-Tsen_leafage/'};
titleName={'t air senescence','k gdd dormance&gdd req max','k gdd dormance','gdd req max','min leaf age','kgdd&gddreq&Tsen&minleafage',' Tsen&minleafage'};
pp_scaler=0.963;
savepath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/phd/implement hydraulics/phenology/parameter analysis/';
cmap=parula(100);

for iff=1:numel(folderName)
    folderPath=folderName{1,iff};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% editable
    rootPath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/src/QPy/examples/sens/output/';
    mkdir([savepath,folderPath]);

    rho_rmse_sos=loadMatData(savepath,folderPath,'rho_rmse_sos');
    rho_rmse_eos=loadMatData(savepath,folderPath,'rho_rmse_eos');
    rho_rmse_los=loadMatData(savepath,folderPath,'rho_rmse_los');

    fig = figure('Color','white','PaperUnits','centimeters','PaperSize',[6 18],'PaperPosition',[0,0,6,18],'Visible','on');
    subplot(3,1,1)
    hold on
    for j=1:100
        scatter(rho_rmse_sos(j,1),rho_rmse_sos(j,2),10,cmap(j,:),'filled');
    end
    ax=gca;
    FtSize=8;
    ax.FontSize=FtSize;
    xticks(0:0.2:1);
    % yticks(5:5:20);
    ax.XLim=[0.1 0.9];
    % ax.YLim=[7 20];
    axis square
    xlabel('R');
    ylabel('RMSE');
    box on
    title('sos');

    subplot(3,1,2)
    hold on
    for j=1:100
        scatter(rho_rmse_eos(j,1),rho_rmse_eos(j,2),10,cmap(j,:),'filled');
    end
    ax=gca;
    FtSize=8;
    ax.FontSize=FtSize;
    xticks(0:0.2:1);
    % yticks(5:5:20);
    ax.XLim=[0.1 0.9];
    % ax.YLim=[7 20];
    axis square
    xlabel('R');
    ylabel('RMSE');
    box on
    title('eos');

    subplot(3,1,3)
    hold on
    for j=1:100
        scatter(rho_rmse_los(j,1),rho_rmse_los(j,2),10,cmap(j,:),'filled');
    end
    ax=gca;
    FtSize=8;
    ax.FontSize=FtSize;
    xticks(0:0.2:1);
    % yticks(5:5:20);
    ax.XLim=[0.1 0.9];
    % ax.YLim=[7 20];
    axis square
    xlabel('R');
    ylabel('RMSE');
    box on
    title('gs');

    t=sgtitle(titleName{1,iff});

    t.FontSize = 8;
    print(fig,'-dtiff','-r800',strcat(savepath,titleName{1,iff},'_rmse_r.tif'));%%%%%%%%editable
    close(fig);
end