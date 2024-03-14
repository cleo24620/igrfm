clear;
clc;

%% 保存数据

sec=0;lat_res=1;lon_res=5;alt_start=0;steplen=-1;
year=2007;month=7;day=17;hour=6;min=30;
lat_start1=60;lat_start2=90;
lon_start1=0;lon_start2=360;
save_data(year, month, day, hour, min, sec, lat_start1, lat_start2, lat_res, ...
    lon_start1, lon_start2, lon_res, alt_start, steplen)

%% functions

function save_data(year, month, day, hour, min, sec, lat_start1, lat_start2, lat_res, ...
    lon_start1, lon_start2, lon_res, alt_start, steplen)

%
% Inputs:
%   - time: format like '[2007 07 17 06 30 00]'
%   - lat, lon: degree
%   - alt: km
%   - steplen: km

time_str = datestr(datetime([year,month,day,hour,min,sec]),'yyyymmddHHMMss');
time = datenum([year month day hour min sec]);
lat_starts = lat_start1:lat_res:lat_start2;
lon_starts = lon_start1:lon_res:lon_start2;

currentDir = pwd;
subfolderName = 'lines_data';
subfolderPath = fullfile(currentDir, subfolderName);
if ~exist(subfolderPath, 'dir')
    mkdir(subfolderPath);
end

for lat_start = lat_starts
    for lon_start = lon_starts
        filename = fullfile(subfolderPath, sprintf('%s_%s_%s_%s.mat', time_str, num2str(lat_start), num2str(lon_start), num2str(alt_start)));
        if exist(filename,'file')
            disp([filename,'已存在，跳过循环。']);
            continue
        else
            [lat, lon, alt] = igrfLimitLine(time, lat_start, lon_start, alt_start, 'geod', steplen);
            limit_alt = alt>-1;
            lat = lat(limit_alt); lon = lon(limit_alt); alt = alt(limit_alt);
            lon(lon > 180) = lon(lon > 180) - 360;

            save(filename, 'lat', 'lon', 'alt');
            clear lat lon alt
            disp([filename,'完成数据写入']);
        end
    end
end

end