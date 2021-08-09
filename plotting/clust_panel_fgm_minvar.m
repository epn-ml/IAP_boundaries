function [ep, odata] = clust_panel_fgm_minvar(ep0, tlen, sc, opts)

% [ep, odata] = cluster_panel_fgm_minvar(ep0, tlen, sc, opts)
%
% Plots panel with FGM magnetic field in minimum variance
% coordinate system
%
% Options (opts)
%  opts.yaxis         - two element vector [Bmin Bmax]
%  opts.show_xlabel   - if true, show label on X axis [def= 1]
%  opts.show_legend   - if true, shows color legend [def= 0]
%  opts.time_seconds  - if true, time axis is labeled in seconds
%                       otherwise datetick is used. [def = 0]


% default parameters
yaxis = [];
show_xlabel = 1;
time_datenum = 1;
show_legend = 0;
subtract_mean = 0;

ep1 = ep0+tlen/86400;

% Stnadrad Cluster colors 
ccolor = 'krgb';

if exist('opts','var') && ~isempty(opts)
	if isfield(opts,'show_legend')
		show_legend = opts.show_legend;
	end
	if isfield(opts,'time_seconds')
		time_datenum = ~opts.time_seconds;
    end
    if isfield(opts,'subtract_mean')
		subtract_mean = opts.subtract_mean;
	end
end

[ep, bb] = caadb_get_fgm(ep0, tlen, 'fgm_5vps', sc);
odata.bb = bb;
[tm, mv_eig] = minvar(bb);
tm = inv(tm);
det(tm)
bb = tm*bb;
%mv_eig
%tm
var(bb(1,:))
var(bb(2,:))
var(bb(3,:))

if (~time_datenum)
	% create time axis in seconds
	ep = (ep - ep0)*86400;
	ep0 = 0;
	ep1 = tlen;
end
opts.colors = ccolor(1:3);

if (subtract_mean)
    for i=1:3
        bb(i,:) = bb(i,:) - mean(bb(i,:));
    end
end

clust_panel_timeseries(ep0, tlen, ep, bb, opts);
xlim([ep0 ep1]);

if (show_legend)
	leglabel = {'Min. variance','Intermediate','Max. variance'};
	legend(leglabel);
end

ylabel('B_{minvar} [nT]','FontSize',12);
title(sprintf('FGM B-field C%d, tstart = %s', sc, datestr(ep(1),'YYYY-mm-DD HH:MM:SS.FFF')),'FontSize',12);
