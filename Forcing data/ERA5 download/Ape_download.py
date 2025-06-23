import cdsapi
import os

# 初始化客户端
client = cdsapi.Client()

dataset = "reanalysis-era5-single-levels"

save_dir = "/Net/Groups/BSI/work_scratch/zduanmu/phd/ERA5_forcing/ERA5_raw/Apelern"

if not os.path.exists(save_dir):
    os.makedirs(save_dir)

variables = [
    "surface_pressure"
]

days = [f"{d:02d}" for d in range(1, 32)]
times = [f"{h:02d}:00" for h in range(24)]

area = [52.8, 8.8, 51.8, 9.8] # where is apelern

for year in range(2000, 2025):  # 2000到2024年
    for variable in variables:
        for month in range(1, 13):
            month_str = f"{month:02d}"
            print(f"Downloading {variable} for {year}-{month_str} ...")

            request = {
                "product_type": "reanalysis",
                "variable": [variable],
                "year": str(year),
                "month": [month_str],
                "day": days,
                "time": times,
                "data_format": "netcdf",
                "area": area
            }

            target_file = os.path.join(save_dir, f"Apelern_{variable}_{year}_{month_str}.nc")

            try:
                result = client.retrieve(dataset, request)
                result.download(target_file)
                print(f"Downloaded {target_file}")
            except Exception as e:
                print(f"Failed to download {variable} for {year}-{month_str}: {e}")
