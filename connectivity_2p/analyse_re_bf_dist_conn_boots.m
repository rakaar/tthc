clear;clc;close all;
pv = load('PV_actual').actual_all_pairs_rebf_vs_dist_boots;
som = load('SOM_actual').actual_all_pairs_rebf_vs_dist_boots;
thy = load('Thy_actual').actual_all_pairs_rebf_vs_dist_boots;

% get the matrix
dist_bin_size = 50;
max_dist = 500; % microns
dist_bins = 0:dist_bin_size:max_dist-dist_bin_size;
rebf_bins = 0:0.5:3;

% 6 rows, 7 cols
% 0 bf difference - 1st col - different distances(1:6)
rebf_index = 1;
dist_index = 1:6;

pv_req_data = squeeze(pv(:, dist_index, rebf_index));
som_req_data = squeeze(som(:, dist_index, rebf_index));
thy_req_data = squeeze(thy(:, dist_index, rebf_index));

pv_mean = mean(pv_req_data, 1);
pv_std = std(pv_req_data, 1);
pv_err = pv_std/sqrt(size(pv_req_data, 1));


som_mean = mean(som_req_data, 1);
som_std = std(som_req_data, 1);
som_err = som_std/sqrt(size(som_req_data, 1));

thy_mean = mean(thy_req_data, 1);
thy_std = std(thy_req_data, 1);
thy_err = thy_std/sqrt(size(thy_req_data, 1));

% plot mean and err of each neuron using errorbars with linewidth 2 and legend - pv, som, thy
figure;
errorbar(dist_bins(1:6)+dist_bin_size/2,pv_mean, pv_err, 'LineWidth', 2);
hold on;
errorbar(dist_bins(1:6)+dist_bin_size/2,som_mean, som_err, 'LineWidth', 2);
errorbar(dist_bins(1:6)+dist_bin_size/2,thy_mean, thy_err, 'LineWidth', 2);
legend('PV', 'SOM', 'Thy');
xlabel('Distance between neurons');
ylabel('Probability of having a BF difference');
% x axis ticks should be dist_bins(1:6)+dist_bin_size/2
xticks(dist_bins(1:6)+dist_bin_size/2);
xticklabels({'0-50', '50-100', '100-150', '150-200', '200-250', '250-300'});
