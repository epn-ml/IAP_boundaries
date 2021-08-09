function [ep_st, ep_end, mode] = caadb_get_cluster_mode(ep0, tlen, scn)

%[ep_st, ep_end, mode] = caadb_get_cluster_mode(ep0, tlen, scn)
%
% Returns intevals of Cluster modes:
%  ep_st, ep_end - start and end time of an interval
%  mode: 0=off,1=NM1,2=NM2,...,11=BM1,12=BM2,13=BM3

%caa_data_paths;
global caapath_matdata;

global CAADB_GLOBAL_TMMODES;

if isempty(CAADB_GLOBAL_TMMODES)
    fname = fullfile(caapath_matdata, 'cluster/cluster_telemetry_modes.mat');
    fprintf(1, 'Loading: %s\n', fname);
    load(fname);
    CAADB_GLOBAL_TMMODES = cell(4,1);
    CAADB_GLOBAL_TMMODES{1} = tmmode_sc1;
    CAADB_GLOBAL_TMMODES{2} = tmmode_sc2;
    CAADB_GLOBAL_TMMODES{3} = tmmode_sc3;
    CAADB_GLOBAL_TMMODES{4} = tmmode_sc4;
end

tmmodes = CAADB_GLOBAL_TMMODES{scn};

ii = find(tmmodes(:,1) <= ep0);
if isempty(ii)
    ep = [];
    mode = [];
    return;
end
i0 = ii(end);
ii = find(tmmodes(:,2) >= ep0 + tlen/86400);
if isempty(ii)
    ep = [];
    mode = [];
    return;
end
i1 = ii(1);

ep_st  = tmmodes(i0:i1,1);
ep_end = tmmodes(i0:i1,2);
mode   = tmmodes(i0:i1,3);

%ii = i0:i1;
%ep   = [tmmodes(ii,1); tmmodes(ii(end),2)];
%mode = [tmmodes(ii,3); tmmodes(ii(end),3)];



