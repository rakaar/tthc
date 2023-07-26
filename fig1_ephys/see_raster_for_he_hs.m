% for all units, see how many freqs are sup/enh, and how far is base or second comp
clear;close all;clc
rms_match_db = load('rms_match_db.mat').rms_match_db;

% remove non-20 dB from all rms values
removal_indices = [];
for u = 1:size(rms_match_db,1)
    if rms_match_db{u,4} ~= 20
        removal_indices = [removal_indices u];
    end
end
rms_match_db(removal_indices,:) = [];

no_effect_indices = [];

example_no1 = nan;
all_neurons_frac_types = struct('he', {}, 'hs', {}, 'ne', {}, 'ns', {});
for u = 1:size(rms_match_db,1)
% for u = 1:1
    all_tone_rates = rms_match_db{u,6};
    all_hc_rates = rms_match_db{u,7};
    all_tone_sig = rms_match_db{u,8};
    all_hc_sig = rms_match_db{u,9};

    case_types_for_indiv_neuron = zeros(5,1);
    for f = 1:5
        t1_spike_rates = mean(all_tone_rates{f,1}(:, 501:570),2);
        t2_spike_rates = mean(all_tone_rates{f+2,1}(:,501:570),2);
        t1t2_spike_rates = mean(all_hc_rates{f,1}(:, 501:570), 2);

        t1_mean_rate = mean(t1_spike_rates);
        t2_mean_rate = mean(t2_spike_rates);
        t1t2_mean_rate = mean(t1t2_spike_rates);

        indiv_type = indiv_he_hs_classifier(t1_spike_rates, t2_spike_rates, t1t2_spike_rates, all_tone_sig(f), all_tone_sig(f+2), all_hc_sig(f));
        if ~isnan(indiv_type)
            case_types_for_indiv_neuron(f) = indiv_type;
        else
            return
        end
    end

    
    n_he = length(find(case_types_for_indiv_neuron == 1));
    n_hs = length(find(case_types_for_indiv_neuron == 2));
    n_ne = length(find(case_types_for_indiv_neuron == 3));
    n_ns = length(find(case_types_for_indiv_neuron == 4));

    % Get the example neuron
    if n_he >= 4
        example_no1 = u;
    end
    if n_hs >= 4
        example_no2 = u;
    end

    if n_ne >= 4
        example_no3 = u;
        no_effect_indices = [no_effect_indices u];
    end
    
    all_neurons_frac_types(u).he = n_he;
    all_neurons_frac_types(u).hs = n_hs;
    all_neurons_frac_types(u).ne = n_ne;
    all_neurons_frac_types(u).ns = n_ns;


end % u

% manual inspection 
example_no3 = 94; % else 21

% plot raster of example neuron
% 1
example_no = example_no1;
time_period = 501:570;
all_tone_dots = zeros(35, length(time_period));
all_hc_dots = zeros(35, length(time_period));

all_tone_rates = rms_match_db{example_no,6};
all_hc_rates = rms_match_db{example_no,7};

for iter = 1:5
    for f = 1:7
        ind35 = (iter - 1)*7 + f;
        
        tone_f_iter_spikes = all_tone_rates{f,1}(iter, time_period);
        hc_f_iter_spikes = all_hc_rates{f,1}(iter, time_period);

        all_tone_dots(ind35,:) = tone_f_iter_spikes;
        all_hc_dots(ind35,:) = hc_f_iter_spikes;

        
    end % f
end % iter

all_freqs = [6, 8.5, 12, 17, 24, 34, 48];
freq_labels = strings(35,1);
for f = 1:5:35
    freq_labels(f) = strcat(num2str(all_freqs((f-1)/5 + 1)), ' Hz');
end

marker_size = 2;

figure
subplot(2,1,1)
    for iStim = 1:35
        spikeTime = find(all_tone_dots(iStim,:) == 1);
        y = iStim * ones(size(spikeTime));  % Same y for all spikes from one stimulus
        plot(spikeTime, y, 'ko', 'MarkerSize', marker_size, 'MarkerFaceColor', 'b'); hold on;   % Plot the spikes as dots
    end

    ylim([0 35]); % set y limits
    xlim([0 70]);
    ylabel('Stimulus');
    xlabel('Time (s)');
    yticks(1:35); % Set y-axis ticks
    yticklabels(freq_labels); % Set y-axis tick labels
    title(['Tone Raster Plot ' num2str(example_no) ]);
    hold off

