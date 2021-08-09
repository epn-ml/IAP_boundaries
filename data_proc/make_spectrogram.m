function [sp, tt, fq, sm, nav] = make_spectrogram(uu, wnd_size, dt, maxfq, avg, ttags, tstep, ovrlp, smat, plotit);

% [sp, tt, fq, sm, nav] = make_spectrogram(uu, wnd_size, dt, maxfq, avg, ttags, tstep, ovrlp, smat, plotit);
%
% Calculates and optionally plots a spectrogram of the input
% time-series. Handles NaN's and data gaps correctly. Uses Hann window.
%
% 
% Input parameters:
% uu - input time series (N x M, N components, M samples)
% wnd_size - FFT size
% dt - sampling period (seconds)
% maxfq - maximum freqeuency to include in Hz (def = fsamp/2)
% avg - number of spectra to average (optional, def = 1)
% ttags  - timetags corresponding to uu as matlab datenum
%          (optional, regular sampling assumed)
% tstep - one spectrum every tstep windows (optional, def = 1)
% plotit  - if nonzero, plot the spectrogram (def = 0)
% ovrlp   - if nonzero, use 50% overlap (def = 0)
% smat    - if nonzero, caclulate spectral matrices (def = 0)
%
% Output:
%
% sp - length(fq) x M x N matrix ( PSD in unit^2/Hz )
% tt - 1 x M - datenum timetags of spectra (start times)
% fq - frequency axis (Hz) up to maxfq (linear, full res)
% sm - spectral matrix length(fq) x M x N x N
%      (empty if smat not set)
% nav - number of averaged fft's for each spectrum
%
% Changelog:
% V0.1 - JS 18/7/2008
%   Initial version, averaging & plotting not implemented
% V0.2 - JS 31/7/2008
%   averaging & plotting works
% V0.3 - JS 13/3/2009
%   fixed frequency axis (bug)
% V0.4 - JS 13/3/2009
%   fixed underestimated number of spectra if datalen is an exact multiple of wnd_size
% V0.5 - JS 20/1/2010
%   checks all components for NaN's when calculating <nav>
% V0.6 - JS 05/07/201
%   fixed normalization of PSD correcting for window function


if (~exist('plotit','var') || isempty(plotit))
	plotit = 0;
end

if (~exist('avg','var') || isempty(avg))
	avg = 1;
end

if (~exist('tstep','var') || isempty(tstep))
	tstep = 1;
end

if (~exist('maxfq','var') || isempty(maxfq))
	maxfq = 1/dt/2; % use Nyquist fq
	maxfq = 0;
end

if (~exist('ovrlp','var') || isempty(ovrlp))
	ovrlp = 0;
end

if (ovrlp && (0 == mod(avg,2)))
	error('If overlap specified, avg must be an odd number\n');
end

if (~exist('smat','var') || isempty(smat))
	smat = 0;
end

% end validation

sm = [];
if (size(uu,2) == 1)
	uu = uu';
end
datalen = size(uu,2);

if (exist('ttags','var') && ~isempty(ttags))
	if (length(ttags) ~= datalen)
		error('Length of ttags does not correspond to data');
	end
	tt_sec = (ttags - ttags(1))*86400;
else
	% assume no gaps
	ttags = [];
	tt_sec = dt*(0:datalen-1);
end

fq = (0:wnd_size/2-1)/dt/wnd_size;
if (maxfq > 0)
	ii = find(fq > maxfq);
	if (~isempty(ii))
		fq = fq(1:ii(1));
	end
end

wnd_time_len = wnd_size*dt;

if (ovrlp)
	nwnd = floor(2*(tt_sec(end) - tt_sec(1))/wnd_time_len) - 1;
else
	if (isempty(ttags))
		nwnd = floor(datalen/wnd_size);
	else
		nwnd = floor((tt_sec(end) - tt_sec(1))/wnd_time_len);
	end
end

ncomp = size(uu,1);
spec = zeros(length(fq), nwnd, ncomp);

if (ovrlp)
	tstarts = (0:nwnd-1)*wnd_time_len/2;
else
	tstarts = (0:nwnd-1)*wnd_time_len;
end

wndmatrix = repmat(hann(wnd_size)',ncomp,1);
wndnormfact = sum(hann(wnd_size).^2);

%whos

for k = 1:nwnd
	if (isempty(ttags))
		ii = find((tt_sec >= tstarts(k)) & (tt_sec < tstarts(k)+wnd_time_len-dt/10));
		if (length(ii) ~= wnd_size)
			fprintf(1,'skipping window of size %d, data gap\n', length(ii));
			spec(:,k,:) = nan;
			continue;
		end
	else
		ii = find((tt_sec >= tstarts(k)) & (tt_sec < tstarts(k)+wnd_time_len+dt));
		if (length(ii) < wnd_size)
			fprintf(1,'skipping window of size %d, data gap\n', length(ii));
			spec(:,k,:) = nan;
			continue;
		end
		ii = ii(1:wnd_size);
	end


	uu0 = uu(:,ii);
	if (~isempty(find(~isfinite(uu0))))
		fprintf(1,'Skipping window containing NaN\n', length(ii));
	end

	uu0 = uu0.*wndmatrix;
	s0 = fft(uu0,[],2);
	for j=1:ncomp
		spec(:,k,j) = s0(j,1:length(fq))';
	end
end

nspec = floor(nwnd/tstep);

while (nwnd - (nspec-1)*tstep < avg)
	nspec = nspec -1;
end

sp = zeros(length(fq), nspec, ncomp);
tt = zeros(1,nspec);
nav = zeros(1,nspec);

if (smat)
	sm = zeros(length(fq), nspec, ncomp, ncomp);
end

for j=1:nspec
	i0 = (j-1)*tstep + 1;
	iav = i0:i0+avg-1;

	% find central time tag
	if (mod(avg,2))
		tt(j) = tstarts(i0+(avg-1)/2) + wnd_time_len/2;
	else
		tt(j) = tstarts(i0+avg/2);
	end

	% Old V0.4 code
	%inan = find(isnan(spec(1,iav,1)));
	%iav(inan) = [];
	%nav(j) = length(iav);

	% remove bad spectra
	inan = [];
	for i=1:length(iav)
		if ~isempty(find(isnan(spec(1,iav(i),:))))
			inan = [inan i];
		end
	end
	iav(inan) = [];
	nav(j) = length(iav);

	if (~isempty(iav))
		sp(:,j,:) = sum(abs(spec(:,iav,:)).^2,2) / nav(j);
	else
		sp(:,j,:) = NaN;
	end

	if (smat)
		for kx=1:ncomp
		for ky=1:ncomp
			sm(:,j,kx,ky) = sum(spec(:,iav,kx).*conj(spec(:,iav,ky)),2) / nav(j);
		end
		end
	end
end

% normalized so sp is a PSD
sp = 2*dt*sp/wndnormfact;
sm = 2*dt*sm/wndnormfact;
if (~isempty(ttags))
	tt = ttags(1) + tt/86400;
%	vv = datevec(ttags(1));
%	tt = datenum(vv(1), vv(2), vv(3), 0, 0, tstarts);
end

if (plotit)
	plot_spectrogram(sp, fq, tt);
end