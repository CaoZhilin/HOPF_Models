function [ nl,W,Dist ] = build_gaussian_similarity_sys_lap( raw_data,delta,n_neighbors,M )
%BUILD_GAUSSIAN_SIMILARITY_SYS_LAP 此处显示有关此函数的摘要
%   此处显示详细说明
[num_ver,~] = size(raw_data);
[W,Dist] = build_weight_matrix(raw_data,num_ver,delta);
[~,neibor_matrix] = build_localpar_vector(W,M,num_ver,n_neighbors,'des');
W = build_nearest_neighbors(W,neibor_matrix,num_ver,n_neighbors);
D = zeros(num_ver,num_ver);
for i=1:num_ver
    D(i,i) = sum(W(i,:));
end
laplacian_matrix = D - W;

%compute the normalized laplacian (method 2)  eye command is used to
% obtain the identity matrix of size m x n
%NL = eye(size(affinity,1),size(affinity,2)) - (D^(-1/2) . affinity . D^(-1/2));
% determine the normalized Laplacian nL
nl = (D^(-.5))*laplacian_matrix*(D^(-.5));
end

