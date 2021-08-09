function [ep, odata] = clust_panel_ion_density_hiacaa(ep0, tlen, sc, opts)

% [ep, odata] = cluster_panel_ion_speed(ep0, tlen, sc, opts)
%
% Plots panel with ion flow speed from CIS - HIA
% <sc> can be 1 or 3
%
% Options (opts)
%  opts.yaxis         - two element vector [Bmin Bmax]
%  opts.show_xlabel   - if true, show label on X axis [def= 1]
%  opts.show_legend   - if true, shows color legend [def= 0]
%  opts.time_seconds  - if true, time axis is labeled in seconds
%                       otherwise datetick is used. [def = 0]
%
% Changes:
%   Jan 13, 2011 JS
%     - created


% default parameters
show_legend = 1;

% Standard Cluster colors 
% ccolor = 'krgb';

if exist('opts','var') && ~isempty(opts)
    if isfield(opts,'show_legend')
		show_legend = opts.show_legend;
    end     
else
    opts = [];
end

[ep, dens, vel_gse, tpar, tperp, extras] = caadb_get_cis_hia_moments(ep0, tlen, sc);
if (isempty(ep))
    plot(0);
    title('No data on CIS HIA', 'FontSize', 12);
    return;
end
%dens = hia(1,:);
%dens(stat(1,:) == 0) = NaN;

odata.dens = dens;
odata.cis_mode = extras.cis_mode;
odata.vel_gse = vel_gse;

clust_panel_timeseries(ep0, tlen, ep, dens, opts);
ylabel('n [cm\^-3]','FontSize',12);
title(sprintf('CIS HIA ion density, C%d, tstart = %s', sc, datestr(ep0,'YYYY-mm-DD HH:MM:SS.FFF')),'FontSize',12);




