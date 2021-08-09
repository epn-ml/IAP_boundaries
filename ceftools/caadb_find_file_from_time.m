function [status, finfo] = caadb_find_file_from_time(ep, product, sc)

% [status, finfo] = caadb_find_file_from_time(ep, product, sc)
%
% CAADB internal function. Finds data file for <product>, which contains data
% for time-tag <ep>
%
% Return values:
% status : 0 - no file found
%		   1 - single file found
%
% V0.2 JS May 5, 2009 (simplified, removed 2 sec margin)

%caa_data_paths;
global caapath_matdata;

[prod_str, prod_num, prod_rpath, multisc] = caadb_get_product_info(product);
if (multisc)
	mask = sprintf('c%d_%s__*.mat', sc, prod_str);
else
	mask = sprintf('%s__*.mat', prod_str);
end

dd = dir(fullfile(caapath_matdata, prod_rpath, mask));

curver = -1;
finfo  = [];
status = 0;

for i=1:length(dd)
	if (multisc)
		nums = sscanf(dd(i).name, ['c', num2str(sc), '_', prod_str, '__%d_%d_%d_%d_V%d.mat']);	
	else
		nums = sscanf(dd(i).name, [prod_str, '__%d_%d_%d_%d_V%d.mat']);	
    end
    
	ep1 = caadb_parse_datetime(nums(1), nums(2));
	ep2 = caadb_parse_datetime(nums(3), nums(4));
	ver = nums(5);
    
    %datestr(ep1)
    %datestr(ep2)

	if ((ep < ep2) && (ep >= ep1) && (ver > curver))
	% found file
		finfo.fname	   = dd(i).name;
		finfo.ep_start = ep1;
		finfo.ep_end   = ep2;
		finfo.version  = ver;
		status = 1;
	end
end

if (status > 0)
	finfo.path = fullfile(caapath_matdata, prod_rpath);
end

function ep = caadb_parse_datetime(dnum, tnum)

	yy1  = floor(dnum/10000);
	rem  = mod(dnum,10000);
	mm1  = floor(rem/100);
	dd1  = mod(rem,100);
	ep1 = datenum(yy1, mm1, dd1);

	hh1  = floor(tnum/10000);
	rem  = mod(tnum,10000);
	mi1  = floor(rem/100);
	ss1  = mod(rem,100);
	ep = datenum(yy1, mm1, dd1, hh1, mi1, ss1);
