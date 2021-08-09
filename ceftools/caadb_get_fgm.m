function [ep, b_gse, range, pos] = caadb_get_fgm(ep_start, len, product, sc)

% [ep, b_gse, range, pos] = caadb_get_fgm(ep_start, len, product, sc)
%
% Function to read CAADB FGM data.
% Product is one of: 'fgm_5vps' (default), 'fgm_spin', 'fgm_full' 

if isempty(product)
    product = 'fgm_5vps';
end

[ep, dt] = caadb_get_data(ep_start, len, product, sc);
if (isempty(ep))
    b_gse = [];
    pos = [];
    range = [];
    return;
end

b_gse = dt(1:3,:);
pos = dt(4:6,:);
range = dt(7,:);
