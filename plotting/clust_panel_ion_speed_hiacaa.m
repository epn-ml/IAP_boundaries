function [ep, odata] = clust_panel_ion_speed(ep0, tlen, sc, opts)

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
%  opts.mach_num	  - if true, plots as Alfven Mach number
%
% Changes:
%   Nov 12, 2009 JS
%     - created
%   Dec 1, 2009 JS
%     - corrected beahvior when no CIS data avialable


% default parameters
show_legend = 0;
mach_num = 0;

% Standard Cluster colors 
% ccolor = 'krgb';

if exist('opts','var') && ~isempty(opts)
	if isfield(opts,'show_legend')
		show_legend = opts.show_legend;
	end
    if isfield(opts,'mach_num')
		mach_num = opts.mach_num;
    end
else
    opts = [];
end

[ep, dens, velgse, tpar, tperp, extras] = caadb_get_cis_hia_moments(ep0, tlen, sc);
if (isempty(ep))
    plot(0);
    title('No data on CIS HIA', 'FontSize', 12);
    return;
end
vel = vnorm(velgse);

if (mach_num)
    load_plasma_constants;
	[epb, bb] = caadb_get_fgm(ep0, tlen, 'fgm_5vps', sc);
	bm = cdb_resample_to_ttags(epb,vnorm(bb), ep);
	vel = 1e15*vel./bm.*sqrt(mu0*m_prot*hia(1,:));
end

odata.vel = vel;
odata.dens = dens;
odata.cis_mode = extras.cis_mode;

clust_panel_timeseries(ep0, tlen, ep, vel, opts);

if (mach_num)
	ylabel('M_A','FontSize',12);
	title(sprintf('Alven Mach num [CIS HIA], C%d, tstart = %s', sc, datestr(ep0,'YYYY-mm-DD HH:MM:SS.FFF')),'FontSize',12);
else
	ylabel('|V| [km/s]','FontSize',12);
	title(sprintf('CIS HIA velocity, C%d, tstart = %s', sc, datestr(ep0,'YYYY-mm-DD HH:MM:SS.FFF')),'FontSize',12);
end
