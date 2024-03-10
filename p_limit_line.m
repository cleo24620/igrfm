close;
clear;
clc;

font = 'Times New Roman';
axis_font = 12;
title_font = 12;

time = datenum([2007 7 17 6 30 0]);
lat_start = 60; % Geodetic latitude in degrees.
lon_start = 20; % Geodetic longitude in degrees.
alt_start = 0; % Altitude in km.
distance = -1e8; % km.
nsteps = abs(distance)/1;
spin = false;

[lat, lon, alt] = igrfline(time, lat_start, lon_start, alt_start, 'geod', distance, nsteps);
% limit_alt = and(alt >= 20, alt <= 3000);
limit_alt = alt>-1;
lat = lat(limit_alt); lon = lon(limit_alt); alt = alt(limit_alt);
lon(lon > 180) = lon(lon > 180) - 360;
for_group = lat_start > 0;
mid_i = floor(length(lat)/2);
if (lat(mid_i)>0) == for_group
    while (lat(mid_i)>0) == for_group
        mid_i = mid_i + 1;
    end
    lat1 = lat(1:mid_i-1); lat2 = lat(mid_i:end);
    lon1 = lon(1:mid_i-1); lon2 = lon(mid_i:end);
    alt1 = alt(1:mid_i-1); alt2 = alt(mid_i:end);
else
    while (lat(mid_i)>0) ~= for_group
        mid_i = mid_i - 1;
    end
    lat1 = lat(1:mid_i); lat2 = lat(mid_i+1:end);
    lon1 = lon(1:mid_i); lon2 = lon(mid_i+1:end);
    alt1 = alt(1:mid_i); alt2 = alt(mid_i+1:end);
end


figure;
hold on;

a = 6378.137; f = 1/298.257223563;
b = a*(1 - f); e2 = 1 - (b/a)^2; ep2 = (a/b)^2 - 1;

% Plot a globe.
load('topo.mat', 'topo', 'topomap2');
[xe, ye, ze] = ellipsoid(0, 0, 0, a, a, b, 100);
surface(-xe, -ye, ze, 'FaceColor', 'texture', ...
        'EdgeColor', 'none', 'CData', topo); % 为什么加 "-"？
% colormap(topomap2);

% Convert lla to xyz.
[x1, y1, z1] = geod2ecef(lat1, lon1, alt1*1e3);
x1 = x1/1e3; y1 = y1/1e3; z1 = z1/1e3;
[x2, y2, z2] = geod2ecef(lat2, lon2, alt2*1e3);
x2 = x2/1e3; y2 = y2/1e3; z2 = z2/1e3;
plot3(x1, y1, z1, 'r',x2, y2, z2,'r');
axis equal;

% Set the plot background to black.
set(gcf, 'color', 'k');
axis off;
title(['Magnetic Field Line at ' datestr(time)], 'FontName', font, ...
    'FontSize', title_font, 'Color', 'w');

% Spin the plot indefinitely.
index = 0;
view(mod(index, 360), 24.5);
while spin
    view(mod(index, 360), 23.5); % Earth's axis tilts by 23.5 degrees
    drawnow;
    pause(0.1);
    index = index - 5;
end