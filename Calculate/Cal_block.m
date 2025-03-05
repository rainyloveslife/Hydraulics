function block_mean=Cal_block(ori_ts,block)
%%% block = 48
if iscolumn(ori_ts)

else
    ori_ts=ori_ts';
end

ts_length=size(ori_ts,1);

blo_num=ts_length/block;

block_mean=nan(blo_num,1);

for i=1:blo_num

    b_start=block*i-(block-1);

    b_end=block*i;

    each_ts=squeeze(ori_ts(b_start:b_end,1));

    block_mean(i,1)=mean(each_ts);

end

end


