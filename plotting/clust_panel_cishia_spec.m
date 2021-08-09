function [ep, odata] = clust_panel_cishia_spec(ep0, tlen, sc, opts)

% ep = clust_panel_cishia_spec(ep0, tlen, sc, opts)
%
% Plots panel with CIS HIA (HS) energy spectrogram integrated over all angles.
%
% Options (opts)
%  opts.max_en        - maximum energy in eV [def = Inf]
%  opts.show_xlabel   - if true, show label on X axis [default = 1]
%  opts.show_title    - if true, show panel title [defa = 1]
%  opts.show_colorbar - if true, show colorbar [default = 0]
%  opts.time_seconds  - if true, time axis is labeled in seconds
%                       otherwise datetick is used. [def = 0]
%
% V0.1  ?/10/2010 JS  - initial version
% V0.2  17/3/2011 JS  - corrected behavior on empty data, added show_title
%                       option

% default parameters
max_en = [];
clrbar = 0;
show_xlabel = 1;
show_title = 1;
time_datenum = 1;
max_bin_width = 24;
lowsens = 0;
show_magmode = 0;
out_timeres = 0;

if exist('opts','var') && ~isempty(opts)
    if isfield(opts,'max_en')
		max_en = opts.max_en;
    end
    if isfield(opts,'show_xlabel')
		show_xlabel = opts.show_xlabel;
    end
    if isfield(opts,'show_colorbar')
		clrbar = opts.show_colorbar;
    end
    if isfield(opts,'time_seconds')
		time_datenum = ~opts.time_seconds;
    end
    if isfield(opts,'show_title')
		show_title = opts.show_title;
    end
    if isfield(opts,'low_sensitivity')
		lowsens = opts.low_sensitivity;
    end
    if isfield(opts,'show_magmode')
		show_magmode = opts.show_magmode;
    end
    if isfield(opts,'time_resol')
		out_timeres = opts.time_resol;
    end
end

[ep, spec, energ, extras] = caadb_get_cis_1dspec(ep0, tlen, sc,[],lowsens);

if (length(ep) < 2)
    epplot = ep0 + [0:tlen-1]/86400;
    plot(epplot,zeros(size(epplot))); 
    ylim([0 1]);
    datetick;
    
    if lowsens
        text(0.6,0.4,sprintf('No data on Cluster %d (HIA LS)',sc));
    else
        text(0.6,0.4,sprintf('No data on Cluster %d (HIA HS)',sc));
    end
    ep = [];    
    odata.cis_mode = [];
    return;
end

% place time tags to center of acqusisition interval
ep = ep + extras.interval_duration/2/86400;
odata.cis_mode = extras.cis_mode;

ep_start = ep0;
if (~time_datenum)
	% create time axis in seconds
	ep = (ep - ep0)*86400;
	ep0 = 0;
	ep1 = tlen;
else
    ep1 = ep0 + tlen/86400;
    max_bin_width = max_bin_width/86400;
end

optsp.log_y = 1;
optsp.epoch_time = time_datenum;
optsp.max_freq = max_en;
optsp.colorax = 0;
%optsp.regular_time = 1;
optsp.max_bin_width = max_bin_width;

%plot(diff(ep)*86400);
%[mm,ii] = min(diff(ep)*86400)
%datestr(ep(ii))
%return;

if (out_timeres > 0)    
    fprintf(1,'Rebinning (reducing time resolution to %.1f sec)...\n', out_timeres);
    nreb = floor(tlen/out_timeres);
    ep_plot = ep_start + ((1:nreb)-0.5)*out_timeres/86400;   
    
    delta_ep = out_timeres/2/86400;
    sp_plot = nan(size(spec,1), length(ep_plot));
    for i=1:length(ep_plot)
        ii = find((abs(ep - ep_plot(i)) <= delta_ep));
        if ~isempty(ii)
            sp_plot(:,i) = nanmean(spec(:,ii),2);
        end
    end
    %sp_plot(:,1:5)
    optsp.regular_time = 1;
else   
    ep_plot = ep;
    sp_plot = spec;
    optsp.regular_time = 0;
end

plot_spectrogram(sp_plot, energ, ep_plot, optsp);
if (show_magmode)
    iimag = find(odata.cis_mode >= 8);
    oplotx(ep(iimag), energ(end)*ones(size(ep(iimag))),'*k');
end
xlim([ep0 ep1]);

set(gca,'FontSize',12);
ylabel('Energy [eV]','FontSize',12);

if (show_title)
    if lowsens
        title(sprintf('CIS HIA-LS C%d %s', sc, datestr(ep_start,'DD-mm-YYYY HH:MM:SS.FFF')),'FontSize',12);
    else
        title(sprintf('CIS HIA-HS C%d %s', sc, datestr(ep_start,'DD-mm-YYYY HH:MM:SS.FFF')),'FontSize',12);
    end
end

if ~show_xlabel
	xlabel([]);
end
if clrbar
	colorbar;
end
