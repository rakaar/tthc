% HC - T1 + T2 / HC + T1 + T2
clear; clc; close all
rms_match_db = load('rms_match_db.mat').rms_match_db;

% find rows where 4th column is not 20
% removal_indices = [];
% for i = 1:size(rms_match_db,1)
%     if rms_match_db{i,4} ~= 20
%         removal_indices = [removal_indices i];
%     end
% end
% remove them
% rms_match_db(removal_indices,:) = [];

octaves_apart = -3:0.5:3;
n_octaves_apart = length(octaves_apart);
bf_index = 12; % 12 for Bf, 13 for Bf0

linear_index_re_bf_data_pos = cell(n_octaves_apart,1);
linear_index_re_bf_data_neg = cell(n_octaves_apart,1);

for u = 1:size(rms_match_db,1)
    bf = rms_match_db{u,bf_index};
    if bf == -1
        continue
    end 

    all_tone_rates = rms_match_db{u,6};
    all_hc_rates = rms_match_db{u,7};

    for f = 1:5
        t1_rate = mean(mean(all_tone_rates{f,1}(:, 501:570),2));
        t2_rate = mean(mean(all_tone_rates{f+2,1}(:, 501:570),2));
        t1t2_rate = mean(mean(all_hc_rates{f,1}(:, 501:570),2));

        linear_index_num = t1t2_rate - max(t1_rate, t2_rate);
        linear_index_denom = t1t2_rate + max(t1_rate, t2_rate);
        linear_index = linear_index_num/linear_index_denom;

        if ~isnan(linear_index)
            % find the octave difference between the two tones
            f_apart_from_bf = (f - bf)*0.5;
            % find the index of the octave difference
            octave_index = find(octaves_apart == f_apart_from_bf);
            if linear_index >= 0
                linear_index_re_bf_data_pos{octave_index,1} = [linear_index_re_bf_data_pos{octave_index,1} linear_index];
            else
                linear_index_re_bf_data_neg{octave_index,1} = [linear_index_re_bf_data_neg{octave_index,1} linear_index];
            end
            
        end
    end % f
end % u


% empty the cells where len is less than threshold
threshold = 10;
for i = 1:n_octaves_apart
    if length(linear_index_re_bf_data_pos{i,1}) < threshold
        linear_index_re_bf_data_pos{i,1} = [];
    end

    if length(linear_index_re_bf_data_neg{i,1}) < threshold
        linear_index_re_bf_data_neg{i,1} = [];
    end
end

% mean and err
mean_linear_index_pos = cellfun(@mean, linear_index_re_bf_data_pos);
err_linear_index_pos = cellfun(@std, linear_index_re_bf_data_pos)./sqrt(cellfun(@length, linear_index_re_bf_data_pos));

mean_linear_index_neg = cellfun(@mean, linear_index_re_bf_data_neg);
err_linear_index_neg = cellfun(@std, linear_index_re_bf_data_neg)./sqrt(cellfun(@length, linear_index_re_bf_data_neg));



% plot
figure
    errorbar(octaves_apart, mean_linear_index_pos, err_linear_index_pos, 'LineWidth', 2, 'Color', 'k')
    title('Pos H - max T/ H + max T')
    xlabel('Octaves Apart from BF')
    ylabel('Linear Index')

figure
    errorbar(octaves_apart, mean_linear_index_neg, err_linear_index_neg, 'LineWidth', 2, 'Color', 'k')
    title('Neg H - max T/ H + max T')
    xlabel('Octaves Apart from BF')
    ylabel('Linear Index')

% ttest results
% each cell of pos and neg linear index is neg or not
pos_ttest_h_p = nan(n_octaves_apart,2);
neg_ttest_h_p = nan(n_octaves_apart,2);
for i = 1:n_octaves_apart
    if ~isempty(linear_index_re_bf_data_pos{i,1})
        [pos_ttest_h_p(i,1), pos_ttest_h_p(i,2)] = ttest(linear_index_re_bf_data_pos{i,1});
    end

    if ~isempty(linear_index_re_bf_data_neg{i,1})
        [neg_ttest_h_p(i,1), neg_ttest_h_p(i,2)] = ttest(linear_index_re_bf_data_neg{i,1});
    end
end

% display a table of h and p values with octaves_apart as row names
pos_ttest_h_p_table = array2table(pos_ttest_h_p, 'VariableNames', {'h', 'p'}, 'RowNames', string(octaves_apart));
neg_ttest_h_p_table = array2table(neg_ttest_h_p, 'VariableNames', {'h', 'p'}, 'RowNames', string(octaves_apart));

% print those tables
disp('Pos H - max T/ H + max T')
display(pos_ttest_h_p_table)

disp('Neg H - max T/ H + max T')
display(neg_ttest_h_p_table)