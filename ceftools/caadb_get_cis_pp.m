function [ep, cis_stat, cis_hia, cis_codif] = caadb_get_cis_pp(ep_start, len, sc);

% [ep, cis_stat, cis_hia, cis_codif] = caadb_get_cis_pp(ep_start, len, sc)
%
% Loads CIS prime parameter data
%
%   output:
%
%   cis_stat = 
%	  1 - status[1] (0 - bad, 1 - use w/ caution, 2 - OK)
%	  2 - status[2] (CIS mode)
%
%   cis_hia = 
%     1 - n (HIA) [cm^-3]
%	  2 - v_x (HIA) [km/s]
%	  3 - v_y (HIA)
%	  4 - v_z (HIA)
%	  5 - T_par (HIA) [MK]
%	  6 - T_perp (HIA) [MK]
%
%   cis_codif = 
%     1 - np (CODIF)
%	  2 - vp_x (CODIF)
%	  3 - vp_y (CODIF)
%	  4 - vp_z (CODIF)
%	  5 - T_par (CODIF)
%	  6 - T_perp (CODIF)

product = 'cis_pp';

[ep, data] = caadb_get_data(ep_start, len, product, sc);

if (~isempty(ep))
	cis_stat = data(1:2,:);
	cis_hia = data(3:8,:);
	cis_codif = data(9:14,:);
else
	cis_stat = [];
	cis_hia = [];
	cis_codif = [];
end
