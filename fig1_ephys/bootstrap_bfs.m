close all;clc;clear ;
load('rms_match_db.mat')

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


% boots params
n_boots = 1000;
original_ratio_mean = zeros(n_boots,1);
shuffled_ratio_mean = zeros(n_boots,1);
n = size(rms_match_db,1);

% surrogate data without shuffle
% rng(1); % Seed for reproducability
for b = 1:n_boots
    rand_indices = randi(n,n,1);
    bootstrap_sample = rms_match_db(rand_indices,:);
    bf_bf0 = zeros(7,7);

    for u=1:size(bootstrap_sample,1)
        bfi = bootstrap_sample{u,12};
        bf0i = bootstrap_sample{u,13};

        if bfi ~= -1 && bf0i ~= -1
            bf_bf0(bfi, bf0i) = bf_bf0(bfi, bf0i) + 1;
        end
    end % for


    % bf_bf0 = bf_bf0./sum(bf_bf0(:));
    % calculate ratio
    all_ratios = zeros(5,1);
    for d = 3:7
        on_diag = bf_bf0(d,d);
        off_diag = bf_bf0(d, d-2);

        all_ratios(d-2) = off_diag/on_diag;
    end
    all_ratios(isnan(all_ratios) | isinf(all_ratios)) = [];
    original_ratio_mean(b) = mean(all_ratios); 
end % b

% shuffle
% rng(2);
for b = 1:n_boots
    rand_indices1 = randi(n,n,1);
    rand_indices2 = randi(n,n,1);

    bootstrap_sample1 = rms_match_db(rand_indices1,:);
    bootstrap_sample2 = rms_match_db(rand_indices2,:);

    bf_bf0 = zeros(7,7);

    for u=1:size(bootstrap_sample,1)
        bfi = bootstrap_sample1{u,12};
        bf0i = bootstrap_sample2{u,13};

        if bfi ~= -1 && bf0i ~= -1
            bf_bf0(bfi, bf0i) = bf_bf0(bfi, bf0i) + 1;
        end
    end % for

    % bf_bf0 = bf_bf0./sum(bf_bf0(:));
    % calculate ratio
    all_ratios = zeros(5,1);
    for d = 3:7
        on_diag = bf_bf0(d,d);
        off_diag = bf_bf0(d, d-2);

        all_ratios(d-2) = off_diag/on_diag;
    end
    all_ratios(isnan(all_ratios) | isinf(all_ratios)) = [];
    shuffled_ratio_mean(b) = mean(all_ratios); 
end % b


% 95 percet confidence interval
sort_original_ratio_mean = sort(original_ratio_mean);
sort_shuffled_ratio_mean = sort(shuffled_ratio_mean);

confidence_val = 90;

lower_bound = round(n_boots*(1-confidence_val/100)/2);
upper_bound = round(n_boots*(1-(1-confidence_val/100)/2));

original_ratio_bounds = [sort_original_ratio_mean(lower_bound), sort_original_ratio_mean(upper_bound)];
shuffled_ratio_bounds = [sort_shuffled_ratio_mean(lower_bound), sort_shuffled_ratio_mean(upper_bound)];

if original_ratio_bounds(1) > shuffled_ratio_bounds(2) 
    disp('Significant')
else
    disp('Not Significant')
end
