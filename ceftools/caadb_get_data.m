function [ep, dout, metadata] = caadb_get_data(ep_start, tlen, product, scnum, caaopt)

% [ep, dout, metadata] = caadb_get_data(ep_start, tlen, product, scnum, caaopt)
%
% Main general script to load any data from the cdb database.
%
% V0.1:  March 2008 JS - initial version
% V0.2:  18/03/2009 JS - fixed bug causing crashes if ii was empty inside loop
%                      - improved caching (ep_file)
%					   - metadata support
% V0.3   04/05/2009 JS - improved caching (now checking cache when loading files)
%
% V0.4   17/03/2011 JS - improved timetag checking


verbose = 5;
cachedepth = 3;

global CDBOPT_VERBOSITY;
if ~isempty(CDBOPT_VERBOSITY)
    verbose = CDBOPT_VERBOSITY;
end

[pro, pnum, ppath, multisc] = caadb_get_product_info(product);
if (multisc == 0)
	scnum = 0;
end

usecache = 1;	

check_timetags = 1;
if (exist('caaopt') && strcmp(caaopt,'no_tt_check'))
	check_timetags = 0;	
end

if (usecache)
	[ep, dout, metadata] = caadb_cache_lookup(ep_start, tlen, pnum, scnum, check_timetags);
	if (~isempty(ep))
		% data found in cache, we are done
		return;
	end
end

fivemin = 300/86400; % 300 seconds

ep1 = ep_start;
ep2 = ep_start+tlen/86400;

dout = [];
ep = [];

[status, fi0] = caadb_find_file_from_time(ep1, product, scnum);

if (status == 0)
  	fprintf(1,'File containing product %s for SC%d, %s not found\n', pro, scnum, datestr(ep_start));
	return;
else
	[ttags, data, metadata] = internal_load_file_cached(fi0, pnum, scnum, verbose);
end


breakit = 0;
while (1)
	if (usecache && ~isempty(ttags))
		% we have data, store it in the cache
		ep_file = [fi0.ep_start, fi0.ep_end];
		caadb_cache_store(ttags, data, metadata, pnum, scnum, ep_file, cachedepth);
	end

	if (ep2 < fi0.ep_end)
		ii = find((ttags > ep1) & (ttags < ep2));
		breakit = 1;
	else
		ii = find(ttags > ep1);
		ep1 = 0;
	end

	if (~isempty(ep) && ~isempty(ii))
		if (ep(end) > ttags(ii(1)))
			fprintf('W: files overlap: 1st ends: %s 2nd starts %s', datestr(ep(end)), datestr(ep(end)));
		end
    end
   
	ep = [ep ttags(ii)];
	dout = [dout data(:,ii)];
	clear data ttags;

	if (breakit)
		break;
	end
	
	% load next file
	fi1 = fi0;
	[status, fi0] = caadb_find_file_from_time(fi0.ep_end+fivemin, product, scnum);
	if (status == 0)
		fprintf(1,'File containing product %s for SC%d after %s not found\n', pro, scnum, datestr(fi1.ep_end));
		%ep = [];
		%dout = [];
		return;
	else
		[ttags, data, meta_tmp] = internal_load_file_cached(fi0, pnum, scnum, verbose);
        if isempty(metadata)
            metadata = meta_tmp;
        end
	end
end

if (check_timetags)
    [ep, dout] = caadb_check_timetag_correctness(ep, dout);
end
% end of caadb_get_data


function [ttags, data, metadata] = internal_load_file_cached(fi0, pnum, scnum, verbose)

tlen2 = (fi0.ep_end - fi0.ep_start)*86400 - 1e-5; % just to correct roundoff
[ttags, data, metadata] = caadb_cache_lookup(fi0.ep_start, tlen2, pnum, scnum);
if (~isempty(ttags))
	if (verbose > 1)
		fprintf(1,'Loaded from cache: %s\n', fi0.fname);
	end
else
	if (verbose)
		fprintf(1,'Loading: %s\n', fi0.fname);
	end
	fulln = fullfile(fi0.path, fi0.fname);
	warning('off','MATLAB:load:variableNotFound');
	load(fulln, 'data', 'ttags','metadata');
	warning('on','MATLAB:load:variableNotFound');
	if (~exist('metadata','var'))
		metadata = [];
    end    
end


