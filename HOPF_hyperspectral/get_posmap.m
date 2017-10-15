%% -------------------------------------------------
% Matlab code fo getting data posemap and ordering input data & groundtruth.
% Author: Zhilin Cao <zhilin.cao@foxmail.com>, THU
% There are currently no liceses.
%% -------------------------------------------------
matrixData = indian_pines_corrected;
matrixGroundtruth = indian_pines_gt;

[a,b,c] = size(matrixData);
amount = 0;

for i = 1:a
    for j = 1:b
        if matrixGroundtruth(i,j,:) ~= 0
            amount = amount + 1;
        end
    end
end

data = zeros(amount,c);
groundtruth = zeros(amount,1);
posmap = zeros(amount,2);
k = 1;

for i = 1:a
    for j = 1:b
        if matrixGroundtruth(i,j,:) ~= 0
            data(k,:) = matrixData(i,j,:);
            groundtruth(k) = matrixGroundtruth(i,j);
            posmap(k,:) = [i,j];
            k = k + 1;
        end
    end
end

num_ver = amount;        