clear;clc;close all;
% Scores of rebf vs dist matrices of pv, som, thy on thy basis
disp('Boots- Running pca of pv and som on thy basis')

% load matrices
thy_chance = load('thy_chance').chance_all_pairs_rebf_vs_dist_boots;
pv_chance = load('pv_chance').chance_all_pairs_rebf_vs_dist_boots;
som_chance = load('som_chance').chance_all_pairs_rebf_vs_dist_boots;

thy_actual = load('thy_actual').actual_all_pairs_rebf_vs_dist_boots;
pv_actual = load('pv_actual').actual_all_pairs_rebf_vs_dist_boots;
som_actual = load('som_actual').actual_all_pairs_rebf_vs_dist_boots;

n_boots = 1000;
chance_pv_from_thy = zeros(n_boots, 1);
chance_som_from_thy = zeros(n_boots, 1);

actual_pv_from_thy = zeros(n_boots, 1);
actual_som_from_thy = zeros(n_boots, 1);

pcs_to_use = 4;
cols_to_see = 1:2;

for b = 1:n_boots

    disp(['Boots: ' num2str(b)])
    % chance
    thy = squeeze(thy_chance(b, 1:6, 1:7));
    pv = squeeze(pv_chance(b, 1:6, 1:7));
    som = squeeze(som_chance(b, 1:6, 1:7));

    % replace nan with zeros in all 3
    thy(isnan(thy)) = 0;
    pv(isnan(pv)) = 0;
    som(isnan(som)) = 0;

    % do pca of thy
    [coeff,score,latent] = pca(thy);

    weights_for_mean = latent(pcs_to_use)./sum(latent(pcs_to_use));
    % NOTE thy - mean(thy) = score x coeff'

    % Get scores of pv and som on thy basis
    % pv - mean(pv) = score_pv_on_thy_basis x coeff'
    % Multiply by coeff on both sides
    % (pv - mean(pv))*coeff = score_pv_on_thy_basis x coeff'coeff
    % coeff'coeff = 1
    % (pv - mean(pv))*coeff = score_pv_on_thy_basis

    score_pv_on_thy_basis = (pv - mean(thy))*coeff;
    score_som_on_thy_basis = (som - mean(thy))*coeff;
    score_thy_on_thy_basis = score;

    % visualise take only first 3
    % Assuming A, B, and C are your 6 x 5 matrices
    % Take first 3 columns from each matrix
    A = score_thy_on_thy_basis;
    B = score_pv_on_thy_basis;
    C = score_som_on_thy_basis;

    % Assuming A, B, and C are your 6 x 5 matrices
    % Take first 3 columns from each matrix
    A = A(pcs_to_use, cols_to_see);
    B = B(pcs_to_use, cols_to_see);
    C = C(pcs_to_use, cols_to_see);


    % get distances of pv and som from thy (B,C from A)
    % euclidean distance
    dist_pv_from_thy = sqrt(sum((B - A).^2, 2));
    dist_som_from_thy = sqrt(sum((C - A).^2, 2));

    chance_pv_from_thy(b) = sum(dist_pv_from_thy.*weights_for_mean);
    chance_som_from_thy(b) = sum(dist_som_from_thy.*weights_for_mean);

    % actual
    thy = squeeze(thy_actual(b, 1:6, 1:7));
    pv = squeeze(pv_actual(b, 1:6, 1:7));
    som = squeeze(som_actual(b, 1:6, 1:7));

    % replace nan with zeros in all 3
    thy(isnan(thy)) = 0;
    pv(isnan(pv)) = 0;
    som(isnan(som)) = 0;

    % do pca of thy
    [coeff,score,latent] = pca(thy);

    
    % NOTE thy - mean(thy) = score x coeff'

    % Get scores of pv and som on thy basis
    % pv - mean(thy) = score_pv_on_thy_basis x coeff'
    % Multiply by coeff on both sides
    % (pv - mean(thy))*coeff = score_pv_on_thy_basis x coeff'coeff
    % coeff'coeff = 1
    % (pv - mean(thy))*coeff = score_pv_on_thy_basis

    score_pv_on_thy_basis = (pv - mean(thy))*coeff;
    score_som_on_thy_basis = (som - mean(thy))*coeff;
    score_thy_on_thy_basis = score;

    % visualise take only first 3
    % Assuming A, B, and C are your 6 x 5 matrices
    % Take first 3 columns from each matrix
    A = score_thy_on_thy_basis;
    B = score_pv_on_thy_basis;
    C = score_som_on_thy_basis;

    % Assuming A, B, and C are your 6 x 5 matrices
    % Take first 3 columns from each matrix
    A = A(pcs_to_use, cols_to_see);
    B = B(pcs_to_use, cols_to_see);
    C = C(pcs_to_use, cols_to_see);


    % get distances of pv and som from thy (B,C from A)
    % euclidean distance
    dist_pv_from_thy = sqrt(sum((B - A).^2, 2));
    dist_som_from_thy = sqrt(sum((C - A).^2, 2));

    actual_pv_from_thy(b) = mean(dist_pv_from_thy.*weights_for_mean);
    actual_som_from_thy(b) = mean(dist_som_from_thy.*weights_for_mean);


end % b



% confidence interval test
% PV
actual_pv_from_thy = sort(actual_pv_from_thy);
chance_pv_from_thy = sort(chance_pv_from_thy);

confidence = 0.90;
actual_ci = actual_pv_from_thy([floor((1-confidence)/2*n_boots) ceil((1+confidence)/2*n_boots)]);
chance_ci = chance_pv_from_thy([floor((1-confidence)/2*n_boots) ceil((1+confidence)/2*n_boots)]);

if actual_ci(1) > chance_ci(2)
    disp('🔥 PV: Actual is greater than chance')
else
    disp('👻PV: Actual is not greater than chance')
end
disp(['chance ci: ' num2str(chance_ci(1)) ' ' num2str(chance_ci(2))])
disp(['actual ci: ' num2str(actual_ci(1)) ' ' num2str(actual_ci(2))])

% SOM
actual_som_from_thy = sort(actual_som_from_thy);
chance_som_from_thy = sort(chance_som_from_thy);

confidence = 0.90;
actual_ci = actual_som_from_thy([floor((1-confidence)/2*n_boots) ceil((1+confidence)/2*n_boots)]);
chance_ci = chance_som_from_thy([floor((1-confidence)/2*n_boots) ceil((1+confidence)/2*n_boots)]);

if actual_ci(1) > chance_ci(2)
    disp('🔥 SOM: Actual is greater than chance')
else
    disp('👻SOM: Actual is not greater than chance')
end

disp(['chance ci: ' num2str(chance_ci(1)) ' ' num2str(chance_ci(2))])
disp(['actual ci: ' num2str(actual_ci(1)) ' ' num2str(actual_ci(2))])
