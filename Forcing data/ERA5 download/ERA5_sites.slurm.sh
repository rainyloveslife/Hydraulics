#!/bin/bash
#SBATCH --job-name=era5_download
#SBATCH --output=era5_download_%j.log
#SBATCH --error=era5_download_%j.err
#SBATCH --time=7-00:00:00            # 运行最长12小时，根据需要调整
#SBATCH --ntasks=2                  # 只运行一个任务
#SBATCH --cpus-per-task=4           # 需要2个CPU核心
#SBATCH --mem=32G                    # 需要4GB内存

# 激活conda环境，如果需要
# source /opt/ohpc/pub/apps/Miniconda3/4.9.2/etc/profile.d/conda.sh
# conda activate base

python "/Net/Groups/BSI/work_scratch/zduanmu/phd/ERA5_forcing/ERA5_raw/Hai_download.py" & 

python "/Net/Groups/BSI/work_scratch/zduanmu/phd/ERA5_forcing/ERA5_raw/Har_download.py" &

wait