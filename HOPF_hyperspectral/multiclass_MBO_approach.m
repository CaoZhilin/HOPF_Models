function [ u_n_1,difference,precision ] = multiclass_MBO_approach(mu,mu_matrix,dt,num_ver,Ns,K,u_hat,fidelity_gt,E,D,maxiter,tol,gt )
%MULTICLASS_MBO_APPROACH
% num_ver = Nd

%generate mu matrix
%[mu_matrix] = generate_mu_matrix( num_ver,fidelity_gt,mu );

u_init = generate_initial_value_multiclass(num_ver,K);
[length,~] = size(fidelity_gt);
for i = 1:length
    u_init(fidelity_gt(i,1),:)=u_hat(fidelity_gt(i,1),:);
end 
Y = (eye(num_ver) + dt/Ns*E)^(-1)*D';
n = 1;
u_n = u_init;
u_n_1= u_n;
iteration_difference = 1:num_ver;%delta = eye(K);
new_length = 1:num_ver;
% max_diffirence = 1;
% diffuse_difference = 1;
total_difference = 1;
%filename = ['C:\Users\DELL\Desktop\results\dt_' num2str(dt) '_mu_' num2str(mu) '.xlsx'];
while  ( n < maxiter && total_difference > tol )
    u_n = u_n_1;
    %disp(['--iteration round:',num2str(n)]);
    diffuse_difference = zeros(Ns,1);
    %dt = dt/(10);
    for i = 1:Ns
        u_n_0 = u_n_1;
        Z = Y*(u_n_0 - dt/Ns*mu_matrix*(u_n_0 - u_hat));
        u_n_1 = D*Z;
        
        diffuse_difference(i) = sum(sum(abs((u_n_0-u_n_1))));
        %disp(['--diffuse_difference:',num2str(diffuse_difference)]);
    end
    for i = 1:num_ver
        u_n_1(i,:) = project_to_simplex(u_n_1(i,:));
        [u_n_1(i,:),~] = nearest_e(K,u_n_1(i,:));
    end
   
    for j = 1:num_ver
        iteration_difference(j) = norm(u_n_1(j,:)-u_n(j,:))^2;
        new_length(j) = norm(u_n_1(j,:))^2;
    end
    max_difference = max(iteration_difference)/max(new_length);
    %disp(['--max:',num2str(max_difference)]);
    total_difference = sum(sum(abs((u_n_1-u_n))));
    %disp(['--total diffirence:',num2str(total_difference)]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [total_precision,each_precision] = calculate_precision(u_n_1,gt,K,num_ver,fidelity_gt);
    difference{n,1} = diffuse_difference;
    difference{n,2} = max_difference;
    difference{n,3} = total_difference;
    precision{n,1}=total_precision;
    precision{n,2}=each_precision;
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    n = n+1;
%     xlswrite(filename,max_diffirence,1,['B' num2str(n)]);
%     xlswrite(filename,total_diffirence,1,['C' num2str(n)]);
%     xlswrite(filename,total_precision,1,['D' num2str(n)]);
%     for i = 1:K
%         xlswrite(filename,each_precision(i),1,[char(68+i) num2str(n)]);
%     end
end
end


