function [sm, tt, fq, sp] = make_smat(uu, wnd_size, dt, maxfq, nav, fav);

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
% nav - number of spectra to average (optional, def = 1)
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

if (~exist('nav','var') || isempty(nav))
	nav = 1;
end
if (~exist('fav','var') || isempty(nav))
	fav = 1;
end
if (~exist('maxfq','var') || isempty(maxfq))
	maxfq = 1/dt/2; % use Nyquist fq
end

% end validation

if (size(uu,2) == 1)
	uu = uu';
end
datalen = size(uu, 2);
tt_sec = dt*(0:datalen-1);
datalen = size(uu,2);
%frequency vector
fq = (0:wnd_size/2-1)/dt/wnd_size;
if (maxfq > 0)
	ii = find(fq > maxfq);
	if (~isempty(ii))
		fq = fq(1:ii(1));
	end
end

wnd_time_len = wnd_size*dt;
nwnd = floor(2*(tt_sec(end) - tt_sec(1))/wnd_time_len) - 1;
ncomp = size(uu,1);
spec = zeros(length(fq), nwnd, ncomp);

tstarts = (0:nwnd-1)*wnd_time_len/2;
% HANNING WINDOW
wndmatrix = repmat(hann(wnd_size)',ncomp,1);
wndnormfact = sum(hann(wnd_size).^2);
%whos
for k = 1:nwnd
	ii = find((tt_sec >= tstarts(k)) & (tt_sec < tstarts(k)+wnd_time_len-dt/10));
	if (length(ii) ~= wnd_size)
		fprintf(1,'skipping window of size %d, data gap\n', length(ii));
		spec(:,k,:) = nan;
		continue;
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
while (nwnd - (nspec-1)*tstep < nav)
	nspec = nspec -1;
end

sp = zeros(length(fq), nspec, ncomp);
tt = zeros(1,nspec);
nav = zeros(1,nspec);
sm = zeros(length(fq), nspec, ncomp, ncomp);

for j=1:nspec
    for f=1:length(fq)
        tind = (j-nav:j+nav);
        tnd = tnd(tnd >= 1 & tnd <= nspec);
        fnd = (f-fav:f+fav); % indexes for frequency
        fnd = fnd(fnd >= 1 & fnd <= length(fq));
    	% find central time tag
        tt(j) = tstarts(j);
        % remove bad spectra
        inan = [];
        for i=1:length(tnd)
            if ~isempty(find(isnan(spec(1,tnd(i),:))))
			inan = [inan i];
		end
        end
        iav(inan) = [];
        nv(j) = length(tnd);
        nf(j) = length(fnd);
        if (~isempty(iav))
            sp(f,j,:) = sum(abs(spec(fnd,tnd,:)).^2,2) / nv(j) / nf(j);
        else
            sp(:,j,:) = NaN;
        end
    
		for kx=1:ncomp
		for ky=1:ncomp
			sm(f,j,kx,ky) = sum(spec(fnd,tnd,kx).*conj(spec(fnd,tnd,ky)),2) / nv(j) / nf(j);
		end
		end
    end
end
   
% normalized so sp is a PSD
sp = 2*dt*sp/wndnormfact;
if (~isempty(ttags))
	tt = ttags(1) + tt/86400;
%	vv = datevec(ttags(1));
%	tt = datenum(vv(1), vv(2), vv(3), 0, 0, tstarts);
end