subplot(2,1,2)
    for iStim = 1:35
        spikeTime = find(all_hc_dots(iStim,:) == 1);
        y = iStim * ones(size(spikeTime));  % Same y for all spikes from one stimulus
        plot(spikeTime, y, 'ko', 'MarkerSize', marker_size, 'MarkerFaceColor', 'r');
        hold on;   % Plot the spikes as dots
    end

    ylim([0 35]); % set y limits
    xlim([0 70]);
    ylabel('Stimulus');
    yticks(1:35); % Set y-axis ticks
    yticklabels(freq_labels); % Set y-axis tick labels
    xlabel('Time (s)');
    title('HC Raster Plot');

    saveas(gcf, 'E:\RK_E_folder_TTHC_backup\RK TTHC figs eps\fig1\HE_raster.fig')


% 2
example_no = example_no2;
time_period = 501:570;
all_tone_dots = zeros(35, length(time_period));
all_hc_dots = zeros(35, length(time_period));

all_tone_rates = rms_match_db{example_no,6};
all_hc_rates = rms_match_db{example_no,7};

for iter = 1:5
    for f = 1:7
        ind35 = (iter - 1)*7 + f;
        
        tone_f_iter_spikes = all_tone_rates{f,1}(iter, time_period);
        hc_f_iter_spikes = all_hc_rates{f,1}(iter, time_period);

        all_tone_dots(ind35,:) = tone_f_iter_spikes;
        all_hc_dots(ind35,:) = hc_f_iter_spikes;

        
    end % f
end % iter

all_freqs = [6, 8.5, 12, 17, 24, 34, 48];
freq_labels = strings(35,1);
for f = 1:5:35
    freq_labels(f) = strcat(num2str(all_freqs((f-1)/5 + 1)), ' Hz');
end

marker_size = 2;
figure
subplot(2,1,1)
    for iStim = 1:35
        spikeTime = find(all_tone_dots(iStim,:) == 1);
        y = iStim * ones(size(spikeTime));  % Same y for all spikes from one stimulus
        plot(spikeTime, y, 'ko', 'MarkerSize', marker_size, 'MarkerFaceColor', 'b'); hold on;   % Plot the spikes as dots
    end

    ylim([0 35]); % set y limits
    xlim([0 70]);
    ylabel('Stimulus');
    xlabel('Time (s)');
    yticks(1:35); % Set y-axis ticks
    yticklabels(freq_labels); % Set y-axis tick labels
    title(['Tone Raster Plot ' num2str(example_no) ]);
    hold off

subplot(2,1,2)
    for iStim = 1:35
        spikeTime = find(all_hc_dots(iStim,:) == 1);
        y = iStim * ones(size(spikeTime));  % Same y for all spikes from one stimulus
        plot(spikeTime, y, 'ko', 'MarkerSize', marker_size, 'MarkerFaceColor', 'r');
        hold on;   % Plot the spikes as dots
    end

    ylim([0 35]); % set y limits
    xlim([0 70]);
    ylabel('Stimulus');
    yticks(1:35); % Set y-axis ticks
    yticklabels(freq_labels); % Set y-axis tick labels
    xlabel('Time (s)');
    title('HC Raster Plot');
    saveas(gcf, 'E:\RK_E_folder_TTHC_backup\RK TTHC figs eps\fig1\HS_raster.fig')

% 3

example_no = example_no3;
time_period = 501:570;
all_tone_dots = zeros(35, length(time_period));
all_hc_dots = zeros(35, length(time_period));

all_tone_rates = rms_match_db{example_no,6};
all_hc_rates = rms_match_db{example_no,7};

for iter = 1:5
    for f = 1:7
        ind35 = (iter - 1)*7 + f;
        
        tone_f_iter_spikes = all_tone_rates{f,1}(iter, time_period);
        hc_f_iter_spikes = all_hc_rates{f,1}(iter, time_period);

        all_tone_dots(ind35,:) = tone_f_iter_spikes;
        all_hc_dots(ind35,:) = hc_f_iter_spikes;

        
    end % f
end % iter

all_freqs = [6, 8.5, 12, 17, 24, 34, 48];
freq_labels = strings(35,1);
for f = 1:5:35
    freq_labels(f) = strcat(num2str(all_freqs((f-1)/5 + 1)), ' Hz');
end

marker_size = 2;
figure
subplot(2,1,1)
    for iStim = 1:35
        spikeTime = find(all_tone_dots(iStim,:) == 1);
        y = iStim * ones(size(spikeTime));  % Same y for all spikes from one stimulus
        plot(spikeTime, y, 'ko', 'MarkerSize', marker_size, 'MarkerFaceColor', 'b'); hold on;   % Plot the spikes as dots
    end

    ylim([0 35]); % set y limits
    xlim([0 70]);
    ylabel('Stimulus');
    xlabel('Time (s)');
    yticks(1:35); % Set y-axis ticks
    yticklabels(freq_labels); % Set y-axis tick labels
    title(['Tone Raster Plot ' num2str(example_no) ]);
    hold off

