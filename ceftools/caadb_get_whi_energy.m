function [ep, energ, extras] = caadb_get_whi_energy(ep_start, len, sc)

% [ep, dens, extras] = caadb_get_cis_pp(ep_start, len, sc)
%

product = 'whisper_energy';

[ep, data] = caadb_get_data(ep_start, len, product, sc);

if (~isempty(ep))
	energ = data(1,:);
	extras.spec_code    = data(2,:);
	extras.overflow_idx = data(3,:);
	extras.average_num  = data(4,:);
else
	ep = [];
	energ = [];
	extras = [];
end
