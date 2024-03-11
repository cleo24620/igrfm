close;
clear;
clc;

% font = 'Times New Roman';
% axis_font = 12;
% title_font = 12;

time = datenum([2007 7 17 6 30 0]);
time_str = datestr(time);
lat_start1 = 82; % Geodetic latitude in degrees.
lat_start2 = 90; lat_res = 1; lat_starts = lat_start1:lat_res:lat_start2;
lon_start1 = 0; % Geodetic longitude in degrees.
lon_start2 = 360; lon_res = 5; lon_starts = lon_start1:lon_res:lon_start2;
alt_start = 0; % Altitude in km.
distance = -1e8; % km.
nsteps = abs(distance)/1;
% spin = false;

% figure;
% hold on;
% 
% a = 6378.137; f = 1/298.257223563;
% b = a*(1 - f); e2 = 1 - (b/a)^2; ep2 = (a/b)^2 - 1;
% 
% % Plot a globe.
% load('topo.mat', 'topo', 'topomap2');
% [xe, ye, ze] = ellipsoid(0, 0, 0, a, a, b, 100);
% surface(-xe, -ye, ze, 'FaceColor', 'texture', ...
%         'EdgeColor', 'none', 'CData', topo); % 为什么加 "-"？
% % colormap(topomap2);

currentDir = pwd;
subfolderName = 'lines_data';

subfolderPath = fullfile(currentDir, subfolderName);

if ~exist(subfolderPath, 'dir')
    mkdir(subfolderPath);
end

for lat_start = lat_starts
    for lon_start = lon_starts
        filename = fullfile(subfolderPath, sprintf('20070717063000_%s_%s_%s.mat', num2str(lat_start), num2str(lon_start), num2str(alt_start)));
        if exist(filename,'file')
            disp([filename,'已存在，跳过循环。']);
            continue
        else
            [lat, lon, alt] = igrfline(time, lat_start, lon_start, alt_start, 'geod', distance, nsteps);
            limit_alt = alt>-1;
            lat = lat(limit_alt); lon = lon(limit_alt); alt = alt(limit_alt);
            lon(lon > 180) = lon(lon > 180) - 360;

            save(filename, 'lat', 'lon', 'alt');
            clear lat lon alt
            disp([filename,'完成数据写入']);
        end
    
%         % Convert lla to xyz.
%         [x, y, z] = geod2ecef(lat, lon, alt*1e3);
%         x = x/1e3; y = y/1e3; z = z/1e3;
%         plot3(x, y, z, 'r');
    end
end

% axis equal;
% 
% % Set the plot background to black.
% set(gcf, 'color', 'k');
% axis off;
% title(['Magnetic Field Line at ' datestr(time)], 'FontName', font, ...
%     'FontSize', title_font, 'Color', 'w');
% 
% % Spin the plot indefinitely.
% index = 0;
% view(mod(index, 360), 24.5);
% while spin
%     view(mod(index, 360), 23.5); % Earth's axis tilts by 23.5 degrees
%     drawnow;
%     pause(0.1);
%     index = index - 5;
% end