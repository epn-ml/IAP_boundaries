function [ep, bmout] = clust_panel_fgm_mag(ep0, tlen, sc, opts)

% [ep, odata] = cluster_panel_fgm_mag(ep0, tlen, sc, opts)
%
% Plots panel with FGM magnetic field magnitude
% <sc> can be a vector of multiple spacecraft
%
% Options (opts)
%  opts.yaxis         - two element vector [Bmin Bmax]
%  opts.show_xlabel   - if true, show label on X axis [def= 1]
%  opts.show_legend   - if true, shows color legend [def= 0]
%  opts.time_seconds  - if true, time axis is labeled in seconds
%                       otherwise datetick is used. [def = 0]
%  opts.comp_shift    - shift signal for k-th spacecraft by 
%                       (k-1)*<opts.comp_shift>
%
% Changes:
%   Nov 11, 2009 JS
%     - modified to use new clust_panel_timeseries


% default parameters
show_legend = 0;
comp_shift = 0;
marg = 20;
out_timeres = 0;

if ~exist('opts','var')
    opts = [];
end

% Standard Cluster colors 
% ccolor = 'krgb';

if exist('opts','var') && ~isempty(opts)
	if isfield(opts,'show_legend')
		show_legend = opts.show_legend;
	end
    if isfield(opts,'comp_shift')
		comp_shift = opts.comp_shift;
    end
    if isfield(opts,'time_resol')
		out_timeres = opts.time_resol;
	end
end

k=1;
for isc=sc
	[ept, bb] = caadb_get_fgm(ep0, tlen, 'fgm_5vps', isc);
	if (1 == k)
        ep = ept;
		bm(k,:) = vnorm(bb);
    else
        i0 = find(ep(1) == ept);
        i1 = find(ep(end) == ept);
        bmtmp = vnorm(bb(:,i0:i1));
		bm(k,:) = bmtmp;
	end
	bmout(k,:) = bm(k,:);
    bm(k,:) = bm(k,:) + (k-1)*comp_shift;
	k = k+1;
end

if (out_timeres > 0.2)
    epx = ep;
    bmx = bm;
    
    nreb = floor(tlen/out_timeres);
    ep = ep0 + ((1:nreb)-0.5)*out_timeres/86400;   
    
    delta_ep = out_timeres/2/86400;
    bm = nan(size(bmx,1), length(ep));
    for i=1:length(ep)
        ii = find((abs(epx - ep(i)) <= delta_ep));
        if ~isempty(ii)
            bm(:,i) = nanmean(bmx(:,ii),2);
        end
    end    
end
    

%opts.colors = ccolor(sc);
clust_panel_timeseries(ep0, tlen, ep, bm, opts);

if (show_legend)
	leglabel = {'C1','C2','C3','C4'};
	legend(leglabel{sc});
end

ylabel('|B| [nT]','FontSize',12);
cstr = 'C';
for isc=sc
	cstr = [cstr, num2str(isc)];
end
title(sprintf('FGM B-field %s, tstart = %s', cstr, datestr(ep0,'YYYY-mm-DD HH:MM:SS.FFF')),'FontSize',12);
