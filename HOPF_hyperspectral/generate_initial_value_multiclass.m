function [ u_init ] = generate_initial_value_multiclass( num_ver,K)
%GENERATE_INITIAL_VALUE_MULTICLASS
%     Parameters
%     -----------
%     K : 
%         number of possible classes
%     num_ver : 
%         number fo vectexes
%     fidelity_vector:
%         if the vertex is a fidelity element, the value will > 0
% -------------------------------------------------------------------
u_init = randi([1,1],num_ver,K);

% get the intial matrix to be Gibbs simplex
for i = 1:num_ver
    u_init(i,:) = project_to_simplex(u_init(i,:));
end

end