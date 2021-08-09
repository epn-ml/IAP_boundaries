function [ep, dens, extras] = caadb_get_whi_density(ep_start, len, sc)

% [ep, dens, extras] = caadb_get_whi_density(ep_start, len, sc)
%
% Returns WHISPER density in cm^-3 from CAA data. Dnesity estimated by PI
% team using WHI actve and passive data, EFW and FGM data.
% 
% extrasi structure:
%    spec_type
%    method
%    ext_data
%    uncertainty
%    contrast
%
%  V0.1 JS Feb 2010


product = 'whisper_density';

[ep, data] = caadb_get_data(ep_start, len, product, sc);

if (~isempty(ep))
	dens = data(1,:);
	extras.spec_type   = data(3,:);
	extras.method      = data(4,:);
	extras.ext_data    = data(5,:);
	extras.uncertainty = data(6,:);
	extras.contrast    = data(7,:);
else
	ep = [];
	dens = [];
	extras = [];
end
