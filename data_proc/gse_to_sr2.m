function [v_sr2, tm] = gse_to_s2(v_gse, axis_gse);

% [v_sr2, tm] = gse_to_s2(v_gse, axis_gse);
%
% Performs oordinate transform from GSE to SR2
% Input:
%	v_gse - vector in SR2 coordinate system (can be 3xN array of vectors)
%	axis_gse - unit vector of satellite spin axis in GSE coordinates
% Output:
%   v_sr2 - v_sr2 vector(s) in SR2 coords
%   tm    - transformation matrix v_gse = tm*v_sr2;
%
% JS 27/4/2009 

% transformation matrix SR2 -> GSE
rx = axis_gse(1);
ry = axis_gse(2);
rz = axis_gse(3);
a = 1/sqrt(rz*rz + ry*ry);
tm = zeros(3,3);
tm(:,3) = axis_gse;
tm(:,2) = [0, a*rz, -a*ry]';
tm(:,1) = [a*(ry*ry + rz*rz), -a*rx*ry, -a*rx*rz]';

% invert orthogonal matrix (GSE -> SR2)
tm = tm';

v_sr2 = tm*v_gse;
