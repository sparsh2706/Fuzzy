function [centers, U ,J] = my_fcm(dataset,clusters)

data_points = size(dataset,1);
% clusters is the cluster number

% U is initialized
U = randn(clusters,data_points) + 3;
val = sum(U);
U = U./val; % All matrix elements are converted to less than 1 and the sum of the each column is ensured to be 1

m = 2;
iter = 100;
epsilon = 0.0001;
J = zeros(iter,1); % The Objective Function
for i = 1:iter    
    mf = U.^2;
    denominator = (ones(2,1) * sum(mf'))';
    centers = (mf * dataset) ./ denominator; % Got the Centroids
    
    distances = zeros(data_points,clusters);
    for k = 1:size(centers,1)
        distances(:,k) = distances(:,k) + pdist2(dataset,centers(k,:));
    end
    % Distance Matrix Generated
    distances = distances';
    J(i) = sum(sum((distances.^2) .* (mf)));  % objective function Update
    % calculate new U
    tmp = distances.^(-2/(m-1)); 
    U = tmp./(ones(clusters, 1)*sum(tmp));
    if i>1
        if abs(J(i) - J(i-1)) < epsilon
            break;
        end
    end
end

looped_iter = i;
J(looped_iter+1:iter) = []; % Empty the Rest of the Objective Functions we had initialized

end
