% COMPARE with Tones in Moving avg fashion
% Spont removed and normalised
% generating bar graph and ttest results
clc;clear;close all
load('stage3_db.mat')
load('stage1_db.mat')
load('f13.mat')

tone_dup_counter = [];

bin_size = 70;
window_size = 10;
t_end = 1000;

all_freq_at_once_rate = cell(25,7);
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
        octaves_apart_index = 13 + (basef - tone_bf);
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
        octaves_apart_index = 13 + (basef - tone_bf);
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
index_range = 13-n_quart_oct_from_bf:13+n_quart_oct_from_bf;
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

% 
% % Subtract spont
spont_bin_start = 300/window_size + 1;
spont_bin_end = (500 - bin_size)/window_size + 1;


%%
% ttests
% H-AL, H-AH, AL-AH
h_t_each_row_norm = [];
ahc_low_each_row_norm = [];
ahc_high_each_row_norm = [];
tone_all_each_row_norm = [];
for r=1:size(hc,1)
    h_t_each_row_norm = [h_t_each_row_norm; ( hc(r,:) - mean(hc(r,spont_bin_start:spont_bin_end)) )./max(hc(r,:))];
    ahc_low_each_row_norm = [ahc_low_each_row_norm; ( ahc_low(r,:) - mean(ahc_low(r,spont_bin_start:spont_bin_end)) )./max(ahc_low(r,:))];
    ahc_high_each_row_norm = [ahc_high_each_row_norm; ( ahc_high(r,:) - mean(ahc_high(r,spont_bin_start:spont_bin_end)) )./max(ahc_high(r,:))];
end

for r=1:size(tone_og,1)
    tone_all_each_row_norm = [tone_all_each_row_norm; ( tone_og(r,:) - mean(tone_og(r,spont_bin_start:spont_bin_end)) )./max( ( tone_og(r,:) - mean(tone_og(r,spont_bin_start:spont_bin_end)) ) )];
end
for r=1:size(tone_2x,1)
    tone_all_each_row_norm = [tone_all_each_row_norm; ( tone_2x(r,:) - mean(tone_2x(r,spont_bin_start:spont_bin_end)) )./max( ( tone_2x(r,:) - mean(tone_2x(r,spont_bin_start:spont_bin_end)) ) )];
end
for r=1:size(tone_low,1)
    tone_all_each_row_norm = [tone_all_each_row_norm; ( tone_low(r,:) - mean(tone_low(r,spont_bin_start:spont_bin_end)) )./max( ( tone_low(r,:) - mean(tone_low(r,spont_bin_start:spont_bin_end)) ) )];
end
for r=1:size(tone_high,1)
    tone_all_each_row_norm = [tone_all_each_row_norm; ( tone_high(r,:) - mean(tone_high(r,spont_bin_start:spont_bin_end)) )./max( ( tone_high(r,:) - mean(tone_high(r,spont_bin_start:spont_bin_end)) ) )];
end


hvals = zeros(6,size(hc,2));
pvals = zeros(6, size(hc,2));
for t=1:size(hc,2)
    [hvals(1,t), pvals(1,t)] = ttest(h_t_each_row_norm(:,t),ahc_low_each_row_norm(:,t), 'Tail', 'left');
    [hvals(2,t), pvals(2,t)] = ttest(h_t_each_row_norm(:,t),ahc_high_each_row_norm(:,t), 'Tail', 'left');
    [hvals(3,t), pvals(3,t)] = ttest(ahc_low_each_row_norm(:,t), ahc_high_each_row_norm(:,t));

    [hvals(4,t), pvals(4,t)] = ttest2(h_t_each_row_norm(:,t),tone_all_each_row_norm(:,t), 'Tail', 'right');
    [hvals(5,t), pvals(5,t)] = ttest2(ahc_low_each_row_norm(:,t),tone_all_each_row_norm(:,t),'Tail', 'right');
    [hvals(6,t), pvals(6,t)] = ttest2(ahc_high_each_row_norm(:,t),tone_all_each_row_norm(:,t),'Tail', 'right');
end % t

%%
figure
hold on
h1 = mean(h_t_each_row_norm);
ahc_low1 = mean(ahc_low_each_row_norm);
ahc_high1 = mean(ahc_high_each_row_norm);
tone_all1 = mean(tone_all_each_row_norm);

plot(h1, 'LineWidth',2)
plot(ahc_low1, 'LineWidth',2)
plot(ahc_high1, 'LineWidth',2)
plot(tone_all1, 'LineWidth',3)
for t=1:size(hc,2)
    if hvals(1,t) == 1
        text(t, h1(t), 'H > AL', 'color', 'red','FontWeight','bold','VerticalAlignment', 'bottom')
    end
    if hvals(2,t) == 1
        text(t, h1(t), 'H > AH', 'color', 'blue', 'FontWeight','bold','VerticalAlignment', 'top')
    end
    if hvals(3,t) == 1
        text(t, h1(t), 'AL-AH', 'color', 'green','FontWeight','bold','VerticalAlignment', 'bottom')
    end
    if hvals(4,t) == 1
         text(t, tone_all1(t), '!!!', 'color', 'black','FontWeight','bold','VerticalAlignment', 'top', 'FontSize',15)
    end
     if hvals(5,t) == 1
        text(t, tone_all1(t), '@@@@@', 'color', 'black','FontWeight','bold', 'VerticalAlignment', 'top');
     end
    if hvals(6,t) == 1
        text(t, tone_all1(t), '########', 'color', 'black','FontWeight','bold','VerticalAlignment', 'top')
    end
end
    

hold off
legend('HC', 'AHC Low', 'AHC High', 'T all')
title(['t end = ', num2str(t_end),' bin size = ', num2str(bin_size), ' window size = ', num2str(window_size),' far from bf = ', num2str(n_quart_oct_from_bf)])
%%
% the_bin = 51;
the_bin = 51;
A = h_t_each_row_norm(:,the_bin)';
B = ahc_low_each_row_norm(:, the_bin)';
C = ahc_high_each_row_norm(:, the_bin)';
D = tone_all_each_row_norm(:, the_bin)';

% Combine the vectors into a cell array
data = {A, B, C, D};

% Calculate means and standard errors
means = cellfun(@mean, data);
std_errors = cellfun(@std, data) ./ sqrt(cellfun(@numel, data));

% Create a bar graph with error bars
figure;
bar(1:4, means, 'FaceColor', 'flat');
hold on;

% Plot error bars only on the top side
for i = 1:numel(data)
    line([i, i], [means(i), means(i) + std_errors(i)], 'Color', 'k', 'LineWidth', 1.5);
end

hold off;

% Set x-axis labels
xticks(1:4);
xticklabels({'HC', 'AHC Low', 'AHC High', 'Tone'});

% Set y-axis label
ylabel('Mean Value');

% Add a title
title('stim res');
%%
disp(['H & AHL, ', num2str(hvals(1,the_bin)), ' ', num2str(pvals(1,the_bin)) ])
disp(['H & AHH, ', num2str(hvals(2,the_bin)), ' ', num2str(pvals(2,the_bin)) ])
disp(['H & T ', num2str(hvals(4,the_bin)), ' ', num2str(pvals(4,the_bin))])
disp(['AHL & AHH ', num2str(hvals(3,the_bin)), ' ', num2str(pvals(3,the_bin))])