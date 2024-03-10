time = datenum([2011 1 1 6 30 0]);
latitude = 0;
longitude = 180;
altitude = 850;
coord = 'geodetic';
[Bx, By, Bz] = igrf(time, latitude, longitude, altitude, coord);
B = (Bx.^2 + By.^2 + Bz.^2)^0.5;