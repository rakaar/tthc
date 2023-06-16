% HC, AHC rates vs BF-0.25, BF, BF+0.25 
clear;clc;
load('stage3_db.mat')
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
for u=1:size(stage3_db,1)
    if strcmp(bf_or_bf0,'BF')
        tone_bf = stage3_db{u,9};
        tone_rates = stage3_db{u,6};
    elseif strcmp(bf_or_bf0,'BF0')
        tone_bf = stage3_db{u,10};
        tone_rates = stage3_db{u,7};
    end

    if tone_bf == -1
        continue
    end

    
    tone_bf_rates = tone_rates{tone_bf,1};
    tone_bf_rates_mean = 1000*mean(mean(tone_bf_rates(:,501:570),2));

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


octaves_from_bf = -3.25:0.25:3.25;
row_nums_with_data = 10:17;
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
title([zscores_or_rates ' ---atleast 1/3 sig, with errorbar ' ' Is Normalised by Tone BF rates = ' num2str(is_normalised)] )
xlabel(['octaves from ' bf_or_bf0])
ylabel(zscores_or_rates)
% After plotting your graph, get the current axes with the `gca` function.
ax = gca;

% Now set the x-ticks. For example, to set 15 ticks:
ax.XTick = linspace(min(octaves_apart_with_data), max(octaves_apart_with_data), 15); % replace 'x' with your array

% If you want to specify exactly which values to use as ticks, you can pass them as an array:
ax.XTick = octaves_apart_with_data; % replace 'x' with your array

