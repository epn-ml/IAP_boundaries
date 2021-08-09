function [tt, sp] = rebin_spectrogram(tt0, sp0, maxwidth)

% [tt, sp] = rebin_spectrogram(tt0, sp0, maxwidth)
%
% Re-bins spectrogram in time-tags. Input tt can be irregular and contain
% gaps, output tt are regularly spaced.
%
% Input: 
%   tt, sp - timetags and spectrogram matrix
%   maxwidth - (optional) maximum distance between input timetags
%              If this distance exceeded, data-gap is assumed. [def = Inf]  
%
% Changes:
%    V0.1 19/10/2009 JS 
%        - initial version

if ~exist('maxwidth','var') || isempty(maxwidth)
	maxwidth = inf;
end

reb_factor = 10;
dt = min(diff(tt0))/reb_factor;
edges(1) = tt0(1) - (tt0(2)-tt0(1))/2;
edges(length(tt0)+1) = tt0(end) + (tt0(end)-tt0(end-1))/2;
edges(2:length(tt0)) = (tt0(1:end-1)+tt0(2:end))/2;

nsamp = floor((edges(end) - edges(1))/dt); 
tt = (edges(1) + dt/2 + (0:nsamp-1)*dt)';
sp = nan(size(sp0,1),nsamp);

parfor i=1:nsamp
	% fill datagaps with NaN's
	if (min(abs(tt(i) - tt0)) > maxwidth/2)
        continue;
	end
	j = find((edges(2:end) >= tt(i)) & (edges(1:end-1) < tt(i))); 
	if ~isempty(j)
		sp(:,i) = sp0(:,j);
	end
end
