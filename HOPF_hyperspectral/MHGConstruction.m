function [H W] = MHGConstruction(mPara)
%% this function is to construct multiple hypergraphs

%%parameter setting
mDist = mPara.mDist;
IS_ProH = mPara.IS_ProH;
mStarExp = mPara.mStarExp; % The number of star expansion
mRatio = mPara.mRatio;
mProb = mPara.mProb;
nMod = size(mDist,1); % The number of modalities or distance matrices
nObject = size(mDist{1,1},1); % The number of objects in the learning process
nEdge = nObject; % The number of hyperedges for each hypergraph
% It is noted that the number of edges nEdge can be different from nObject, which
% is determined by the way of hyperedge generation.
%%%%%%%%%%%%%%%%%

H = cell(nMod,1); % the incidence matrices for all modalities
for iMod = 1:nMod
    H{iMod,1} = zeros(nObject,nEdge);% initialize H{iMod,1}
    W{iMod,1} = ones(nEdge,1);
    distM = sqrt(mDist{iMod,1}); % the distance marix in current modality
    aveDist = mean(mean(distM)); %zeros(nObject,1);%mean(mean(distM));%zeros(nObject,1); %zeros(nObject,1)% =mean(mean(distM));% the mean distancein current modaltiy
%     aveDist = zeros(nObject,1);
%     for i = 1:nObject
%         neiList = sort(distM(i,:));
%         aveDist(i) = neiList(10);%mean(distM(i,:));%neiList(20);
%     end
    for iObject = 1:nObject
                vDist = distM(:,iObject)';
                [values orders] = sort(vDist,'ascend');
                if mPara.GraphType == 1% star expansion
                        orders2 = orders(1:mStarExp);
                        if isempty(find(orders2==iObject))
                            values(mStarExp)=0;
                            orders(mStarExp)=iObject;
                        end
                        iEdge = iObject;
                        for iNeighbor = 1:mStarExp
                                if IS_ProH == 0 % if it is not pro H
                                    H{iMod,1}(orders(iNeighbor),iEdge) = 1;
                                else
                                    H{iMod,1}(orders(iNeighbor),iEdge)  = exp(-(values(iNeighbor))^2/(mProb*aveDist)^2);%(aveDist(iObject)*aveDist(iObject))); %exp(-values(iNeighbor)^2/(mProb*aveDist)^2);%exp(-values(iNeighbor)/(aveDist(iObject)*aveDist(orders(iNeighbor))));%exp(-values(iNeighbor)^2/(mProb*aveDist)^2);(aveDist(iObject)*aveDist(orders(iNeighbor))));
                                end
                        end
                elseif mPara.GraphType == 2% distance-based
                        threshold = mRatio*aveDist(iObject); % the threshold for distance-based hyperedge construction
                        %threshold = aveDist(iObject);
                        iEdge = iObject;
                        for iNeighbor = 1:nObject
                                if vDist(iNeighbor) < threshold
                                       if IS_ProH == 0 % if it is not pro H
                                                H{iMod,1}(iNeighbor,iEdge) = 1;
                                       else
                                                H{iMod,1}(iNeighbor,iEdge)  = exp(-vDist(iNeighbor)^2/(mProb*aveDist(iObject))^2);
                                       end
                                end
                        end
                end
    end
%     for i = 1:nObject
%         for j = 1:nObject
%             if  H{iMod,1}(i,j) ~=  H{iMod,1}(j,i)
%                 if H{iMod,1}(i,j) ~= 0
%                     H{iMod,1}(j,i) = H{iMod,1}(i,j);
%                 else
%                     H{iMod,1}(i,j) = H{iMod,1}(j,i);
%                 end
%             end
%         end
%     end       
end