clear;clc;close all;
% Scores of rebf vs dist matrices of pv, som, thy on thy basis
disp('Running pca of pv and som on thy basis')

% load matrices
thy = load('Thy_rebf_vs_dist').all_pairs_rebf_vs_dist_norm;
pv = load('PV_rebf_vs_dist').all_pairs_rebf_vs_dist_norm;
som = load('SOM_rebf_vs_dist').all_pairs_rebf_vs_dist_norm;

% reduce it from 6 x 7
thy = thy(1:6, 1:7);
pv = pv(1:6, 1:7);
som = som(1:6, 1:7);

% replace nan with zeros in all 3
thy(isnan(thy)) = 0;
pv(isnan(pv)) = 0;
som(isnan(som)) = 0;

% do pca of thy
[coeff,score,latent] = pca(thy);

% NOTE thy - mean(thy) = score x coeff'

% Get scores of pv and som on thy basis
% pv - mean(pv) = score_pv_on_thy_basis x coeff'
% Multiply by coeff on both sides
% (pv - mean(pv))*coeff = score_pv_on_thy_basis x coeff'coeff
% coeff'coeff = 1
% (pv - mean(pv))*coeff = score_pv_on_thy_basis

score_pv_on_thy_basis = (pv - mean(pv))*coeff;
score_som_on_thy_basis = (som - mean(som))*coeff;
score_thy_on_thy_basis = score;

% visualise take only first 3
% Assuming A, B, and C are your 6 x 5 matrices
% Take first 3 columns from each matrix
A = score_thy_on_thy_basis;
B = score_pv_on_thy_basis;
C = score_som_on_thy_basis;

% Assuming A, B, and C are your 6 x 5 matrices
% Take first 3 columns from each matrix
A = A(:, 1:3);
B = B(:, 1:3);
C = C(:, 1:3);

% Define the size of the marker
markerSize = 20;

% Assuming A, B, and C are your 6 x 3 matrices

% Loop over each row
for row = 1:size(A, 1)
    % Create a new figure for this row
    figure;
    
    % Plot each matrix's data in 3D
    plot3(A(row, 1), B(row, 2), A(row, 3), 'r*');
    hold on;
    
    plot3(B(row, 1), B(row, 2), B(row, 3), 'g*');
    plot3(C(row, 1), C(row, 2), C(row, 3), 'b*');
    
    % Label the axes
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    
    % Add a title to each figure
    title(['Figure ' num2str(row)]);
    
   

    % Add a legend to each figure
    legend('Thy', 'PV', 'SOM');
end

% get distances of pv and som from thy (B,C from A)
% euclidean distance
dist_pv_from_thy = sqrt(sum((B - A).^2, 2));
dist_som_from_thy = sqrt(sum((C - A).^2, 2));

% pv from thy, mean and err
disp('PV from thy')
disp(['Mean: ' num2str(mean(dist_pv_from_thy))])
disp(['Std: ' num2str(std(dist_pv_from_thy))])

disp('SOM from thy')
disp(['Mean: ' num2str(mean(dist_som_from_thy))])
disp(['Std: ' num2str(std(dist_som_from_thy))])
