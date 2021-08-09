function r_spin = spin_axis_gse(latitude, longitude);

% r_spin = spin_axis_gse(latitude, longitude);
%
% Caluclates satellite spin axis vetor in GSE coordinates from
% the spherical latitude-longitude values (e.g. from the CSDS database)
% latitude & longitude in degrees

[r_spin(1,:), r_spin(2,:), r_spin(3,:)] = sph2cart(longitude*pi/180, latitude*pi/180,1);

