function [ep, odata] = clust_panel_fgm_3comp(ep0, tlen, sc, opts)

% [ep, odata] = cluster_panel_fgm_mag(ep0, tlen, sc, opts)
%
% Plots panel with FGM magnetic field (3 compnents in GSE)
%
% Options (opts)
%  opts.yaxis         - two element vector [Bmin Bmax]
%  opts.show_xlabel   - if true, show label on X axis [def= 1]
%  opts.show_legend   - if true, shows color legend [def= 0]
%  opts.time_seconds  - if true, time axis is labeled in seconds
%                       otherwise datetick is used. [def = 0]
%
% Changes:
%   Nov 18, 2009 JS
%     - modified to use new clust_panel_timeseries


% default parameters
show_legend = 0;

% Stnadrad Cluster colors 
ccolor = 'krgb';

if exist('opts','var') && ~isempty(opts)
	if isfield(opts,'show_legend')
		show_legend = opts.show_legend;
	end
end

[ep, bb] = caadb_get_fgm(ep0, tlen, 'fgm_5vps', sc);
odata.bb = bb;

opts.colors = ccolor(1:3);

clust_panel_timeseries(ep0, tlen, ep, bb, opts);

if (show_legend)
	leglabel = {'Bx','By','Bz'};
	legend(leglabel);
end

ylabel('B_{x,y,z} [nT]','FontSize',12);
title(sprintf('FGM B-field C%d, tstart = %s', sc, datestr(ep0,'YYYY-mm-DD HH:MM:SS.FFF')),'FontSize',12);
