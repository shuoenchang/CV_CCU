clear;
clc;

D2 = load('2D.csv');
D3 = load('3D.csv');

[records, fields ] = size(D2);

D2 = [D2, ones(records, 1)];    % convert to homogeneous
D3 = [D3, ones(records, 1)];

A  = [];    
for i=1:records     % A matrix
    A = [A; D3(i,:) zeros(1, 4) -D2(i,1).*D3(i,:); 
            zeros(1, 4) D3(i,:) -D2(i,2).*D3(i,:)];
end

[V , lambda] = eig(A'*A);   % find all eigenvector
[smallValue, smallIndex] = min(sum(lambda));    % find smallest eigenvalue
P = V(:, smallIndex);
P = reshape(P, 4, 3)'   % get project metrix

M = P(:, 1:3);
[q, r] = qr(inv(M));    % use M inverse to do qr decomposition
K = inv(r)
R = inv(q)
T = inv(K)*P(:, 4)

projectD2 = (P*D3')';
projectD2 = projectD2./projectD2(:,3); % convert from homogeneous
L2norm = sqrt(sum((projectD2-D2).^2, 2));
project_error = mean(L2norm)

