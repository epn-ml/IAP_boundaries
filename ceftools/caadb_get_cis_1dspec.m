function [ep, spec, energies, extras] = caadb_get_cis_1dspec(ep_start, len, sc, product, low_sens)

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

if ~exist('product','var') || isempty(product)
    product = 'hia';
end

if ~exist('low_sens','var') || isempty(low_sens)
    low_sens = 0;
end

if (low_sens)
    sens_txt = 'ls';
else
    sens_txt = 'hs';
end

switch (product)
    case 'hia'
        dprod = sprintf('cishia_1dspec_%s_pef', sens_txt);
    case 'codif_h1'
        dprod = 'codif_1dspec_h1_pef';
    otherwise
        error('unknown CIS data product');
end

[ep, dt, meta] = caadb_get_data(ep_start, len, dprod, sc);
% should be done at ingestion...
[ep, dt] = caadb_check_timetag_correctness(ep, dt, 3);

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
extras.delta_minus_en = meta.delta_minus_en;
extras.delta_plus_en = meta.delta_plus_en; 
if (size(energies,2) > 1)
    energies = energies(:,1);
    extras.delta_minus_en = extras.delta_minus_en(:,1);
    extras.delta_plus_en = extras.delta_plus_en(:,1); 
end

extras.interval_duration = dt(1,:);
extras.cis_mode = dt(3,:);

spec = dt(7:37,:);
