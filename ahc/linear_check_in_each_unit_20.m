% Calculate (non harmonic rate/ individual tone rates sum) // (harmonic rate/ individual tone rates sum)
clear; clc; close all;
load('stage3_db.mat')
load('stage1_db.mat')
load('f13.mat')

% Remove all non-20db tones
% stage3_db
removal_indices = [];
for u=1:size(stage3_db,1)
    if stage3_db{u,4} ~= 20
        removal_indices = [removal_indices; u];
    end
end % u
stage3_db(removal_indices,:) = [];

bf_or_bf0 = 'BF'; % BF or BF0


octaves_apart = -3.25:0.25:3.25;
linear_ratio_unit_wise = cell(length(octaves_apart),4);
% 1 - 2^0.25(4)
% 2 - 2^0.5(3)
% 3 - 2^1.25(6)
% 4 - 2^1.75(5)

for u=1:size(stage3_db,1)
    if strcmp(bf_or_bf0, 'BF')
        bf_index = stage3_db{u,9};
    else
        bf_index = stage3_db{u,10};
    end
    
    tone_rates = stage3_db{u,6};
    if bf_index == -1
        continue
    end

    ahc_units = stage3_db{u,8};
    for au=1:length(ahc_units)
        ahc_unit = ahc_units(au);

        % check for AHC pakka
        if stage1_db{ahc_unit,4} ~= 2
            disp('Problem: Not AHC unit')
            break
        end


        ahc_stim = stage1_db{ahc_unit,6};
        base_f1 = ahc_stim(1,1);
        base_f2 = ahc_stim(1,2);

        base_f1_index = my_find(f13, base_f1);
        base_f2_index = my_find(f13, base_f2);


        % sig
        res = stage1_db{ahc_unit,7};
        spont_for_test = [];
        for s=1:6
            spont_for_test = [spont_for_test; mean(res{s,1}(:,431:500),2) ];
        end % s

        sig6 = zeros(6,1);
        for s=1:6
            stim_rates = mean(res{s,1}(:,501:570),2);
            if mean(stim_rates) > mean(spont_for_test) && ttest2(stim_rates, spont_for_test) == 1
                sig6(s) = 1;
            end
        end

        if sum(sig6([1,3,5])) ~= 0
            base_index = base_f1_index;
            base_octaves_from_bf = (base_index - bf_index)*0.25;
            row_no = find(base_octaves_from_bf == octaves_apart);
            
            stim_rates1 = mean(mean(res{1,1}(:,501:570),2));
            stim_rates3 = mean(mean(res{3,1}(:,501:570),2));
            stim_rates5 = mean(mean(res{5,1}(:,501:570),2));

            % ---- 3(0.5)
            % rates
            non_harmonic_oct_apart = 0.5;
            rates_ratio = stim_rates3/stim_rates1;
            if max(base_index + round(non_harmonic_oct_apart/0.25), base_index + round(1/0.25)) <= size(tone_rates,1)
                % indiv tones
                harmonic_sum = mean(mean(tone_rates{base_index,1}(:,501:570),2)) + mean(mean(tone_rates{base_index + round(1/0.25),1}(:,501:570),2));
                non_harmonic_sum = mean(mean(tone_rates{base_index,1}(:,501:570),2)) + mean(mean(tone_rates{base_index + round(non_harmonic_oct_apart/0.25),1}(:,501:570),2));
                sum_ratio = non_harmonic_sum/harmonic_sum;

                the_ratio = rates_ratio/sum_ratio;
                if ~isnan(the_ratio) && ~isinf(the_ratio)
                    linear_ratio_unit_wise{row_no, 2} = [linear_ratio_unit_wise{row_no, 2} the_ratio];
                end
            end

            
            % 5 - 1.75
            % rates
            non_harmonic_oct_apart = 1.75;
            rates_ratio = stim_rates5/stim_rates1;
            if max(base_index + round(non_harmonic_oct_apart/0.25), base_index + round(1/0.25)) <= size(tone_rates,1)
                % indiv tones
                harmonic_sum = mean(mean(tone_rates{base_index,1}(:,501:570),2)) + mean(mean(tone_rates{base_index + round(1/0.25),1}(:,501:570),2));
                non_harmonic_sum = mean(mean(tone_rates{base_index,1}(:,501:570),2)) + mean(mean(tone_rates{base_index + round(non_harmonic_oct_apart/0.25),1}(:,501:570),2));
                sum_ratio = non_harmonic_sum/harmonic_sum;

                the_ratio = rates_ratio/sum_ratio;
                if ~isnan(the_ratio) && ~isinf(the_ratio)
                    linear_ratio_unit_wise{row_no, 4} = [linear_ratio_unit_wise{row_no, 4} the_ratio];
                end
            end
            
        end

        if sum(sig6([2,4,6])) ~= 0
            base_index = base_f2_index;
            base_octaves_from_bf = (base_index - bf_index)*0.25;
            row_no = find(base_octaves_from_bf == octaves_apart);
            
            stim_rates2 = mean(mean(res{2,1}(:,501:570),2));
            stim_rates4 = mean(mean(res{4,1}(:,501:570),2));
            stim_rates6 = mean(mean(res{6,1}(:,501:570),2));

            % ---- 4(0.25)
            % rates
            non_harmonic_oct_apart = 0.25;
            rates_ratio = stim_rates4/stim_rates2;
            if max(base_index + round(non_harmonic_oct_apart/0.25), base_index + round(1/0.25)) <= size(tone_rates,1)
                % indiv tones
                harmonic_sum = mean(mean(tone_rates{base_index,1}(:,501:570),2)) + mean(mean(tone_rates{base_index + round(1/0.25),1}(:,501:570),2));
                non_harmonic_sum = mean(mean(tone_rates{base_index,1}(:,501:570),2)) + mean(mean(tone_rates{base_index + round(non_harmonic_oct_apart/0.25),1}(:,501:570),2));
                sum_ratio = non_harmonic_sum/harmonic_sum;
                
                the_ratio = rates_ratio/sum_ratio;
                if ~isnan(the_ratio) && ~isinf(the_ratio)
                    linear_ratio_unit_wise{row_no, 1} = [linear_ratio_unit_wise{row_no, 1} the_ratio];
                end
            end
            
            %6 - 1.25
            % rates
            non_harmonic_oct_apart = 1.25;
            rates_ratio = stim_rates6/stim_rates2;
            if max(base_index + round(non_harmonic_oct_apart/0.25), base_index + round(1/0.25)) <= size(tone_rates,1)
                % indiv tones
                harmonic_sum = mean(mean(tone_rates{base_index,1}(:,501:570),2)) + mean(mean(tone_rates{base_index + round(1/0.25),1}(:,501:570),2));
                non_harmonic_sum = mean(mean(tone_rates{base_index,1}(:,501:570),2)) + mean(mean(tone_rates{base_index + round(non_harmonic_oct_apart/0.25),1}(:,501:570),2));
                sum_ratio = non_harmonic_sum/harmonic_sum;

                the_ratio = rates_ratio/sum_ratio;
                if ~isnan(the_ratio) && ~isinf(the_ratio)
                    linear_ratio_unit_wise{row_no, 3} = [linear_ratio_unit_wise{row_no, 3} the_ratio];
                end
            end
        end



    end % au
