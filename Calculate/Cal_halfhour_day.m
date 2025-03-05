function B=Cal_halfhour_day(ts,window)
%%% start year is 2000
%%% windows=10;
if iscolumn(ts)

else
    ts=ts';

end
%% from half-hourly to daily
daily_ts=Cal_block(ts,48);

%% calculate how many years
yrs=size(daily_ts,1)/365;

%% from daily to biweekly
for iy=1:yrs
[first_day, last_day] = get_first_last_day(2000+iy-1);
% generate a interval of n days
days_list = first_day:window:last_day;
days_list(1,end+1)= last_day;

aggregate_yr_ts=nan(size(days_list,2)-1,3);

for i=1:size(days_list,2)-1

    start_day=days_list(i);
    end_day=days_list(i+1);
    each_ts=squeeze(daily_ts(start_day:end_day,1));

    if sum(each_ts)~=0
        zero_mask=each_ts==0;
        each_ts(zero_mask)=[];
        mean_interval=mean(each_ts);
        Q1 = quantile(each_ts, 0.25);  
        Q3 = quantile(each_ts, 0.75); 
    else
        mean_interval=mean(each_ts);
        Q1 = quantile(each_ts, 0.25); 
        Q3 = quantile(each_ts, 0.75);  
    end

    aggregate_yr_ts(i,:)=[mean_interval,Q1,Q3];
    aggregate_ts(i,:,iy)=[mean_interval,Q1,Q3];
end

end

    y_permuted = permute(aggregate_ts, [1, 3, 2]); 
    B = reshape(y_permuted, [], 3);

end

