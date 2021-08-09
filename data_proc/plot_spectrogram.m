function hcbar = plot_spectrogram(sp, fq, tt, opts)

% hcbar = plot_spectrogram(sp, fq, tt, opts)
%
% Plots a spectrogram (PSD), designed to work with make_spectrogram function.
% Returns a handle to colorbar (empty if no colorbar)
%
% Inputs:
%
%  sp -  complex spectrum in <unit>/sqrt(Hz);
%  fq -  frequency bin (Hz)  
%  tt -  time tags (matlab datenum, seconds or anything)
%  opts - options structure
%    - max_freq - maximum freqeuncy in fq units
%    - linear_color:
%          1 - linear colorscale
%          0 - log colorscale (default)
%    - epoch_time: timetag intgerpretation 
%          1 - datenum (default)
%          0 - seconds
%    - colorax: colorbar options
%          0 - no colorbar;
%          1 - default colorbar (default)
%	       2 - element vector - use caxis(colorax)
%    - log_y: the y-axis is logaritmic
%          0 - linear Y-axis [def]
%    - regular_time: 
%          0 - timetags can be irregular and contain gaps
%          1 - regularly sampled time tags, no gaps [default]
%    - max_bin_width (only valid if regular_time = 0): 
%          maximum width of a bin in time, paremter to rebin_spectrogram
%          [default = Inf]
%    - show_xlabel - if 1, show label on X-axis [def = 1]
%    - show_xticks
%          if 1, show ticks on the X-axis [def = 1]
%    - cbar_label
%          label on the colorbar [ def = [] ]
%    - thresh_mat
%          threshold matrix of the same size as sp. Only elements with 
%          nonzero threshold are plotted.
%
% Changes:
%       V0.1 2008 JS
%         - initial version
%       V0.2 19/10/2009 JS
%         - changed parameters (opts structure used) 
%         - added time-tag rebinning (if opts.regular_time == 0)
%       V0.21 20/11/2009 JS
%         - new opts parameter


% defaults 
colorax = 1;
linear_color = 0;
log_y = 0;
maxfq = 0;
minfq = 0;
regular_time = 1;
max_bin_width = [];
show_xlabel = 1;
show_xticks = 1;
cbar_label = [];
thrm = [];


% time tag autodetection :)
if (tt(1) > datenum([1950,0,0,0,0,0]))
	epoch_time = 1;
else
	epoch_time = 0;
end

% process options
if exist('opts','var') && ~isempty(opts)
    if isfield(opts,'colorax')
		colorax = opts.colorax;
    end
    if isfield(opts,'epoch_time')
		epoch_time = opts.epoch_time;
    end
    if isfield(opts,'log_y')
		log_y = opts.log_y;
    end
    if isfield(opts,'max_freq')
		maxfq = opts.max_freq;
    end
    if isfield(opts,'min_freq')
		minfq = opts.min_freq;
    end
    if isfield(opts,'linear_color')
		linear_color = opts.linear_color;
    end
    if isfield(opts,'regular_time')
		regular_time = opts.regular_time;
    end
    if isfield(opts,'max_bin_width')
		max_bin_width = opts.max_bin_width;
    end
    if isfield(opts,'show_xlabel')
		show_xlabel = opts.show_xlabel;
    end
    if isfield(opts,'show_xticks')
		show_xticks = opts.show_xticks;
    end
    if isfield(opts,'cbar_label')
		cbar_label = opts.cbar_label;
    end
    if isfield(opts,'thresh_mat')
		thrm = opts.thresh_mat;
    end
end

if (maxfq > 0)
	ii = find(fq <= maxfq);
else
	ii = 1:length(fq);
end
fq2 = fq(ii);
sp = sp(ii,:,:);

ii = find(fq2 >= minfq);
fq2 = fq2(ii);
sp = sp(ii,:,:);

[fq2,isorted] = sort(fq2,'ascend');
sp = sp(isorted,:,:);

if (3 == ndims(sp))
	sp = sum(abs(sp),3);
end

if ~isempty(thrm)	
	sp(thrm == 0) = NaN;
end

sp(~isfinite(sp)) = NaN;
if (linear_color)
	sppl = sp;
else
    if ~isempty(find(sp <= 0,1))    
        fprintf(1,'Negative spectral values ignored.\n');
        sp(sp <= 0) = NaN;
    end
	sppl = log10(sp);    
end

% resample the spectrogram
if (~regular_time)
	[tt, sppl] = rebin_spectrogram(tt, sppl, max_bin_width);
end

if (length(colorax) == 2)	
	maxval = colorax(2);
else
    maxval = max(max(sppl));
end
colormap('jet');
scolor = size(colormap,1); 
sppl_corr = sppl;
sppl_corr(isnan(sppl)) = maxval*(scolor)/scolor;
%sppl_corr(isnan(sppl)) = NaN;
%maxval*(scolor+2.02)/scolor
%sppl_corr(isnan(sppl)) = 1;


if (log_y)
    yticks = sort(10.^(ceil(log10(fq2(1))):1:floor(log10(fq2(end))))); 
	imagesclogy(tt, fq2, sppl_corr,[],[], yticks);
    set(gca, 'yminortick', 'on', 'tickdir','in');
    %pcolor(tt, fq2, sppl); shading('flat');
    %set(gca,'YScale','log');
	%ylim([0 max(fq2)]);
else    
	imagesc(tt, fq2, sppl_corr);
    ylim([minfq max(fq2)]);    
end
cmap0 = colormap;
cmap = cmap0;
cmap(end,:) = [1,1,1];
colormap(cmap);

if (epoch_time)
	datetick;
    xlim([tt(1) tt(end)]);
    if (show_xlabel)
        xlabel(sprintf('UT %s',datestr(tt(1),1)),'FontSize',12);
    end
else
    if (show_xlabel)
        xlabel('time [seconds]','FontSize',12);
    end
end

axis xy
set(gca, 'FontSize',12);

if (~show_xticks)
    set(gca, 'XTick',[]);
end

iok = find(isfinite(sppl(:)));
minvalue = min(sppl(iok));
maxvalue = max(sppl(iok));
%caxis([minvalue maxvalue]);

if (length(colorax) == 2)
	lowtick = ceil(colorax(1));
	hitick = floor(colorax(2));
	caxis(colorax);
else
	lowtick = ceil(minvalue);
	hitick = floor(maxvalue);
    caxis([minvalue maxvalue]);
end

if ((length(colorax) > 1) || (0 ~= colorax))    
	hcbar = colorbar;

% set colorbar ticks
    if (0 == linear_color)
		cticks = lowtick:hitick;
		ticklab = cell(length(cticks),1);
		for i=1:length(cticks)
			ticklab{i} = sprintf('1e%d',cticks(i));
		end
		set(hcbar, 'YTick', cticks, 'YTickLabel', ticklab,'FontSize',12);
    end
    
    if ~isempty(cbar_label)
        ylabel(hcbar, cbar_label);
    end
else
    hcbar = [];
end

ylabel('Freq [Hz]','FontSize',12);

