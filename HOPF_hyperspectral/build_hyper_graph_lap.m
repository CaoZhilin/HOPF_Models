
%% simulation distance matrices
mDist{1,1} = distance_matrix;
%mDist{2,1} = rand(100,100);
%%%%%%%%%%%%%%%%

%% parameter settings
mPara.mDist = mDist;
% n*1 cell, the distance matrix for all samples

mPara.IS_ProH = 1;
% IS_ProH is to determine whether the hypergraph incidence matrix is constructed probabilistically
% 1: the entry of H is a probability,    2: the entry of H is 1 or 0.
% Generally, IS_ProH = 1 works better.

mPara.mProb = 0.2;%0.05;
% The parameter for probabilistic incidence matrix (exp(-d^2/sigma^2), sigma = mPro.aveDist)
% It is usually set as 0.05 or 0.1

mPara.GraphType = 1;
% The neighbor selection method
% 1: star expansion using mStarExp   2: distance-based using mRatio

mPara.mStarExp = 15; 
% The number of star expansion
% It can be set as 5, 10, 20, or other numbers

mPara.mRatio = 0.8;
% The ratio of average distance to select neighbor
% It is set as 0.1 or 1. We need to check the incidence matrix H to determine it

mPara.IsWeight = 0;
% Whether learn the hypergraph weight during learning process
% 1: learn  0:no-learn

mPara.lambda = 100;
% The parameter on empirical loss in hypergraph learning
% lambda may range from 10e0 to 10e4

mPara.mu = 100;
% The parameter on the hypergraph weight in hypergraph learning
% mu may range from 10e-2 to 10e4

mPara.nIter = 100;
% The maximal iteration times for learning
% The iteration may stop in no more than 20 rounds.

%% Initialize Y
nObject = size(mDist{1,1},1); % number of objects in the learning process
Y = zeros(nObject,1);
Y(1,1) = 1;% the query is set as 1
%%%%%%%%%%%%%%%%%

%% The main procedures
[H W] = MHGConstruction(mPara);
%[~,Lap] = MHGL(H,W,Y,mPara);

mDist = mPara.mDist;
IS_ProH = mPara.IS_ProH;
mStarExp = mPara.mStarExp; % The number of star expansion
mRatio = mPara.mRatio;
mProb = mPara.mProb;
nMod = size(mDist,1); % The number of modalities or distance matrices
nObject = size(mDist{1,1},1); % The number of objects in the learning process
nEdge = nObject;
Lap = cell(nMod,1);
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

% F is the to-be-learned relevance vector