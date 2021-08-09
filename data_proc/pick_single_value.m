function [rvl,ep_val,navg,idx] = pick_single_value(epp, data, ep0, avgpar)

% [rvl,ep_val,navg] = pick_single_value(epp, data, ep0, avgpar);
%
% Returns a single value from time series [epp, data] in the neigborhood of ep0 
% according to value of avgpar:
%  avgpar = 0 -> use nearest neighbor [default]
%  avgpar > 0 -> average data in an interval of width avgpar centered on ep0 

if ~exist('avgpar','var') || isempty(avgpar)
    avgpar = 0;
end

if (avgpar == 0)
	[tmp, idx] = min(abs(epp - ep0));
	if isvector(data)
		rvl = data(idx);
	else
		rvl = data(:,idx);
	end
	ep_val = epp(idx);
	navg = 1;
else
	idx = find(abs(epp - ep0) <= avgpar/2);
	navg = length(idx);
	if isempty(idx)
		rvl = [];
	else
		if isvector(data)
			rvl = nanmean(data(idx));
		else
			rvl = nanmean(data(:,idx),2);
		end
	end
	ep_val = ep0;
end
