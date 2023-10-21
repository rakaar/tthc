% Number of cases of HE, HS as a func of re BF
clear;clc;close all;

% remove non-20 dB from all rms values
% removal_indices = [];
% for u = 1:size(rms_match_db,1)
%     if rms_match_db{u,4} ~= 20
%         removal_indices = [removal_indices u];
%     end
% end
% rms_match_db(removal_indices,:) = [];

all_gender = {'M', 'F'};
octaves_apart = -3:0.5:3;
n_octaves_apart = length(octaves_apart);

num_cases_base_re_bf = zeros(2, n_octaves_apart,4); % base how far from BF
% 2 - M,F 3 - octaves apart, 4 - HE, HS, NE, NS
bf_index = 13; % 12 for BF, 13 for BF0

for gender_no = 1:2
    rms_match_db = load('rms_match_db.mat').rms_match_db;
        % decide only male or female
        animal_gender = all_gender{gender_no}; % M for Male, F for Female, all for both
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



        for u = 1:size(rms_match_db,1)
            bf = rms_match_db{u,bf_index};
            if bf == -1
                continue
            end

            % for u = 1:1
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

                num_cases_base_re_bf(gender_no, base_index, indiv_type) = num_cases_base_re_bf(gender_no, base_index, indiv_type) + 1;
            end
        end % u

end % gender_no


% tests
type_strs = {'HE', 'HS', 'NE', 'NS'};

disp('Repeating numbers ks test')
for cat = 1:4
    male_data = num_cases_base_re_bf(1,:,cat);
    female_data = num_cases_base_re_bf(2,:,cat);

     % kstest
     male_data_for_kstest = [];
     female_data_for_kstest = [];
     for i = 1:n_octaves_apart
        male_data_for_kstest = [male_data_for_kstest octaves_apart(i)*ones(1,male_data(i))];
        female_data_for_kstest = [female_data_for_kstest octaves_apart(i)*ones(1, female_data(i))];
    end
    [h,p] = kstest2(male_data_for_kstest, female_data_for_kstest);
     disp('kstest2 ')
     disp(['h = ' num2str(h) ' p = ' num2str(p) ' for ' type_strs{cat}])
    
end % cat

% plot

if bf_index == 12
    bf_str = 'BF';
else
    bf_str = 'BF0';
end


for i = 1:4
    figure
    both_m_f_each_cat_data = squeeze(num_cases_base_re_bf(:,:,i))';
    for j = 1:2
        both_m_f_each_cat_data(:,j) = both_m_f_each_cat_data(:,j)./sum(both_m_f_each_cat_data(:,j));
    end
    bar(octaves_apart, both_m_f_each_cat_data, 'grouped')
    xlabel(['Base octaves apart from BF/BF0 - scale ' bf_str])
    ylabel('Prop of cases')
    title([type_strs{i} ])
    legend('M', 'F')
    % saveas(gcf,['E:\RK_E_folder_TTHC_backup\RK TTHC figs eps\figEphys\' bf_str '_' type_strs{i}  '_he_hs_as_func_of_re_bf_histogram.fig'])
end


figure
for i = 1:4
    figure
    both_m_f_each_cat_data = squeeze(num_cases_base_re_bf(:,:,i))';
    for j = 1:2
        both_m_f_each_cat_data(:,j) = both_m_f_each_cat_data(:,j)./sum(both_m_f_each_cat_data(:,j));
    end
    hold on
        plot(cumsum(both_m_f_each_cat_data(:,1)), 'LineWidth', 2, 'Color', 'b')
        plot(cumsum(both_m_f_each_cat_data(:,2)), 'LineWidth', 2, 'Color', 'r')
    hold off
    xlabel(['Base octaves apart from BF/BF0 - scale ' bf_str])
    ylabel('Cum sum of prop')
    title([type_strs{i}])
    legend('M', 'F')
    % saveas(gcf,['E:\RK_E_folder_TTHC_backup\RK TTHC figs eps\figEphys\' bf_str '_' type_strs{i}  '_he_hs_as_func_of_re_bf_cdf.fig'])
end

disp('KS test btn CDFs')
for i = 1:4
    
    both_m_f_each_cat_data = squeeze(num_cases_base_re_bf(:,:,i))';
    for j = 1:2
        both_m_f_each_cat_data(:,j) = both_m_f_each_cat_data(:,j)./sum(both_m_f_each_cat_data(:,j));
    end
    
    male_cumsum = cumsum(both_m_f_each_cat_data(:,1));
    female_cumsum = cumsum(both_m_f_each_cat_data(:,2));
    
    [h,p] = kstest2(male_cumsum, female_cumsum);
    disp(['h = ' num2str(h) ' p = ' num2str(p) ' for ' type_strs{i}])
end