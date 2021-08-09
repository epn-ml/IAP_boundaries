function [ep, odata] = clust_panel_whisper_density(ep0, tlen, sc, opts)

% [ep, odata] = cluster_panel_whisper_density(ep0, tlen, sc, opts)
%
% Plots panel with WHISPER density (CAA data)
%
% Options (opts)
%   - supports default clust_panel_timeseries options.
%   show_legend (default = 1 fo multiple SC, 0 for single SC)
%  
% V0.2 JS 21/01/2011 - added support for multiple spacecraft.

% Standard Cluster colors 
ccolor = 'krgb';

show_title = 1;

if length(sc) > 1
    show_legend = 1;
else
    show_legend = 0;
end

if ~exist('opts','var') || isempty(opts)
    opts = [];
end

if isfield(opts,'show_title')
	show_title = opts.show_title;
end
if isfield(opts,'show_legend')
	show_legend = opts.show_legend;
end

[ep, dens, extras] = caadb_get_whi_density(ep0, tlen, sc(1));
odata.density = dens;
odata.extras = extras;

if (isempty(ep))
	plot(0);
    title(sprintf('No data for C%d, tstart = %s', sc, datestr(ep0,'YYYY-mm-DD HH:MM:SS.FFF')),'FontSize',12);
	return;
end

clust_panel_timeseries(ep0, tlen, ep, dens, opts);

for i=2:length(sc)
    [epx, densx] = caadb_get_whi_density(ep0, tlen, sc(i));
    hold on;
    plot(epx, densx, ccolor(sc(i)));
    hold off;
end

ylabel('density [cm^{-3}]','FontSize',12);
if (show_title)
    cstr = 'C';
    for isc=sc
        cstr = [cstr, num2str(isc)];
    end
    title(sprintf('WHISPER density %s, tstart = %s', cstr, datestr(ep0,'YYYY-mm-DD HH:MM:SS.FFF')),'FontSize',12);
end
if (show_legend)
	leglabel = {'C1','C2','C3','C4'};
	legend(leglabel{sc});
end
