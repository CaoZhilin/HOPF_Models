%% -------------------------------------------------
% Matlab code for phase field modeling 
% Author: Zhilin Cao <zhilin.cao@foxmail.com>, THU
% There are currently no liceses.
%-------------------------------------------------
% Description:
%   Phase field modeling's application in image 
% segmentation.
%-------------------------------------------------
%the energy function of the form
% E(u)=GL(u) + lambda¡¤F(u£¬u0)

%% parameter settings
% define the number of vertexes
num_ver = 2021;

% define the number of different kinds
K = 67;

% define the neighbor number of the graph 
n_neighbors = 5;

% M parametrize a local value for each vertex
% the Mth closest vertex to vertex i
M = 7;

% eigVectors = eigVe;
% eigValues = eigVa;

%% 
flag = 1;
for n_neighbors = 20
    for M = 10
        % build graph laplacian and eigen vectors & values
        %[eigVectors,eigValues] = eig(Lap{1,1});
        %eig_filename = ['C:\Users\DELL\Desktop\data\NTU_H\new_n_',num2str(n_neighbors),'_M_',num2str(M),'.mat'];
        %save(eig_filename,'eigVectors','eigValues');
        
        % multiclass segmentation
        disp(['--n_neighbors:',num2str(n_neighbors),' --M:',num2str(M)]);
        for mu = [1] %100 200 400 500] %200:50:500 600:100:900 1000:200:5000]
            for dt = [2] %[0.0005 0.001 0.005 0.01 0.05 0.1 0.5 1 ]%0.01:0.02:0.09 0.1:0.1:1 1:1:10]
                for Ns = 3
                    
                    for fid_num = 1:10
                        disp(['--mu:',num2str(mu),' --dt:',num2str(dt),' --Ns:',num2str(Ns),' --fid_num',num2str(fid_num)]);
                        % fidelity persent from 5% to 90%
                        totalp = 0;
                        fid_list = fid_all{fid_num,1};
                        for fid_round = 1:10
                             disp(['--mu:',num2str(mu),' --dt:',num2str(dt),' --Ns:',num2str(Ns),' --fid_num',num2str(fid_num),...
                                 ' --fid_round:',num2str(fid_round)]);
                            fid = fid_list{1,fid_round};
                            fid_length = sum(fid);
                            fid_gt = zeros(fid_length,2);
                            mark = 1;
                            for fid_count = 1:num_ver
                                if fid(fid_count) == 1
                                    fid_gt(mark,1) = fid_count;
                                    mark = mark+1;
                                end
                            end
                            for fid_count = 1:fid_length
                                fid_gt(fid_count,2) = gnd( fid_gt(fid_count,1));
                            end
                            mu_matrix = generate_mu_matrix(num_ver,fid_gt,mu);
                            u_hat = generate_u_hat(num_ver,K,fid_gt);
                            [u_n_1,difference,precision] = multiclass_MBO_approach(mu,mu_matrix,dt,num_ver,Ns,K,u_hat,fid_gt,eigValues,eigVectors,10,10^(-5),gnd);
                            parameter = table(n_neighbors,M,mu,dt,Ns,fid_num,fid_round);
                            filename = ['C:\Users\DELL\Desktop\results\NTU_H\n_neighbors',num2str(n_neighbors),'_M_',num2str(M),'_mu_',num2str(mu),'_dt_',num2str(dt),'_Ns_',num2str(Ns),'_fid_',num2str(fid_num),...
                                '_round_',num2str(fid_round),'.mat'];
                            save(filename,'parameter','difference','precision');
                            [precision_length,~] = size(precision);
                            totalp = totalp +precision{end,1};
                            %%
                            %disp(['--precision:' num2str(precision{end,1})]);
%                             if precision{end,1} < 0.5
%                                 flag = 0;
%                                 break;
%                             else 
%                                 flag = 1;
%                             end
                        end
                        disp(['--total_precision:' num2str(totalp/10)]);
                        %%
                        if flag == 0
                            break;
                        end
                    end
                end
            end
        end
    end
end
