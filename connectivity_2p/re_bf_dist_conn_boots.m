% Bootstrap re BF vs num of connected pairs
clear;clc;close all;
disp('Running re_bf_dist_conn.m - conn vs rebf vs dist')
neuron_type = 'Thy'; % PV or SOM or Thy
rms_match_db_with_sig_bf = load("E:\RK_E_folder_TTHC_backup\RK TTHC Data\"+ neuron_type + "\rms_match_db_with_sig_bf.mat").rms_match_db_with_sig_bf;
rms_match_db = load("E:\RK_E_folder_TTHC_backup\RK TTHC Data\" + neuron_type + "\rms_match_db.mat").rms_match_db;

normalise_along_what = 'dist'; % 'rebf' or 'dist'

% add 2 columns - x coord and y coord
for u=1:size(rms_match_db_with_sig_bf,1)
   rms_match_db_with_sig_bf{u,17} = rms_match_db{u,10};
   rms_match_db_with_sig_bf{u,18} = rms_match_db{u,11};
end

% seperate gender wise
animal_gender = 'all';
if strcmp(animal_gender, 'M')
    rejected_gender = 'F';
elseif strcmp(animal_gender, 'F')
    rejected_gender = 'M';
else
    rejected_gender = nan;
end
if ~isnan(rejected_gender)
    removal_indices = [];
    for u = 1:size(rms_match_db_with_sig_bf,1)
        animal_name = rms_match_db_with_sig_bf{u,1};
        if contains(animal_name, strcat('_', rejected_gender))
            removal_indices = [removal_indices; u];
        end
    end

    rms_match_db_with_sig_bf(removal_indices,:) = [];
end


% BF or BF0
scale = 'BF'; % 11-BF or 13-BF0
if strcmp(scale, 'BF')
    bf_index = 11;
elseif strcmp(scale, 'BF0')
    bf_index = 13;
end

% remove rows where 11 or 13th column of cell is -1
removal_indices = [];
for u=1:size(rms_match_db_with_sig_bf,1)
    if rms_match_db_with_sig_bf{u,11} == -1 || rms_match_db_with_sig_bf{u,13} == -1
        removal_indices = [removal_indices;u];
    end
end
rms_match_db_with_sig_bf(removal_indices,:) = [];

% Fill noise corr vecs
for u=1:size(rms_match_db_with_sig_bf,1)
    tbf = rms_match_db_with_sig_bf{u,11};
    hbf = rms_match_db_with_sig_bf{u,13};

   

    % tone
    rate_ind = 8;
    noise_ind = 14;
    noise = [];
    for freq=1:7
        r5 = mean(rms_match_db_with_sig_bf{u,rate_ind}{freq,1}(:,10:14),2);
        n5 = r5 - mean(r5);
        noise = [noise; n5];
    end

    rms_match_db_with_sig_bf{u,noise_ind} = noise;

    % hc
    rate_ind = 9;
    noise_ind = 15;
    noise = [];
    for freq=1:7
        r5 = mean(rms_match_db_with_sig_bf{u,rate_ind}{freq,1}(:,10:14),2);
        n5 = r5 - mean(r5);
        noise = [noise; n5];
    end
    rms_match_db_with_sig_bf{u,noise_ind} = noise;


end

% get all with same roi
roi_to_units_map = containers.Map;
combiner = '***';
for u = 1:size(rms_match_db_with_sig_bf)
    animal_name = rms_match_db_with_sig_bf{u,1};
    location = rms_match_db_with_sig_bf{u,2};
    spl_str = num2str(rms_match_db_with_sig_bf{u,6});

    roi_uniq_name = strcat(animal_name,combiner,location,combiner,spl_str);
    if isKey(roi_to_units_map,roi_uniq_name)
        roi_to_units_map(roi_uniq_name) = [roi_to_units_map(roi_uniq_name);u];
    else
        roi_to_units_map(roi_uniq_name) = [u];
    end
end

% get each roi info in 1 struct
noise_index = 14; % TONE Noise Correlations

all_roi_keys = keys(roi_to_units_map);
counter = 1;

all_roi_info = struct('roi_name', {}, 'rebf', {}, 'x_coord', {}, 'y_coord', {}, 'noise_corr_mat', {});

for k = 1:length(all_roi_keys)
    roi_key_name = all_roi_keys{k};
    roi_units = roi_to_units_map(roi_key_name);
    n_roi_units = length(roi_units);

    roi_name = roi_key_name;
    roi_re_bf = zeros(n_roi_units, 1);
    roi_x_coord = zeros(n_roi_units, 1);
    roi_y_coord = zeros(n_roi_units, 1);
    roi_noise_corr_mat = zeros(n_roi_units, n_roi_units);

    roi_noise_corr_vecs = zeros(35, n_roi_units);
    
    for ru = 1:length(roi_units)
        unit_index = roi_units(ru);
        
        % fill rebf
        roi_re_bf(ru,1) = rms_match_db_with_sig_bf{unit_index, bf_index};
        % coords
        roi_x_coord(ru,1) = rms_match_db_with_sig_bf{unit_index, 17};
        roi_y_coord(ru,1) = rms_match_db_with_sig_bf{unit_index, 18};

        %   nc
        roi_noise_corr_vecs(:,ru) = rms_match_db_with_sig_bf{unit_index, noise_index}; 
    end % ru

    roi_noise_corr_vecs = corrcoef(roi_noise_corr_vecs);


    all_roi_info(counter).roi_name = roi_name;
    all_roi_info(counter).rebf = roi_re_bf;
    all_roi_info(counter).x_coord = roi_x_coord;
    all_roi_info(counter).y_coord = roi_y_coord;
    all_roi_info(counter).noise_corr_mat = roi_noise_corr_vecs;

    counter = counter + 1;
end % k

% Code to get upp tri elements
% A = [1 2 3; 4 5 6; 7 8 9];
% mask = triu(true(size(A)), 1);
% B = A(mask);
% disp(B);

total_pairs_len = 0;
for i = 1:length(all_roi_info)
    n_cells = length(all_roi_info(i).rebf);
    total_pairs_len = total_pairs_len + (n_cells*(n_cells-1))/2;
end % i

% all pairs rebf, dist, noise corr
all_pairs_noise_corr = [];
for i = 1:length(all_roi_info)
    roi_noise_corr = all_roi_info(i).noise_corr_mat;
    mask = triu(true(size(roi_noise_corr)), 1);
    triu_noise_corr = roi_noise_corr(mask);

    all_pairs_noise_corr = [all_pairs_noise_corr; triu_noise_corr];
end % i

% Get the left and right extreme
mean_noise_corr = mean(all_pairs_noise_corr);
std_noise_corr = std(all_pairs_noise_corr);
right_extreme = mean_noise_corr + 2*std_noise_corr;
left_extreme = mean_noise_corr - 2*std_noise_corr;

% get the matrix
dist_bin_size = 50;
max_dist = 500; % microns
dist_bins = 0:dist_bin_size:max_dist-dist_bin_size;
rebf_bins = 0:0.5:3;

% all pairs rebf vs dist
all_pairs_rebf_vs_dist = zeros(length(dist_bins), length(rebf_bins));


% struct: roi_name, n1, n2
roi_n1_n2 = struct('roi_no', {}, 'n1', {}, 'n2', {}, 'dist', {}, 'rebf', {});
counter = 1;
for i = 1:length(all_roi_info)
    
    all_bf = all_roi_info(i).rebf;

    all_x_cord = all_roi_info(i).x_coord;
    all_y_cord = all_roi_info(i).y_coord;
    
    all_noise_corr = all_roi_info(i).noise_corr_mat;
    
    n_cells = length(all_bf);
    for n1 = 1:n_cells-1
        for n2 = n1+1:n_cells
            nc_for_n1_n2 = all_noise_corr(n1,n2);
            if nc_for_n1_n2 > right_extreme || nc_for_n1_n2 < left_extreme
                % get the distance
                x1 = all_x_cord(n1);
                y1 = all_y_cord(n1);
                x2 = all_x_cord(n2);
                y2 = all_y_cord(n2);
                dist = sqrt((x1-x2)^2 + (y1-y2)^2)*1.17; % 1.17 microns per pixel
                dist_bin = floor(dist/dist_bin_size) + 1;

                % get the rebf
                bf1 = all_bf(n1);
                bf2 = all_bf(n2);
                rebf = abs(bf1 - bf2)*0.5;
                rebf_bin = find(rebf_bins == rebf);


                roi_n1_n2(counter).roi_no = i;
                roi_n1_n2(counter).n1 = n1;
                roi_n1_n2(counter).n2 = n2;
                roi_n1_n2(counter).dist = dist_bin;
                roi_n1_n2(counter).rebf = rebf_bin;
                counter = counter + 1;
            end 
        end
    end
end % i


disp(['Total pairs ' num2str(counter - 1)]);

num_extreme_pairs = counter - 1;


% bootstrapped data
n_boots = 1000;
actual_all_pairs_rebf_vs_dist_boots = zeros(n_boots, length(dist_bins), length(rebf_bins));

for b = 1:n_boots
    disp(['Boot ' num2str(b)])
    random_indices = randi([1 num_extreme_pairs], num_extreme_pairs, 1);
    for r = 1:length(random_indices)
        rand_ind = random_indices(r);
        dist_bin = roi_n1_n2(rand_ind).dist;
        rebf_bin = roi_n1_n2(rand_ind).rebf;

        actual_all_pairs_rebf_vs_dist_boots(b, dist_bin, rebf_bin) = actual_all_pairs_rebf_vs_dist_boots(b, dist_bin, rebf_bin) + 1;
        
    end  % r
end % b

% % normalise each row in actual by nansum of each row
if strcmp(normalise_along_what, 'rebf')
    % - Normalise such that each row sums to 1 (sum of all rebf = 1)
    for b = 1:n_boots
        for r = 1:length(dist_bins(1:6))
            actual_all_pairs_rebf_vs_dist_boots(b,r,:) = actual_all_pairs_rebf_vs_dist_boots(b,r,:)/nansum(actual_all_pairs_rebf_vs_dist_boots(b,r,:));
        end
    end % b
elseif strcmp(normalise_along_what, 'dist')
    % normalise each row in actual by nansum of each column (sum of all dist = 1)
    for b = 1:n_boots
        for r = 1:length(rebf_bins)
            actual_all_pairs_rebf_vs_dist_boots(b,1:6,r) = actual_all_pairs_rebf_vs_dist_boots(b,1:6,r)/nansum(actual_all_pairs_rebf_vs_dist_boots(b,1:6,r));
        end
    end % b
end
save(strcat(neuron_type, '_actual.mat'), 'actual_all_pairs_rebf_vs_dist_boots');