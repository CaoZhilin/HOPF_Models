function [distance_matrix] = build_distance_matrix(data,num_ver)
%BUILD_DISTANCE_MATRIX
distance_matrix = zeros(num_ver,num_ver);
for i = 1:num_ver
    for j = 1:num_ver
        if i <= j
            distance_matrix(i,j) = sum((data(i,:)-data(j,:)).^2);
         elseif i > j
             distance_matrix(i,j) = distance_matrix(j,i);
        end
    end
end
end