end

% find rows with enough data
threshold = 5;
row_nums_greater_than_threshold = [];

for r=1:size(linear_ratio_unit_wise,1)
    is_all_above_threshold = 1;
    for j=1:size(linear_ratio_unit_wise,2)
       if length(linear_ratio_unit_wise{r,j}) < threshold
           is_all_above_threshold = 0;
           break
       end 
    end

    if is_all_above_threshold == 1
        row_nums_greater_than_threshold = [row_nums_greater_than_threshold; r];
    end
end

%% plot
rows_with_data = row_nums_greater_than_threshold;
octaves_with_data = octaves_apart(rows_with_data);
linear_ratio_unit_wise_enuf_data = linear_ratio_unit_wise(rows_with_data,:);


mean_linear_ratio_unit_wise = cellfun(@mean, linear_ratio_unit_wise_enuf_data);
err_linear_ratio_unit_wise = cellfun(@std, linear_ratio_unit_wise_enuf_data)./sqrt(cellfun(@length, linear_ratio_unit_wise_enuf_data));

figure
    hold on
        errorbar(octaves_with_data, mean_linear_ratio_unit_wise(:,1), err_linear_ratio_unit_wise(:,1), 'r', 'LineWidth', 2)
        errorbar(octaves_with_data, mean_linear_ratio_unit_wise(:,2), err_linear_ratio_unit_wise(:,2), 'b', 'LineWidth', 2)
        errorbar(octaves_with_data, mean_linear_ratio_unit_wise(:,3), err_linear_ratio_unit_wise(:,3), 'g', 'LineWidth', 2)
        errorbar(octaves_with_data, mean_linear_ratio_unit_wise(:,4), err_linear_ratio_unit_wise(:,4), 'k', 'LineWidth', 2)
    hold off
    xlabel(['octaves apart from ' bf_or_bf0])
    ylabel('ratio units wise ')
    title('ratio units wise')
    legend('0.25', '0.5', '1.25', '1.75')
% After plotting your graph, get the current axes with the `gca` function.
ax = gca;

% If you want to specify exactly which values to use as ticks, you can pass them as an array:
ax.XTick = octaves_with_data; % replace 'x' with your array

% remove the cells with less than threshold number of elements
threshold = 5;
enuf_linear_ratio = cell(size(linear_ratio_unit_wise,1), size(linear_ratio_unit_wise,2));
for r=1:size(linear_ratio_unit_wise,1)
    for j=1:size(linear_ratio_unit_wise,2)
        if length(linear_ratio_unit_wise{r,j}) >= threshold
            enuf_linear_ratio{r,j} = linear_ratio_unit_wise{r,j};
        end
    end
end
mean_linear_ratio_unit_wise = cellfun(@mean, enuf_linear_ratio);
err_linear_ratio_unit_wise = cellfun(@std, enuf_linear_ratio)./sqrt(cellfun(@length, enuf_linear_ratio));



figure
    hold on
        errorbar(octaves_apart, mean_linear_ratio_unit_wise(:,1), err_linear_ratio_unit_wise(:,1), 'r', 'LineWidth', 2)
        errorbar(octaves_apart, mean_linear_ratio_unit_wise(:,2), err_linear_ratio_unit_wise(:,2), 'b', 'LineWidth', 2)
        errorbar(octaves_apart, mean_linear_ratio_unit_wise(:,3), err_linear_ratio_unit_wise(:,3), 'g', 'LineWidth', 2)
        errorbar(octaves_apart, mean_linear_ratio_unit_wise(:,4), err_linear_ratio_unit_wise(:,4), 'k', 'LineWidth', 2)
    hold off
    xlabel(['octaves apart from ' bf_or_bf0])
    ylabel('ratio units wise ')
    title('ratio units wise')
    legend('0.25', '0.5', '1.25', '1.75')
% After plotting your graph, get the current axes with the `gca` function.
ax = gca;

% If you want to specify exactly which values to use as ticks, you can pass them as an array:
ax.XTick = octaves_apart; % replace 'x' with your array
