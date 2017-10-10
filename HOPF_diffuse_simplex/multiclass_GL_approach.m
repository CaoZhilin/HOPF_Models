function [u_n_1 ] = multiclass_GL_approach(fidelity_gt,eigen_vectors,eigen_values,mu_matrix,u_hat,eps,mu,dt,K,num_ver,tol,maxiter,gt)
%MULTICLASS_GL_APPROACH 
% Multiclass Ginzburg Landau with fidelity using eigenvectors
%     Parameters
%     -----------
%     eigen_vectors : 
%         ndarray, shape (n_samples, Neig)
%         collection of smallest eigenvectors
%     eigen_values : 
%         ndarray, shape (n_samples, 1)
%         collection of smallest eigenvalues
%     mu_matrix:
%         vector(num_ver)
%         indecate whether the vertex is a fidelity element       
%     u_hat:
%         matrix(num_ver,K)
%         prior_knowledge,indicate prior class knowledge of each sample
%     eps : scalar = 1, 
%         diffuse interface parameter
%     mu_matrix : scalar = 1,
%         strength of fidelity(is a diagonal matrix)
%     delta:
%         a diagonal matrix for Kronecker delta
%     fid : ndarray, shape(num_fidelity, 2)
%         index and label of the fidelity points. fid[i,0] 
%     tol : scalar = 1e-5, 
%         stopping criterion for iteration
%     maxiter : int 500, 
%         maximum number of iterations
%     u_init : ndarray, shape (n_samples ,1)
%         initial u_0 for the iterations
%     E: shape(K,K)
%         a matrix of unit vectors          
% performing the Main GL iteration with fidelity
%---------------------------------------------------------

u_init = generate_initial_value_multiclass(num_ver,K);
% keep the fidelity elements
[length,~] = size(fidelity_gt);
for i = 1:length
    u_init(fidelity_gt(i,1),:)=u_hat(fidelity_gt(i,1),:);
end 
% set the iteration number
n = 1;
max_diffirence = 1;
T = zeros(num_ver,K);
u_n = u_init;
u_n_1 = u_n;
E = eye(K);
iteration_diffirence = 1:num_ver;%delta = eye(K);
new_length = 1:num_ver;
C = mu + 1/eps;
Y = ((1 + C*dt) * eye(num_ver) + eps*dt*eigen_values)^(-1)*(eigen_vectors)'; 
%disp(['Y-value:',]);
while ( n<maxiter && max_diffirence > tol )
    disp(['--round',num2str(n),':']);
    u_n = u_n_1;
    T = zeros(num_ver,K);
    for i = 1:num_ver
        %disp(['i:',num2str(i)]);
        u= u_n(i,:);
        for k = sym(1:K)
            for l = sym(1:K)
               sum_part = 0.5*(1-2*kroneckerDelta(k,l) * sum(abs(u- E(l,:))));
               prod_part = 1;
               for m = 1:K
                   if m ~= l
                       prod_part = prod_part * 0.25 * (sum(abs(u-E(m,:))))^2;
                   end
               end
               T(i,k) = T(i,k)+sum_part * prod_part;
            end
%             syms l m;
%                   
%             T(i,k) = symsum((0.5*(1-2*kroneckerDelta(k,l)) * sum(abs(u_n(i,:)- E(l,:)))...
%                 *symprod((0.25*(sum(abs(u_n(i,:)-E(m,:))))^2),m,1,l-1)...            
%                 *symprod((0.25*(sum(abs(u_n(i,:)-E(m,:))))^2),m,l+1,K)),l,1,K);
        end
    end
    Z = Y * ((1+C*dt)*u_n - dt/(2*eps)*T - dt*mu_matrix*(u_n-u_hat));
    u_n_1 = eigen_vectors*Z;
    for i = 1:num_ver
        u_n_1(i,:) = project_to_simplex(u_n_1(i,:));
    end
    n = n+1;
    for j = 1:num_ver
        iteration_diffirence(j) = norm(u_n_1(j,:)-u_n(j,:))^2;
        new_length(j) = norm(u_n_1(j,:))^2;
    end
    max_diffirence = max(iteration_diffirence)/max(new_length);
    disp(['--max:',num2str(max_diffirence)]); 
    total_diffirence = sum(sum(abs((u_n_1-u_n))));
    disp(['--total diffirence:',num2str(total_diffirence)]);
    [~,~] = calculate_precision(u_n_1,gt,K,num_ver);
end
end




