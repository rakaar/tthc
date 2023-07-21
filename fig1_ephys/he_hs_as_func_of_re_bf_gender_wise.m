% Number of cases of HE, HS as a func of re BF
clear;clc;close all;
rms_match_db = load('rms_match_db.mat').rms_match_db;

% remove non-20 dB from all rms values
% removal_indices = [];
% for u = 1:size(rms_match_db,1)
%     if rms_match_db{u,4} ~= 20
%         removal_indices = [removal_indices u];
%     end
% end
% rms_match_db(removal_indices,:) = [];

% decide only male or female
animal_gender = 'F'; % M for Male, F for Female, all for both
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


octaves_apart = -3:0.5:3;
n_octaves_apart = length(octaves_apart);

num_cases_base_re_bf = zeros(n_octaves_apart,4); % base how far from BF
num_cases_second_comp_re_bf = zeros(n_octaves_apart,4); % second comp from BF
num_cases_min_re_bf = zeros((n_octaves_apart-1)/2 + 1, 4); % min distance of either components from BF

bf_index = 12; % 12 for BF, 13 for BF0

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

        num_cases_base_re_bf(base_index, indiv_type) = num_cases_base_re_bf(base_index, indiv_type) + 1;
        num_cases_second_comp_re_bf(second_comp_index, indiv_type) = num_cases_second_comp_re_bf(second_comp_index, indiv_type) + 1;
        num_cases_min_re_bf(min_index, indiv_type) = num_cases_min_re_bf(min_index, indiv_type) + 1;
        
    end
end % u

% plot
type_strs = {'HE', 'HS', 'NE', 'NS'};
if bf_index == 12
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

num_cases_base_re_bf_norm = zeros(n_octaves_apart,4);
for i = 1:4
    num_cases_base_re_bf_norm(:,i) = num_cases_base_re_bf(:,i)./sum(num_cases_base_re_bf(:,i));
end
save(strcat(animal_gender, '_hehs_rebf'), 'num_cases_base_re_bf_norm')
% figure
%     for i = 1:4
%         subplot(2,2,i)
%         bar(octaves_apart, num_cases_second_comp_re_bf(:,i))
%         title(type_strs{i})
%         xlabel(['Second octaves apart from BF/BF0 - scale ' bf_str])
%         ylabel('Number of cases')
%         title(type_strs{i})
%     end

% figure
%     for i = 1:4
%         subplot(2,2,i)
%         bar(0:0.5:3, num_cases_min_re_bf(:,i))
%         title(type_strs{i})
%         xlabel(['Min octaves apart from BF/BF0 - scale ' bf_str])
%         ylabel('Number of cases')
%         title(type_strs{i})
%     end
