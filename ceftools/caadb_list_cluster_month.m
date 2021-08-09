function caadb_list_cluster_month(ep_start, nmonth)

% caadb_list_cluster_month(ep_start, nmonth)
%
% Prints a list of available Cluster + ACE data
%
% Input:
%   ep_start    - starting month (default: first month in database)
%   nmonth      - number of months to display (default: all)
%
% Changes:
%  V0.1: JS 21/10/2008 - initial version

if (~exist('ep_start'))
	ep_start = [];
end

if (~exist('nmonth'))
	nmonth = [];
end

refsc = 3;

[ep_fgm5, cov_fgm5, rat_fgm5] = caadb_list_data_month('fgm_5vps',refsc,ep_start, nmonth,1);
[ep_whi, cov_whi, rat_whi] = caadb_list_data_month('whisper_natural',refsc,ep_start, nmonth,1);
[ep_aceb, cov_aceb, rat_aceb] = caadb_list_data_month('ace_mag16s',0,ep_start, nmonth,1);
[ep_acei, cov_acei, rat_acei] = caadb_list_data_month('ace_swepam64s',0,ep_start, nmonth,1);
[ep_cisp, cov_cisp, rat_cisp] = caadb_list_data_month('cis_pp',refsc,ep_start, nmonth,1);
[ep_aux, cov_aux, rat_aux] = caadb_list_data_month('cluster_aux',refsc,ep_start, nmonth,1);

% common axis (may have gaps - FIX ?)
ep = unique([ep_fgm5 ep_aceb ep_acei ep_cisp ep_aux]); 
[tf,ifgm5] = ismember(ep, ep_fgm5);
[tf,iwhi] = ismember(ep, ep_whi);
[tf,icisp] = ismember(ep, ep_cisp);
[tf,iaux] = ismember(ep, ep_aux);
[tf,iaceb] = ismember(ep, ep_aceb);
[tf,iacei] = ismember(ep, ep_acei);

if (~exist('ep_start') || isempty(ep_start))
	fprintf(1,'Starting from first available month: %s\n', datestr(ep_start,'mmm-yyyy'));
	ep_start = min(ep);
else
	ep_start = strip_month(ep_start);
end

nmonth = length(ep);


fprintf(1,'YYYY | MMM | FGM 5vps | CIS PP | CL AUX | WHI SPC | ACE MAG16 | ACE ION64 | \n');

for k=1:nmonth
	vv = datevec(ep(k));
	if ((vv(2) == 1))
		fprintf('---------------------------\n');
	end

	if (0 == ifgm5(k))
		cv_fgm5 = ' none';
	else
		cv_fgm5 = cvrstr(cov_fgm5(ifgm5(k)), rat_fgm5(ifgm5(k)));
	end

	if (0 == icisp(k))
		cv_cisp = ' none';
	else
		cv_cisp = cvrstr(cov_cisp(icisp(k)), rat_cisp(icisp(k)));
	end

	if (0 == iaux(k))
		cv_aux = ' none';
	else
		cv_aux = cvrstr(cov_aux(iaux(k)), rat_aux(iaux(k)));
	end

	if (0 == iwhi(k))
		cv_whi = ' none';
	else
		cv_whi = cvrstr(cov_whi(iwhi(k)), rat_whi(iwhi(k)));
	end

	if (0 == iaceb(k))
		cv_aceb = ' none';
	else
		cv_aceb = cvrstr(cov_aceb(iaceb(k)), rat_aceb(iaceb(k)));
	end

	if (0 == iacei(k))
		cv_acei = ' none';
	else
		cv_acei = cvrstr(cov_acei(iacei(k)), rat_acei(iacei(k)));
	end


	fprintf(1,'%s     %s     %s    %s    %s     %s      %s\n', datestr(ep(k),'yyyy   mmm'), cv_fgm5, cv_cisp, cv_aux, cv_whi, cv_aceb, cv_acei);
end

function cs = cvrstr(cover, ratio)
	if (cover == 1)
		cs = ' full';
	elseif (cover == 0)
		cs = ' none';
	else
		cs = sprintf('%4.1f%%', 100*ratio);
	end



function ep = add_months(ep0, nmon)
	vv = datevec(ep0);
	newmon = vv(2)+nmon;
	ny = floor(newmon/12);
	if (0 == mod(newmon,12))
		ny = ny-1;% fix december	
	end
	vv(2) = vv(2) + nmon - 12*ny;
	vv(1) = vv(1) + ny;
	ep = datenum(vv);

function ep = strip_month(epin)
	vv = datevec(epin);
	vv(4:6) = 0;
	vv(3) = 1;
%	vv(6) = 1;
	ep = datenum(vv);

