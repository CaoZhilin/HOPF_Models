function [ total_precision,each_precision ] = calculate_precision( u_n_1,gt,K,num_ver,fidelity_gt )
%CALCULATE_PRECISION 此处显示有关此函数的摘要

true = 0;
each_precision = zeros(1,K);
each_gross = zeros(1,K);
each_correct =  zeros(1,K);
for i = 1:num_ver
    [~,order] = nearest_e(K,u_n_1(i,:));
    if  ~(ismember(i,fidelity_gt(:,1)))
        if (gt(i)==order)
            true = true+1;
            each_correct(order) = each_correct(order)+1;
        end
        each_gross(gt(i)) = each_gross(gt(i))+1;
    end
end
[fid_length,~] = size(fidelity_gt);
%for i = 1:fid_length
    %true = true - 1;
    %each_gross(fidelity_gt(i,2)) =  each_gross(fidelity_gt(i,2))-1;
    %each_correct(fidelity_gt(i,2)) = each_correct(fidelity_gt(i,2))-1;
%end
total_precision = true/(num_ver-fid_length);
%disp(['--total_precision:', num2str(total_precision)]);
for i = 1:K
    each_precision(i) = each_correct(i)/each_gross(i);
    %disp(['--class_',num2str(i),'_precision:',num2str(each_precision(i))]);
end
end

