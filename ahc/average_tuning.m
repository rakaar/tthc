% Average tuning of BF OR BF0
clear;clc;
load('stage3_db.mat')
bf_tuning = cell(27,1);

bf_or_bf0 = 'BF'; % BF for Tone, BF0 for HC

for u=1:size(stage3_db,1)
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


rows_with_data = 5:26;
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
    
    