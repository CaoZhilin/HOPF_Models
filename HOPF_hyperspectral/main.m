%-------------------------------------------------
% Matlab code for phase field modeling 
% Author: Zhilin Cao <zhilin.cao@foxmail.com>, THU
% There are currently no liceses.
%-------------------------------------------------
% Description:
%   Phase field modeling's application in image 
% segmentation.
%-------------------------------------------------

%define the image size
ni = 144;
nj = 140;

%define the number of different kinds
K = 4;
[num_ver,~] = size(data);

%define the width of diffuse interface
eta = 0;
%define the neighbor number of the graph
n_neighbors = 5;
M = 7;

%the energy function of the form
% E(u)=GL(u) + lambda¡¤F(u£¬u0)

%Step1:load the data and groundtruth
%loaddata
[ ground_truth,raw_data,position_map ] = load_data( gt, data, pos_map );

%Step2:bulid the graph's symmetric Laplacian(and its eigenvectors)
nl = build_graph_sym_lap(n_neighbors,raw_data,M);
[V,D] = eig(nl);
disp('--finish calculate V,D--');

%generate mu_matrix and u_hat
[ mu_matrix ] = generate_mu_matrix( num_ver,gt_select_5,mu );
[u_hat] = generate_u_hat(num_ver,K,gt_select_5);

%Step4:get result
[u_n_1] = multiclass_GL_approach(gt_select_5,D,V,mu_matrix,u_hat,1,50,1,K,num_ver,10^-5,500,ground_truth);

%Step5:calculate precision
%[total_precision,each_precision] = calculate_precision(u_n_1,gt,K,num_ver);