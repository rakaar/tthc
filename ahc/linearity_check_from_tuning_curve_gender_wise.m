% check linear effect compared to harmonic from tuning curve
clear;

load('stage3_db.mat')

animal_gender = 'F';
if strcmp(animal_gender, 'M')
    rejected_gender = 'F';
elseif strcmp(animal_gender, 'F')
    rejected_gender = 'M';
else
    rejected_gender = nan;
end
if ~isnan(rejected_gender)
    removal_indices = [];
    for u = 1:size(stage3_db,1)
        animal_name = stage3_db{u,1};
        if contains(animal_name, strcat('_', rejected_gender))
            removal_indices = [removal_indices; u];
        end
    end

    stage3_db(removal_indices,:) = [];
end

%  ########## average_tuning ############
% Average tuning of BF OR BF0

bf_tuning = cell(27,1);

bf_or_bf0 = 'BF'; % BF for Tone, BF0 for HC

for u=1:size(stage3_db,1)
    if isempty(stage3_db{u,1})
        continue
    end

    if strcmp(bf_or_bf0, 'BF')
        rates = stage3_db{u,6};
        bf = stage3_db{u,9};
    else
        rates = stage3_db{u,7};
        bf = stage3_db{u,10};
    end


    if bf == -1
        continue
    end

    mean_rates = zeros(13,1);
    for f=1:13
        mean_rates(f) = mean(mean(rates{f,1}(:,501:570),2));
    end

    norm_mean_rates = mean_rates/mean_rates(bf);

    if bf > 1
        pre_bf_indices = 1:bf-1;
    else
        pre_bf_indices = nan;
    end

    if bf < 13
        post_bf_indices = bf+1:13;
    else
        post_bf_indices = nan;
    end

    bf_tuning{14,1} = [bf_tuning{14,1} norm_mean_rates(bf)];
    if ~anynan(pre_bf_indices)
        counter = 1;
        for b=length(pre_bf_indices):-1:1
            ind = pre_bf_indices(b);
            bf_tuning{14-counter,1} = [bf_tuning{14-counter,1} norm_mean_rates(ind)];
            counter = counter + 1; 
        end
    end
    
    if ~anynan(post_bf_indices)
        for b=1:length(post_bf_indices)
            ind = post_bf_indices(b);
            bf_tuning{14+b,1} = [ bf_tuning{14+b,1} norm_mean_rates(ind) ];
        end
    end

    

end % for u

% find rows with enough data
threshold = 5;
row_nums_greater_than_threshold = [];

for r=1:size(bf_tuning,1)
    is_all_above_threshold = 1;
    for j=1:size(bf_tuning,2)
       if length(bf_tuning{r,j}) < threshold
           is_all_above_threshold = 0;
           break
       end 
    end

    if is_all_above_threshold == 1
        row_nums_greater_than_threshold = [row_nums_greater_than_threshold; r];
    end
end

rows_with_data = row_nums_greater_than_threshold;
all_octs = -3.25:0.25:3.25;
octs_with_data = all_octs(rows_with_data);

bf_tuning_with_enuf_data = bf_tuning(rows_with_data,1);

mean_bf_tuning = zeros(length(octs_with_data),1);
err = zeros(length(octs_with_data),1);

for f=1:length(octs_with_data)
    mean_bf_tuning(f) = mean(bf_tuning{rows_with_data(f),1});
    err(f) = std(bf_tuning{rows_with_data(f),1})/sqrt(length(bf_tuning{rows_with_data(f),1}));
end


figure 
    errorbar(octs_with_data, mean_bf_tuning, err, 'k', 'LineWidth', 2)
    title(['Average tuning  for ' bf_or_bf0])
    xlabel([ 'Octaves from ' bf_or_bf0 ])
    ylabel(['Normalized by '  bf_or_bf0 ' firing rate'])

    ax = gca;

    % Now set the x-ticks. For example, to set 15 ticks:
    ax.XTick = linspace(min(octs_with_data), max(octs_with_data), length(octs_with_data)); % replace 'x' with your array
    
    % If you want to specify exactly which values to use as ticks, you can pass them as an array:
    ax.XTick = octs_with_data; % replace 'x' with your array
    
    % ########## average_tuning ############
disp(['scale bf_or_bf0 ' bf_or_bf0])
% important vars
% **octs_with_data** - octaves apart where we have atleast 10 examples
% **mean_bf_tuning** - mean of above 
% % bf_tuning_with_enuf_data -  for all those octaves apart above and BF and rate/BF
% renaming to avoid confusion
bf_tuning_octs_with_data = octs_with_data;

% ###### hc_ahc_rates_vs_bf; ########
load('stage1_db.mat')
load('f13.mat')


