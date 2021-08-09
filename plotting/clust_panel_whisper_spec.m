function [ep,sp,fq] = clust_panel_whisper_spec(ep0, tlen, sc, opts)

% cluster_panel_whisper_spec(ep0, tlen, sc, opts)
%
% Plots panel with WHISPER spectrogram
%
% Options (opts)
%  opts.max_freq      - maximum frequency in kHz [def = 80]
%  opts.show_xlabel   - if true, show label on X axis [default = 1]
%  opts.show_colorbar - if true, show colorbar [default = 0]
%  opts.time_seconds  - if true, time axis is labeled in seconds
%                       otherwise datetick is used. [def = 0]


% default parameters

show_xlabel = 1;
show_title = 1;
time_datenum = 1;
overplot_dens = 0;
overplot_peace = 0;
opts_sp.colorax = 0;

if exist('opts','var') && ~isempty(opts)
    if isfield(opts,'colorax')        
		opts_sp.colorax = opts.colorax;    
	end
	if isfield(opts,'max_freq')
		opts_sp.max_freq = opts.max_freq;
	end
	if isfield(opts,'show_xlabel')
		show_xlabel = opts.show_xlabel;
    end
    if isfield(opts,'show_xticks')
		opts_sp.show_xticks = opts.show_xticks;
    end
    if isfield(opts,'show_title')
		show_title = opts.show_title;
    end
    if isfield(opts,'overplot_dens')
		overplot_dens = opts.overplot_dens;
    end
    if isfield(opts,'overplot_peace')
		overplot_peace = opts.overplot_peace;
	end
	if isfield(opts,'show_colorbar')
		if (0 == opts.show_colorbar)
            opts_sp.colorax = 0;
        elseif (0 == opts_sp.colorax)
            opts_sp.colorax = 1;
        end
	end
	if isfield(opts,'time_seconds')
        time_datenum = ~opts.time_seconds;
	end
end

[ep, sp, fq] = caadb_get_whi_spec(ep0, tlen, sc);
if (isempty(ep))
    plot(0);
    title('No WHISPER data for this event');
    return;
end

%datestr(ep,'HH:MM:SS.FFF')
%diff(ep)*86400

%maxwidth = 2.4; % in seconds
maxwidth = 5; % in seconds
ep_start = ep0;
if (~time_datenum)
	% create time axis in seconds
	ep = (ep - ep0)*86400;
	ep0 = 0;
	ep1 = tlen;
    opts_sp.epoch_time = 0;
else
    ep1 = ep0+tlen/86400;
    maxwidth = maxwidth/86400;
end

opts_sp.regular_time = 1;
[epp, spp] = rebin_spectrogram(ep, sp, maxwidth);
plot_spectrogram(spp, fq, epp, opts_sp);
xlim([ep0 ep1]);

if (overplot_dens)
    [epd, dens] = caadb_get_whi_density(ep0, tlen, sc);
    hold on;
    plot(epd, 8.98*sqrt(dens),'k:','LineWidth',2);
    hold off;
end

if (overplot_peace)
    [epd, dens] = caadb_get_peace_moments(ep0, tlen, sc);
    hold on;
    plot(epd, 8.98*sqrt(dens),'w');
    hold off;
end

set(gca,'FontSize',12);
ylabel('frequency [kHz]','FontSize',12);
if (show_title)
    title(sprintf('WHISPER C%d %s', sc, datestr(ep_start,'YYYY-mm-dd HH:MM:SS.FFF')),'FontSize',12);
end
if ~show_xlabel
	xlabel([]);
end

%if clrbar
%	colorbar;
%end
