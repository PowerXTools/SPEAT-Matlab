function result = ReadComtrade(strpath, strfile)
    % ReadComtrade: 读取并解析COMTRADE文件
    % 输入:
    %   strpath: 配置文件所在路径
    %   strfile: 配置文件名（含.cfg后缀）
    % 输出:
    %   result: 包含配置信息、原始数据和处理后数据的结构体

    if nargin == 0
        % 如果没有输入路径和文件名，使用uigetfile选择文件
        [CfgFileName, Path] = uigetfile('*.cfg');
        strpath = Path;
        strfile = CfgFileName;
    end

    % 确保路径末尾有反斜杠
    if strpath(end) ~= filesep
        strpath = [strpath filesep];
    end

    % 构建完整的文件路径
    PathAndCfgName = fullfile(strpath, strfile);
    DatFileName = strrep(upper(strfile), '.CFG', '.DAT');
    PathAndDatName = fullfile(strpath, DatFileName);

    % 打开配置文件并检查是否成功
    cfg_id = fopen(PathAndCfgName);
    if cfg_id == -1
        error('Failed to open configuration file: %s', PathAndCfgName);
    end

    % 打开数据文件并检查是否成功
    dat_id = fopen(PathAndDatName);
    if dat_id == -1
        fclose(cfg_id);
        error('Failed to open data file: %s', PathAndDatName);
    end

    % 读取配置文件内容
    cfg = textscan(cfg_id, '%s', 'delimiter', '\n');
    fclose(cfg_id);

    % 初始化配置解析
    cfg_len = length(cfg{1});
    cfg_string = cell(cfg_len, 1);
    filetype = 'BINARY'; % 默认文件类型

    % 解析配置文件
    for i = 1:cfg_len
        temp_string = char(cfg{1}{i});
        cfg_string{i} = textscan(temp_string, '%s', 'Delimiter', ',');
        if contains(temp_string, 'ASCII', 'IgnoreCase', true)
            filetype = 'ASCII';
        end
    end

    % 提取配置信息
    No_Ch = strread(char(cfg_string{2,1}{1}(1)));
    Ana_Ch = strread(char(cfg_string{2,1}{1}(2)));
    Dig_Ch = strread(char(cfg_string{2,1}{1}(3)));
    frequency = str2double(cfg_string{3+No_Ch}{1});

    % 提取采样率
    try
        samp_rate = str2double(cfg_string{5+No_Ch}{1});
    catch
        samp_rate = 1e6; % 默认采样率
    end

    % 提取记录开始/结束时间
    start_date = char(cfg_string{6+No_Ch}{1}(1));
    start_time = char(cfg_string{6+No_Ch}{1}(2));
    end_date = char(cfg_string{7+No_Ch}{1}(1));
    end_time = char(cfg_string{7+No_Ch}{1}(2));

    % 初始化返回值结构体
    result.Config = struct('Total_Channels', No_Ch, ...
                           'Analogue_Channels', Ana_Ch, ...
                           'Digital_Channels', Dig_Ch, ...
                           'Frequency', frequency, ...
                           'Sample_rate', samp_rate, ...
                           'Start_date', start_date, ...
                           'Start_time', start_time, ...
                           'End_date', end_date, ...
                           'End_time', end_time, ...
                           'DataType', filetype);

    % 读取数据文件
    if strcmp(filetype, 'ASCII')
        % ASCII格式数据读取
        formatstr = ['%g, %g', repmat(', %g', 1, No_Ch)];
        data = fscanf(dat_id, formatstr, [(No_Ch+2) inf])';
    else
        % BINARY格式数据读取
        [raw_data, count] = fread(dat_id, inf, 'int16');
        if Dig_Ch == 0
            % 仅模拟通道
            data = reshape(raw_data, Ana_Ch+4, [])';
        else
            % 模拟和数字通道
            data = zeros(count / (Ana_Ch + 5), Ana_Ch + Dig_Ch + 2);
            for i = 1:Ana_Ch
                data(:, i+2) = raw_data((4+i):(Ana_Ch+5):end);
            end
            digital_raw = raw_data((5+Ana_Ch):(Ana_Ch+5):end);
            digital_data = GetBinary(digital_raw, Dig_Ch);
            data(:, (Ana_Ch+3):end) = digital_data;
        end
        % 添加时间戳列
        data(:, 1) = (0:size(data, 1)-1)' / samp_rate;
    end
    fclose(dat_id);

    % 保存原始数据
    result.RawData = data;

    % 数据范围检查与缩放
    for i = 1:Ana_Ch
        j = i + 2;
        min_level = str2double(cfg_string{2+i}{1}{9});
        max_level = str2double(cfg_string{2+i}{1}{10});
        multiplier = str2double(cfg_string{2+i}{1}{6});
        offset = str2double(cfg_string{2+i}{1}{7});

        % 限制范围并缩放
        data(:, j) = max(min(data(:, j), max_level), min_level);
        data(:, j) = data(:, j) * multiplier + offset;

        % 主副变比处理
        if length(cfg_string{2+i}) > 10
            pri_scaling = str2double(cfg_string{2+i}{11});
            sec_scaling = str2double(cfg_string{2+i}{12});
            pri_sec = char(cfg_string{2+i}{13});
            if strcmpi(pri_sec, 'P')
                data(:, j) = data(:, j) * pri_scaling;
            else
                data(:, j) = data(:, j) * sec_scaling;
            end
        end
    end

    % 保存处理后数据
    result.ProcessedData = data;
end

