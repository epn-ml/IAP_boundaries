function [ep, odata] = clust_panel_whisper_energy(ep0, tlen, sc, opts)

% [ep, odata] = cluster_panel_whisper_energy(ep0, tlen, sc, opts)
%
% Plots panel with WHISPER waveform energy.
%
% Options (opts)
%   - supports default clust_panel_timeseries options.


show_title = 1;
if ~exist('opts','var') || isempty(opts)
    opts = [];
end

if isfield(opts,'show_title')
	show_title = opts.show_title;
end

[ep, eng, extras] = caadb_get_whi_energy(ep0, tlen, sc);

clust_panel_timeseries(ep0, tlen, ep, log10(eng), opts);
odata.energy = eng;
odata.extras = extras;

ylabel('PSD [V^2/(m^2 Hz)]','FontSize',12);
if (show_title)
    title(sprintf('WHISPER waveform energy C%d, tstart = %s', sc, datestr(ep0,'YYYY-mm-DD HH:MM:SS.FFF')),'FontSize',12);
end