rates_vs_bf = cell(27,5);
% 1 - HC(1/2)
% 2 - AHC 2^0.25(4)
% 3 - AHC 2^0.5(3)
% 4 - AHC 2^1.25(6)
% 5 - AHC 2^1.75(5)
zscores_or_rates = 'rates';
bf_or_bf0 = 'BF';
is_normalised = 1;
normalize_by = 'BF'; % normalize by BF0 or BF
for u=1:size(stage3_db,1)
    if isempty(stage3_db{u,1})
        continue
    end
    if strcmp(bf_or_bf0,'BF')
        tone_bf = stage3_db{u,9};
        tone_rates = stage3_db{u,6};
    elseif strcmp(bf_or_bf0,'BF0')
        tone_bf = stage3_db{u,10};
        tone_rates = stage3_db{u,7};
    end

    % the scale is BF or BF0
    if tone_bf == -1
        continue
    end

    if strcmp(normalize_by, 'BF')
        bf = stage3_db{u,9};
        if bf == -1
            continue
        end
        rates = stage3_db{u,6};
        tone_bf_rates = rates{bf,1};
        tone_bf_rates_mean = 1000*mean(mean(tone_bf_rates(:,501:570),2));
    elseif strcmp(normalize_by, 'BF0')
        bf = stage3_db{u,10};
        if bf == -1
            continue
        end
        rates = stage3_db{u,7};
        tone_bf_rates = rates{bf,1};
        tone_bf_rates_mean = 1000*mean(mean(tone_bf_rates(:,501:570),2));
    end
    
    

    ahc_units = stage3_db{u,8};
    for au=1:length(ahc_units)
        ahc_unit = ahc_units(au);
        ahc_stim = stage1_db{ahc_unit,6};
        base_freq1 = ahc_stim(1,1);
        base_freq2 = ahc_stim(1,2);

        base_freq1_index = my_find(f13,base_freq1);
        base_freq2_index = my_find(f13,base_freq2);

        delta_base1_minus_bf = base_freq1_index - tone_bf;
        delta_base2_minus_bf = base_freq2_index - tone_bf;

        delta1_index = 14 + delta_base1_minus_bf;
        delta2_index = 14 + delta_base2_minus_bf;
    
        res = stage1_db{ahc_unit,7};
        spont_for_test = [];
        spont_for_mean = [];
        for s=1:6
            spont_for_test = [spont_for_test; mean(res{s,1}(:,431:500),2) ];
            spont_for_mean = [spont_for_mean; mean(res{s,1}(:, 301:500),2)];
        end % s

        mean_spont = mean(spont_for_mean);
        std_spont = std(spont_for_mean);

        if strcmp(zscores_or_rates,'zscore')
            if std_spont == 0
                continue
            end
        end
        sig6 = zeros(6,1);
        for s=1:6
            stim_rates = mean(res{s,1}(:,501:570),2);
            if mean(stim_rates) > mean(spont_for_test) && ttest2(stim_rates, spont_for_test) == 1
                sig6(s) = 1;
            end
        end


        if sum(sig6([1,3,5])) ~= 0
            stim_rates1 = mean(res{1,1}(:,501:570),2);
            stim_rates3 = mean(res{3,1}(:,501:570),2);
            stim_rates5 = mean(res{5,1}(:,501:570),2);

            if strcmp(zscores_or_rates, 'zscore')
                stim_rates1_z_score = (stim_rates1 - mean_spont)./std_spont;
                stim_rates3_z_score = (stim_rates3 - mean_spont)./std_spont;
                stim_rates5_z_score = (stim_rates5 - mean_spont)./std_spont;
            else
                if is_normalised == 0
                    stim_rates1_z_score = 1000*stim_rates1;
                    stim_rates3_z_score = 1000*stim_rates3;
                    stim_rates5_z_score = 1000*stim_rates5;
                else
                    stim_rates1_z_score = 1000*stim_rates1./tone_bf_rates_mean;
                    stim_rates3_z_score = 1000*stim_rates3./tone_bf_rates_mean;
                    stim_rates5_z_score = 1000*stim_rates5./tone_bf_rates_mean;
                    
                end
            end
            rates_vs_bf{delta1_index,1} = [rates_vs_bf{delta1_index,1}; mean(stim_rates1_z_score)];
            rates_vs_bf{delta1_index,3} = [rates_vs_bf{delta1_index,3}; mean(stim_rates3_z_score)];
            rates_vs_bf{delta1_index,5} = [rates_vs_bf{delta1_index,5}; mean(stim_rates5_z_score)];

        end

        if sum(sig6([2,4,6])) ~= 0
            stim_rates2 = mean(res{2,1}(:,501:570),2);
            stim_rates4 = mean(res{4,1}(:,501:570),2);
            stim_rates6 = mean(res{6,1}(:,501:570),2);

            if strcmp(zscores_or_rates, 'zscore')
                stim_rates2_z_score = (stim_rates2 - mean_spont)./std_spont;
                stim_rates4_z_score = (stim_rates4 - mean_spont)./std_spont;
                stim_rates6_z_score = (stim_rates6 - mean_spont)./std_spont;
            else
                if is_normalised == 0
                    stim_rates2_z_score = 1000*stim_rates2;
                    stim_rates4_z_score = 1000*stim_rates4;
                    stim_rates6_z_score = 1000*stim_rates6;
                else
                    stim_rates2_z_score = 1000*stim_rates2./tone_bf_rates_mean;
                    stim_rates4_z_score = 1000*stim_rates4./tone_bf_rates_mean;
                    stim_rates6_z_score = 1000*stim_rates6./tone_bf_rates_mean;
                end

            end
            rates_vs_bf{delta2_index,1} = [rates_vs_bf{delta2_index,1}; mean(stim_rates2_z_score)];
            rates_vs_bf{delta2_index,2} = [rates_vs_bf{delta2_index,2}; mean(stim_rates4_z_score)];
            rates_vs_bf{delta2_index,4} = [rates_vs_bf{delta2_index,4}; mean(stim_rates6_z_score)];

        end



    end % au
