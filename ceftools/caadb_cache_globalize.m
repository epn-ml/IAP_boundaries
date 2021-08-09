% numbers of cached entries
global CDBCACHE_NUM_ENTRIES;
% array CDBCACHE_NUM_ENTRIES x 2 - start & end epochs
global CDBCACHE_EPOCHS;
% cell_arrays of FGMCACHE_NUM_ENTRIES x 4 data for each spacecraft
global CDBCACHE_DATA;
% array of product numbers (integer)
global CDBCACHE_PRODUCT;
% array of sc numbers (integer, only valid for multi-sc data)
global CDBCACHE_SCNUM;
% serial number of the record (record with lowest sn is always replaced)
global CDBCACHE_SERIAL;

% if this is the first call ever, initialize counts 
if (isempty(CDBCACHE_NUM_ENTRIES))
	CDBCACHE_NUM_ENTRIES = 0;
end

