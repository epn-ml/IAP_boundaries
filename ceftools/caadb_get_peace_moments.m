function [ep, dens, tperp, tpar, velocity, extras] = caadb_get_peace_moments(ep_start, len, sc)

% [ep, dens, tperp, tpar, velocity, extras] = caadb_get_peace_moments(ep_start, len, sc);

[ep, dt] = caadb_get_data(ep_start, len, 'peace_moments', sc);

if isempty(ep)
   dens = [];
   velocity = [];
   tperp = [];
   tpar  = [];
   extras = [];
   return;
end

velocity = dt(9:11,:);
dens  = dt(8,:);
tperp = dt(21,:);
tpar  = dt(22,:);

extras.quality = dt(1,:);
extras.stat_count_leea  = dt(2,:);
extras.stat_count_heea  = dt(3,:);
extras.aspoc_status     = dt(4,:);
extras.fgm_status       = dt(5,:);
extras.sc_potential     = dt(6,:);
extras.sensor           = dt(7,:);
extras.pressure_tensor  = dt(12:20,:);
extras.heat_flux        = dt(23:25,:);
extras.en_range_leea    = dt(26:27,:);
extras.en_range_heea    = dt(28:29,:);
extras.swep_mode_leea   = dt(30,:);
extras.swep_mode_heea   = dt(31,:);
