% COMPARE with Tones in Moving avg fashion
clc;clear;close all
load('stage3_db.mat')
load('stage1_db.mat')
load('f13.mat')

tone_dup_counter = [];

bin_size = 20;
window_size = 10;
t_end = 1500;

all_freq_at_once_rate = cell(21,7);
% 1 - hc, 2 - ahc low, 3 - ahc high,
% 4- Tone Base, 5 - Tone 2xBase, 6 - Tone low, 7 - Tone high


for u=1:size(stage3_db,1)
    % T BF
    tone_bf = stage3_db{u,9};
    %     tone_bf = stage3_db{u,10}; % BF0
    if tone_bf == -1
        continue
    end

    tone_rates = stage3_db{u,6};

    % AHC units
    ahc_units = stage3_db{u,8};
    for ahc_u=ahc_units
        ahc_freqs = stage1_db{ahc_u,6};
        ahc_rates = stage1_db{ahc_u,7};

        % spont
        spont = [];
        for f=1:6
            spont = [spont; mean(ahc_rates{f,1}(:,431:500),2)];
        end % f

        % tests
        sig6 = zeros(6,1);
        for f=1:6
            sig6(f) = ttest2(spont, mean(ahc_rates{f,1}(:, 501:570),2));
        end % f

        basef = my_find(f13,ahc_freqs(1,1));
        bfi = 1;
        octaves_apart_index = 11 + (basef - tone_bf);
        the_indices = [bfi, bfi+2, bfi+4];
        if sum(sig6(the_indices)) ~= 0
            for i=1:3
                %                 r = mean(reshape(mean(ahc_rates{the_indices(i),1}(:,1:t_end)), bin_size, t_end/bin_size));
                r = moving_mean(mean(ahc_rates{the_indices(i),1}(:,1:t_end)),   bin_size, window_size);
                all_freq_at_once_rate{octaves_apart_index,i} = [all_freq_at_once_rate{octaves_apart_index,i}; r];
            end % for
        end % if

        basef = my_find(f13,ahc_freqs(1,2));
        bfi = 2;
        octaves_apart_index = 11 + (basef - tone_bf);
        the_indices = [bfi, bfi+2, bfi+4];
        if sum(sig6(the_indices)) ~= 0
            for i=1:3
                %                 r = mean(reshape(mean(ahc_rates{the_indices(i),1}(:,1:t_end)), bin_size, t_end/bin_size));
                r = moving_mean(mean(ahc_rates{the_indices(i),1}(:,1:t_end)),   bin_size, window_size);
                all_freq_at_once_rate{octaves_apart_index,i} = [all_freq_at_once_rate{octaves_apart_index,i}; r];
            end % for
        end % if

        % Tones
        if ~ismember(u,tone_dup_counter)
            % Base
            r = moving_mean(mean(tone_rates{tone_bf,1}(:,1:t_end)),   bin_size, window_size);
            all_freq_at_once_rate{octaves_apart_index,4} = [all_freq_at_once_rate{octaves_apart_index,4}; r];

            % 2 Base
            if tone_bf + 4 <= 13
                r = moving_mean(mean(tone_rates{tone_bf+4,1}(:,1:t_end)),   bin_size, window_size);
                all_freq_at_once_rate{octaves_apart_index,5} = [all_freq_at_once_rate{octaves_apart_index,5}; r];
            end

            % 2 ^0.25 base
            if tone_bf - 1 >= 1
                r = moving_mean(mean(tone_rates{tone_bf-1,1}(:,1:t_end)),   bin_size, window_size);
                all_freq_at_once_rate{octaves_apart_index,6} = [all_freq_at_once_rate{octaves_apart_index,6}; r];
            end

            % 2 ^0.5 base
            if tone_bf - 2 >= 1
                r = moving_mean(mean(tone_rates{tone_bf-2,1}(:,1:t_end)),   bin_size, window_size);
                all_freq_at_once_rate{octaves_apart_index,6} = [all_freq_at_once_rate{octaves_apart_index,6}; r];
            end

            % 2 ^1.25 base
            if tone_bf + 1 <= 13
                r = moving_mean(mean(tone_rates{tone_bf + 1,1}(:,1:t_end)),   bin_size, window_size);
                all_freq_at_once_rate{octaves_apart_index,7} = [all_freq_at_once_rate{octaves_apart_index,7}; r];
            end

            % 2 ^1.75 base
            if tone_bf + 3 <= 13
                r = moving_mean(mean(tone_rates{tone_bf + 3,1}(:,1:t_end)),   bin_size, window_size);
                all_freq_at_once_rate{octaves_apart_index,7} = [all_freq_at_once_rate{octaves_apart_index,7}; r];
            end

            tone_dup_counter = [tone_dup_counter u];
        else
            continue
        end


    end % ahc_u

