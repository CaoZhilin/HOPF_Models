function [ a ] = alternating_optimize(a_init, nl, num_ver, tol,mu,dt,fid_gt,K,weight_matrix,d,groundtruth )
%ALTERNATING_OPTIMIZE multi-model of phase field method
% use u and a to alternating optimize each other 
[~,length] = size(a_init);
n = 1;
mu_matrix = generate_mu_matrix(num_ver,fid_gt,mu);
fid_length = sum(fid_gt);
fid = zeros(fid_length,2);
mark = 1;
for fid_count = 1:num_ver
    if fid_gt(fid_count) == 1
        fid(mark,1) = fid_count;
        mark = mark+1;
    end
end
for fid_count = 1:fid_length
    fid(fid_count,2) = groundtruth( fid(fid_count,1));
end
u_hat = generate_u_hat(num_ver,K,fid);
E_matrix = eye(K);
a = a_init;
beta = 100;
difference =1;
Ns = 1;
while (1)%difference < tol || n == 1)
    disp(['--round:',num2str(n)]);
    nl_combine = zeros(num_ver,num_ver);
    for i = 1:length
        nl_combine = nl_combine + a(i) * nl(:,:,i);                                                                                                                                                                                      
    end
    
     [eigVectors,eigValues] = eig(nl_combine);
    [u_n_1,~,precision] = multiclass_MBO_approach(mu,mu_matrix,dt,num_ver,Ns,K,u_hat,fid_gt,eigValues,eigVectors,100,10^(-5),groundtruth);
    disp(['precision',num2str(precision{end,1})]);
    %GL_func = zeros(num_ver,num_ver,length);
   
%     for i = 1:num_ver
%         for j = 1:num_ver
%             for l = 1:length
%                 GL_func_1(i,j) = GL_func_1(i,j) + a(l)*weight_matrix(l,i,j)*(u_n_1(i)/d(l,i)-u_n_1(j)/d(l,j))^2;
%             end
%         end
%         GL_func_2(i) = 1;
%         for j = 1:K
%             GL_func_2(i) = GL_func_2(i) * 0.25 * (sum(abs(u_n_1(i)-E(j,:))))^2;
%         end
%     end
%     GL_value = 0.5*sum(sum(GL_func_1))+0.5*sum(GL_func_2);
%     for i = 1:num_ver
%         for j = 1:num_ver
%             for l = 1:length
%                 GL_func(i,j,l) = weight_matrix(i,j,l)*(u_n_1(i)/sqrt(d(i,l))-u_n_1(j)/sqrt(d(j,l)))^2;
%             end
%         end
%     end
    GL_value = zeros(1,length);
    for i =  1:length
        GL_value(i) = trace(u_n_1'*nl(:,:,i)*u_n_1);
    end
    eps = - (2*beta  + sum(GL_value))/length;
    a_old = a;
    for i = 1:length
        a(i) = -(eps+GL_value(i))/(2*beta);
    end
    difference = norm(a_old-a);
    n=n+1;
end

end

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   