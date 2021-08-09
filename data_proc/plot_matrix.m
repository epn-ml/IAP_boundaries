function hcb = plot_matrix(sp, fq, tt, clr_range, threshm, opts)

% hcb = plot_matrix(sp, fq, tt, clr_range, threshm, opts)
%
% Plots a checker plot of matrix sp in linear color scale.
% Calls plot_spectrogram function. Returns handle to colorbar.
%
% Inputs:
%
%  sp -  matix to plot
%  fq -  frequency bin (Hz)  
%  tt -  time tags (matlab datenum)
%  clr_range - range of values of the colorscale
%  threshm - matrix of the saem size as sp. Points where threshm == 0 are
%            omitted from the plot


if exist('opts','var') && ~isempty(opts) 
    opts2 = opts;
    if ~isfield(opts2,'linear_color')
        opts2.linear_color = 1;
    end
else
    opts2.linear_color = 1;
end

if exist('clr_range','var') && (length(clr_range) == 2)
        opts2.colorax = clr_range;
end
if exist('threshm','var') && ~isempty(threshm)
        opts2.thresh_mat = threshm;
end

hcb = plot_spectrogram(sp, fq, tt, opts2);