end % for 


% find rows with enough data
threshold = 5;
row_nums_greater_than_threshold = [];

for r=1:size(rates_vs_bf,1)
    is_all_above_threshold = 1;
    for j=1:size(rates_vs_bf,2)
       if length(rates_vs_bf{r,j}) < threshold
           is_all_above_threshold = 0;
           break
       end 
    end

    if is_all_above_threshold == 1
        row_nums_greater_than_threshold = [row_nums_greater_than_threshold; r];
    end
end


octaves_from_bf = -3.25:0.25:3.25;
row_nums_with_data = row_nums_greater_than_threshold;
octaves_apart_with_data = octaves_from_bf(row_nums_with_data);

reduced_data = rates_vs_bf(row_nums_with_data,:);
mean_reduced_data = cellfun(@mean, reduced_data);
std_reduced_data = cellfun(@std, reduced_data);
err_reduced_data = std_reduced_data./sqrt(cellfun(@length, reduced_data));

figure 
hold on
errorbar(octaves_apart_with_data, mean_reduced_data(:,1), err_reduced_data(:,1), 'b', 'LineWidth', 2)
errorbar(octaves_apart_with_data, mean_reduced_data(:,2), err_reduced_data(:,2), 'r', 'LineWidth', 2)
errorbar(octaves_apart_with_data, mean_reduced_data(:,3), err_reduced_data(:,3), 'g', 'LineWidth', 2)
errorbar(octaves_apart_with_data, mean_reduced_data(:,4), err_reduced_data(:,4), 'm', 'LineWidth', 2)
errorbar(octaves_apart_with_data, mean_reduced_data(:,5), err_reduced_data(:,5), 'k', 'LineWidth', 2)
legend('HC', 'AHC 2*0.25(4)', 'AHC 2*0.5(3)', 'AHC 2*1.25(6)', 'AHC 2*1.75(5)')
title([zscores_or_rates ' ---atleast 1/3 sig, with errorbar ' ' Is Normalised by rates of = ' normalize_by] )
xlabel(['octaves from ' bf_or_bf0])
ylabel(zscores_or_rates)
% After plotting your graph, get the current axes with the `gca` function.
ax = gca;

% Now set the x-ticks. For example, to set 15 ticks:
ax.XTick = linspace(min(octaves_apart_with_data), max(octaves_apart_with_data), 15); % replace 'x' with your array

% If you want to specify exactly which values to use as ticks, you can pass them as an array:
ax.XTick = octaves_apart_with_data; % replace 'x' with your array

%  ########## hc_ahc_rates_vs_bf; ############
% important vars
% octaves_apart_with_data - octaves apart that have atleast 10 examples
% mean_reduced_data  - rates normalised by BF
% bf_or_bf0 = 'BF'; is_normalised = 1;normalize_by = 'BF'; % normalize by BF0 or BF
disp(['scale bf_or_bf0 ' bf_or_bf0])
disp(['is_normalised ' num2str(is_normalised)])
disp(['normalize_by ' normalize_by])
% in mean_reduced_data
% 1 - HC(1/2)
% 2 - AHC 2^0.25(4)
% 3 - AHC 2^0.5(3)
% 4 - AHC 2^1.25(6)
% 5 - AHC 2^1.75(5)

