%% Apelern with ERA5 climate forcing

%% 1. Check the forcing data %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 检查数据是否齐全
rootpath='/Users/zeyu/remote/BSI/work_scratch/zduanmu/phd/ERA5 forcing/ERA5 raw/';
site={'Apelern','Hainich','Hartheim'};


for i=1:numel(site)

    each_path=strcat(rootpath,site{1,i},'/');
    fileFormat = strcat(site{1,i},'_*.nc');
    fileList = dir([each_path,fileFormat]);

    % 初始化Map
    var_map = containers.Map();

    for j = 1:length(fileList)
        fname = fileList(j).name;

        % 提取变量名和年月
        patterns=[site{1,i},'_(.+)_(\d{4})_(\d{2})\.nc'];
        tokens = regexp(fname,patterns, 'tokens');
        if isempty(tokens)
            continue;
        end
        tokens = tokens{1};
        var = tokens{1};
        date = [tokens{2} '-' tokens{3}];

        % 存入 map
        if isKey(var_map, var)
            tmp = var_map(var);
            tmp{end+1} = date;
            var_map(var) = tmp;
        else
            var_map(var) = {date};
        end
    end

    % 获取所有变量名
    var_names = keys(var_map);
    n_vars = length(var_names);

    % 找最长的日期列
    max_len = 0;
    for k = 1:n_vars
        max_len = max(max_len, length(var_map(var_names{k})));
    end

    % 构建表格字符串
    table_data = strings(max_len+1, n_vars);  % +1 是加表头
    for n = 1:n_vars
        table_data(1, n) = var_names{n};  % 表头
        dates = var_map(var_names{n});
        for t = 1:length(dates)
            table_data(t+1, n) = dates{t};  % 填时间
        end
    end
    save(strcat(rootpath,'data check/',site{1,i},'_era5_time.mat'),'table_data');
    clear table_data
end



%% 2. cdo merge time + sellonlat + interpolate to HH %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% module swap gnu12 intel/2023.0.0
% module load intel openmpi4 cdo

rootPathW='/Users/zeyu/remote/BSI/work_scratch/zduanmu/phd/ERA5_forcing/ERA5_raw/';
rootPath = '/Net/Groups/BSI/work_scratch/zduanmu/phd/ERA5_forcing/ERA5_raw/';
outPathW = '/Users/zeyu/remote/BSI/work_scratch/zduanmu/phd/ERA5_forcing/ERA5_merged/';%% define the output path(保存.sh文件的路径)
outPath = '/Net/Groups/BSI/work_scratch/zduanmu/phd/ERA5_forcing/ERA5_merged/';%% define the output path(保存.sh文件的路径)

site={'Apelern','Hainich','Hartheim'};
lon_site=[9.3106,10.4522,7.5981];
lat_site=[52.2811,51.0792,47.933];
varName={'10m_u_component_of_wind','10m_v_component_of_wind','2m_dewpoint_temperature','2m_temperature','surface_solar_radiation_downwards','surface_thermal_radiation_downwards','total_precipitation'};

for is=1:numel(site)
    fid = fopen([outPathW,site{1,is}, '_cmdFile.sh'],'w');
    fprintf(fid,'#!/bin/bash\r\n');
    for iv=1:numel(varName)

        inPath1 = strcat(rootPathW,site{1,is},'/',site{1,is},'_',varName{1,iv},'*.nc');
        infiles = dir(inPath1);
        [b]={infiles(:).name};
        if numel(b)>0
            cmdStr1 = 'cdo mergetime ';
            for ifiles = 1:numel(b)
                cmdStr1 = strcat(cmdStr1,{32},rootPath,site{1,is},'/',b{ifiles},{32});
            end
        end
        timeMergedFile = strcat(outPath,'merged/',site{1,is},'_',varName{1,iv},'_merged.nc');
        cmdStr1 = strcat(cmdStr1,{32},timeMergedFile);
        cmdStr1=cmdStr1{1,1};

        fprintf(fid,'%s\n',cmdStr1);

        %% seldate
        timeSelFile = strcat(outPath,'seldate/',site{1,is},'_',varName{1,iv},'_2000to2023.nc');
        cmdStr2 = strcat('cdo seldate,2000-01-01,2023-12-31',{32},timeMergedFile,{32},timeSelFile);
        cmdStr2=cmdStr2{1,1};
        fprintf(fid,'%s\n',cmdStr2);

        %% sellonlatbox
        lonlatSelFile = strcat(outPath,'sellonlat/',site{1,is},'_',varName{1,iv},'_2000to2023_location.nc');
        cmdStr3 = strcat('cdo remapnn,lon=',num2str(lon_site(1,is)),'_lat=',num2str(lat_site(1,is)),{32},timeSelFile,{32},lonlatSelFile);
        cmdStr3=cmdStr3{1,1};
        fprintf(fid,'%s\n',cmdStr3);
        
        %% interpolate time
        halfHourlyFile = strcat(outPath,'interpolated/',site{1,is},'_',varName{1,iv},'_2000to2023_halfhourly.nc');
        cmdStr4 = strcat('cdo inttime,2000-01-01,00:00,30minute',{32},lonlatSelFile,{32},halfHourlyFile);
        cmdStr4=cmdStr4{1,1};
        fprintf(fid,'%s\n',cmdStr4);
    end
    fclose(fid); %% close the file
end


%% 计算需要的变量 %%
%%%%%%%%%%%%%%%%%%
varName={'10m_u_component_of_wind','10m_v_component_of_wind','2m_dewpoint_temperature','2m_temperature','surface_solar_radiation_downwards','surface_thermal_radiation_downwards','total_precipitation'};

%% lwdown
% thermal radiation downward
%% swdown
% solar radiation downward
%% air temperature
% t2m: K to degree
%% qair（specific humidity)

%% air pressure

%% wind speed
% (u^2+v^2)^0.5
%% rain
% Pr: from m to mm

