function aa = vectang_acute(v1, v2)

% aa = vectang(v1, v2)
% 
% Returns acute angle between vectors v1 and v2 in degrees (between 0 and 90)
% Calls vectang and if ang > 90 it is changed to 180-ang.
%
% Input can be:
%  1) v1 & v2 both column or row vectors
%  2) v1 & v2 N-D arrays of identical dimensions (scalar product taken over 1st dim)
%  3) v1 NxM array, v2 Nx1 column vector - returns 1xM array of angles between v1(:,i) and v2

aa = vectang(v1,v2);
ii = find(aa > 90);
aa(ii) = 180 - aa(ii);

