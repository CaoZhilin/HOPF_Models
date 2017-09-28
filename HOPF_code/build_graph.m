function [ affinity_matrix ] = build_graph(n_neighbors,raw_data,position_map,M)
%BUILD_GRAPH 
%   n_neighbors: interger
%        Number of neighbors to use when constructing the affinity matrix
%   raw_data:
%        The feature of each point
%   position_map:
%        The order of each point on different position.
%   M:
%        Indecate the local parameter for each vertex,the Mth closest to it
%   graph:
%        Include the vertexs and edges G = [V,E].
[num_ver feature_size] = size(raw_data);
distance_matrix = build_distance_matrix(raw_data,num_ver);
[localpar_vector,neighbor_matrix] = build_localpar_vector(distance_matrix,M,num_ver,n_neighbors);
affinity_matrix = build_affinity_matrix(distance_matrix,localpar_vector,neighbor_matrix,num_ver,n_neighbors);
%[incidence_matrix,W]= build_incidence_matrix(n_neighbors,affinity_matrix,num_ver);
%[laplacian_matrix,nl] = build_laplacian_matrix(W,num_ver);

% returns the k smallest magnitude eigenvalues
% 
% [V,D] = eigs(nl,num_ver,'sm');
% vertexes = 1:num_ver;
% edges = incidence_matrix;
end

function [incidence_matrix,W] = build_incidence_matrix(n_neighbors,affinity_matrix,num_ver)
%BUILD_AFFINITY_MATRIX
%   Use to select n_neightbors from distance matrix to build affinity
%   matrix
%   The method to varify the neighbors can be defined by the wanted number
%   of neighbors(k-nearst) or all of the neighbors.
incidence_matrix = zeros(num_ver,num_ver);
W = zeros(num_ver,num_ver);
%   K-nearest method
distance_cell = cell(num_ver);
for i = 1:num_ver
    for j = 1:num_ver
        distance_cell{i,j} = [affinity_matrix(i,j),i,j];
    end
end
for i = 1:num_ver
    target_row = [{distance_cell{i,:}}];
    %%%%
    row_cell = cell(3,num_ver);
    for k = 1:num_ver
        for j = 1:3
            row_cell{j,k} = target_row{1,k}(1,j);
        end
    end
    % The neighbors are the index of top K nearest points.
    [~,idx] = sort([row_cell{1,:}], 'descend');
    result = row_cell(:,idx);
    for l = 1:n_neighbors
        incidence_matrix(result{2,l},result{3,l}) = 1;
        W(result{2,l},result{3,l}) = affinity_matrix(result{2,l},result{3,l});
    end
        
end
end

%function [neighbors_matrix] = nearest_K_neighbors( distance_map,n_neighbors,num_ver )  
% distance_map: 
%        
% n_neighbors:
%
% distance_cell:
%    include the distance and the points number
%
% The distance is the Euclid Distance.
% distance_cell = cell(num_ver);
% neighbors_matrix = zeros(num_ver,n_neighbors);
% for i = 1:num_ver
%     for j = 1:num_ver
%         distance_cell{i,j} = [distance_matrix(i,j),i,j];
%     end
% end
% for i = 1:num_ver
%     target_row = [{distance_cell{i,:}}];
%     row_cell = zeros(3,num_ver);
%     for k = 1:num_ver
%         for j = 1:3
%             row_cell{j,k} = target_row{1,k}(1,j);
%         end
%     end
%     [trash idx] = sort([row_cell{1,:}], 'descend');
%     result = row_cell(:,idx);
%     for l = 1:n_neighbors
%         
% end
% dist_array = sum(dist_mat);  
% [dists, neighbors] = sort(dist_array);  
% % The neighbors are the index of top K nearest points.  
% dists = dists(1:K);  
% neighbors = neighbors(1:K);  
%   
%end  

function [affinity_matrix] = build_affinity_matrix(data,num_ver,pos_map)
%BUILD_DISTANCE_MATRIX
% Using squared euclidean distance.
% set the parameter gamma = 1.
%gamma = 1;
%istance_matrix = zeros(num_ver,num_ver);
affinity_matrix = zeros(num_ver,num_ver);
for i = 1:num_ver
    for j = 1:num_ver
        if i <= j
            %[~,indx]=ismember([i,j],pos_map,'rows');
            distance_matrix(i,j) = sum((data(i,:)-data(j,:)).^2);
           % affinity_matrix(i,j) = exp(-sum((data(i,:)-data(j,:)).^2)/);
        else
            distance_matrix(i,j) = distance_matrix(j,i);
            affinity_matrix(i,j) = exp(-sum((data(i,:)-data(j,:)).^2));
        end
        if affinity_matrix(i,j) == 1
            affinity_matrix(i,j) = 0;
        end
    end
end
d_mean = mean(sum(affinity_matrix));
affinity_matrix = affinity_matrix / d_mean;
end

function [laplacian_matrix,nl] = build_laplacian_matrix(W,num_ver)
%BUILD_LAPLACIAN_MATRIX
%  Build normalized Laplacian Matrix from affinity matrix W
%  Input : 
%    affinity_matrix : 
%    data : Raw input data.
%    num_ver: The number of vertexes.

% normalized laplacian
% set diagonal to zero
%laplacian_matrix = laplacian_matrix - diag(diag(laplacian_matrix));

% compute the degree matrix
D = zeros(num_ver,num_ver);
for i=1:num_ver
    D(i,i) = sum(W(i,:));
end
laplacian_matrix = D - W;
% compute the normalized laplacian / affinity matrix (method 1)
% NL1 = D^(-1/2) .* L .* D^(-1/2);
% NL1 = zeros(size(W,1),size(W,2));
% for i=1:size(W,1)
%     for j=1:size(W,2)
%         NL1(i,j) = W(i,j) / (sqrt(D(i,i)) * sqrt(D(j,j)));  
%     end
% end

%compute the normalized laplacian (method 2)  eye command is used to
% obtain the identity matrix of size m x n
%NL = eye(size(affinity,1),size(affinity,2)) - (D^(-1/2) . affinity . D^(-1/2));
% determine the normalized Laplacian nL
nl = (full(D)^(-.5))*laplacian_matrix*(full(D)^(-.5));

end
