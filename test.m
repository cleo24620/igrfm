
clear;
close all;

font = 'Times New Roman';
axis_font = 12;
title_font = 12;

time = datenum([2007 7 17 6 30 0]);


lat_start = 45;
lon_start = 110;
alt_start = 400;
coord = 'geodetic';
trace_alt_length = 1;
nsteps = 10000;
spin = false;


[lat, lon, alt] = igrfline1(time, lat_start, ...
    lon_start, alt_start, coord, trace_alt_length, nsteps);

figure;
hold on;

a = 6378.137; f = 1/298.257223563;
b = a*(1 - f); e2 = 1 - (b/a)^2; ep2 = (a/b)^2 - 1;

load('topo.mat', 'topo', 'topomap2');
[xe, ye, ze] = ellipsoid(0, 0, 0, a, a, b, 100);

surface(-xe, -ye, ze, 'FaceColor', 'texture', ...
    'EdgeColor', 'none', 'CData', topo);
colormap(topomap2);

[x, y, z] = geod2ecef(lat, lon, alt*1e3);
x = x/1e3; y = y/1e3; z = z/1e3;

plot3(x, y, z, 'r');
axis equal;