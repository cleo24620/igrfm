clear;
clc;

sec=0;lat_res=1;lon_res=5;alt_start=0;steplen=-1;
year=2007;month=7;day=17;hour=6;min=30;
lat_start1=60;lat_start2=90;
lon_start1=0;lon_start2=360;
save_data(year, month, day, hour, min, sec, lat_start1, lat_start2, lat_res, ...
    lon_start1, lon_start2, lon_res, alt_start, steplen)