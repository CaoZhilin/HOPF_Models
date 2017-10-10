function [ affinity_matrix ] = build_affinity_matrix( distance_matrix,localpar_vector,num_ver )
%BUILD_AFFINITY_MATRIX 此处显示有关此函数的摘要
%   set the parameter gamma = 1.
% affinity_matrix = zeros(num_ver,num_ver);
% for i = 1:num_ver
%     for j = 1:n_neighbors
%         %[~,indx]=ismember([i,j],pos_map,'rows');
%         %flag = ~isempty(find(neighbor_matrix(i,:)==j));
%         nei = neighbor_matrix(i,j);
%         affinity_matrix(i,nei) = exp(-distance_matrix(i,nei)/sqrt(localpar_vector(i)*localpar_vector(nei)));
%     end
% end
% end

affinity_matrix = zeros(num_ver,num_ver);
for i = 1:num_ver
    for j = 1:num_ver
        affinity_matrix(i,j) = exp(-distance_matrix(i,j)/sqrt(localpar_vector(i)*localpar_vector(j)));
    end
end
end

