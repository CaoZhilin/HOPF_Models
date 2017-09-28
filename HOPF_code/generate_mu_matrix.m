function [ mu_matrix ] = generate_mu_matrix( num_ver,gt,mu )
%GENERATE_MU_MATRIX 

mu_matrix = zeros(num_ver);
[length,~] = size(gt);
for i = 1:length
    ele = gt(i,1);
    mu_matrix(ele,ele) = mu;
end
end

