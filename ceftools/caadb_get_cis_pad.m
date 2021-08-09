function [ep, spec, energies, pitcha, extras] = caadb_get_cis_pad(ep_start, len, sc)

% [ep, spec, energies, extras] = caadb_get_cis_1dspec(ep_start, len, sc, product, low_sens)
%
% Returns data for CIS 1D spectrogram from CEF. 
%    product  - form of the distribution ('peflux','pflux','psd','cnt_raw','cnt_persec')
%    low_sens - nonzero for low sensitivity (default = high)
% Output:
%    spec  - energy spectrogram matrix
%    energies - energy bin centers (31-element vector)
%    extras: 
%         - delta_minus_en, delta_plus_en (energy bin deltas)
%         - interval_duration (measurement interval in sec)
%         - cis_mode
%
% V0.1 JS 08/11/2010

dprod = 'cishia_pad_pf';

[ep, dt, meta] = caadb_get_data(ep_start, len, dprod, sc);

if (isempty(ep))
    spec = [];
    energies = [];
    extras.delta_minus_en = [];
    extras.delta_plus_en = [];
    extras.interval_duration = [];
    extras.cis_mode = [];
    return;
end
    

energies = meta.energy_bins;
pitcha = meta.pitch_angles;
extras.delta_minus_en = meta.delta_minus_en;
extras.delta_plus_en = meta.delta_plus_en;
extras.interval_duration = dt(1,:);
extras.cis_mode = dt(2,:);

spec = reshape(dt(4:499,:),31,16,[]);
