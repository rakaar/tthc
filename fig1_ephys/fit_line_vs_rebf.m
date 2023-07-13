% try fitting line and see how well it fits at different rebfs
clc;clear;close all;
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

all_triplets = cell(n_octaves_apart, 1);

for u = 1:size(rms_match_db,1)
    bf = rms_match_db{u,bf_index};
    if bf == -1
        continue
    end

    all_tone_rates = rms_match_db{u,6};
    all_hc_rates = rms_match_db{u,7};
    all_tone_sig = rms_match_db{u,8};
    all_hc_sig = rms_match_db{u,9};

    
    for f = 1:5
        t1_spike_rates = mean(all_tone_rates{f,1}(:, 501:570),2);
        t2_spike_rates = mean(all_tone_rates{f+2,1}(:,501:570),2);
        t1t2_spike_rates = mean(all_hc_rates{f,1}(:, 501:570), 2);

        t1_mean_rate = mean(t1_spike_rates);
        t2_mean_rate = mean(t2_spike_rates);
        t1t2_mean_rate = mean(t1t2_spike_rates);

        
        base_oct_apart_from_bf = (f - bf)*0.5;
        oct_index = find(octaves_apart == base_oct_apart_from_bf);

        all_triplets{oct_index, 1} = [all_triplets{oct_index, 1};  [t1_mean_rate t2_mean_rate t1t2_mean_rate]];

    end
end % u

% remove less than threshold
threshold = 5;
for i = 1:n_octaves_apart
    if length(all_triplets{i,1}) < threshold
        all_triplets{i,1} = [];
    end
end


% line fit
alpha_beta_gamma = zeros(n_octaves_apart, 3);
err = nan(n_octaves_apart, 1);


for i = 1:n_octaves_apart
    if isempty(all_triplets{i,1})
        continue
    end
    x = all_triplets{i,1}(:,1);
    y = all_triplets{i,1}(:,2);
    R = all_triplets{i,1}(:,3);
    
    % Assuming x, y, R are your data vectors of size n x 1
    tbl = table(x, y, R, 'VariableNames', {'x', 'y', 'R'});
    lm = fitlm(tbl, 'R ~ x + y');
    coeffs = lm.Coefficients.Estimate;
    rsquared = lm.Rsquared.Ordinary;

    alpha_beta_gamma(i,:)  = coeffs';
    err(i) = rsquared;

end

% plot
figure
    bar(octaves_apart, err)
    title('err for line fit')
    xlabel('octaves apart')
    ylabel('err')

