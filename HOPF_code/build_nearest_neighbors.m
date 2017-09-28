function [ nearest_neighbors ] = build_nearest_neighbors( affinity_matrix,neighbor_matrix,num_ver,n_neighbors )
%BUILD_NEAREST_NEIGHBORS 此处显示有关此函数的摘要
%   此处显示详细说明
nearest_neighbors = zeros(num_ver,num_ver);
 for i = 1:num_ver
     for j = 1:n_neighbors
         %[~,indx]=ismember([i,j],pos_map,'rows');
         %flag = ~isempty(find(neighbor_matrix(i,:)==j));
         nei = neighbor_matrix(i,j);
         nearest_neighbors(i,nei) = affinity_matrix(i,nei); %exp(-distance_matrix(i,nei)/sqrt(localpar_vector(i)*localpar_vector(nei)));
     end
 end
 
 for i = 1:num_ver
     for j = 1:num_ver
         if nearest_neighbors(i,j) ~= nearest_neighbors(j,i)
             if nearest_neighbors(i,j) ~= 0
                nearest_neighbors(j,i) = nearest_neighbors(i,j);
             else
                nearest_neighbors(i,j) = nearest_neighbors(j,i);
             end
         end
     end
 end

end

