function aa = vectang(v1, v2)

% aa = vectang(v1, v2)
% 
% Returns angle between vectors v1 and v2 in degrees (between 0 and 180)
% Input can be:
%  1) v1 & v2 both column or row vectors
%  2) v1 & v2 N-D arrays of identical dimensions (scalar product taken over 1st dim)
%  3) v1 NxM array, v2 Nx1 column vector - returns 1xM array of angles between v1(:,i) and v2
%
%  V0.2 JS 7/12/2010 - optimized for large vector arrays

if (size(v1) == size(v2))
	aa = 180*(acos(dot(v1,v2)./sqrt(sum(v1.*v1).*sum(v2.*v2)))/pi);
elseif ((size(v1,1) == size(v2,1)) && (size(v2,2) == 1))
    bb = repmat(v2,1,size(v1,2));
    aa = 180*(acos(dot(v1,bb)./sqrt(sum(v1.^2).*sum(bb.*bb)))/pi);
	%nvec = size(v1,2);
	%aa = zeros(1,nvec);
	%for i=1:nvec
    %	aa(i) = 180*(acos(dot(v1(:,i),v2)./sqrt(sum(v1(:,i).^2).*sum(v2.*v2)))/pi);%
	%end
else
    whos
	error('Incompatible dimensions of inputs');
end




