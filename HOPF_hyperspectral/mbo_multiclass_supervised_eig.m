function [ output_args ] = mbo_multiclass_supervised_eig( V,E,fid,dt,u_init,eta,tol,Maxiter,inner_step_count )
%MBO_MULTICLASS_SUPERVISED_EIG 
%Multiclass MBO with fidelity, using eigenvectors
% Parameters
%     -----------
%     V : ndarray, shape (n_samples, Neig)
%         collection of smallest eigenv ectors
%     E : ndarray, shape (n_samples, 1)
%         collection of smallest eigenvalues
%     eta : scalar,
%         strength of fidelity
%     fid : ndarray, shape(num_fidelity, 2)
%         index and label of the fidelity points. fid[i,0] 
%     u_init : ndarray, shape(n_samples, n_class)
%         initial condition of scheme
%     dt : float
%         stepsize for scheme
%     tol : scalar, 
%         stopping criterion for iteration
%     Maxiter : int, 
%         maximum number of iterations
%     """
%     #performing the Main MBO iteration with fidelity
% Set parameters
eta = 1;
tol = .5;
Maxiter = 500;
inner_step_count = 10;
i = 0;
u_new = u_init;
u_diff = 1;
%fid_ind = fid[:,0];
%fid_vec = util.labels_to_vector(fid[:,1]);

while (i<Maxiter) && (u_diff > tol)
    u_old = u_new;
    v = u_old;
    for k = 1:inner_step_count
        w = l2_fidelity_gradient_multiclass(v,dt,fid_ind,fid_vec,eta);
        v = diffusion_step_eig(w,V,E,dt);
    end
    u_new = _mbo_forward_step_multiclass(v);
    %u_diff = (abs(u_new-u_old)).sum();
    i = i+1;
end  

end

function [  ] = l2_fidelity_gradient_multiclass(v,dt,fid_ind,fid_vec,eta)

end

function [] = initalize_u(num_ver)