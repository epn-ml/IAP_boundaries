function [ep, pos, sc_axis_angles, sc_vel, gsm_rot_angle, gsm_tilt_angle] = caadb_get_cluster_aux(ep_start, len);

% [ep, pos, sc_axis_angles, sc_vel, gsm_rot_angle, gsm_tilt_angle] = caadb_get_cluster_aux(ep_start, len);
%
% Loads Cluster SC position data:
%  pos: 3 x N x 4 array (N - num. samples) - SC GSE poitions in km
%  sc_axis_angles: 2 x N x 4 array (N - num. samples) - latitude and longitude angles 
%                                                       of SC axis
%  sc_vel - velocity of SC 3 in km/s [GSE]

pos = [];
sc_axis_angles = [];
sc_vel = [];
gsm_rot_angle = [];
gsm_tilt_angle = [];

[ep, data] = caadb_get_data(ep_start, len, 'cluster_aux');
if (numel(ep)== 0); return; end; % Aug2018 DP added condition for no data
pos(:,:,1) = data(1:3,:);
pos(:,:,2) = data(4:6,:);
pos(:,:,3) = data(7:9,:);
pos(:,:,4) = data(10:12,:);
sc_axis_angles(1,:,1) = data(13,:);
sc_axis_angles(2,:,1) = data(14,:);
sc_axis_angles(1,:,2) = data(15,:);
sc_axis_angles(2,:,2) = data(16,:);
sc_axis_angles(1,:,3) = data(17,:);
sc_axis_angles(2,:,3) = data(18,:);
sc_axis_angles(1,:,4) = data(19,:);
sc_axis_angles(2,:,4) = data(20,:);
gsm_rot_angle = data(21,:);
gsm_tilt_angle = data(22,:);
sc_vel = data(23:25,:);
