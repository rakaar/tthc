clear;clc;close all;
rms_match_db = load('rms_match_db.mat').rms_match_db;

% BF or BF0
scale = 'BF'; % 11-BF or 13-BF0
if strcmp(scale, 'BF')
    bf_index = 12;
elseif strcmp(scale, 'BF0')
    bf_index = 13;
end

% find indices where 12th or 13th col is -1
removal_indices = [];
for u = 1:size(rms_match_db,1)
    if rms_match_db{u,12} == -1 || rms_match_db{u,13} == -1
        removal_indices = [removal_indices u];
    end
end
% remove those indices
rms_match_db(removal_indices,:) = [];

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
    for u = 1:size(rms_match_db,1)
        animal_name = rms_match_db{u,1};
        if contains(animal_name, strcat('_', rejected_gender))
            removal_indices = [removal_indices; u];
        end
    end

    rms_match_db(removal_indices,:) = [];
end



% fill noise vec - 35 x 1 at 14 th col
for u = 1:size(rms_match_db,1)
    tone_rates = rms_match_db{u,6};
    
    mean_rate_of_7_stim = zeros(7,1);
    for f = 1:7
        mean_rate_of_7_stim(f) = mean(mean(tone_rates{f,1}(:, 501:570),2));
    end % f

    noise_vec = zeros(35,1);
    for iter = 1:5
        for f = 1:7
            ind35 = (iter - 1)*7 + f;
            rate_at_iter_f = mean(tone_rates{f,1}(iter, 501:570));
            noise_vec(ind35) = rate_at_iter_f - mean_rate_of_7_stim(f);
        end % f
    end % iter

    rms_match_db{u,14} = noise_vec;
end % u

% find roi keys
roi_name_to_units_map = containers.Map;
combiner = '***';
for u = 1:size(rms_match_db,1)
    animal_name = rms_match_db{u,1};
    location = rms_match_db{u,2};
    spl_str = num2str(rms_match_db{u,4});

    roi_name = strcat(animal_name,combiner,location,combiner,spl_str);

    if isKey(roi_name_to_units_map,roi_name)
        roi_name_to_units_map(roi_name) = [roi_name_to_units_map(roi_name) u];
    else
        roi_name_to_units_map(roi_name) = [u];
    end
end % u

% make roi db
all_roi_info = struct('roi_name', {}, 'channels', {}, 'bf', {}, 'noise_corr', {});
roi_keynames = keys(roi_name_to_units_map);
counter = 1;
for k = 1:length(roi_keynames)
    roi_name = roi_keynames{k};
    units = roi_name_to_units_map(roi_name);

    channels = zeros(length(units),1);
    bfs = zeros(length(units),1);
    noise_vecs = zeros(35, length(units));

    if length(units) > 1
        for u = 1:length(units)
            unit = units(u);
            
            channels(u) = str2double(rms_match_db{unit,3});
            bfs(u) = rms_match_db{unit,bf_index};
            noise_vecs(:,u) = rms_match_db{unit,14};
        end % u
        
        all_roi_info(counter).roi_name = roi_name;
        all_roi_info(counter).channels = channels;
        all_roi_info(counter).bf = bfs;
        all_roi_info(counter).noise_corr = corrcoef(noise_vecs);

        counter = counter + 1;
    end % if
end % k

% all noise corr pairs
all_pairs_noise_corr = [];
for i = 1:length(all_roi_info)
    roi_noise_corr = all_roi_info(i).noise_corr;
    mask = triu(true(size(roi_noise_corr)), 1);
    triu_noise_corr = roi_noise_corr(mask);

    all_pairs_noise_corr = [all_pairs_noise_corr; triu_noise_corr];
end % i

% Get the left and right extreme
mean_noise_corr = mean(all_pairs_noise_corr);
std_noise_corr = std(all_pairs_noise_corr);
right_extreme = mean_noise_corr + 2*std_noise_corr;
left_extreme = mean_noise_corr - 2*std_noise_corr;

% bins
rebf_bins = 0:0.5:3;

