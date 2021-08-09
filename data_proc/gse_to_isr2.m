function [v_sr2, tm] = gse_to_isr2(v_gse, axis_gse);

% [v_sr2, tm] = gse_to_isr2(v_gse, axis_gse);
%
% Performs oordinate transform from GSE to ISR2
% Input:
%	v_gse - vector in ISR2 coordinate system (can be 3xN array of vectors)
%	axis_gse - unit vector of satellite spin axis in GSE coordinates
% Output:
%   v_sr2 - v_sr2 vector(s) in SR2 coords
%   tm    - transformation matrix v_gse = tm*v_sr2;
%
% JS 1/12/2010 

% to make sure...
axis_gse = axis_gse/norm(axis_gse);

% transformation matrix ISR2 -> GSE
rx = axis_gse(1);
ry = axis_gse(2);
rz = axis_gse(3);
a = 1/sqrt(rz*rz + ry*ry);
tm = zeros(3,3);
tm(:,3) = axis_gse;
tm(:,2) = [0, a*rz, -a*ry]';
tm(:,1) = [a*(ry*ry + rz*rz), -a*rx*ry, -a*rx*rz]';


tm_isr2_sr2 = diag([1,-1,-1]);
tm = tm*tm_isr2_sr2;
% invert orthogonal matrix (GSE -> ISR2)
tm = tm';

v_sr2 = tm*v_gse;
