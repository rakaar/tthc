% calculate H - max(T1,T2)/H + max(T1, T2)
clc;clear;close all
disp('Running linear_index_sep_pos_neg.m - calculate Harmonic Mod Index as func of re BF')

% load stage3 db
stage3_db = load('stage3_db.mat').stage3_db;
stage1_db = load('stage1_db.mat').stage1_db;
f13 = load('f13.mat').f13;

% decide only male or female
animal_gender = 'all'; % M for Male, F for Female, all for both
if strcmp(animal_gender, 'M')
    rejected_gender = 'F';
elseif strcmp(animal_gender, 'F')
    rejected_gender = 'M';
else
    rejected_gender = nan;
end

removal_indices = [];
if ~isnan(rejected_gender)
    for u = 1:size(stage3_db,1)
        animal_name = stage3_db{u,1};
        % if animal name includes _{rejected_gender} add it to removal index
        if contains(animal_name, strcat('_',rejected_gender))
            removal_indices = [removal_indices; u];
        end
    end % u
end

% remove rejected gender
stage3_db(removal_indices,:) = [];

bf_or_bf0 = 'BF'; % BF or BF0
if strcmp(bf_or_bf0, 'BF')
    bf_index = 9;
elseif strcmp(bf_or_bf0, 'BF0')
    bf_index = 10;
else
    bf_index = nan;
end

% HMI's harmonic modulation index
octaves_apart = -3:0.25:3;
n_octaves_apart = length(octaves_apart);

pos_hmi = cell(n_octaves_apart, 5); 
neg_hmi = cell(n_octaves_apart, 5);
% 1 - 2(1/2)
% 2 - 0.25(4)
% 3 - 0.5(3)
% 4 - 1.25(6) 
% 5 - 1.75(5)

mapping_from_db_ind_to_hmi_ind = containers.Map({1,2,3,4,5,6}, {1,1,3,2,5,4});
% iter over stage3_db
for u = 1:size(stage3_db,1)
    bf = stage3_db{u, bf_index};
    if bf == -1
        continue
    end

    tone_rates = stage3_db{u,6};
    ahc_units = stage3_db{u,8};

    for au = 1:length(ahc_units)
        ahc_unit = ahc_units(au);
        ahc_stim = stage1_db{ahc_unit, 6};
        ahc_rates = stage1_db{ahc_unit, 7};

        for f = 1:6
            base_f = ahc_stim(1,f);
            base_f_index = my_find(f13, base_f);

            second_f = ahc_stim(2,f);
            second_f_index = my_find(f13, second_f);

            if isnan(base_f_index) || isnan(second_f_index)
                if base_f < 48e3 && second_f < 48e3
                    disp('One of the frequencies is not in the f13 list')
                end
                continue
            end

            oct_apart = (base_f_index - bf)*0.25;
            oct_apart_index = find(octaves_apart == oct_apart);
            db_ind = mapping_from_db_ind_to_hmi_ind(f);

            t1_rate = mean(mean(tone_rates{base_f_index,1}(:, 501:570),2));
            t2_rate = mean(mean(tone_rates{second_f_index,1}(:, 501:570),2));
            t1t2_rate = mean(mean(ahc_rates{f,1}(:, 501:570),2));

            hmi_num = t1t2_rate - max(t1_rate, t2_rate);
            hmi_den = t1t2_rate + max(t1_rate, t2_rate);
            hmi_frac = hmi_num/hmi_den;

            if ~isnan(hmi_frac)
                if hmi_frac > 0
                    pos_hmi{oct_apart_index, db_ind} = [pos_hmi{oct_apart_index, db_ind}; hmi_frac];
                elseif hmi_frac < 0
                    neg_hmi{oct_apart_index, db_ind} = [neg_hmi{oct_apart_index, db_ind}; hmi_frac];
                end
            end

        end % f


    end % au 
end % u

% In each cell, if len < threshold, make it empty
threshold = 10;
for o = 1:n_octaves_apart
    for db_ind = 1:5
        if length(pos_hmi{o, db_ind}) < threshold
            pos_hmi{o, db_ind} = [];
        end
        if length(neg_hmi{o, db_ind}) < threshold
            neg_hmi{o, db_ind} = [];
        end
    end
end

% mean and err using cell fun on both hmis
pos_hmi_mean = cellfun(@mean, pos_hmi);
pos_hmi_err = cellfun(@std, pos_hmi)./sqrt(cellfun(@length, pos_hmi));

neg_hmi_mean = cellfun(@mean, neg_hmi);
neg_hmi_err = cellfun(@std, neg_hmi)./sqrt(cellfun(@length, neg_hmi));

% plot pos hmi and neg hmi seperately
figure
    errorbar(octaves_apart, pos_hmi_mean, pos_hmi_err, 'LineWidth', 2)
    xlabel(['Base freq Octaves Apart from ' bf_or_bf0])
    ylabel('HMI')
    title('Positive HMI: T1T2 - max(T1,T2)/T1T2 + max(T1, T2)')
    legend('HC', '0.25', '0.5', '1.25', '1.75')

