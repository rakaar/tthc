% Harmonic rates vs rebf
clear;close all;clc;
rms_match_db = load('rms_match_db.mat').rms_match_db;

% find rows where 4th column is not 20 to remove non-20dB rows
removal_indices = [];
for u = 1:size(rms_match_db,1)
    if rms_match_db{u,4} ~= 20
        removal_indices = [removal_indices;u];
    end % if
end % u
rms_match_db(removal_indices,:) = [];

octaves_apart = -3:0.5:3;
n_octaves_apart = length(octaves_apart);
hc_rates_vs_rebf = cell(n_octaves_apart,1);
norm_hc_rates_vs_rebf = cell(n_octaves_apart,1);

bf_index = 12; % 12 for BF, 13 for Bf0
for u = 1:size(rms_match_db,1)
    bf = rms_match_db{u,bf_index};
    if bf == -1
        continue
    end 

    all_hc_rates = rms_match_db{u,7};
    abs_hc_mean_rates = zeros(7,1);
    for f=1:7
        hc_f_spike_rates5 = mean(mean(all_hc_rates{f,1}(:,501:570),2));
        hc_f_mean_rate = mean(hc_f_spike_rates5);
        abs_hc_mean_rates(f) = hc_f_mean_rate;

        f_re_bf = (f - bf)*0.5;
        re_index = find(octaves_apart == 0) + 2*f_re_bf;

        hc_rates_vs_rebf{re_index,1} = [hc_rates_vs_rebf{re_index,1}; 1000*hc_f_mean_rate];
    end

    % normalize
    norm_hc_mean_rates = abs_hc_mean_rates./max(abs_hc_mean_rates);
    if ~anynan(norm_hc_mean_rates)
        for f = 1:7
            f_re_bf = (f - bf)*0.5;
            re_index = find(octaves_apart == 0) + 2*f_re_bf;
            norm_hc_rates_vs_rebf{re_index,1} = [norm_hc_rates_vs_rebf{re_index,1}; norm_hc_mean_rates(f)];
            
        end    
    end

    

end % u

% remove less than threshold
threshold = 5;
for i = 1:n_octaves_apart
    if length(hc_rates_vs_rebf{i,1}) < threshold
        hc_rates_vs_rebf{i,1} = [];
    end
end


% plot
mean_hc_rates_vs_bf = cellfun(@mean,hc_rates_vs_rebf);
err_hc_rates_vs_bf = cellfun(@std,hc_rates_vs_rebf)./sqrt(cellfun(@length,hc_rates_vs_rebf));
figure
    errorbar(octaves_apart,mean_hc_rates_vs_bf,err_hc_rates_vs_bf,'k','LineWidth',2)
    title('Rates vs re BF')
    xlabel('Octaves apart from BF')
    ylabel('Mean rate (Hz)')

mean_norm_hc_rates_vs_bf = cellfun(@mean,norm_hc_rates_vs_rebf);
err_norm_hc_rates_vs_bf = cellfun(@std,norm_hc_rates_vs_rebf)./sqrt(cellfun(@length,norm_hc_rates_vs_rebf));
figure
    errorbar(octaves_apart,mean_norm_hc_rates_vs_bf,err_norm_hc_rates_vs_bf,'k','LineWidth',2)
    title('Norm rates vs re BF')
    xlabel('Octaves apart from BF')
    ylabel('Mean rate (Hz)')