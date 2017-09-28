function [ nl,D ] = build_symmetric_laplacian( W,num_ver)
%BUILD_SYMMETRIC_LAPLACIAN 
%  Build normalized Laplacian Matrix from affinity matrix W
%  Input : 
%    affinity_matrix : 
%    data : Raw input data.
%    num_ver: The number of vertexes.

% compute the degree matrix
D = zeros(num_ver,num_ver);
for i=1:num_ver
    D(i,i) = sum(W(i,:));
end
laplacian_matrix = D - W;

%compute the normalized laplacian (method 2)  eye command is used to
% obtain the identity matrix of size m x n
%NL = eye(size(affinity,1),size(affinity,2)) - (D^(-1/2) . affinity . D^(-1/2));
% determine the normalized Laplacian nL
nl = (full(D)^(-.5))*laplacian_matrix*(full(D)^(-.5));

end

