function errn = caadb_cache_store(ep, data, metadata, prod_num, scnum, ep_search, cacheopt)

% errn = caadb_cache_store(ep, data, metadata, prod_num, scnum, ep_search, cacheopt)
%
% Stores the dataset (ep, data, metadata) for product (prod_num, scnum) in cache.
% metadata - a structure containing additional non-indexed support data,
%            can be empty.
%
% Other parameters:
% ep_search - 2-element vector giving the start and end time of the original
%             request which retuned the data. This helps avoid relaoding
%             cached file.
%             ( optional - default value = [ep(1), ep(end)] )
% cacheopt  - number of datasets for each product to be stored in the cache
%           - (default = 1)
%
% V0.1 15/09/2008 JS - initial version
% V0.2 18/03/2009 JS - added ep_search parameter
% V0.3 29/03/2009 JS - added metadata support

if (~exist('cacheopt','var') || isempty(cacheopt))
	cacheopt = 1;
end

if (~exist('ep_search','var') || isempty(ep_search))
	ep_search = [ep(1), ep(end)];
end

caadb_cache_globalize;

% search for existing occurence of the same product
rel_idx = []; 
for i=1:CDBCACHE_NUM_ENTRIES
	if ((CDBCACHE_PRODUCT(i) == prod_num) && (CDBCACHE_SCNUM(i) == scnum))
		rel_idx = [rel_idx i];

		ep1 = ep(1);
		ep2 = ep(end);
		if ((ep1 >= CDBCACHE_EPOCHS(i,1)) && (ep2 <= CDBCACHE_EPOCHS(i,2)))
			% already in cache
			errn = 1;
			return;
		end
	end
end

if (length(rel_idx) < cacheopt)
	CDBCACHE_NUM_ENTRIES = CDBCACHE_NUM_ENTRIES + 1;
	inew = CDBCACHE_NUM_ENTRIES;
else
	[mi, im] = min(CDBCACHE_SERIAL(rel_idx));
	inew = rel_idx(im);
end

if (~isempty(rel_idx))
	newser = max(CDBCACHE_SERIAL(rel_idx))+1;
else
	newser = 1;
end

% add new record
CDBCACHE_EPOCHS(inew,1) = ep_search(1);
CDBCACHE_EPOCHS(inew,2) = ep_search(2);
CDBCACHE_PRODUCT(inew) = prod_num;
CDBCACHE_SCNUM(inew) = scnum;
CDBCACHE_SERIAL(inew) = newser;

ts.ep = ep;
ts.data = data;
ts.metadata = metadata;
CDBCACHE_DATA{inew} = ts;

errn = 2;
