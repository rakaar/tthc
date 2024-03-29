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

hs_dom_examples = [];

all_neurons_frac_types = struct('he', {}, 'hs', {}, 'ne', {}, 'ns', {});
for u = 1:size(rms_match_db,1)
% for u = 1:1
    all_tone_rates = rms_match_db{u,6};
    all_hc_rates = rms_match_db{u,7};
    all_tone_sig = rms_match_db{u,8};
    all_hc_sig = rms_match_db{u,9};

    case_types_for_indiv_neuron = zeros(5,1);
    for f = 1:5
        t1_spike_rates = mean(all_tone_rates{f,1}(:, 350:700),2);
        t2_spike_rates = mean(all_tone_rates{f+2,1}(:,350:700),2);
        t1t2_spike_rates = mean(all_hc_rates{f,1}(:, 350:700), 2);

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
        hs_dom_examples = [hs_dom_examples u];
    end

    if n_ne >= 4
        example_no3 = u;
        
    end
    
    all_neurons_frac_types(u).he = n_he;
    all_neurons_frac_types(u).hs = n_hs;
    all_neurons_frac_types(u).ne = n_ne;
    all_neurons_frac_types(u).ns = n_ns;


end % u

return
% plot raster of example neuron
% 
example_no = 81;
time_period = 400:650;
all_tone_dots = zeros(35, length(time_period));
all_hc_dots = zeros(35, length(time_period));

all_tone_rates = rms_match_db{example_no,6};
all_hc_rates = rms_match_db{example_no,7};
for ind35 = 1:35
    freq_no = ceil(ind35/5);
    iter_no = mod(ind35-1, 5) + 1;
    
    tone_f_iter_spikes = all_tone_rates{freq_no,1}(iter_no, time_period);
    hc_f_iter_spikes = all_hc_rates{freq_no,1}(iter_no, time_period);

    all_tone_dots(ind35,:) = tone_f_iter_spikes;
    all_hc_dots(ind35,:) = hc_f_iter_spikes;

end

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
    % xlim([0 70]);
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
    % xlim([0 70]);
    ylabel('Stimulus');
    yticks(1:35); % Set y-axis ticks
    yticklabels(freq_labels); % Set y-axis tick labels
    xlabel('Time (s)');
    title('HC Raster Plot');

    % saveas(gcf, 'E:\RK_E_folder_TTHC_backup\RK TTHC figs eps\fig1\HE_raster.fig')

   