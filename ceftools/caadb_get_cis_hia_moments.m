function [ep, dens, vel_gse, tpar, tperp, extras] = caadb_get_cis_hia_moments(ep_start, len, sc)

% [ep, dens, vel_gse, tpar, tperp, extras] = caadb_get_cis_hia_moments(ep_start, len, sc)
%
% Returns onboard HIA moments (CAA)
%       dens (in cm^-3)
%       vel_gse (km/s)
%       tpar, tperp (MK)
% Output:
%    extras:          
%         - interval_duration (measurement interval in sec)
%         - cis_mode
%         - sensitivity        
%         - pressure [nPa]
%         - vel_isr2 [km/s in ISR2 system]       
%
% V0.1 JS 20/1/2011

dprod = 'cishia_onboard_mom';

[ep, dt] = caadb_get_data(ep_start, len, dprod, sc);

if isempty(ep)       
%    extras.interval_duration = [];
%    extras.cis_mode = [];
%    extras.sensitivity = [];
%    extras.pressure = [];
%    extras.vel_isr2 = [];
%    extras.temperature = [];
 
    extras = [];
    dens = [];
    tpar  = [];
    tperp = [];
    vel_gse = [];    

    return;
end
%ep = ep + dt(1,:)/86400;

dens  = dt(4,:);
tpar  = dt(12,:);
tperp = dt(13,:);
vel_gse = dt(8:10,:);    

extras.interval_duration = dt(1,:);
extras.cis_mode = dt(3,:);
extras.sensitivity = dt(2,:);
extras.pressure = dt(14,:);
extras.vel_isr2 = dt(5:7,:);
extras.temperature = dt(11,:);

