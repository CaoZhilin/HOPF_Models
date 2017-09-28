function [ fid ] = generate_fid( gt,K,num_ver)
%GENERATE_FID 
%   use ground truth to generate certain persentage fidelity elements
%%%%%%%%%%%%%%%%%%%%%%%
% [length,~] = size(gt);
% n = ceil(length * persent);
% vertex_list = sort(randperm(length, n));
% fid = zeros(n,2);
% fid(:,1) = vertex_list';
% for i = 1:n
%     fid(i,2) = gt(fid(i,1));
% end
%%%%%%%%%%%%%%%%%%%%%%%
%length = 40;
%fid_each_10(11:20,1) = sort(randperm(730,10)+ 1005);
class_quantity = zeros(1,K);
class_fide_num = zeros(1,K);
class_base = zeros(1,K);

for i = 1:K
    class_quantity(i) = sum(gt == i);
end

for i = 1:K
    class_base(i) = sum(class_quantity(1:i-1));
end

fid = cell(1,1);
for i = 1:1
    fid{i,1} = cell(1,10);
end
m = 1;
for persent=[0.05]% 0.1:0.1:0.9]
    for i = 1:10
        fid_array = [];
        for j = 1:K
            class_fide_num(j) = ceil(class_quantity(j) * persent);
            fid_array = [fid_array sort(class_base(j) + randperm(class_quantity(j) ,class_fide_num(j)))];
        end
        fid_logical = zeros(1,num_ver);
        [~,length] = size(fid_array);
        for l = 1:length
            fid_logical(fid_array(l)) = 1;
        end
        fid{m,1}{1,i} = fid_logical;
    end
    m = m+1;
end
end

