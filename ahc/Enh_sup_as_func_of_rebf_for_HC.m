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
octaves_apart = -3:0.25:3;
n_octaves_apart = length(octaves_apart);

num_cases_base_re_bf = zeros(2, n_octaves_apart,4); % base how far from BF
% 2 - M,F 3 - octaves apart, 4 - HE, HS, NE, NS
bf_index = 9; % 12 for BF, 13 for BF0



for gender_no = 1:2
    rms_match_db = load('stage3_db.mat').stage3_db;
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

            all_tone_sig = zeros(13,1);
            all_hc_sig = zeros(13,1);

            spont = [];
            % collect spont
            for f=1:13
                spont = [spont; mean(all_tone_rates{f,1}(:,431:500),2)];
            end % f

            for f=1:13
                f_rates = mean(all_tone_rates{f,1}(:, 501:570),2);
                h = ttest2(spont, f_rates);

                if mean(f_rates) < mean(spont)
                    h = 0;
                end
                if isnan(h)
                    if sum(spont) + sum(f_rates) == 0
                        h = 0;
                    else
                        error('1. h is nan')
                    end
                    
                end
                all_tone_sig(f) = h;
            end % ttest

            spont = [];
            % collect spont
            for f=1:13
                spont = [spont; mean(all_hc_rates{f,1}(:,431:500),2)];
            end % f

            for f=1:13
                f_rates = mean(all_hc_rates{f,1}(:, 501:570),2);
                h = ttest2(spont, f_rates);

                if mean(f_rates) < mean(spont)
                    h = 0;
                end
                
                if isnan(h) 
                    if sum(f_rates) + sum(spont) == 0
                        h = 0;
                    else
                        error('2. h is nan')
                    end
                end
                all_hc_sig(f) = h;

            end % ttest

            
            for f = 1:9
                t1_spike_rates = mean(all_tone_rates{f,1}(:, 501:570),2);
                t2_spike_rates = mean(all_tone_rates{f+4,1}(:,501:570),2);
                t1t2_spike_rates = mean(all_hc_rates{f,1}(:, 501:570), 2);

                t1_mean_rate = mean(t1_spike_rates);
                t2_mean_rate = mean(t2_spike_rates);
                t1t2_mean_rate = mean(t1t2_spike_rates);

                indiv_type = indiv_he_hs_classifier(t1_spike_rates, t2_spike_rates, t1t2_spike_rates, all_tone_sig(f), all_tone_sig(f+4), all_hc_sig(f));
                if isnan(indiv_type)
                disp('HE HS cant be nan')
                    return
                end


                base_oct_apart_from_bf = (f - bf)*0.25;
                second_comp_oct_apart_from_bf = (f + 4 - bf)*0.25;
                
                base_index = 13 + 4*base_oct_apart_from_bf;
                second_comp_index = 13 + 4*second_comp_oct_apart_from_bf;
                
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

%% -----
nhc = load('nhc_enh_sup').num_cases_base_re_bf;
hc = load('hc_enh_sup').num_cases_base_re_bf;

% ---
gen_strs = {'Male', 'Female'};

for g = 1:2
    for c = 1:4
        disp(['Gender =  ' gen_strs{g} ' Type = ' type_strs{c}])
        hdata = squeeze(hc(g,:,c));
        nhdata = squeeze(nhc(g,:,c));

        % chi sq test
        r1 = [];
        r2 = [];

        for f = 1:13
            if sum(hdata(f) + nhdata(f)) ~= 0
                
            r1 = [r1 hdata(f)];
            r2 = [r2 nhdata(f)];
            end

         end

        [h,p] = chi_sq_test_of_ind([r1;r2]);
        disp(['chi sq test: h = ' num2str(h) ' p = ' num2str(p)])
    end
end