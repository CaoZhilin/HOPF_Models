function [ localpar_vector,neighbor_matrix ] = build_localpar_vector( distance_matrix,M,num_ver,n_neighbors,direction )
%BUILD_LOCALPAR_MATRIX 
%   Use to select n_neightbors from distance matrix to build localpar
%   matrix
localpar_vector = 1:num_ver;
distance_cell = cell(num_ver);
neighbor_matrix = zeros(num_ver,n_neighbors);
for i = 1:num_ver
    for j = 1:num_ver
        distance_cell{i,j} = [distance_matrix(i,j),i,j];
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
    if direction == 'asc'
        [~,idx] = sort([row_cell{1,:}]);
    else
        [~,idx] = sort([row_cell{1,:}],'descend');
    end
    result = row_cell(:,idx);
    localpar_vector(i) = result{1,M};
    for j = 1:n_neighbors
        neighbor_matrix(i,j) = result{3,j};
    end
end
end

% function [incidence_matrix,W] = build_incidence_matrix(n_neighbors,affinity_matrix,num_ver)
% %BUILD_AFFINITY_MATRIX
% %   Use to select n_neightbors from distance matrix to build affinity
% %   matrix
% %   The method to varify the neighbors can be defined by the wantd number
% %   of neighbors(k-nearst) or all of the neighbors.
% incidence_matrix = zeros(num_ver,num_ver);
% W = zeros(num_ver,num_ver);
% %   K-nearest method
% distance_cell = cell(num_ver);
% for i = 1:num_ver
%     for j = 1:num_ver
%         distance_cell{i,j} = [affinity_matrix(i,j),i,j];
%     end
% end
% for i = 1:num_ver
%     target_row = [{distance_cell{i,:}}];
%     %%%%
%     row_cell = cell(3,num_ver);
%     for k = 1:num_ver
%         for j = 1:3
%             row_cell{j,k} = target_row{1,k}(1,j);
%         end
%     end
%     % The neighbors are the index of top K nearest points.
%     [~,idx] = sort([row_cell{1,:}], 'descend');
%     result = row_cell(:,idx);
%     for l = 1:n_neighbors
%         incidence_matrix(result{2,l},result{3,l}) = 1;
%         W(result{2,l},result{3,l}) = affinity_matrix(result{2,l},result{3,l});
%     end
%         
% end