%%%%% MEDIAL %%%%
loc_mat=[[12 16 4 8];[11 15 3 7];[10 14 2 6];[9 13 1 5]];%%%%% CAUDAL %%%%   %%% TO CONVERT FROM ELECTRODE NUMBER TO LOATION
%%%%% LATERAL %%%

%%
dist = [];
for r=0:3
    for c=0:3
            dist = [dist sqrt(r^2 + c^2)*125];
    end
end
dist = unique(nonzeros(dist));
dist = sort(dist);

all_pairs_rebf_vs_dist = zeros(length(dist), length(rebf_bins));
extreme_count = 0;
for i = 1:length(all_roi_info)
    all_channels = all_roi_info(i).channels;
    all_bfs = all_roi_info(i).bf;
    all_noise_corr = all_roi_info(i).noise_corr;

    n_channels = length(all_channels);
    for c1 = 1:n_channels-1
        for c2 = c1+1:n_channels
            nc_c1_c2 = all_noise_corr(c1,c2);
            if nc_c1_c2 > right_extreme || nc_c1_c2 < left_extreme


                extreme_count = extreme_count + 1;

                channel_no1 = all_channels(c1);
                channel_no2 = all_channels(c2);

                num1 = channel_no1; num2 = channel_no2;
                % find the row and column indices of the two numbers in the matrix
                [row1, col1] = ind2sub(size(loc_mat), find(loc_mat == num1));
                [row2, col2] = ind2sub(size(loc_mat), find(loc_mat == num2));

                % calculate the Euclidean distance between the two numbers
                d = sqrt((row1-row2)^2 + (col1-col2)^2)*125;
                dist_index = find(dist == d);


                bf1 = all_bfs(c1);
                bf2 = all_bfs(c2);
                rebf = abs(bf1 - bf2)*0.5;
                rebf_index = find(rebf_bins == rebf);

                all_pairs_rebf_vs_dist(dist_index, rebf_index) = all_pairs_rebf_vs_dist(dist_index, rebf_index) + 1;



            end % if
        end % c2
    end % c1
end


% less than threshold in all_pairs_rebf_vs_dist, make it nan
threshold = 5;
% all_pairs_rebf_vs_dist(find(all_pairs_rebf_vs_dist < threshold)) = nan;

all_pairs_rebf_vs_dist_norm = zeros(length(dist), length(rebf_bins));
% normalise such that sum of each row is 1
for i = 1:length(dist)
    all_pairs_rebf_vs_dist_norm(i,:) = all_pairs_rebf_vs_dist(i,:)/sum(all_pairs_rebf_vs_dist(i,:));
end

figure
    imagesc(all_pairs_rebf_vs_dist_norm)
    alpha = double(~isnan(all_pairs_rebf_vs_dist_norm));
    imagesc(all_pairs_rebf_vs_dist_norm, 'AlphaData', alpha);

    title('all pairs rebf vs dist norm: at a dist(d), sum of all 7 rebf = 1')
    ylabel('dist(d) bins')
    xlabel([scale ' bins'])
    colorbar()
    xticks(1:length(rebf_bins))
    xticklabels(rebf_bins)
    yticks(1:length(dist))
    yticklabels(dist)

% normalise such that each column is 1
all_pairs_rebf_vs_dist_norm = zeros(length(dist), length(rebf_bins));
for i = 1:length(rebf_bins)
    all_pairs_rebf_vs_dist_norm(:,i) = all_pairs_rebf_vs_dist(:,i)./nansum(all_pairs_rebf_vs_dist(:,i));
end

figure
    imagesc(all_pairs_rebf_vs_dist_norm)
    alpha = double(~isnan(all_pairs_rebf_vs_dist_norm));
    imagesc(all_pairs_rebf_vs_dist_norm, 'AlphaData', alpha);

    title('all pairs rebf vs dist norm: at a rebf(r), sum of all 20 dist = 1')
    ylabel('dist(d) bins')
    xlabel([scale ' bins'])
    colorbar()
    xticks(1:length(rebf_bins))
    xticklabels(rebf_bins)
    yticks(1:length(dist))
    yticklabels(dist)
