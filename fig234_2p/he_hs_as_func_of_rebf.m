% Number of cases of HE, HS as a func of re BF
clear;clc; close all
disp('Running he_hs_as_func_of_re_bf.m to find he hs as a function of re BF')
rms_match_file_path = 'E:\RK_E_folder_TTHC_backup\RK TTHC Data\Thy\rms_match_db_with_sig_bf.mat';
rms_match_db_with_sig_bf = load(rms_match_file_path).rms_match_db_with_sig_bf;
rms_match_db = rms_match_db_with_sig_bf;

% remove non-20 dB from all rms values
% removal_indices = [];
% for u = 1:size(rms_match_db,1)
%     if rms_match_db{u,4} ~= 20
%         removal_indices = [removal_indices u];
%     end
% end
% rms_match_db(removal_indices,:) = [];

octaves_apart = -3:0.5:3;
n_octaves_apart = length(octaves_apart);


num_cases_base_re_bf = zeros(n_octaves_apart,4); % base how far from BF

bf_index = 11; % 11 for BF, 13 for BF0

for u = 1:size(rms_match_db,1)
    bf = rms_match_db{u,bf_index};
    if bf == -1
        continue
    end

    % for u = 1:1
    all_tone_rates = rms_match_db{u,8};
    all_hc_rates = rms_match_db{u,9};
    all_tone_sig = rms_match_db{u,10};
    all_hc_sig = rms_match_db{u,12};

    all_tone_sig(find(all_tone_sig == -1)) = 0;
    all_hc_sig(find(all_hc_sig == -1)) = 0;

    if anynan(all_tone_sig) || anynan(all_hc_sig)
        continue
    end

    
    for f = 1:5
        t1_spike_rates = mean(all_tone_rates{f,1}(:, 10:14),2);
        t2_spike_rates = mean(all_tone_rates{f+2,1}(:,10:14),2);
        t1t2_spike_rates = mean(all_hc_rates{f,1}(:, 10:14), 2);

        t1_mean_rate = mean(t1_spike_rates);
        t2_mean_rate = mean(t2_spike_rates);
        t1t2_mean_rate = mean(t1t2_spike_rates);

        indiv_type = indiv_he_hs_classifier(t1_spike_rates, t2_spike_rates, t1t2_spike_rates, all_tone_sig(f), all_tone_sig(f+2), all_hc_sig(f));
        if isnan(indiv_type)
           disp('HE HS cant be nan')
            return
        end


        base_oct_apart_from_bf = (f - bf)*0.5;
        second_comp_oct_apart_from_bf = (f + 2 - bf)*0.5;
        
        base_index = 7 + 2*base_oct_apart_from_bf;
        second_comp_index = 7 + 2*second_comp_oct_apart_from_bf;
        min_index = 1 + 2*min(abs(base_oct_apart_from_bf), abs(second_comp_oct_apart_from_bf));

        num_cases_base_re_bf(base_index, indiv_type) = num_cases_base_re_bf(base_index, indiv_type) + 1;
        
    end
end % u

% plot
type_strs = {'HE', 'HS', 'NE', 'NS'};
if bf_index == 11
    bf_str = 'BF';
else
    bf_str = 'BF0';
end
figure
    for i = 1:4
        subplot(2,2,i)
        bar(octaves_apart, num_cases_base_re_bf(:,i))
        title(type_strs{i})
        xlabel(['Base octaves apart from BF/BF0 - scale ' bf_str])
        ylabel('Number of cases')
        title(type_strs{i})
    end
figure
    for i = 1:4
        subplot(2,2,i)
        bar(octaves_apart, num_cases_base_re_bf(:,i)./sum(num_cases_base_re_bf(:,i)))
        title(type_strs{i})
        xlabel(['Base octaves apart from BF/BF0 - scale ' bf_str])
        ylabel('Number of cases')
        title(type_strs{i})
    end

