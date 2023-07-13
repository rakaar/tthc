% HC - T1 + T2 / HC + T1 + T2
clear; clc; close all
rms_match_db = load('rms_match_db.mat').rms_match_db;

% find rows where 4th column is not 20
removal_indices = [];
for i = 1:size(rms_match_db,1)
    if rms_match_db{i,4} ~= 20
        removal_indices = [removal_indices i];
    end
end
% remove them
rms_match_db(removal_indices,:) = [];

octaves_apart = -3:0.5:3;
n_octaves_apart = length(octaves_apart);
bf_index = 12; % 12 for Bf, 13 for Bf0

linear_index_re_bf_data = cell(n_octaves_apart,1);

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

        linear_index_num = t1t2_rate - 0.5*(t1_rate + t2_rate);
        linear_index_denom = t1t2_rate + 0.5*(t1_rate + t2_rate);
        linear_index = linear_index_num/linear_index_denom;

        if ~isnan(linear_index)
            % find the octave difference between the two tones
            f_apart_from_bf = (f - bf)*0.5;
            % find the index of the octave difference
            octave_index = find(octaves_apart == f_apart_from_bf);
            
            linear_index_re_bf_data{octave_index,1} = [linear_index_re_bf_data{octave_index,1} linear_index];
        end
    end % f
end % u


% empty the cells where len is less than threshold
threshold = 5;
for i = 1:n_octaves_apart
    if length(linear_index_re_bf_data{i,1}) < threshold
        linear_index_re_bf_data{i,1} = [];
    end
end

% mean and err
mean_linear_index = cellfun(@mean, linear_index_re_bf_data);
err_linear_index = cellfun(@std, linear_index_re_bf_data)./sqrt(cellfun(@length, linear_index_re_bf_data));


% plot
figure
    errorbar(octaves_apart, mean_linear_index, err_linear_index, 'LineWidth', 2, 'Color', 'k')
    title('H - T/ H + T')
    xlabel('Octaves Apart from BF')
    ylabel('Linear Index')
    