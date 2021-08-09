function out = struct_field_subset(str, idx, len)

% out = struct_reduce(str, idx, len)
% 
% Generic function to reduce each field of a structure of length <length> 
% using a given set of indices. 
% Operates on the last dimension
%
% Parameter len can be omitted, empty or zero to peform the reduction
% for all fields.
%
% V0.1 JS 05 Feb 2014

flds = fieldnames(str);
out = str;

for i=1:length(flds)
    field_name = flds{i};
    value = str.(field_name);
    sz = size(value);
    if (length(sz) == 2)
        if ((len == 0) || (sz(2) == len))
            out.(field_name) = value(:,idx);
        end
    elseif (length(sz) == 3)
        if ((len == 0) || (sz(3) == len))
            out.(field_name) = value(:,:,idx);
        end
    end
end
