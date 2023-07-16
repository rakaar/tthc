% load rms_match_db
clear;clc;close all;
rms_match_db_with_sig_bf = load('E:\RK_E_folder_TTHC_backup\RK TTHC Data\PV\rms_match_db_with_sig_bf.mat').rms_match_db_with_sig_bf;
rms_match_db = rms_match_db_with_sig_bf;

bf_index = 11;
bf0_index = 13;

n_boots = 1000;

n_rows = size(rms_match_db,1);
boots_distr = zeros(n_boots, 7, 7);

for i = 1:n_boots
    all_bfs = cell2mat( rms_match_db(1:n_rows, bf_index) );
    all_bf0s = cell2mat( rms_match_db(1:n_rows, bf0_index) );

    % shuffle both arrays with replacement 
    all_bfs = all_bfs(randperm(length(all_bfs)));
    all_bf0s = all_bf0s(randperm(length(all_bf0s)));

    chance_bf_bf0_mat = get_bf_bf0_mat(all_bfs, all_bf0s);
    boots_distr(i,:,:) = chance_bf_bf0_mat;
end

% actual dist 
all_bfs = cell2mat( rms_match_db(1:n_rows, bf_index) );
all_bf0s = cell2mat( rms_match_db(1:n_rows, bf0_index) );
actual_bf_bf0_mat = get_bf_bf0_mat(all_bfs, all_bf0s);

% actual_bf_bf0_mat(7 x 7) and chance_bf_bf0_mat(n_boots x 7 x 7) 

function bf_bf0_mat = get_bf_bf0_mat(all_bfs, all_bf0s)
    bf_bf0_mat = zeros(7,7);
    for i = 1:length(all_bfs)
        if all_bfs(i)  ~= -1 && all_bf0s(i) ~= -1
            bf_bf0_mat(all_bfs(i), all_bf0s(i)) = bf_bf0_mat(all_bfs(i), all_bf0s(i)) + 1;
        end
    end
end