end % u



%% averaging together
n_quart_oct_from_bf = 0;
index_range = 11-n_quart_oct_from_bf:11+n_quart_oct_from_bf;
hc = [];
ahc_low = [];
ahc_high = [];

tone_og = [];
tone_2x = [];
tone_low = [];
tone_high = [];
for i=index_range
    hc = [hc; all_freq_at_once_rate{i,1}];
    ahc_low = [ahc_low; all_freq_at_once_rate{i,2}];
    ahc_high = [ahc_high; all_freq_at_once_rate{i,3}];

    tone_og =  [tone_og; all_freq_at_once_rate{i,4}];
    tone_2x =  [tone_2x; all_freq_at_once_rate{i,5}];
    tone_low =  [tone_low; all_freq_at_once_rate{i,6}];
    tone_high =  [tone_high; all_freq_at_once_rate{i,7}];

end % i

hc_mean = mean(hc);
ahc_low_mean = mean(ahc_low);
ahc_high_mean = mean(ahc_high);
tone_og_mean = mean(tone_og);
tone_2x_mean = mean(tone_2x);
tone_low_mean = mean(tone_low);
tone_high_mean = mean(tone_high);

hc_mean_norm = hc_mean./max(hc_mean);
ahc_low_mean_norm = ahc_low_mean./max(ahc_low_mean);
ahc_high_mean_norm = ahc_high_mean./max(ahc_high_mean);
tone_og_mean_norm = tone_og_mean./max(tone_og_mean);
tone_2x_mean_norm = tone_2x_mean./max(tone_2x_mean);
tone_low_mean_norm = tone_low_mean./max(tone_low_mean);
tone_high_mean_norm = tone_high_mean./max(tone_high_mean);


%%
% ttests
% H-AL, H-AH, AL-AH
h_t_each_row_norm = [];
ahc_low_each_row_norm = [];
ahc_high_each_row_norm = [];

for r=1:size(hc,1)
    h_t_each_row_norm = [h_t_each_row_norm; hc(r,:)./max(hc(r,:))];
    ahc_low_each_row_norm = [ahc_low_each_row_norm; ahc_low(r,:)./max(ahc_low(r,:))];
    ahc_high_each_row_norm = [ahc_high_each_row_norm; ahc_high(r,:)./max(ahc_high(r,:))];
end

hvals = zeros(3,size(hc,2));
for t=1:size(hc,2)
    %     h_t = hc(:,t);
    %     ahc_low_t = ahc_low(:,t);
    %     ahc_high_t = ahc_high(:,t);

    %     hvals(1,t) = ttest(h_t,ahc_low_t);
    %     hvals(2,t) = ttest(h_t,ahc_high_t);
    %     hvals(3,t) = ttest(ahc_low_t, ahc_high_t);

    hvals(1,t) = ttest(h_t_each_row_norm(:,t),ahc_low_each_row_norm(:,t));
    hvals(2,t) = ttest(h_t_each_row_norm(:,t),ahc_high_each_row_norm(:,t));
    hvals(3,t) = ttest(ahc_low_each_row_norm(:,t), ahc_high_each_row_norm(:,t));


end % t

%%
figure
hold on
plot(hc_mean_norm, 'LineWidth',2)
plot(ahc_low_mean_norm, 'LineWidth',2)
plot(ahc_high_mean_norm, 'LineWidth',2)

plot(tone_og_mean_norm, 'LineWidth',3)
plot(tone_2x_mean_norm, 'LineWidth',3)
plot(tone_low_mean_norm, 'LineWidth',3)
plot(tone_high_mean_norm, 'LineWidth',3)

for t=1:size(hc,2)
    if hvals(1,t) == 1
        text(t, hc_mean_norm(t), 'H-AL', 'color', 'black','FontWeight','bold')
    elseif hvals(2,t) == 1
        text(t, hc_mean_norm(t), 'H-AH', 'color', 'black', 'FontWeight','bold')
    elseif hvals(3,t) == 1
        text(t, ahc_low_mean_norm(t), 'AL-AH', 'color', 'black','FontWeight','bold')
    end
end
hold off
legend('HC', 'AHC Low', 'AHC High', 'T', 'T 2x', 'T Low', 'T high')
title(['t end = ', num2str(t_end),' bin size = ', num2str(bin_size), ' window size = ', num2str(window_size),' far from bf = ', num2str(n_quart_oct_from_bf)])