subplot(2,1,2)
    for iStim = 1:35
        spikeTime = find(all_hc_dots(iStim,:) == 1);
        y = iStim * ones(size(spikeTime));  % Same y for all spikes from one stimulus
        plot(spikeTime, y, 'ko', 'MarkerSize', marker_size, 'MarkerFaceColor', 'r');
        hold on;   % Plot the spikes as dots
    end

    ylim([0 35]); % set y limits
    xlim([0 70]);
    ylabel('Stimulus');
    yticks(1:35); % Set y-axis ticks
    yticklabels(freq_labels); % Set y-axis tick labels
    xlabel('Time (s)');
    title('HC Raster Plot');
    saveas(gcf, 'E:\RK_E_folder_TTHC_backup\RK TTHC figs eps\fig1\NE_raster.fig')
% tuning curves
% 1
example_no = example_no1;

all_tone_rates = rms_match_db{example_no,6};
all_hc_rates = rms_match_db{example_no,7};

tone_mean = zeros(7,1);
tone_err = zeros(7,1);
hc_mean = zeros(7,1);
hc_err = zeros(7,1);
for i = 1:7
    t_rates = 1000.*mean(all_tone_rates{i,1}(:, 501:570),2);
    h_rates = 1000.*mean(all_hc_rates{i,1}(:, 501:570),2);

    tone_mean(i) = mean(t_rates);
    tone_err(i) = std(t_rates)/sqrt(length(t_rates));
    hc_mean(i) = mean(h_rates);
    hc_err(i) = std(h_rates)/sqrt(length(h_rates));
end
figure
    hold on
        errorbar(1:7, tone_mean, tone_err, 'LineWidth', 2, 'Color', 'b');
        errorbar(1:7, hc_mean, hc_err, 'LineWidth', 2, 'Color', 'r');
    hold off
    legend('Tone', 'HC');
    xlabel('Frequency (kHz)');
    ylabel('Spike Rate (spikes/s)');
    title(['Tuning Curves '  num2str(example_no)]);
    hold off
    xticklabels({'6', '8.5', '12', '17', '24', '34', '48'});
    saveas(gcf, 'E:\RK_E_folder_TTHC_backup\RK TTHC figs eps\fig1\HE_tuning.fig')
% 2
example_no = example_no2;

all_tone_rates = rms_match_db{example_no,6};
all_hc_rates = rms_match_db{example_no,7};

tone_mean = zeros(7,1);
tone_err = zeros(7,1);
hc_mean = zeros(7,1);
hc_err = zeros(7,1);
for i = 1:7
    t_rates = 1000.*mean(all_tone_rates{i,1}(:, 501:570),2);
    h_rates = 1000.*mean(all_hc_rates{i,1}(:, 501:570),2);

    tone_mean(i) = mean(t_rates);
    tone_err(i) = std(t_rates)/sqrt(length(t_rates));
    hc_mean(i) = mean(h_rates);
    hc_err(i) = std(h_rates)/sqrt(length(h_rates));
end
figure
    hold on
        errorbar(1:7, tone_mean, tone_err, 'LineWidth', 2, 'Color', 'b');
        errorbar(1:7, hc_mean, hc_err, 'LineWidth', 2, 'Color', 'r');
    hold off
    legend('Tone', 'HC');
    xlabel('Frequency (kHz)');
    ylabel('Spike Rate (spikes/s)');
    title(['Tuning Curves '  num2str(example_no)]);
    hold off
    xticklabels({'6', '8.5', '12', '17', '24', '34', '48'});
    saveas(gcf, 'E:\RK_E_folder_TTHC_backup\RK TTHC figs eps\fig1\HS_tuning.fig')

% 3 

example_no = example_no3;

all_tone_rates = rms_match_db{example_no,6};
all_hc_rates = rms_match_db{example_no,7};

tone_mean = zeros(7,1);
tone_err = zeros(7,1);
hc_mean = zeros(7,1);
hc_err = zeros(7,1);
for i = 1:7
    t_rates = 1000.*mean(all_tone_rates{i,1}(:, 501:570),2);
    h_rates = 1000.*mean(all_hc_rates{i,1}(:, 501:570),2);

    tone_mean(i) = mean(t_rates);
    tone_err(i) = std(t_rates)/sqrt(length(t_rates));
    hc_mean(i) = mean(h_rates);
    hc_err(i) = std(h_rates)/sqrt(length(h_rates));
