function [ e_k,b ] = nearest_e( K,input )
%NEAREST_E 此处显示有关此函数的摘要

distance = zeros(1,K);
E = eye(K);
for i = 1:K
    distance(i) = norm((input-E(i,:)));
end
[~,b] = min(distance);
e_k = zeros(1,K);
e_k(b) = 1;
end

