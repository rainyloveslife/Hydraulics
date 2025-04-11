function [sos,eos]=retrive_phenology(gpp)

% aggregate ts as daily
window=7;
GPP_aggr_sen=Cal_sim_halfhour_day(gpp,window);
gpp_ts=GPP_aggr_sen(:,1);
clear GPP_aggr_sen
days=size(gpp_ts,1);
yrs=days/53;
gpp_yr=reshape(gpp_ts,[53 yrs]);

sos=nan(yrs,4);
eos=nan(yrs,4);

[first_day, last_day] = get_sim_first_last_day(2000+1-1);
% generate a interval of n days
days_list = first_day:window:last_day;
days_list(1,end+1)= last_day;
x=days_list(1,1:53)';

for iy=1:yrs
    y_ori=squeeze(gpp_yr(:,iy));
    % multi method
    k = 2;
    f = 3;
    y = sgolayfilt(y_ori,k,f);
    [sos_Spln,eos_Spln,~] = Spline(x,y);
    [sos_Polyf,eos_Polyf,~] = Polyf(x,y);
    % [sos_Hants,eos_Hants,pos_Hants] = Hants0(x,y);
    [sos_Plog,eos_Plog] = Plog(x,y_ori);
    [sos_Dlog,eos_Dlog,~] = Dlog(x,y_ori);
    sos(iy,:)=[sos_Spln,sos_Polyf,sos_Plog,sos_Dlog];
    eos(iy,:)=[eos_Spln,eos_Polyf,eos_Plog,eos_Dlog];
end

end