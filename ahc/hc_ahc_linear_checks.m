% Find Linear index in HC, AHC as a function of octaves apart from BF
clear;clc

load('stage3_db.mat')
load('stage1_db.mat')
load('f13.mat')

octaves_apart = -3.25:0.25:3.25;

linear_index_all_stim = cell(5, length(octaves_apart));  
% 1 - HC
% 2 - AHC05
% 3 - AHC025
% 4 - AHC175
% 5 - AHC125

scale_bf_or_bf0 = 'BF';
normalise_by = 'BF';


for u=1:size(stage3_db,1)

    individual_tone_rates = stage3_db{u,6};

    if strcmp(scale_bf_or_bf0, 'BF')        
        bf_for_scale = stage3_db{u,9};
    else
        bf_for_scale = stage3_db{u,10};
    end

    if bf_for_scale == -1
        continue
    end

    if strcmp(normalise_by, 'BF')
        bf_for_normalise = stage3_db{u,9};
        rates_for_normalise = stage3_db{u,6};
    else
        bf_for_normalise = stage3_db{u,10};
        rates_for_normalise = stage3_db{u,7};
    end

    if bf_for_normalise == -1
        continue
    end

    bf_rates_for_normalise = rates_for_normalise{bf_for_normalise,1};
    bf_mean_rate_for_normalise = 1000*mean(mean(bf_rates_for_normalise(:,501:570),2));


    ahc_units = stage3_db{u,8};
    for au=1:length(ahc_units)
        ahc_unit = ahc_units(au);

        ahc_stim = stage1_db{ahc_unit,6};
        f1 = ahc_stim(1,1);
        f2 = ahc_stim(1,2);

        f1_index = my_find(f13, f1);
        f2_index = my_find(f13, f2);

        delta_f1 = 14 + (f1_index - bf_for_scale);
        delta_f2 = 14 + (f2_index - bf_for_scale);

        ahc_rates = stage1_db{ahc_unit,7};
        for f=1:6
            if mod(f,2) == 1
                delta_f = delta_f1;
                f_index = f1_index;
            else
                delta_f = delta_f2;
                f_index = f2_index;
            end

            t1_index = f_index;
            if f == 1 || f == 2
                t2_index = f_index + 4;
            elseif f == 3
                t2_index = f_index + 2;
            elseif f == 4
                t2_index = f_index + 1;
            elseif f == 5
                t2_index = f_index + 7;
            elseif f == 6
                t2_index = f_index + 5;
            end

            if t2_index > 13
                continue
            end

            t1_r =  individual_tone_rates{t1_index,1};
            t1r_mean = 1000*mean(mean(t1_r(:,501:570),2));
            t1r_mean_norm = t1r_mean/bf_mean_rate_for_normalise;

            t2_r =  individual_tone_rates{t2_index,1};
            t2r_mean = 1000*mean(mean(t2_r(:,501:570),2));
            t2r_mean_norm = t2r_mean/bf_mean_rate_for_normalise;

            t1t2_r = ahc_rates{f,1};
            t1t2r_mean = 1000*mean(mean(t1t2_r(:,501:570),2));
            t1t2r_mean_norm = t1t2r_mean/bf_mean_rate_for_normalise;

            linear_index = (t1t2r_mean_norm - (t1r_mean_norm + t2r_mean_norm))/(t1t2r_mean_norm + (t1r_mean_norm + t2r_mean_norm));

            if isnan(linear_index)
                continue
            end

            if f == 1 || f == 2
                linear_index_all_stim{1, delta_f} = [linear_index_all_stim{1, delta_f} linear_index];
            else
                linear_index_all_stim{f-1, delta_f} = [linear_index_all_stim{f-1, delta_f} linear_index];
            end
        end
        


    end % au

end % for u



%% accepted data limit, replace with empty array where there aren't enough units'LI
% A new variable, good for copy
enough_data_linear_index_all_stim = cell(5, length(octaves_apart));
for f=1:5
    for o=1:length(octaves_apart)
        if length(linear_index_all_stim{f,o}) >= 5
            enough_data_linear_index_all_stim{f,o} = linear_index_all_stim{f,o};
        end
    end
end

%% mean and std
mean_linear_index_all_stim = cellfun(@mean, enough_data_linear_index_all_stim);
std_linear_index_all_stim = cellfun(@std, enough_data_linear_index_all_stim);
std_err_linear_index_all_stim = std_linear_index_all_stim./sqrt(cellfun(@length, enough_data_linear_index_all_stim));

%% plot - HARDCODED - which octaves apart to be on x - axis, based on availability of data. Atleast 10 units' LI
cols_with_data = 10:18;
octaves_with_data = octaves_apart(cols_with_data);
figure 
    hold on
        errorbar(octaves_with_data, mean_linear_index_all_stim(1,cols_with_data), std_err_linear_index_all_stim(1,cols_with_data), 'r', 'LineWidth', 2')
        errorbar(octaves_with_data, mean_linear_index_all_stim(2,cols_with_data), std_err_linear_index_all_stim(2,cols_with_data), 'g', 'LineWidth', 2')
        errorbar(octaves_with_data, mean_linear_index_all_stim(3,cols_with_data), std_err_linear_index_all_stim(3,cols_with_data), 'b', 'LineWidth', 2')
        errorbar(octaves_with_data, mean_linear_index_all_stim(4,cols_with_data), std_err_linear_index_all_stim(4,cols_with_data), 'c', 'LineWidth', 2')
        errorbar(octaves_with_data, mean_linear_index_all_stim(5,cols_with_data), std_err_linear_index_all_stim(5,cols_with_data), 'm', 'LineWidth', 2')
        
    hold off
    title(['Linear Index all stim: T1T2 - (T1+T2)/T1T2 - (T1+T2). Normalize by rates of ' normalise_by])
    xlabel(['Octaves apart from  ' scale_bf_or_bf0])
    ylabel('Linear Index')
    legend('HC', 'AHC-0.5', 'AHC-0.25', 'AHC-1.75', 'AHC-1.25')
    
% After plotting your graph, get the current axes with the `gca` function.
ax = gca;

% Now set the x-ticks. For example, to set 15 ticks:
ax.XTick = linspace(min(octaves_with_data), max(octaves_with_data), length(octaves_with_data)); % replace 'x' with your array

% If you want to specify exactly which values to use as ticks, you can pass them as an array:
ax.XTick = octaves_with_data; % replace 'x' with your array