figure
    errorbar(octaves_apart, neg_hmi_mean, neg_hmi_err, 'LineWidth', 2)
    xlabel(['Base freq Octaves Apart from ' bf_or_bf0])
    ylabel('HMI')
    title('Negative HMI: T1T2 - max(T1,T2)/T1T2 + max(T1, T2)')
    legend('HC', '0.25', '0.5', '1.25', '1.75')

% keep 1 as 1, group 2,3 in 2 and 4,5 in 3 
pos_hmi_grouped = cell(n_octaves_apart,3);
for o = 1:n_octaves_apart
   pos_hmi_grouped{o,1} = pos_hmi{o,1};
    pos_hmi_grouped{o,2} = [pos_hmi{o,2}; pos_hmi{o,3}];
    pos_hmi_grouped{o,3} = [pos_hmi{o,4}; pos_hmi{o,5}];
end

neg_hmi_grouped = cell(n_octaves_apart,3);
for o = 1:n_octaves_apart
   neg_hmi_grouped{o,1} = neg_hmi{o,1};
    neg_hmi_grouped{o,2} = [neg_hmi{o,2}; neg_hmi{o,3}];
    neg_hmi_grouped{o,3} = [neg_hmi{o,4}; neg_hmi{o,5}];
end

% mean and err using cell fun on both hmis
pos_hmi_grouped_mean = cellfun(@mean, pos_hmi_grouped);
pos_hmi_grouped_err = cellfun(@std, pos_hmi_grouped)./sqrt(cellfun(@length, pos_hmi_grouped));

neg_hmi_grouped_mean = cellfun(@mean, neg_hmi_grouped);
neg_hmi_grouped_err = cellfun(@std, neg_hmi_grouped)./sqrt(cellfun(@length, neg_hmi_grouped));

% plot both seperately like before
figure
    errorbar(octaves_apart, pos_hmi_grouped_mean, pos_hmi_grouped_err, 'LineWidth', 2)
    xlabel(['Base freq Octaves Apart from ' bf_or_bf0])
    ylabel('HMI')
    title('Positive HMI: T1T2 - max(T1,T2)/T1T2 + max(T1, T2)')
    legend('HC', '0.25, 0.5', '1.25, 1.75')

figure
    errorbar(octaves_apart, neg_hmi_grouped_mean, neg_hmi_grouped_err, 'LineWidth', 2)
    xlabel(['Base freq Octaves Apart from ' bf_or_bf0])
    ylabel('HMI')
    title('Negative HMI: T1T2 - max(T1,T2)/T1T2 + max(T1, T2)')
    legend('HC', '0.25, 0.5', '1.25, 1.75')

% tests btn H and low and High
h_and_p_for_pos_hmi = zeros(n_octaves_apart,2);
h_and_p_for_neg_hmi = zeros(n_octaves_apart,2);
% btn 1 and 2
for o = 1:n_octaves_apart
    if ~isempty(pos_hmi_grouped{o,1}) && ~isempty(pos_hmi_grouped{o,2})
        [h_and_p_for_pos_hmi(o,1), h_and_p_for_pos_hmi(o,2)] = ttest2(pos_hmi_grouped{o,1}, pos_hmi_grouped{o,2});
    end

    if ~isempty(neg_hmi_grouped{o,1}) && ~isempty(neg_hmi_grouped{o,2})
        [h_and_p_for_neg_hmi(o,1), h_and_p_for_neg_hmi(o,2)] = ttest2(neg_hmi_grouped{o,1}, neg_hmi_grouped{o,2});
    end
end
disp('In Positive HMI, H and p values for HC vs 0.25, 0.5(Low)')
% disp h and p vals of pos hmi and neg hmi the above as a table with  octaves apart as rows
disp([octaves_apart', h_and_p_for_pos_hmi])

disp('In Negative HMI, H and p values for HC vs 0.25, 0.5(Low)')
disp([octaves_apart', h_and_p_for_neg_hmi])

h_and_p_for_pos_hmi = zeros(n_octaves_apart,2);
h_and_p_for_neg_hmi = zeros(n_octaves_apart,2);
% btn 1 and 3
for o = 1:n_octaves_apart
    if ~isempty(pos_hmi_grouped{o,1}) && ~isempty(pos_hmi_grouped{o,3})
        [h_and_p_for_pos_hmi(o,1), h_and_p_for_pos_hmi(o,2)] = ttest2(pos_hmi_grouped{o,1}, pos_hmi_grouped{o,3});
    end

    if ~isempty(neg_hmi_grouped{o,1}) && ~isempty(neg_hmi_grouped{o,3})
        [h_and_p_for_neg_hmi(o,1), h_and_p_for_neg_hmi(o,2)] = ttest2(neg_hmi_grouped{o,1}, neg_hmi_grouped{o,3});
    end
end

disp('In Positive HMI, H and p values for HC vs 1.25, 1.75(High)')
disp([octaves_apart', h_and_p_for_pos_hmi])
disp('In Negative HMI, H and p values for HC vs 1.25, 1.75(High)')
disp([octaves_apart', h_and_p_for_neg_hmi])