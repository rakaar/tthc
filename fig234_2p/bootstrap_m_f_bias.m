close all;clc;clear ;
rms_file_path = '/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC Data/PV/rms_match_db_with_sig_bf.mat';
rms_match_db = load(rms_file_path).rms_match_db_with_sig_bf;

animal_gender = 'F'; % M for Male, F for Female, all for both
if strcmp(animal_gender, 'M')
    rejected_gender = 'F';
elseif strcmp(animal_gender, 'F')
    rejected_gender = 'M';
else
    rejected_gender = nan;
end
if ~isnan(rejected_gender)
    removal_indices = [];
    for u = 1:size(rms_match_db,1)
        animal_name = rms_match_db{u,1};
        % if animal name includes _{rejected_gender} add it to removal index
        if contains(animal_name, strcat('_',rejected_gender))
            removal_indices = [removal_indices; u];
        end
    end % u

    % remove rejected gender
    rms_match_db(removal_indices,:) = [];

end % if

female_rms_match = rms_match_db;
save('female_rms_match', 'female_rms_match')

% boots params
n_boots = 1000;
original_ratio_mean = zeros(n_boots,1);
n = size(rms_match_db,1);
f0_to_see = 3:5;

% surrogate data without shuffle
% rng(1); % Seed for reproducability
for b = 1:n_boots
    rand_indices = randi(n,n,1);
    bootstrap_sample = rms_match_db(rand_indices,:);
    bf_bf0 = zeros(7,7);

    for u=1:size(bootstrap_sample,1)
        bfi = bootstrap_sample{u,11};
        bf0i = bootstrap_sample{u,13};

        if bfi ~= -1 && bf0i ~= -1
            bf_bf0(bfi, bf0i) = bf_bf0(bfi, bf0i) + 1;
        end
    end % for


    % bf_bf0 = bf_bf0./sum(bf_bf0(:));
    % calculate ratio
    % all_ratios = zeros(length(f0_to_see),1);

    % off0_sum = zeros(length(f0_to_see),1);
    % off1_sum = zeros(length(f0_to_see),1);
    % off2_sum = zeros(length(f0_to_see),1);

    % for d = f0_to_see
    %     on_diag = bf_bf0(d,d);
    %     off_diag = bf_bf0(d, d-2);
    %     off_diag1 = bf_bf0(d, d-1);

    %     % all_ratios(d-2) = (off_diag - off_diag1)/on_diag;
    %     % all_ratios(d-2) = off_diag/on_diag;
    %     off0_sum(d-2) =  on_diag;
    %     off2_sum(d-2) =  off_diag;
    %     off1_sum(d-2) =  off_diag1;

    % end


    % all_ratios(isnan(all_ratios) | isinf(all_ratios)) = [];
    % original_ratio_mean(b) = mean(all_ratios)
    % original_ratio_mean(b) = (sum(off2_sum) - sum(off1_sum))/sum(off0_sum); 

    % bf_bf0 = bf_bf0(1:5, 1:5);

    original_ratio_mean(b) = ( mean(diag(bf_bf0,-1))  - mean(diag(bf_bf0)) ) / mean(diag(bf_bf0));
end % b

female_original_ratio = original_ratio_mean;

% ---- Male --------------
rms_match_db = load(rms_file_path).rms_match_db_with_sig_bf;
animal_gender = 'M'; % M for Male, F for Female, all for both
if strcmp(animal_gender, 'M')
    rejected_gender = 'F';
elseif strcmp(animal_gender, 'F')
    rejected_gender = 'M';
else
    rejected_gender = nan;
end
if ~isnan(rejected_gender)
    removal_indices = [];
    for u = 1:size(rms_match_db,1)
        animal_name = rms_match_db{u,1};
        % if animal name includes _{rejected_gender} add it to removal index
        if contains(animal_name, strcat('_',rejected_gender))
            removal_indices = [removal_indices; u];
        end
    end % u

    % remove rejected gender
    rms_match_db(removal_indices,:) = [];

end % if

male_rms_match = rms_match_db;
save('male_rms_match', 'male_rms_match');
% boots params
original_ratio_mean = zeros(n_boots,1);
n = size(rms_match_db,1);

% surrogate data without shuffle
% rng(1); % Seed for reproducability
for b = 1:n_boots
    rand_indices = randi(n,n,1);
    bootstrap_sample = rms_match_db(rand_indices,:);
    bf_bf0 = zeros(7,7);

    for u=1:size(bootstrap_sample,1)
        bfi = bootstrap_sample{u,11};
        bf0i = bootstrap_sample{u,13};

        if bfi ~= -1 && bf0i ~= -1
            bf_bf0(bfi, bf0i) = bf_bf0(bfi, bf0i) + 1;
        end
    end % for


    % bf_bf0 = bf_bf0./sum(bf_bf0(:));
    % calculate ratio
    % all_ratios = zeros(length(f0_to_see),1);

    % off0_sum = zeros(length(f0_to_see),1);
    % off1_sum = zeros(length(f0_to_see),1);
    % off2_sum = zeros(length(f0_to_see),1);

    % for d = f0_to_see
    %     on_diag = bf_bf0(d,d);
    %     off_diag = bf_bf0(d, d-2);
    %     off_diag1 = bf_bf0(d, d-1);

    %     % all_ratios(d-2) = (off_diag - off_diag1)/on_diag;
    %     % all_ratios(d-2) = off_diag/on_diag;

    %     off0_sum(d-2) = on_diag;
    %     off2_sum(d-2) =  off_diag;
    %     off1_sum(d-2) =  off_diag1;

    % end
    % all_ratios(isnan(all_ratios) | isinf(all_ratios)) = [];
    % original_ratio_mean(b) = mean(all_ratios); 
    % original_ratio_mean(b) = (sum(off2_sum) - sum(off1_sum))/sum(off0_sum);
    % bf_bf0 = bf_bf0(1:5, 1:5);
    original_ratio_mean(b) = ( mean(diag(bf_bf0,-1))  - mean(diag(bf_bf0)) ) / mean(diag(bf_bf0));
end % b

male_original_ratio = original_ratio_mean;

% 95 percet confidence interval
sort_female_ratio = sort(female_original_ratio);
sort_male_ratio = sort(male_original_ratio);

confidence_val = 90;

lower_bound = round(n_boots*(1-confidence_val/100)/2);
upper_bound = round(n_boots*(1-(1-confidence_val/100)/2));

female_bounds = [sort_female_ratio(lower_bound), sort_female_ratio(upper_bound)];
male_bounds = [sort_male_ratio(lower_bound), sort_male_ratio(upper_bound)];

if female_bounds(1) > male_bounds(2) || female_bounds(2) < male_bounds(1)
    disp('Significant')
    disp('---female---')
    disp(female_bounds)
    disp('---male---')
    disp(male_bounds)
else
    disp('Not Significant')
    disp('---female---')
    disp(female_bounds)
    disp('---male---')
    disp(male_bounds)
end
