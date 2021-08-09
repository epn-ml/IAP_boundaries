function out = struct_field_join(str1, str2)

% out = struct_field_join(str1, str2)
% 
% Generic function to reduce each field of a structure of length <length> 
% using a given set of indices. 
% Operates on the last dimension
%
% Parameter len can be omitted, empty or zero to peform the reduction
% for all fields.
%
% V0.1 JS 05 Feb 2014

flds = fieldnames(str1);
out = str1;

for i=1:length(flds)
    field_name = flds{i};
    sz = size(str1.(field_name));
    if ((length(sz) == 2) || (length(sz) == 3))
        fprintf(1,"%s\n", field_name);        
        out.(field_name) = cat(length(sz),str1.(field_name),str2.(field_name));
    end    
end
