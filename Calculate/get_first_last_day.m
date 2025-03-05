function [first_day, last_day] = get_first_last_day(year)
    % 输入年份，输出该年第一天和最后一天相对于 2000 年 1 月 1 日的天数

    % 基准年：2000年
    base_year = 2000;

    % 初始化变量
    current_day = 1; % 2000年1月1日是第1天

    % 计算从2000年到目标年份前一年的天数
    for y = base_year:(year-1)
        if is_leap_year(y)
            current_day = current_day + 366;
        else
            current_day = current_day + 365;
        end
    end

    % 该年第一天
    first_day = current_day;

    % 判断该年是否为闰年
    if is_leap_year(year)
        year_length = 366;
    else
        year_length = 365;
    end

    % 该年最后一天
    last_day = first_day + year_length - 1;
end

