function [v_gse, tm] = sr2_to_gse(v_sr2, axis_gse);

% [v_gse, tm] = sr2_to_gse(v_sr2, axis_gse);
%
% Performs oordinate transform from SR2 to GSE
% Input:
%	v_sr2 - vector in SR2 coordinate system
%	axis_gse - unit vector of satellite spin axis in GSE coordinates
% Output:
%   v_gse - v_sr2 vector in GSE coords
%   tm    - transformation matrix v_gse = tm*v_sr2;

% transformation matrix sr2 -> GSE
rx = axis_gse(1);
ry = axis_gse(2);
rz = axis_gse(3);
a = 1/sqrt(rz*rz + ry*ry);
tm = zeros(3,3);
tm(:,3) = axis_gse;
tm(:,2) = [0, a*rz, -a*ry]';
tm(:,1) = [a*(ry*ry + rz*rz), -a*rx*ry, -a*rx*rz]';

v_gse = tm*v_sr2;
