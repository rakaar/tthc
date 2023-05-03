clc;clear;close all

%  subtract spont 
load('stage3_db.mat')
load('stage1_db.mat')
load('f13.mat')


% bin_size = 20;
% window_size = 10;

bin_size = 100;
window_size = 20;

t_end = 1500;

all_freq_at_once_rate = cell(21,3);


for u=1:size(stage3_db,1)
    % T BF
    tone_bf = stage3_db{u,9};
%     tone_bf = stage3_db{u,10}; % BF0
    if tone_bf == -1
        continue
    end

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
        

    end % ahc_u
    
end % u



%% averaging together
n_quart_oct_from_bf = 0;
index_range = 11-n_quart_oct_from_bf:11+n_quart_oct_from_bf;
hc = [];
ahc_low = [];
ahc_high = [];

for i=index_range
    hc = [hc; all_freq_at_once_rate{i,1}];
    ahc_low = [ahc_low; all_freq_at_once_rate{i,2}];
    ahc_high = [ahc_high; all_freq_at_once_rate{i,3}];
end % i

hc_mean = mean(hc);
ahc_low_mean = mean(ahc_low);
ahc_high_mean = mean(ahc_high);

% Subtract spont
spont_bin_start = 300/window_size + 1;
spont_bin_end = (500 - bin_size)/window_size + 1;

hc_mean_spont_mean = mean(hc_mean(spont_bin_start:spont_bin_end));
ahc_low_mean_spont_mean = mean(ahc_low_mean(spont_bin_start:spont_bin_end));
ahc_high_mean_spont_mean = mean(ahc_high_mean(spont_bin_start:spont_bin_end));

hc_mean_spont_removed = hc_mean - hc_mean_spont_mean;
ahc_low_mean_spont_removed = ahc_low_mean - ahc_low_mean_spont_mean;
ahc_high_mean_spont_removed = ahc_high_mean - ahc_high_mean_spont_mean;


hc_mean_norm = hc_mean_spont_removed./max(hc_mean_spont_removed);
ahc_low_mean_norm = ahc_low_mean_spont_removed./max(ahc_low_mean_spont_removed);
ahc_high_mean_norm = ahc_high_mean_spont_removed./max(ahc_high_mean_spont_removed);



%%
% ttests
% H-AL, H-AH, AL-AH
h_t_each_row_norm = [];
ahc_low_each_row_norm = [];
ahc_high_each_row_norm = [];

for r=1:size(hc,1)
    h_t_each_row_norm = [h_t_each_row_norm; ( hc(r,:) - mean(hc(r,spont_bin_start:spont_bin_end)) )./max( ( hc(r,:) - mean(hc(r,spont_bin_start:spont_bin_end)) ) )];
    ahc_low_each_row_norm = [ahc_low_each_row_norm; ( ahc_low(r,:) - mean(ahc_low(r,spont_bin_start:spont_bin_end)) )./max( ( ahc_low(r,:) - mean(ahc_low(r,spont_bin_start:spont_bin_end)) ) )];
    ahc_high_each_row_norm = [ahc_high_each_row_norm; ( ahc_high(r,:) - mean(ahc_high(r,spont_bin_start:spont_bin_end)) )./max( ( ahc_high(r,:) - mean(ahc_high(r,spont_bin_start:spont_bin_end)) ) )];
end

hvals = zeros(3,size(hc,2));
for t=1:size(hc,2)

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
legend('HC', 'AHC Low', 'AHC High')
title(['t end = ', num2str(t_end),' bin size = ', num2str(bin_size), ' window size = ', num2str(window_size),' far from bf = ', num2str(n_quart_oct_from_bf)])


