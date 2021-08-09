function [epo, dto] = caadb_check_timetag_correctness(ep, dt, min_srate)

% [epo, dto] = caadb_check_timetag_correctness(ep, dt, min_srate)
%
% Check if timetags are monotonous and removes duplicate time tags.
% Returns corrected timetags and data arrays.
%
%   min_srate - smallest allowed difference between subsequent samples. If
%               zero, only samples with exaclty duplicate time tags are
%               removed. (default = 0)
%
% V0.1 17/03/12011 JS - initial version

if ~exist('min_srate','var') || isempty(min_srate)
    min_srate = 0;
end

tdiffs = diff(ep);

if any(tdiffs < 0)
    fprintf(1,'Warning: Non-monotonous time tags (%d occurences)! Sorting...\n', length(find(tdiffs < 0)));
    [epo, isort] = sort(ep);
    dto = dt(:,isort);
    tdiffs = diff(epo);
else
    epo = ep;
    dto = dt;
end

idupl = find(tdiffs <= min_srate/86400);

if ~isempty(idupl)
	fprintf(1, 'Warning: found %d occurences of duplicate time-tags between %s and %s. Removing.\n',length(idupl), datestr(ep(1)), datestr(ep(end)));
	epo(idupl+1) = [];
	dto(:,idupl+1) = [];
end




