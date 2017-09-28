function [ weight_matrix,D ] = build_weight_matrix( data,num_ver,prob )
%BUILD_WEIGHT_MATRIX 此处显示有关此函数的摘要
%   此处显示详细说明
% the parameter for probabilistic incidence matrix (exp(-d^2/sigma^2))
% usually set as 0.05 or 0.1
weight_matrix = zeros(num_ver,num_ver);
for i = 1:num_ver
    for j = 1:num_ver
        if i <= j
            %weight_matrix(i,j) = exp(-sum((data(i,:)-data(j,:)).^2)/(delta^2));
            weight_matrix(i,j) = norm(data(i,:)-data(j,:));
        elseif i > j
            weight_matrix(i,j) = weight_matrix(j,i);
        end
    end
end
D = weight_matrix;
aveDist = mean(mean(weight_matrix));
for i = 1:num_ver
    for j = 1:num_ver
        if i <= j
            weight_matrix(i,j) = exp(-(weight_matrix(i,j))^2/(prob*aveDist)^2);
        elseif i > j
            weight_matrix(i,j) = weight_matrix(j,i);
        end
    end
end
aveWeig =  mean(mean(weight_matrix));
for i = 1:num_ver
    for j = 1:num_ver
        if weight_matrix(i,j) < aveWeig
            weight_matrix(i,j) = 0;
        elseif i > j
            weight_matrix(i,j) = weight_matrix(j,i);
        end
    end
end
end


