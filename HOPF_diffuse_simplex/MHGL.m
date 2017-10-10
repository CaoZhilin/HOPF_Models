function [F,Lap] = MHL(H,W,Y,mPara)
%% Multiple hypergraph learning with hypergraph weight learning


%% parameter setting
nMod = size(H,1); % number of modalities or distance matrices
nObject = size(H{1,1},1); % number of objects in the learning process
nEdge = size(H{1,1},2); % number of hyperedges for each hypergraph
IsWeight = mPara.IsWeight;% whether learn hypergraph weight
nIter = mPara.nIter;
lambda = mPara.lambda;
mu = mPara.mu;
%%%%%%%%%%%%%%%%%%

%% Initialization
hgW = ones(nMod,1); %Initialize the weight for each hypergraph as 1
F = zeros(nObject,1);
%%%%%%%%%%%%%%%%%%

if IsWeight == 0 % if weight learning is not required
    Theta = cell(nMod,1);
    Lap = cell(nMod,1);
    ThetaS = zeros(nObject);   
    for iMod = 1:nMod
           DV{iMod} = eye(nObject);
           for iObject = 1:nObject
              DV{iMod}(iObject,iObject) = sum(sum(H{iMod,1}(iObject,:).*diag(W{iMod})')); 
           end
           DE{iMod} = eye(nEdge);
           for iEdge = 1:nEdge
               DE{iMod}(iEdge,iEdge)=sum(H{iMod,1}(:,iEdge));
           end
           DV2{iMod} = DV{iMod}^(-0.5);
           INVDE{iMod} = inv(DE{iMod});
           Theta{iMod,1} = DV2{iMod}*H{iMod,1}*diag(W{iMod,1})*INVDE{iMod}*H{iMod,1}'*DV2{iMod};
           Lap{iMod,1} = eye(nObject) - Theta{iMod,1};
    end
    
    for iMod = 1:nMod
           ThetaS = ThetaS + hgW(iMod)* Theta{iMod}; 
    end    
    L2 = eye(nObject)-1/(1+lambda)*ThetaS;
    F = (lambda/(1+lambda))*L2\Y;
elseif IsWeight == 1% if weight learning is required
    flag = 1;
    for iIter = 1:nIter
        if flag == 1          
                %% update F
                Theta = cell(nMod,1);
                ThetaS = zeros(nObject);   
                for iMod = 1:nMod

                       DV{iMod} = eye(nObject);
                       for iObject = 1:nObject
                          DV{iMod}(iObject,iObject) = sum(H{iMod,1}(iObject,:).*W{iMod}'); 
                       end
                       DE{iMod} = eye(nEdge);
                       for iEdge = 1:nEdge
                           DE{iMod}(iEdge,iEdge)=sum(H{iMod,1}(:,iEdge));
                       end
                       DV2{iMod} = DV{iMod}^(-0.5);
                       INVDE{iMod} = inv(DE{iMod});
                       Theta{iMod,1} = DV2{iMod}*H{iMod,1}*diag(W{iMod})*INVDE{iMod}*H{iMod,1}'*DV2{iMod};
                end
                for iMod = 1:nMod
                       ThetaS = ThetaS + hgW(iMod)* Theta{iMod}; 
                end
                
                L2 = eye(nObject)-1/(1+lambda)*ThetaS;
                F = ((1+lambda)/lambda)*L2\Y;

                %% save current F and the previous F
                if iIter > 1
                    mF{1,1} = mF{2,1};
                    mF{2,1} = F;
                else
                    mF{2,1} = F;
                end
                
                %% update hgW
                % calculate the regularizer on each graph               
                for iMod = 1:nMod
                    Omega(iMod) = F' * (eye(nObject) - Theta{iMod}) *F;
                end
                % update hgW
                for iMod = 1:nMod
                     hgW(iMod) = 1/nMod + sum(Omega)/(2*mu*nMod) - Omega(iMod)/(2*mu);
                end

                %% calculate the cost function
                costValue(iIter,1) = sum(hgW.*Omega') + lambda*(norm(F-Y));

                if iIter > 1
                    disp(['Iteration = ' num2str(iIter) ' The cost value is ' num2str(costValue(iIter,1)) ' The cost value is reduced by ' num2str(costValue(iIter) - costValue(iIter-1))]);
                     if costValue(iIter) - costValue(iIter-1) > -0.00001 % if the cost value does not decrease again, stop the iteration
                         flag = 0;
                         disp(['Iteration stops after ' num2str(iIter-1) ' round.']);
                         F = mF{1,1};
                         bar(hgW);
                     end
                 else                     
                     disp(['Iteration = ' num2str(iIter) ' The cost value is ' num2str(costValue(iIter,1))]);
                 end
        end       
    end
end