end
figure
    hold on
        errorbar(1:7, tone_mean, tone_err, 'LineWidth', 2, 'Color', 'b');
        errorbar(1:7, hc_mean, hc_err, 'LineWidth', 2, 'Color', 'r');
    hold off
    legend('Tone', 'HC');
    xlabel('Frequency (kHz)');
    ylabel('Spike Rate (spikes/s)');
    title(['Tuning Curves '  num2str(example_no)]);
    hold off
    xticklabels({'6', '8.5', '12', '17', '24', '34', '48'});
    saveas(gcf, 'E:\RK_E_folder_TTHC_backup\RK TTHC figs eps\fig1\NE_tuning.fig')

    %%  TEMP
    % close all
    
% for i = 1:length(no_effect_indices)
%     example_no = no_effect_indices(i);

%     all_tone_rates = rms_match_db{example_no,6};
%     all_hc_rates = rms_match_db{example_no,7};

%     tone_mean = zeros(7,1);
%     tone_err = zeros(7,1);
%     hc_mean = zeros(7,1);
%     hc_err = zeros(7,1);
%     for i = 1:7
%         t_rates = 1000.*mean(all_tone_rates{i,1}(:, 501:570),2);
%         h_rates = 1000.*mean(all_hc_rates{i,1}(:, 501:570),2);

%         tone_mean(i) = mean(t_rates);
%         tone_err(i) = std(t_rates)/sqrt(length(t_rates));
%         hc_mean(i) = mean(h_rates);
%         hc_err(i) = std(h_rates)/sqrt(length(h_rates));
%     end
    
%         hold on
%             errorbar(1:7, tone_mean, tone_err, 'LineWidth', 2, 'Color', 'b');
%             errorbar(1:7, hc_mean, hc_err, 'LineWidth', 2, 'Color', 'r');
%         hold off
%         legend('Tone', 'HC');
%         xlabel('Frequency (kHz)');
%         ylabel('Spike Rate (spikes/s)');
%         title(num2str(example_no));
%         hold off
%         xticklabels({'6', '8.5', '12', '17', '24', '34', '48'});

%         pause
%        clf

% end


% see raster
% raster_egs = [6 13 21 87 94 104 140 145];
% for i = 1:length(raster_egs)
%     example_no = raster_egs(i);
%     marker_size = 2;

%     time_period = 501:570;
%     all_tone_dots = zeros(35, length(time_period));
%     all_hc_dots = zeros(35, length(time_period));

%     all_tone_rates = rms_match_db{example_no,6};
%     all_hc_rates = rms_match_db{example_no,7};

%     for iter = 1:5
%         for f = 1:7
%             ind35 = (iter - 1)*7 + f;
            
%             tone_f_iter_spikes = all_tone_rates{f,1}(iter, time_period);
%             hc_f_iter_spikes = all_hc_rates{f,1}(iter, time_period);

%             all_tone_dots(ind35,:) = tone_f_iter_spikes;
%             all_hc_dots(ind35,:) = hc_f_iter_spikes;

            
%         end % f
%     end % iter

%     all_freqs = [6, 8.5, 12, 17, 24, 34, 48];
%     freq_labels = strings(35,1);
%     for f = 1:5:35
%         freq_labels(f) = strcat(num2str(all_freqs((f-1)/5 + 1)), ' Hz');
%     end


% subplot(2,1,1)
%     for iStim = 1:35
%         spikeTime = find(all_tone_dots(iStim,:) == 1);
%         y = iStim * ones(size(spikeTime));  % Same y for all spikes from one stimulus
%         plot(spikeTime, y, 'ko', 'MarkerSize', marker_size, 'MarkerFaceColor', 'b'); hold on;   % Plot the spikes as dots
%     end

%     ylim([0 35]); % set y limits
%     xlim([0 70]);
%     ylabel('Stimulus');
%     xlabel('Time (s)');
%     yticks(1:35); % Set y-axis ticks
%     yticklabels(freq_labels); % Set y-axis tick labels
%     title(['Tone Raster Plot ' num2str(example_no)]);
%     hold off

% subplot(2,1,2)
%     for iStim = 1:35
%         spikeTime = find(all_hc_dots(iStim,:) == 1);
%         y = iStim * ones(size(spikeTime));  % Same y for all spikes from one stimulus
%         plot(spikeTime, y, 'ko', 'MarkerSize', marker_size, 'MarkerFaceColor', 'r');
%         hold on;   % Plot the spikes as dots
%     end

%     ylim([0 35]); % set y limits
%     xlim([0 70]);
%     ylabel('Stimulus');
%     yticks(1:35); % Set y-axis ticks
%     yticklabels(freq_labels); % Set y-axis tick labels
%     xlabel('Time (s)');
%     title('HC Raster Plot');

%     pause
%     clf

% end 