ratio_from_harmonic_linear_ideal = zeros(length(octaves_apart_with_data),4);
% 1 - AHC 2^0.25(4)
% 2 - AHC 2^0.5(3)
% 3 - AHC 2^1.25(6)
% 4 - AHC 2^1.75(5) 


for i=1:length(octaves_apart_with_data)
    base_apart_from_bf = i;
    re_base = octaves_apart_with_data(base_apart_from_bf);
    for j=1:4
        if j == 1
            re_second_comp = re_base + (0.25*1);
        elseif j == 2
            re_second_comp = re_base + (0.25*2);
        elseif j == 3
            re_second_comp = re_base + (0.25*5);
        elseif j == 4
            re_second_comp = re_base + (0.25*7);
        end

         % twoToneResp
            hc_two_tone_resp = mean_reduced_data(i,1); % 1 value : average of m rates
            non_hc_two_tone_resp = mean_reduced_data(i,j+1); % 1 value : average of m rates
            
            two_tone_ratio = non_hc_two_tone_resp/hc_two_tone_resp;

            % linear ideal
            base_index_in_bf_tuning_octs = find(bf_tuning_octs_with_data == re_base);
            second_comp_index_in_bf_tuning_octs = find(bf_tuning_octs_with_data == re_second_comp);
            if  base_index_in_bf_tuning_octs + 4 > length(mean_bf_tuning)
                disp(['Skipped in i = ' num2str(i) ' j = ' num2str(j) ' because harmonic is out of range in ideal linear case ' ' base index in bf tun ' num2str(base_index_in_bf_tuning_octs)])
                continue;
            end
            hc_linear = mean_bf_tuning(base_index_in_bf_tuning_octs) + mean_bf_tuning(base_index_in_bf_tuning_octs + 4);
            non_hc_linear = mean_bf_tuning(base_index_in_bf_tuning_octs) + mean_bf_tuning(second_comp_index_in_bf_tuning_octs);
            if hc_linear == 0
                disp('Skip bcz HC linear sum is 0')
                continue
            end
            linear_ratio = non_hc_linear/hc_linear;

            if linear_ratio == 0
                disp('Skip bcz Linear ratio is zero')
                continue
            end
            the_ratio = two_tone_ratio/linear_ratio;

            
             ratio_from_harmonic_linear_ideal(i,j) = the_ratio;
            
       
    end % for j=1:4


end % for octaves_apart_with_data


% plot
figure
    hold on    
    plot(octaves_apart_with_data,ratio_from_harmonic_linear_ideal(:,1),'r', 'LineWidth', 2);
    plot(octaves_apart_with_data,ratio_from_harmonic_linear_ideal(:,2),'g', 'LineWidth', 2);
    plot(octaves_apart_with_data,ratio_from_harmonic_linear_ideal(:,3),'b', 'LineWidth', 2);
    plot(octaves_apart_with_data,ratio_from_harmonic_linear_ideal(:,4),'k', 'LineWidth', 2);
    hold off
    title('Ratio of two tone response to linear sum of two tones')
    xlabel(' # of Octaves apart BASE frequency from BF')
    ylabel('Ratio')
    legend('2^0.25','2^0.5','2^1.25','2^1.75')
    
% After plotting your graph, get the current axes with the `gca` function.
ax = gca;

% Now set the x-ticks. For example, to set 15 ticks:
ax.XTick = linspace(min(octaves_apart_with_data), max(octaves_apart_with_data), length(octaves_apart_with_data)); % replace 'x' with your array

% If you want to specify exactly which values to use as ticks, you can pass them as an array:
ax.XTick = octaves_apart_with_data; % replace 'x' with your array

% plot
figure
    hold on    
    plot(octaves_apart_with_data,0.5*(ratio_from_harmonic_linear_ideal(:,1) + ratio_from_harmonic_linear_ideal(:,2)),'r', 'LineWidth', 2);
    plot(octaves_apart_with_data,0.5*(ratio_from_harmonic_linear_ideal(:,3) + ratio_from_harmonic_linear_ideal(:,4)),'b', 'LineWidth', 2);
    hold off
    title('Ratio of two tone response to linear sum of two tones')
    xlabel(' # of Octaves apart BASE frequency from BF')
    ylabel('Ratio')
    legend('NHC low', 'NHC High')
% After plotting your graph, get the current axes with the `gca` function.
ax = gca;

% Now set the x-ticks. For example, to set 15 ticks:
ax.XTick = linspace(min(octaves_apart_with_data), max(octaves_apart_with_data), length(octaves_apart_with_data)); % replace 'x' with your array

% If you want to specify exactly which values to use as ticks, you can pass them as an array:
ax.XTick = octaves_apart_with_data; % replace 'x' with your array