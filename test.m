clear;
clc;

LLA = load("G:\0_postgraduate\IGRF\igrfm\Limitlines_data\20070717063000_90_360_0_limit.mat");
lat = LLA.lat;
lon = LLA.lon;
alt = LLA.alt;

figure;
hold on;

a = 6378.137; f = 1/298.257223563;
b = a*(1 - f); e2 = 1 - (b/a)^2; ep2 = (a/b)^2 - 1;

% Plot a globe.
load('topo.mat', 'topo', 'topomap2');
[xe, ye, ze] = ellipsoid(0, 0, 0, a, a, b, 100);
surface(-xe, -ye, ze, 'FaceColor', 'texture', ...
        'EdgeColor', 'none', 'CData', topo);

% Convert lla to xyz.
[x, y, z] = geod2ecef(lat, lon, alt*1e3);
x = x/1e3; y = y/1e3; z = z/1e3;
plot3(x, y, z, 'r');

axis equal;

% Set the plot background to black.
set(gcf, 'color', 'k');
axis off;

% Spin the plot indefinitely.
index = 0;
view(mod(index, 360), 24.5);