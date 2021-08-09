function [ep, data, metadata] = caadb_cache_lookup(ep_start, tlen, pnum, scnum)

% [ep, data] = caadb_cache_lookup(ep_start, tlen, pnum, scnum)
%
% Returns the cached dataset if it covers the entire interval specified.
% Otherwise returns empty values;
%
% V0.1  15/09/2008 JS - initial version
% V0.11 18/03/2009 JS - minor changes + added debug printouts
% V0.2  29/03/2009 JS - added matadata support

caadb_cache_globalize;

ep = [];
data = [];
metadata = [];

ep1 = ep_start;
ep2 = ep_start + tlen/86400;
%fprintf(1, 'Looking up prod %d between %s and %s\n', pnum, datestr(ep1,0), datestr(ep2,0));

for i=1:CDBCACHE_NUM_ENTRIES
	if ((CDBCACHE_PRODUCT(i) ~= pnum) || (CDBCACHE_SCNUM(i) ~= scnum))
		continue;
	end

%fprintf(1, 'Found interval %s and %s\n', datestr(CDBCACHE_EPOCHS(i,1),0), datestr(CDBCACHE_EPOCHS(i,2),0));

	if ((ep1 >= CDBCACHE_EPOCHS(i,1)) && (ep2 <= CDBCACHE_EPOCHS(i,2)))
		ep = CDBCACHE_DATA{i}.ep;
		data = CDBCACHE_DATA{i}.data;
		metadata = CDBCACHE_DATA{i}.metadata;
		ii = find((ep >= ep1) & (ep <= ep2));
		ep = ep(ii);
		data = data(:,ii);
%		fprintf(1, 'Got match!\n'); return;
		break;
	end
end
%fprintf(1, 'No match\n');

