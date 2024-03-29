% Number of cases of HE, HS as a func of re BF
clear;clc; 
disp('Running he_hs_as_func_of_re_bf.m to find he hs as a function of re BF')

data_path = '/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC Data/';
figs_path = '/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC figs eps/';


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

            rms_match_file_path = strcat(data_path, neuron_type ,'/rms_match_db_with_sig_bf.mat');
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

        for i = 1:4
            disp(['i= ' num2str(i)])
            figure
            % both_m_f_each_cat_data = squeeze(num_cases_base_re_bf(:,:,i))';
            % for j = 1:2
            %     both_m_f_each_cat_data(:,j) = both_m_f_each_cat_data(:,j)./sum(both_m_f_each_cat_data, 'all');
            % end
            both_m_f_each_cat_data = zeros(13,1);
            for r = 1:13
                mf_sum = sum(num_cases_base_re_bf(:,r,i));
                if sum(num_cases_base_re_bf(:,r,:), 'all') >= 50
                    both_m_f_each_cat_data(r) = mf_sum/sum(num_cases_base_re_bf(:,r,:), 'all');
                else
                    disp(['Not enuf ' num2str(r)])
                    both_m_f_each_cat_data(r) = nan;
                end
                
            end
            % both_m_f_each_cat_data = (num_cases_base_re_bf(1:2, :, i)./sum(num_cases_base_re_bf(:, :, i), 'all'))';
            % bar(octaves_apart, both_m_f_each_cat_data, 'grouped')
            bar(-2:0.5:2, both_m_f_each_cat_data(3:11))
            xlabel(['Base octaves apart from BF/BF0 - scale ' bf_str])
            ylabel('Prop of cases')
            title([type_strs{i} ])
            % legend('M', 'F')
            saveas(gcf,['/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC figs eps/supplmentary_he_hs_ne_ns/' all_neuron_types{n}, '/' bf_str '_' type_strs{i}  '_he_hs_as_func_of_re_bf_norm_by_total.fig'])
        end
        continue
        for i = 1:4
            figure
            % both_m_f_each_cat_data = squeeze(num_cases_base_re_bf(:,:,i))';
            
            both_m_f_each_cat_data = (num_cases_base_re_bf(1:2, :, i)./sum(num_cases_base_re_bf(:, :, i), 'all'))';
            
            bar(octaves_apart, both_m_f_each_cat_data, 'grouped')
            xlabel(['Base octaves apart from BF/BF0 - scale ' bf_str])
            ylabel('Prop of cases')
            title([type_strs{i} ])
            legend('M', 'F')
            saveas(gcf,['/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC figs eps/supplmentary_he_hs_ne_ns/' all_neuron_types{n}, '/' bf_str '_' type_strs{i}  '_he_hs_as_func_of_re_bf_norm_by_total.fig'])
        end

        % save - gender_neuron_bf_str
        save([all_gender{gender_no} '_' all_neuron_types{n} '_' bf_str '_cats'], 'num_cases_base_re_bf')
        disp([all_gender{gender_no} '_' all_neuron_types{n} '_' bf_str '_cats'])
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
        
        
        
        
            for i = 1:4
                figure
                both_m_f_each_cat_data = squeeze(num_cases_base_re_bf(:,:,i))';
                for j = 1:2
                    both_m_f_each_cat_data(:,j) = both_m_f_each_cat_data(:,j)./sum(both_m_f_each_cat_data(:,j));
                end
                bar(octaves_apart, both_m_f_each_cat_data, 'grouped')
                xlabel(['Base octaves apart from BF/BF0 - scale ' bf_str])
                ylabel('Prop of cases')
                title([type_strs{i} ' ' neuron_type])
                legend('M', 'F')
       
                % saveas(gcf,[figs_path, 'fig', neuron_type, '_sept13/'  'neuron_'  neuron_type, '_base_'  bf_str '_case_' type_strs{i} '_he_hs_as_func_of_re_bf_histogram.fig'])
        
            end
            
       
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
                title([type_strs{i} ' ' neuron_type])
                legend('M', 'F')
                % saveas(gcf,[figs_path, 'fig', neuron_type, '_sept13/'  'neuron_'  neuron_type, '_base_'  bf_str '_case_' type_strs{i} '_he_hs_as_func_of_re_bf_cdf.fig'])
            end


            disp('KS test btn CDFs')
            disp(['Neuron type: ' all_neuron_types{n} ' Scale: '  bf_str])
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
            % TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP %
            close all;
        
    end
end % n

return

all_neuron_types = {'PV', 'SOM', 'Thy'};
for n = 1:3
    neuron_type = all_neuron_types{n};
    % F_PV_BF_cats.mat
    filename = sprintf('F_%s_BF_cats', neuron_type);
    data = load(filename).num_cases_base_re_bf;

    disp('------------------')
    disp(neuron_type)
    disp('!!! Male !!!')
    data1 = squeeze(data(1,:,:));
    data1_sum = sum(data1,1);
    disp(['HE % = ' num2str(data1_sum(1)/sum(data1_sum))])
    disp(['HS % = ' num2str(data1_sum(2)/sum(data1_sum))])
    disp(['NE % = ' num2str(data1_sum(3)/sum(data1_sum))])
    disp(['NS % = ' num2str(data1_sum(4)/sum(data1_sum))])

    disp('!!! Female !!!')
    data1 = squeeze(data(2,:,:));
    data1_sum = sum(data1,1);
    disp(['HE % = ' num2str(data1_sum(1)/sum(data1_sum))])
    disp(['HS % = ' num2str(data1_sum(2)/sum(data1_sum))])
    disp(['NE % = ' num2str(data1_sum(3)/sum(data1_sum))])
    disp(['NS % = ' num2str(data1_sum(4)/sum(data1_sum))])

    disp('!!! All !!!')
    data1 = squeeze(sum(data,1));
    data1_sum = sum(data1,1);
    disp(['HE % = ' num2str(data1_sum(1)/sum(data1_sum))])
    disp(['HS % = ' num2str(data1_sum(2)/sum(data1_sum))])
    disp(['NE % = ' num2str(data1_sum(3)/sum(data1_sum))])
    disp(['NS % = ' num2str(data1_sum(4)/sum(data1_sum))])

    disp('----------------')
end