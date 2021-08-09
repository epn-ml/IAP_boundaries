function vn = vnorm(vec, dim)

% vn = vnorm(vec, dim)
% Returns the euclidean norm of vector <vec> summing along dimension <dim>.
% If <dim> is not specified, function operates along the first dimension.
% JS 19/2/2007

if (exist('dim'))
	vn = sqrt(sum(abs(vec).^2,dim));
else
	vn = sqrt(sum(abs(vec).^2,1));
end
