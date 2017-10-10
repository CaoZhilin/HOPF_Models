function [ nl,affinity_matrix,D] = build_graph_sym_lap(n_neighbors,M,distance_matrix,num_ver)
%BUILD_GRAPH_SYM_LAP 此处显示有关此函数的摘要
%   此处显示详细说明
% distance_matrix = build_distance_matrix(raw_data,num_ver);
% [localpar_vector,neighbor_matrix] = build_localpar_vector(distance_matrix,M,num_ver,n_neighbors);
% affinity_matrix = build_affinity_matrix(distance_matrix,localpar_vector,neighbor_matrix,num_ver,n_neighbors);
% nl = build_symmetric_laplacian(affinity_matrix,num_ver);

% [num_ver,~] = size(raw_data);
% distance_matrix = build_distance_matrix(raw_data,num_ver);
[localpar_vector,~] = build_localpar_vector(distance_matrix,M,num_ver,n_neighbors,'asc');
affinity_matrix = build_affinity_matrix(distance_matrix,localpar_vector,num_ver);
%get nearest nodes
[~,neibor_matrix] = build_localpar_vector(affinity_matrix,M,num_ver,n_neighbors,'des');
affinity_matrix = build_nearest_neighbors(affinity_matrix,neibor_matrix,num_ver,n_neighbors);
[nl,D] = build_symmetric_laplacian(affinity_matrix,num_ver);
end

