function [ u_hat ] = generate_u_hat( num_ver,K,gt )
%GENERATE_U_HAT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
u_hat = zeros(num_ver,K);
[length,~] = size(gt);
for i = 1:length
    u_hat(gt(i,1),gt(i,2)) = 1;
end
end

