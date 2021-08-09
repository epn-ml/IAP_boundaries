function [sp, fq, nav] = make_spectrum(uu, wnd_size, dt, maxfq, ovrlp);

% function [sp, fq, nav] = make_spectrum(uu, wnd_size, dt, maxfq, ovrlp);
%
% Calculates and optionally plots a complex spectrogram of the input
% time-series. Handles NaN's and data gaps correctly. Uses Hann window.
%
% 
% Input parameters:
% uu - input time series (N x M, N components, M samples)
% wnd_size - FFT size
% dt - sampling period (seconds)
% maxfq - maximum freqeuency to include in Hz (def = fsamp/2)
% ovrlp   - if nonzero, use 50% overlap (def = 0)
%
% Output:
%
% sp - length(fq) x N matrix (complex spectrum)
% fq - frequency axis (Hz) up to maxfq (linear, full res)
% nav - number of averaged fft's 
%
% Changelog:
% V0.1 - JS 13/3/2009
%   Initial version


if (~exist('maxfq','var') || isempty(maxfq))
	maxfq = 0;
end

if (~exist('ovrlp','var') || isempty(ovrlp))
	ovrlp = 0;
end

[sp0, tt, fq] = make_spectrogram(uu, wnd_size, dt, maxfq, [], [], [], ovrlp);
sp = nanmean(sp0, 2);
nav = size(sp0,2);


