% Number of cases of HE, HS as a func of re BF
clear;clc; 
disp('Running he_hs_as_func_of_re_bf.m to find he hs as a function of re BF')

% remove non-20 dB from all rms values
% removal_indices = [];
% for u = 1:size(rms_match_db,1)
%     if rms_match_db{u,4} ~= 20
%         removal_indices = [removal_indices u];
%     end
% end
% rms_match_db(removal_indices,:) = [];

all_gender = {'M', 'F'};
all_neuron_types = {'PV', 'SOM', 'Thy'};
all_bf_indices = [11,13];
octaves_apart = -3:0.5:3;
n_octaves_apart = length(octaves_apart);
num_cases_base_re_bf = zeros(2, n_octaves_apart,4); % base how far from BF

% 2 - M,F 3 - octaves apart, 4 - HE, HS, NE, NS

% decide only male or female

for n = 1:length(all_neuron_types)
    for b = 1:length(all_bf_indices)
        for gender_no = 1:2
            neuron_type = all_neuron_types{n};
            bf_index = all_bf_indices(b); % 11 for BF, 13 for BF0

            rms_match_file_path = strcat('E:\RK_E_folder_TTHC_backup\RK TTHC Data\', neuron_type ,'\rms_match_db_with_sig_bf.mat');
            rms_match_db_with_sig_bf = load(rms_match_file_path).rms_match_db_with_sig_bf;
            rms_match_db = rms_match_db_with_sig_bf;
        
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
        
                    num_cases_base_re_bf(gender_no, base_index, indiv_type) = num_cases_base_re_bf(gender_no, base_index, indiv_type) + 1;
                    
                end
            end % u
        
        end % gender_no
        
        type_strs = {'HE', 'HS', 'NE', 'NS'};
        
        if bf_index == 11
            bf_str = 'BF';
        else
            bf_str = 'BF0';
        end

        % chi sq tests
        disp(['Neuron Type = ' neuron_type ' BF index = ' bf_str ])
        for cat = 1:4
            male_data = num_cases_base_re_bf(1,:,cat);
            female_data = num_cases_base_re_bf(2,:,cat);
        
            % direct chi square
            % [h,p] = do_chi_sq(male_data, female_data);
            % disp('Direct chi square')
            % disp(['h = ' num2str(h) ' p = ' num2str(p) ' for ' type_strs{cat}])
        
            % % add +0.5 to both male and female
            % [h,p] = do_chi_sq(male_data + 0.5, female_data + 0.5);
            % disp('+0.5')
            % disp(['h = ' num2str(h) ' p = ' num2str(p) ' for ' type_strs{cat}])
        
        
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
        
        
        
        figure
            for i = 1:4
                subplot(2,2,i)
                both_m_f_each_cat_data = squeeze(num_cases_base_re_bf(:,:,i))';
                for j = 1:2
                    both_m_f_each_cat_data(:,j) = both_m_f_each_cat_data(:,j)./sum(both_m_f_each_cat_data(:,j));
                end
                bar(octaves_apart, both_m_f_each_cat_data, 'grouped')
                xlabel(['Base octaves apart from BF/BF0 - scale ' bf_str])
                ylabel('Prop of cases')
                title(type_strs{i})
                legend('M', 'F')
            end
        
        figure
            for i = 1:4
                subplot(2,2,i)
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
                title([type_strs{i} ' ' neuron_type])
                legend('M', 'F')
            end
        
    end
end % n

