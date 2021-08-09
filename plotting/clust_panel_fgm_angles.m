function [ep, odata] = clust_panel_fgm_angles(ep0, tlen, sc, opts)

% [ep, odata] =  clust_panel_fgm_angles(ep0, tlen, sc, opts)
%
% Plots panel with FGM magnetic field polar and azimuthal angle in GSE
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
%   Jun 12, 2013 JS
%     - corrected legend, labels


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
[phi,th] = cart2sph(bb(1,:), bb(2,:), bb(3,:));

th = th*180/pi;
phi = 180*phi/pi;

opts.colors = ccolor(1:3);

clust_panel_timeseries(ep0, tlen, ep, th, opts);
hold on
plot(ep,phi,'r');
hold off;
oplotx(ep,phi*0,'b--');

if (show_legend)
	leglabel = {'Polar','Azimuth'};
	legend(leglabel);
end

ylabel('B angles [deg]','FontSize',12);
title(sprintf('FGM B-field C%d, tstart = %s', sc, datestr(ep0,'YYYY-mm-DD HH:MM:SS.FFF')),'FontSize',12);
