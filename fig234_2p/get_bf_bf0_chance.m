% load rms_match_db
clear;clc;close all;
rms_match_db = load('E:\RK_E_folder_TTHC_backup\RK TTHC Data\Thy\rms_match_db_with_sig_bf.mat').rms_match_db_with_sig_bf;

bf_index = 11;
bf0_index = 13;

n_boots = 1e4;

n_rows = size(rms_match_db,1);
chance_distr = zeros(n_boots, 7, 7);
actual_distr = zeros(n_boots, 7, 7);

for i = 1:n_boots
    % bfs and bf0s
    all_bfs = cell2mat( rms_match_db(1:n_rows, bf_index) );
    all_bf0s = cell2mat( rms_match_db(1:n_rows, bf0_index) );

    % actual distr 
    indices = randi(length(all_bfs), length(all_bfs), 1);
    all_bfs_shuffle = all_bfs(indices);
    all_bf0s_shuffle = all_bf0s(indices);
    actual_distr(i,:,:) = get_bf_bf0_mat(all_bfs_shuffle, all_bf0s_shuffle);

    % chance distr
    indices1 = randi(length(all_bfs), length(all_bfs), 1);
    indices2 = randi(length(all_bfs), length(all_bfs), 1);
    all_bfs_shuffle = all_bfs(indices1);
    all_bf0s_shuffle = all_bf0s(indices2);
    chance_distr(i,:,:) = get_bf_bf0_mat(all_bfs_shuffle, all_bf0s_shuffle);
end

% norms comparison
% symmetric_deviation = norm(A - (A + A')/2);

chance_symmetric_devs = zeros(n_boots, 1);
actual_symmetric_devs = zeros(n_boots, 1);

for i = 1:n_boots
    % get chance matrix
    chance_mat = squeeze(chance_distr(i,:,:));
    % normalize by sum of all elemetns
    chance_mat = chance_mat ./ sum(chance_mat(:));
    % get symmetric deviation
    chance_symmetric_devs(i) = norm(chance_mat - (chance_mat + chance_mat')/2);

    % get actual matrix
    actual_mat = squeeze(actual_distr(i,:,:));
    % normalize by sum of all elemetns
    actual_mat = actual_mat ./ sum(actual_mat(:));
    % get symmetric deviation
    actual_symmetric_devs(i) = norm(actual_mat - (actual_mat + actual_mat')/2);
end

% confidence interval comparison
confidence_interval = 0.90;
lower_bound = round((1 - confidence_interval)/2 * n_boots);
upper_bound = round((1 - (1 - confidence_interval)/2) * n_boots);

% get confidence interval of both chance and actual symmetric dev
chance_symmetric_devs = sort(chance_symmetric_devs);
actual_symmetric_devs = sort(actual_symmetric_devs);

chance_ci = [chance_symmetric_devs(lower_bound), chance_symmetric_devs(upper_bound)];
actual_ci = [actual_symmetric_devs(lower_bound), actual_symmetric_devs(upper_bound)];

% display both cis
disp('chance ci:');
disp(chance_ci);
disp('actual ci:');
disp(actual_ci);

if actual_ci(1) > chance_ci(2)
    disp('✔ significant difference');
else
    disp('✘ no significant difference');
end


function bf_bf0_mat = get_bf_bf0_mat(all_bfs, all_bf0s)
    bf_bf0_mat = zeros(7,7);
    for i = 1:length(all_bfs)
        if all_bfs(i)  ~= -1 && all_bf0s(i) ~= -1
            bf_bf0_mat(all_bfs(i), all_bf0s(i)) = bf_bf0_mat(all_bfs(i), all_bf0s(i)) + 1;
        end
    end
end

