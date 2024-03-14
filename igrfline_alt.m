function [latitude, longitude, altitude] = igrfline_alt(time, lat_start, ...
    lon_start, alt_start, coord, trace_alt_length, nsteps)
% 可以按照固定高度差追踪磁力线但由于地磁场的高度有限，所以超出这个高度限制，
% 绘制会出现问题。
% 与 igrfline.m 的区别在于单次追踪长度不是磁力线长度 steplen，而是高度
% trace_alt_length。
error(nargchk(7, 7, nargin));

% Convert from geodetic coordinates to geocentric coordinates if necessary.
% The coordinate system used here is spherical coordinates (r,phi,theta)
% corresponding to radius, azimuth, and elevation, respectively.
if isempty(coord) || strcmpi(coord, 'geodetic') || strcmpi(coord, 'geod') || strcmpi(coord, 'gd')
    % First convert to ECEF, then convert to spherical. The function
    % geod2ecef assumes meters, but we use km here.
    [x, y, z] = geod2ecef(lat_start, lon_start, alt_start*1e3);
    [phi, theta, r] = cart2sph(x, y, z); r = r/1e3;
elseif strcmpi(coord, 'geocentric') || strcmpi(coord, 'geoc') || strcmpi(coord, 'gc')
    r = alt_start;
    phi = lon_start*pi/180;
    theta = lat_start*pi/180;
else
    error('igrfline:coordInputInvalid', ['Unrecognized command ' coord ...
        ' for COORD input.']);
end

% Get coefficients from loadigrfcoefs.
gh = loadigrfcoefs(time);

% Initialize for loop.
r = [r; zeros(nsteps, 1)];
phi = [phi; zeros(nsteps, 1)];
theta = [theta; zeros(nsteps, 1)];

for index = 1:nsteps
    
    % Get magnetic field at this point. Note that IGRF outputs the
    % Northward (x), Eastward (y), and Downward (z) components, but we want
    % the radial (-z), azimuthal (y), and elevation (x) components
    % corresponding to (r,phi,theta), respectively.
    [Bt, Bp, Br] = igrf(gh, theta(index)*180/pi, phi(index)*180/pi, r(index), 'geoc'); 
    Br = -Br; B = hypot(Br, hypot(Bp, Bt));
    
    % Unit vector in the (r,phi,theta) direction:
    dr = Br/B; dp = Bp/B; dt = Bt/B;
    
    % The next point is steplen km from the previous point in the direction
    % of the unit vector just found above.
    steplen = trace_alt_length/dr;
    r(index+1) = r(index) + trace_alt_length;
    theta(index+1) = theta(index) + steplen*dt/r(index);
    phi(index+1) = phi(index) + steplen*dp/(r(index)*cos(theta(index)));
    
end

% Convert the field line to the proper coordinate system.
if isempty(coord) || strcmpi(coord, 'geodetic') || ...
        strcmpi(coord, 'geod') || strcmpi(coord, 'gd')
    % First convert to ECEF, then geodetic. The function ecef2geod assumes
    % meters, but we want km here.
    [x, y, z] = sph2cart(phi, theta, r*1e3);
    [latitude, longitude, altitude] = ecef2geod(x, y, z);
    altitude = altitude/1e3;
else
    latitude = theta*180/pi;
    longitude = phi*180/pi;
    altitude = r;
end

if nargout <= 1
    latitude = [latitude(:), longitude(:), altitude(:)];
end