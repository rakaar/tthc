% check linear effect compared to harmonic from tuning curve
clear;
average_tuning;
disp(['scale bf_or_bf0 ' bf_or_bf0])
% important vars
% **octs_with_data** - octaves apart where we have atleast 10 examples
% **mean_bf_tuning** - mean of above 
% % bf_tuning_with_enuf_data -  for all those octaves apart above and BF and rate/BF
% renaming to avoid confusion
bf_tuning_octs_with_data = octs_with_data;

hc_ahc_rates_vs_bf;
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
            hc_two_tone_resp = mean_reduced_data(i,1);
            non_hc_two_tone_resp = mean_reduced_data(i,j+1);
            
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