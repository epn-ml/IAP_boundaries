function [ep, data, metadata] = caadb_cache_lookup(ep_start, tlen, pnum, scnum, check_dupes)

% [ep, data] = caadb_cache_lookup(ep_start, tlen, pnum, scnum)
%
% Returns the cached dataset if it covers the entire interval specified.
% Otherwise returns empty values;
%
% V0.1  15/09/2008 JS - initial version
% V0.11 18/03/2009 JS - minor changes + added debug printouts
% V0.2  29/03/2009 JS - added matadata support
% V0.3  28/02/2010 JS - will match interval spanning over several cached files
% V0.4  17/03/2011 JS - modified check for out of order and duplicate time tags
%                       now calls caadb_check_timetag_correctness

caadb_cache_globalize;

if ~exist('check_dupes','var') || isempty(check_dupes)
    check_dupes = 1;
end

ep = [];
data = [];
metadata = [];

ep1 = ep_start;
ep2 = ep_start + tlen/86400;
%fprintf(1, 'Looking up prod %d between %s and %s\n', pnum, datestr(ep1,0), datestr(ep2,0));

% start and end times of continuous intervals
% epdata1 = [];
% epdata2 = [];

iprod = find((CDBCACHE_PRODUCT == pnum) & (CDBCACHE_SCNUM == scnum));
if isempty(iprod)
    return;
end

ep_prod = CDBCACHE_EPOCHS(iprod,:);
[ss, isort] = sort(ep_prod(:,1));
iprod = iprod(isort);
ep_prod = ep_prod(isort,:);

epdata1 = ep_prod(1,1);
epdata2 = ep_prod(1,2);
indices{1} = iprod(1);
k = 1;

for i=2:length(iprod)
    if (ep_prod(i,1) == epdata2(k))
        epdata2(k) = ep_prod(i,2);
        indices{k} = [indices{k}, iprod(i)];
    else
        k = k+1;
        epdata1(k) = ep_prod(i,1);
        epdata2(k) = ep_prod(i,2);
        indices{k} = iprod(i);
    end
end


for i=1:length(epdata1)
	%fprintf(1, 'Found interval %s and %s\n', datestr(CDBCACHE_EPOCHS(i,1),0), datestr(CDBCACHE_EPOCHS(i,2),0));

	if ((ep1 >= epdata1(i)) && (ep2 <= epdata2(i)))
%           fprintf(1, 'Got match!\n'); return;
        for k=indices{i}
            ii = find((CDBCACHE_DATA{k}.ep >= ep1) & (CDBCACHE_DATA{k}.ep <= ep2));
            ep = [ep CDBCACHE_DATA{k}.ep(ii)];
            data = [data CDBCACHE_DATA{k}.data(:,ii)];
        end
        
        if (check_dupes)
            [ep, data] = caadb_check_timetag_correctness(ep, data);
        end

        % Old code
%{
        if ~isempty(find(diff(ep) == 0))
            ibad = find(diff(ep) == 0);
            for kk=ibad
                fprintf(1,'Warning: duplicate time tag in product %s at time %s ! (removing...)\n', caadb_get_product_info(pnum), datestr(ep(kk),'dd-mmm-yyyy HH:MM:SS.FFF'));
            end
            ep(ibad) = [];
            data(:,ibad) = [];
        end
        
        if ~isempty(find(diff(ep) <= 0))
           ibad = find(diff(ep) <= 0);
           %datestr(ep(ibad(1)-10:ibad(1)+10),'dd-mmm-yyyy HH:MM:SS.FFF')
           fprintf(1,'Warning: Non-monotonous time tags in product %s around time %s ! (sorting...)\n', caadb_get_product_info(pnum), datestr(ep(ibad(1)),'dd-mmm-yyyy HH:MM:SS.FFF'));
           [ep, isort] = sort(ep);
           data = data(:,isort);
        end
%}
        
        %ii = find((ep >= ep1) & (ep <= ep2));
        %ep = ep(ii);
        %data = data(:,ii);
        metadata = CDBCACHE_DATA{indices{i}(1)}.metadata;
		break;
	end
end
%fprintf(1, 'No match\n');

