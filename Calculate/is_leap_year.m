function isLeap = is_leap_year(year)
    % 判断是否为闰年
    isLeap = (mod(year, 4) == 0 & mod(year, 100) ~= 0) | (mod(year, 400) == 0);
end